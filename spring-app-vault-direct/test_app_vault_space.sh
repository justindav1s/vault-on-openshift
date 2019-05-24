#!/usr/bin/env bash

APPDOMAIN=ola
APPNAME=spring-vault-demo
ENV=dev
PROJECT=${APPDOMAIN}-${ENV}

VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`
echo VAULT_ADDR $VAULT_ADDR
APP_TOKEN=`cat ../${PROJECT}-admin/${APPDOMAIN}-${ENV}-admin_token.txt| head -1`
export VAULT_TOKEN=$APP_TOKEN

vault login -address=$VAULT_ADDR $APP_TOKEN

echo APP_TOKEN=$APP_TOKEN

vault kv get -tls-skip-verify -address=$VAULT_ADDR  ${APPDOMAIN}/${APPNAME}/dev

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/${APPDOMAIN}/data/${APPNAME}/dev

echo

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/auth/token/lookup-self

