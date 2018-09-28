#!/usr/bin/env bash


docker run -t -i --rm jnd/vault-adapter \
    ./remote_test.sh \
    https://${OCP_HOST}:${OCP_PORT} \
    ${OCP_USER} \
    ${OCP_PASSWORD} \
    spring-vault-demo \
    test1-app \
    test1

