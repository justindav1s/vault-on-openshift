#!/usr/bin/env bash

#set -x

USER=admin
PASSWORD=admin
POLICY=admin

export VAULT_ADDR=https://$(oc get route -n vault | grep -m1 vault | awk '{print $2}')

export VAULT_TOKEN=$(cat ../vault_setup/root_token.txt| head -1)

echo VAULT_TOKEN = $VAULT_TOKEN

vault policy write \
    -tls-skip-verify \
    $POLICY \
    ./$POLICY.hcl

vault token create -tls-skip-verify -policy=$POLICY

export VAULT_TOKEN=$(vault token create -tls-skip-verify -policy=$POLICY | grep '^token ' | awk '{print $2}')

echo VAULT_TOKEN = $VAULT_TOKEN

echo $VAULT_TOKEN > admin_token.txt

vault policy list

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    ${VAULT_ADDR}/v1/auth/token/lookup-self

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request LIST \
    ${VAULT_ADDR}/v1/sys/policies/acl




