#!/usr/bin/env bash

PROJECT=spring-vault-demo

oc new-app -f spring-vault-direct-template.yaml \
    -p APP_NAME=test1-direct-vault-demo \
    -p VAULT_USERROLE=test1 \
    -p IMAGE_NAME=spring-app-vault-direct \
    -p VAULT_HOST=vault-vault-controller.apps.ocp.datr.eu \
    -p VAULT_PORT=443

oc expose svc test1-direct-vault-demo

