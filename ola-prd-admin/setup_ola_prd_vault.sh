#!/usr/bin/env bash

ENV=prd
APPDOMAIN=ola
APPNAME=spring-vault-demo
PROJECT=${APPDOMAIN}-${ENV}
POLICY=${APPDOMAIN}-${ENV}-admin

echo \>\> create the OCP namespace, that will be bound to the $POLICY vault policy
oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $PROJECT 2> /dev/null
done

export VAULT_ADDR=https://$(oc get route -n vault | grep -m1 vault | awk '{print $2}')
export VAULT_TOKEN=$(cat ../admin/admin_token.txt| head -1)
echo \>\> VAULT_TOKEN = $VAULT_TOKEN

echo \>\> create the dev policy
vault policy write \
    -tls-skip-verify \
    ${POLICY} \
    ./${POLICY}.hcl

echo \>\> test the policy, put, patch then get some secrets
export VAULT_TOKEN=$(vault token create -tls-skip-verify -policy=$POLICY | grep '^token ' | awk '{print $2}')
vault kv put -tls-skip-verify ${APPDOMAIN}/${APPNAME}/${ENV} broker.password=${ENV}_pwd_for_broker db.password=${ENV}_pwd_for_db
vault kv patch -tls-skip-verify ${APPDOMAIN}/${APPNAME}/${ENV} broker.url=tcp://amq-${ENV}:61616
vault kv get ${APPDOMAIN}/${APPNAME}/${ENV}

echo \>\> go back to being admin user
export VAULT_TOKEN=$(cat ../admin/admin_token.txt| head -1)
echo \>\> attach policy to kubernetes auth method for default serviceaccount and ${PROJECT}
vault write \
    -tls-skip-verify \
    auth/kubernetes/role/${POLICY} \
    bound_service_account_names=default \
    bound_service_account_namespaces=${PROJECT} \
    policies=${POLICY} ttl=2h

echo \>\> Perform a kubernetes login to get a token and use it as an app would
default_account_token=$(oc serviceaccounts get-token default -n ${PROJECT})
vault write -tls-skip-verify auth/kubernetes/login role=${POLICY} jwt=${default_account_token} > app_token_response.txt
export VAULT_TOKEN=$(cat app_token_response.txt | grep '^token ' | awk '{print $2}')

vault kv get ${APPDOMAIN}/${APPNAME}/${ENV}
