#!/usr/bin/env bash

VAULT_TOKEN=57e71167-637d-3f57-a6c6-50e5ebf5326b

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault-controller.apps.ocp.datr.eu/v1/secret/spring-native-example

curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request GET \
    https://vault-vault-controller.apps.ocp.datr.eu/v1/auth/token/lookup-self

