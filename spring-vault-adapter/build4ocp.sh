#!/usr/bin/env bash

PROJECT=spring-vault-demo

oc project $PROJECT

oc delete bc spring-vault-adapter

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/kube-vault-adapter \
    --context-dir=spring-vault-adapter \
    --name spring-vault-adapter

sleep 5

oc logs -f bc/spring-vault-adapter
