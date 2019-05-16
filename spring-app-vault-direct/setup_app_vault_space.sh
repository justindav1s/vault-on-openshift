#!/usr/bin/env bash

set -x

PROJECT=vrm-prod
APPDOMAIN=vrm
APPNAME=spring-vault-demo

oc login https://ocp.datr.eu:8443 -u justin

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $PROJECT 2> /dev/null
done

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

export ROOT_TOKEN=`cat ../vault_setup/root_token.txt| head -1`
export VAULT_TOKEN=$ROOT_TOKEN

vault secrets disable ${PROJECT}
vault secrets disable ${APPDOMAIN}/data
vault secrets disable ${APPDOMAIN}
vault secrets enable -version=2 -path=${APPDOMAIN} kv

cat <<EOF > ${APPDOMAIN}-${APPNAME}.hcl
path "${APPDOMAIN}/data/${APPNAME}/*" {
  capabilities = ["create", "update", "read", "list"]
}
EOF

vault policy write \
    -tls-skip-verify \
    ${APPDOMAIN}-${APPNAME} \
    ./${APPDOMAIN}-${APPNAME}.hcl

vault write \
    -tls-skip-verify \
    auth/kubernetes/role/${APPDOMAIN}-${APPNAME} \
    bound_service_account_names=default \
    bound_service_account_namespaces=${PROJECT} \
    policies=${APPDOMAIN}-${APPNAME} ttl=2h

vault kv put -tls-skip-verify ${APPDOMAIN}/${APPNAME}/dev broker.password=pwd_for_broker db.password=pwd_for_db
vault kv patch -tls-skip-verify ${APPDOMAIN}/${APPNAME}/dev broker.url=tcp://amq:61616

default_account_token=$(oc serviceaccounts get-token default -n ${PROJECT})

vault write -tls-skip-verify auth/kubernetes/login role=${APPDOMAIN}-${APPNAME} jwt=${default_account_token} > app_token_response.txt

export APP_TOKEN=`cat app_token_response.txt | grep '^token ' | awk '{print $2}'`

echo $APP_TOKEN > app_token.txt

echo APP_TOKEN=$APP_TOKEN

# https://vault-vault.apps.ocp.datr.eu/ui/vault/secrets/vrm/show/spring-vault-demo/dev id browser viewable