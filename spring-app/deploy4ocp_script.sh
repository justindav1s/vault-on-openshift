#!/usr/bin/env bash

PROJECT=spring-vault-demo

oc project spring-vault-demo

oc delete dc,svc,route test1-app

oc new-app -f spring-app-vault-direct-script-init-container-template.yaml \
    -p APP_NAME=test1-app \
    -p VAULT_USERROLE=test1 \
    -p IMAGE_NAME=spring-app \
    -p VAULT_HOST=vault-vault.apps.ocp.datr.eu \
    -p VAULT_PORT=443

oc expose svc test1-app

