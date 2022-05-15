#!/usr/bin/env bash
set -eou pipefail

query_var() {
  variable_name=$1
  variable_description=$2

  if env | grep -q "${variable_name}="; then
    echo "${variable_name} is set"
  else
    read -rp "Enter ${variable_description}: " variable
    echo "export ${variable_name}=\"${variable}\"" >> env-vars.source_me
  fi
}

query_var "TF_VAR_exoscale_api_key" "API Key"
query_var "TF_VAR_exoscale_api_secret" "API Secret"
