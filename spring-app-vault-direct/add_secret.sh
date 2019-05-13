#!/usr/bin/env bash

set -x

PROJECT=vrm-prod
APPNAME=spring-vault-demo

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

export ROOT_TOKEN=`cat ../vault_setup/root_token.txt| head -1`
export VAULT_TOKEN=$ROOT_TOKEN

vault write -tls-skip-verify secret/${APPNAME}/dev dbpassword2=pwd_from_vault

