#!/usr/bin/env bash

APP-NAME=my-app

VAULT_TOKEN=$1

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault-controller.apps.ocp.datr.eu/v1/secret/${APP-NAME}

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault-controller.apps.ocp.datr.eu/v1/auth/token/lookup-self

