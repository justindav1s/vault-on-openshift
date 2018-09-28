#!/usr/bin/env bash

PROJECT=spring-vault-demo
oc project $PROJECT

cat Dockerfile | oc new-build --name script-vault-adapter -D -
