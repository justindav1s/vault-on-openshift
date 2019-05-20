#!/usr/bin/env bash

APPDOMAIN=ola

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`
export VAULT_TOKEN=$(cat ../admin/admin_token.txt| head -1)

vault secrets disable ${APPDOMAIN}/data
vault secrets disable ${APPDOMAIN}
vault secrets enable -version=2 -path=${APPDOMAIN} kv
