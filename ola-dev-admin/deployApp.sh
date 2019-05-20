#!/usr/bin/env bash

ENV=dev
APPDOMAIN=ola
PROJECT=${APPDOMAIN}-${ENV}
APPNAME=spring-vault-demo

oc project $PROJECT

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/kube-vault-adapter \
    --context-dir=spring-app-vault-direct \
    --name spring-app-vault-direct

oc new-app -f ../spring-app-vault-direct/spring-vault-direct-template.yaml \
    -p APP_NAME=${APPNAME} \
    -p APP_DOMAIN=${APPDOMAIN} \
    -p VAULT_USERROLE=${APPDOMAIN}-${APPNAME} \
    -p IMAGE_NAME=spring-app-vault-direct \
    -p VAULT_HOST=vault-vault.apps.ocp.datr.eu \
    -p VAULT_PORT=443

oc expose svc spring-vault-demo

