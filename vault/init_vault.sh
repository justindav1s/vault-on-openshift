#!/usr/bin/env bash

PROJECT=vault-controller

oc project $PROJECT

vault init -tls-skip-verify -key-shares=1 -key-threshold=1

