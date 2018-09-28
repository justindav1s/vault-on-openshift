#!/usr/bin/env bash

PROJECT=spring-vault-demo

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/kube-vault-adapter \
    --context-dir=spring-app \
    --name spring-app

