#!/usr/bin/env bash

PROJECT=vrm-prod
APPNAME=spring-vault-demo
VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`
echo VAULT_ADDR $VAULT_ADDR
APP_TOKEN=`cat app_token.txt| head -1`
export VAULT_TOKEN=$APP_TOKEN

vault login -address=$VAULT_ADDR $APP_TOKEN

echo APP_TOKEN=$APP_TOKEN

vault kv get -tls-skip-verify -address=$VAULT_ADDR  secret/${APPNAME}/dev

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/secret/data/${APPNAME}/dev/

echo

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/auth/token/lookup-self

