#!/usr/bin/env bash

ENV=dev
APPDOMAIN=ola
PROJECT=${APPDOMAIN}-${ENV}
APPNAME=spring-app

oc project $PROJECT

oc delete service spring-vault-demo
oc delete deploymentconfig spring-vault-demo
oc delete buildconfig spring-app-vault-direct
oc delete imagestream spring-app-vault-direct
oc delete route spring-vault-demo

oc delete service spring-app
oc delete deploymentconfig spring-app
oc delete buildconfig spring-app
oc delete imagestream spring-app
oc delete route spring-app

oc delete bc,is script-vault-adapter

oc new-build \
    https://github.com/justindav1s/kube-vault-adapter \
    --name script-vault-adapter \
    --context-dir=script-vault-adapter \
    --strategy=docker

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/kube-vault-adapter \
    --context-dir=spring-app \
    --name spring-app

oc new-app -f ../spring-app/spring-app-vault-direct-script-init-container-template.yaml \
    -p APP_NAME=${APPNAME} \
    -p APP_DOMAIN=${APPDOMAIN} \
    -p SPRING_PROFILES_ACTIVE=${ENV} \
    -p VAULT_USERROLE=${APPDOMAIN}-${ENV}-admin \
    -p IMAGE_NAME=spring-app \
    -p VAULT_ADDR=https://vault-vault.apps.ocp.datr.eu

oc expose svc spring-app

