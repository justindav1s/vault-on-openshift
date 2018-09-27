#!/usr/bin/env bash

VAULT_TOKEN=7e207cda-0dbe-b21d-2bcf-08187f534099

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault-controller.apps.ocp.datr.eu/v1/secret/spring-native-example

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault-controller.apps.ocp.datr.eu/v1/auth/token/lookup-self

