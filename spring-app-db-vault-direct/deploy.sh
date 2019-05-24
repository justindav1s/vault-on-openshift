#!/usr/bin/env bash

PROJECT=ola-dev
APPDOMAIN=ola
APPNAME=spring-app-db-vault-demo

oc project $PROJECT

oc delete all -l app=${APPNAME}

oc new-app -f spring-vault-direct-template.yaml \
    -p APP_NAME=${APPNAME} \
    -p VAULT_USERROLE=${PROJECT}-admin \
    -p IMAGE_NAME=spring-app-db-vault-direct \
    -p VAULT_HOST=vault-vault.apps.ocp.datr.eu \
    -p VAULT_PORT=443

