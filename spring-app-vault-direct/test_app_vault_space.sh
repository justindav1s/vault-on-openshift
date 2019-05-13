#!/usr/bin/env bash

PROJECT=vrm-prod
APPNAME=spring-vault-demo
VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`
APP_TOKEN=`cat app_token.txt| head -1`
VAULT_TOKEN=$APP_TOKEN

vault login $APP_TOKEN

echo APP_TOKEN=$APP_TOKEN

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/${PROJECT}/${APPNAME}

echo

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/auth/token/lookup-self

