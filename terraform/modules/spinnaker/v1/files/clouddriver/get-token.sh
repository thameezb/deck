#!/bin/bash
TOKEN="$(cat /run/secrets/kubernetes.io/serviceaccount/token)"
cat << EOF
{
    "kind":"ExecCredential",
    "apiVersion":"client.authentication.k8s.io/v1beta1",
    "spec":{},
    "status":{
        "token":"${TOKEN}"
    }
}
EOF
