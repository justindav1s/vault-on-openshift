#!/usr/bin/env bash

oc create -f spring-native-example.yaml
oc expose svc spring-native-example

