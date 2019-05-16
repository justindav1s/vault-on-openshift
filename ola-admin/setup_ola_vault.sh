#!/usr/bin/env bash

set -x

APPDOMAIN=ola
APPNAME=spring-vault-demo

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

export ROOT_TOKEN=`cat ../vault_setup/root_token.txt| head -1`
export VAULT_TOKEN=$ROOT_TOKEN

vault secrets disable ${APPDOMAIN}/data
vault secrets disable ${APPDOMAIN}
vault secrets enable -version=2 -path=${APPDOMAIN} kv

vault kv put -tls-skip-verify ${APPDOMAIN}/${APPNAME}/dev broker.password=dev_pwd_for_broker db.password=dev_pwd_for_db
vault kv patch -tls-skip-verify ${APPDOMAIN}/${APPNAME}/dev broker.url=tcp://amq-dev:61616

vault kv put -tls-skip-verify ${APPDOMAIN}/${APPNAME}/prd broker.password=prd_pwd_for_broker db.password=prd_pwd_for_db
vault kv patch -tls-skip-verify ${APPDOMAIN}/${APPNAME}/prd broker.url=tcp://amq-prd:61616

vault kv get ${APPDOMAIN}/spring-vault-demo/dev
vault kv get ${APPDOMAIN}/spring-vault-demo/prd
# https://vault-vault.apps.ocp.datr.eu/ui/vault/secrets/ola/show/spring-vault-demo/dev id browser viewable