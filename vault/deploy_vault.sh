#!/usr/bin/env bash

PROJECT=vault-controller

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $PROJECT 2> /dev/null
done

oc adm policy add-scc-to-user anyuid -z default
oc create configmap vault-config --from-file=vault-config=./config/vault-config.json
oc create -f ./config/vault.yaml
oc create route reencrypt vault --port=8200 --service=vault
export VAULT_ADDR=https://`oc get route | grep -m1 vault | awk '{print $2}'`

