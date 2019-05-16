#!/usr/bin/env bash

#set -x

APPDOMAIN=vrm
POLICY=${APPDOMAIN}-dev-admin

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

export VAULT_ADDR=https://$(oc get route -n vault | grep -m1 vault | awk '{print $2}')

export VAULT_TOKEN=$(cat ../admin/admin_token.txt| head -1)

echo VAULT_TOKEN = $VAULT_TOKEN

vault policy write \
    -tls-skip-verify \
    $POLICY \
    ./$POLICY.hcl

vault token create -tls-skip-verify -policy=$POLICY

export VAULT_TOKEN=$(vault token create -tls-skip-verify -policy=$POLICY | grep '^token ' | awk '{print $2}')

echo VAULT_TOKEN = $VAULT_TOKEN

echo $VAULT_TOKEN > ${POLICY}_token.txt

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    ${VAULT_ADDR}/v1/auth/token/lookup-self


curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    ${VAULT_ADDR}/v1/vrm/data/spring-vault-demo/dev

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    ${VAULT_ADDR}/v1/vrm/data/spring-vault-demo/prd

vault kv get ${APPDOMAIN}/spring-vault-demo/dev
vault kv get ${APPDOMAIN}/spring-vault-demo/prd




