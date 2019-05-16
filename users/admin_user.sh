#!/usr/bin/env bash

#set -x

USER=admin
PASSWORD=admin
POLICY=admin

export VAULT_ADDR=https://$(oc get route -n vault | grep -m1 vault | awk '{print $2}')

export VAULT_TOKEN=$(cat ../admin/admin_token.txt| head -1)

echo VAULT_TOKEN = $VAULT_TOKEN

vault auth disable userpass
vault auth enable userpass

vault write auth/userpass/users/admin password="admin" policies="admin"

vault write auth/userpass/users/ola-admin password="ola-admin" policies="ola-admin"

vault write auth/userpass/users/ola-dev-admin password="ola-dev-admin" policies="ola-dev-admin"

vault write auth/userpass/users/ola-prd-admin password="ola-prd-admin" policies="ola-prd-admin"

vault write auth/userpass/users/vrm-admin password="vrm-admin" policies="vrm-admin"

vault write auth/userpass/users/vrm-dev-admin password="vrm-dev-admin" policies="vrm-dev-admin"

vault write auth/userpass/users/vrm-prd-admin password="vrm-prd-admin" policies="vrm-prd-admin"