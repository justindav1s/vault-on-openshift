#!/usr/bin/env bash

#set -x

APPDOMAIN=ola
APPNAME=spring-vault-demo
ENV=dev
PROJECT=${APPDOMAIN}-${ENV}

oc project ${APPDOMAIN}-${ENV}

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`
echo VAULT_ADDR $VAULT_ADDR

default_account_token=$(oc serviceaccounts get-token default -n ${PROJECT})

AUTH_RESPONSE=$(curl -s \
    --request POST \
    --data "{\"jwt\": \"${default_account_token}\", \"role\": \"${APPDOMAIN}-${ENV}-admin\"}" \
    ${VAULT_ADDR}/v1/auth/kubernetes/login)

export VAULT_TOKEN=$(echo $AUTH_RESPONSE | jq -r .auth.client_token)

echo VAULT_TOKEN=$VAULT_TOKEN

vault kv get -tls-skip-verify ${APPDOMAIN}/${APPNAME}/dev

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/${APPDOMAIN}/data/${APPNAME}/dev

echo

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault.apps.ocp.datr.eu/v1/auth/token/lookup-self

