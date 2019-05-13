#!/usr/bin/env bash

set -x

PROJECT=vault
oc project $PROJECT

export APPNAME=test1

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

export ROOT_TOKEN=`cat root_token.txt| head -1`
export VAULT_TOKEN=$ROOT_TOKEN

cat <<EOF > ${APPNAME}.hcl
path "secret/${APPNAME}" {
  capabilities = ["read", "list"]
}
EOF

vault policy write \
    -tls-skip-verify \
    ${APPNAME} \
    ./${APPNAME}.hcl

vault write \
    -tls-skip-verify \
    auth/kubernetes/role/${APPNAME} \
    bound_service_account_names=default \
    bound_service_account_namespaces='*' \
    policies=${APPNAME} ttl=2h

vault write -tls-skip-verify secret/${APPNAME} password=pwd_from_vault

default_account_token=$(oc serviceaccounts get-token default -n default)

vault write -tls-skip-verify auth/kubernetes/login role=${APPNAME} jwt=${default_account_token} > app_token_response.txt

export APP_TOKEN=`cat app_token_response.txt | grep '^token ' | awk '{print $2}'`

echo $APP_TOKEN > app_token.txt

echo APP_TOKEN=$APP_TOKEN