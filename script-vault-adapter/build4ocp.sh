#!/usr/bin/env bash

PROJECT=spring-vault-demo
oc project $PROJECT

oc delete bc,is script-vault-adapter

oc new-build \
    https://github.com/justindav1s/kube-vault-adapter \
    --name script-vault-adapter \
    --context-dir=script-vault-adapter \
    --strategy=docker
