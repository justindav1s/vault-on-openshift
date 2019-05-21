#!/usr/bin/env bash

echo VAULT_ADDR = $VAULT_ADDR
echo VAULT_USERROLE = $VAULT_USERROLE
echo SPRING_PROFILES_ACTIVE = $SPRING_PROFILES_ACTIVE
echo APP_NAME = $APP_NAME
echo APP_DOMAIN = $APP_DOMAIN

JWT=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`

echo JWT = $JWT

cat <<EOF > payload.json
{"role": "$VAULT_USERROLE", "jwt": "$JWT"}
EOF

curl -v $VAULT_HOST/v1/auth/kubernetes/login \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
--data  @payload.json | jq . > tokendata.json

VAULT_TOKEN=`cat tokendata.json | jq -r .auth.client_token`

echo VAULT_TOKEN = $VAULT_TOKEN

curl -v \
    --header "X-Vault-Token: $CLIENT_TOKEN" \
    -H "Accept: application/json" \
    --request GET \
    $VAULT_HOST/v1/${APP_DOMAIN}/data/${APP_NAME}/${SPRING_PROFILES_ACTIVE} > /tmp/$VAULT_USERROLE.json

cat /tmp/$VAULT_USERROLE.json | jq .data.data > /tmp/${APP_DOMAIN}-${APP_NAME}-${SPRING_PROFILES_ACTIVE}.json


vault get kv ${APP_DOMAIN}/${APP_NAME}/${ENV} > /tmp/${APP_DOMAIN}-${APP_NAME}-${SPRING_PROFILES_ACTIVE}.txt

cat /tmp/${APP_DOMAIN}-${APP_NAME}-${SPRING_PROFILES_ACTIVE}.txt