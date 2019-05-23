#!/usr/bin/env bash

PROJECT=ola-dev
APPDOMAIN=ola
APPNAME=spring-vault-demo

oc project $PROJECT

oc delete bc,svc,dc,is,route,pvc --all

oc new-app postgresql -e POSTGRESQL_ADMIN_PASSWORD=password

oc rollout status dc/postgresql -w

sleep 2

export POD=$(oc get pod -l app=postgresql | grep -m1 postgresql | awk '{print $1}')

echo POD = $POD

oc cp data.sh $POD:/opt/app-root/src

oc exec $POD ./data.sh

oc port-forward $POD 5000:5432




