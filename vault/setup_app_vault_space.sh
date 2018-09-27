#!/usr/bin/env bash

set -x

export APPNAME=test1

export VAULT_ADDR=https://`oc get route -n vault-controller | grep -m1 vault | awk '{print $2}'`

reviewer_service_account_jwt=$(oc serviceaccounts get-token vault-auth)


cat <<EOF > vault-policy.hcl
path "secret/${APPNAME}" {
  capabilities = ["read", "list"]
}
EOF

vault policy write \
    -tls-skip-verify \
    ${APPNAME} \
    ./vault-policy.hcl

vault write \
    -tls-skip-verify \
    auth/kubernetes/role/${APPNAME} \
    bound_service_account_names=default \
    bound_service_account_namespaces='*'
    policies=${APPNAME} ttl=2h

vault write -tls-skip-verify secret/${APPNAME} password=pwd_from_vault

default_account_token=$(oc serviceaccounts get-token default -n default)
vault write -tls-skip-verify auth/kubernetes/login role=${APPNAME} jwt=${default_account_token}

