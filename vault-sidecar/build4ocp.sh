#!/usr/bin/env bash

PROJECT=spring-native-example

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $PROJECT 2> /dev/null
done

oc new-project $PROJECT

oc new-build \
    registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift~https://github.com/justindav1s/vault-sidecar \
    --context-dir=vault-sidecar \
    --name $PROJECT

