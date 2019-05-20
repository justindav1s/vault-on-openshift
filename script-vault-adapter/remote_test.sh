#!/usr/bin/env bash

OCP_URL=$1
OCP_USER=$2
OCP_PWD=$3
PROJECT=$4
APPNAME=$5
VAULT_ROLE=$6

oc login ${OCP_URL} --username=${OCP_USER} --password=${OCP_PWD} --insecure-skip-tls-verify=true

VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`
echo VAULT_ADDR = $VAULT_ADDR

oc project $PROJECT

POD=`oc get pods | grep Running | grep $APPNAME | awk '{print $1}'`

echo POD = $POD

JWT=`oc rsh $POD cat /var/run/secrets/kubernetes.io/serviceaccount/token`

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
    $VAULT_ADDR/v1/ola/data/spring-vault-demo/dev

rm -rf tokendata.json payload.json