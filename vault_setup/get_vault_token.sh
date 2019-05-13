#!/usr/bin/env bash

set -x

APPNAME=test1
PROJECT=$(oc project -q)

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

default_account_token=$(oc serviceaccounts get-token default -n ${PROJECT})

vault write -tls-skip-verify auth/kubernetes/login role=${APPNAME} jwt=${default_account_token} > ${PROJECT}_app_token_response.txt

export APP_TOKEN=$(cat ${PROJECT}_app_token_response.txt | grep '^token ' | awk '{print $2}')

echo $APP_TOKEN > ${PROJECT}_app_token.txt

echo APP_TOKEN=$APP_TOKEN