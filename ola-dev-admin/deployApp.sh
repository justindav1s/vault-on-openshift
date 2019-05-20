#!/usr/bin/env bash

ENV=dev
APPDOMAIN=ola
PROJECT=${APPDOMAIN}-${ENV}
APPNAME=spring-vault-demo

oc project $PROJECT

oc delete service spring-vault-demo
oc delete deploymentconfig spring-vault-demo
oc delete buildconfig spring-app-vault-direct
oc delete imagestream spring-app-vault-direct
oc delete route spring-vault-demo

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/kube-vault-adapter \
    --context-dir=spring-app-vault-direct \
    --name spring-app-vault-direct

oc new-app -f ../spring-app-vault-direct/spring-vault-direct-template.yaml \
    -p APP_NAME=${APPNAME} \
    -p APP_DOMAIN=${APPDOMAIN} \
    -p SPRING_PROFILES_ACTIVE=${ENV} \
    -p VAULT_USERROLE=${APPDOMAIN}-${ENV}-admin \
    -p IMAGE_NAME=spring-app-vault-direct \
    -p VAULT_HOST=vault-vault.apps.ocp.datr.eu \
    -p VAULT_PORT=443

oc expose svc spring-vault-demo

