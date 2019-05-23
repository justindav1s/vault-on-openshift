#!/usr/bin/env bash


export VAULT_ADDR=https://$(oc get route -n vault | grep -m1 vault | awk '{print $2}')
export VAULT_TOKEN=$(cat ../../admin/admin_token.txt| head -1)
echo VAULT_ADDR = $VAULT_ADDR
echo VAULT_TOKEN = $VAULT_TOKEN

vault read database/creds/ola-dev-admin