#!/usr/bin/env bash

PROJECT=ola-dev

oc login https://ocp.datr.eu:8443 -u justin

oc project $PROJECT

oc delete bc spring-app-vault-direct

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/kube-vault-adapter \
    --context-dir=spring-app-vault-direct \
    --name spring-app-vault-direct

oc logs bc/spring-app-db-vault-direct -f