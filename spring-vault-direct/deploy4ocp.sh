#!/usr/bin/env bash

oc create -f spring-vault-direct.yaml
oc expose svc spring-vault-direct

