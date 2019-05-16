#!/usr/bin/env bash

PROJECT=vrm-prod
APPDOMAIN=vrm
APPNAME=spring-vault-demo

oc project $PROJECT

oc new-app -f spring-vault-direct-template.yaml \
    -p APP_NAME=${APPNAME} \
    -p VAULT_USERROLE=${APPDOMAIN}-${APPNAME} \
    -p IMAGE_NAME=spring-app-vault-direct \
    -p VAULT_HOST=vault-vault.apps.ocp.datr.eu \
    -p VAULT_PORT=443

oc expose svc spring-vault-demo

