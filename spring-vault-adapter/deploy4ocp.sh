#!/usr/bin/env bash

oc create -f spring-vault-adapter.yaml
oc expose svc spring-native-example

