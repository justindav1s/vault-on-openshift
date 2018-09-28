#!/usr/bin/env bash

PROJECT=vault-controller

oc project $PROJECT

export VAULT_ADDR=https://`oc get route | grep -m1 vault | awk '{print $2}'`

vault init -tls-skip-verify -key-shares=1 -key-threshold=1 > init.txt

export KEYS=`cat init.txt | grep "Unseal Key" | awk '{print $4}'`

export ROOT_TOKEN=`cat init.txt | grep "Root Token" | awk '{print $4}'`

vault unseal -tls-skip-verify $KEYS
oc create sa vault-auth
oc adm policy add-cluster-role-to-user system:auth-delegator -z vault-auth
reviewer_service_account_jwt=$(oc serviceaccounts get-token vault-auth)
pod=`oc get pods -n $(oc project -q) | grep vault | awk '{print $1}'`
oc exec $pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > ca.crt
export VAULT_TOKEN=$ROOT_TOKEN
vault auth-enable -tls-skip-verify kubernetes
vault write -tls-skip-verify auth/kubernetes/config token_reviewer_jwt=$reviewer_service_account_jwt kubernetes_host=https://ocp.datr.eu:8443 kubernetes_ca_cert=@ca.crt

rm -rf init.txt
rm -rf ca.crt

echo $KEYS > keys.txt
echo $ROOT_TOKEN > root_token.txt