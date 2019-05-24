#!/usr/bin/env bash

PROJECT=ola-dev
APP_NAME=spring-app-vault-direct

mvn clean install -Dspring.profiles.active=laptop

oc login https://ocp.datr.eu:8443 -u justin

oc project $PROJECT

oc delete bc ${APP_NAME}

oc process -f build-config.yaml \
    -p APPLICATION_NAME=${APP_NAME} \
    -p BASE_IMAGE_NAMESPACE=openshift \
    -p BASE_IMAGE=java:8 | oc create -f -

oc start-build ${APP_NAME} --from-file=target/spring-app-vault-direct-0.0.1-SNAPSHOT.jar

oc logs bc/${APP_NAME} -f