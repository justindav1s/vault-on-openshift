#!/usr/bin/env bash

VAULT_ADDR=$1
VAULT_ROLE=$2

echo VAULT_ADDR = $VAULT_ADDR
echo VAULT_ROLE = $VAULT_ROLE

JWT=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`

echo JWT = $JWT

cat <<EOF > payload.json
{"role": "$VAULT_ROLE", "jwt": "$JWT"}
EOF

curl -s $VAULT_ADDR/v1/auth/kubernetes/login \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
--data  @payload.json | jq . > tokendata.json

CLIENT_TOKEN=`cat tokendata.json | jq -r .auth.client_token`

echo CLIENT_TOKEN = $CLIENT_TOKEN

curl \
    --header "X-Vault-Token: $CLIENT_TOKEN" \
    -H "Accept: application/json" \
    --request GET \
    $VAULT_ADDR/v1/secret/${VAULT_ROLE} > /tmp/$VAULT_ROLE.properties

cat /tmp/$VAULT_ROLE.properties

rm -rf tokendata.json payload.json