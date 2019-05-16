#!/usr/bin/env bash

#set -x

USER=admin
PASSWORD=admin
POLICY=admin

export VAULT_ADDR=https://`oc get route -n vault | grep -m1 vault | awk '{print $2}'`

ROOT_TOKEN=`cat root_token.txt| head -1`
export VAULT_TOKEN=$ROOT_TOKEN

echo VAULT_TOKEN = $VAULT_TOKEN

vault policy read $POLICY

vault policy read root

vault write auth/userpass/users/$USER \
    password=$PASSWORD \
    policies=$POLICY

vault write auth/userpass/users/$USER/policies value=$POLICY

vault login -method=userpass \
    username=$USER \
    password=$PASSWORD

export VAULT_TOKEN=$(vault login -method=userpass \
    username=$USER \
    password=$PASSWORD | grep '^token ' | awk '{print $2}')

echo VAULT_TOKEN = $VAULT_TOKEN

#vault token create -policy=$POLICY
#
#export VAULT_TOKEN=$(vault token create -policy=$POLICY | grep '^token ' | awk '{print $2}')

echo VAULT_TOKEN = $VAULT_TOKEN

vault policy list




