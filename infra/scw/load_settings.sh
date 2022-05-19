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


query_var "TF_VAR_scw_organization_id" "Organization ID"
query_var "TF_VAR_scw_api_token" "API Token"
query_var "TF_VAR_scw_access_key" "Access Key"
query_var "TF_VAR_scw_region" "Region"
