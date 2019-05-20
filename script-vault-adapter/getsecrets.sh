#!/usr/bin/env bash

VAULT_HOST=$1
VAULT_USERROLE=$2
SPRING_PROFILES_ACTIVE=$3

echo VAULT_HOST = $VAULT_HOST
echo VAULT_USERROLE = $VAULT_USERROLE
echo SPRING_PROFILES_ACTIVE = $SPRING_PROFILES_ACTIVE

JWT=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`

echo JWT = $JWT

cat <<EOF > payload.json
{"role": "$VAULT_USERROLE", "jwt": "$JWT"}
EOF

curl -s $VAULT_HOST/v1/auth/kubernetes/login \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
--data  @payload.json | jq . > tokendata.json

CLIENT_TOKEN=`cat tokendata.json | jq -r .auth.client_token`

echo CLIENT_TOKEN = $CLIENT_TOKEN

curl -s \
    --header "X-Vault-Token: $CLIENT_TOKEN" \
    -H "Accept: application/json" \
    --request GET \
    $VAULT_HOST/v1/secret/${VAULT_USERROLE} > /tmp/$VAULT_USERROLE.json

cat /tmp/$VAULT_USERROLE.json

rm -rf tokendata.json payload.json