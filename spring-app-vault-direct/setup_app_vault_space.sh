#!/usr/bin/env bash

set -x

PROJECT=vrm-prod
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
vault secrets enable -version=1 -path=${PROJECT} kv

cat <<EOF > ${PROJECT}.hcl
path "${PROJECT}/*" {
  capabilities = ["read", "list"]
}
EOF

vault policy write \
    -tls-skip-verify \
    ${PROJECT} \
    ./${PROJECT}.hcl

vault write \
    -tls-skip-verify \
    auth/kubernetes/role/${PROJECT} \
    bound_service_account_names=default \
    bound_service_account_namespaces=${PROJECT} \
    policies=${PROJECT} ttl=2h

vault write -tls-skip-verify ${PROJECT}/${APPNAME} password=pwd_from_vault

default_account_token=$(oc serviceaccounts get-token default -n ${PROJECT})

vault write -tls-skip-verify auth/kubernetes/login role=${PROJECT} jwt=${default_account_token} > app_token_response.txt

export APP_TOKEN=`cat app_token_response.txt | grep '^token ' | awk '{print $2}'`

echo $APP_TOKEN > app_token.txt

echo APP_TOKEN=$APP_TOKEN