#!/usr/bin/env bash

#set -x

APPNAME=spring-vault-demo
PROJECT=$(oc project -q)

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

default_account_token=$(oc serviceaccounts get-token default -n ${PROJECT})

vault write -tls-skip-verify auth/kubernetes/login role=${APPNAME} jwt=${default_account_token} > ${PROJECT}_app_token_response.txt

export APP_TOKEN=$(cat ${PROJECT}_app_token_response.txt | grep '^token ' | awk '{print $2}')

echo $APP_TOKEN > ${PROJECT}_app_token.txt
export VAULT_TOKEN=$APP_TOKEN
echo VAULT_TOKEN=$APP_TOKEN

vault kv get  secret/${APPNAME}/dev

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/secret/data/${APPNAME}/dev?version=1