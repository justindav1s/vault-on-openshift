#!/usr/bin/env bash

PROJECT=vault-controller

oc project $PROJECT

vault init -tls-skip-verify -key-shares=1 -key-threshold=1 > init.txt

export KEYS=`cat init.txt | grep "Unseal Key" | awk '{print $4}'`

export ROOT_TOKEN=`cat init.txt | grep "Root Token" | awk '{print $4}'`