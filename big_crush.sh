#!/usr/bin/env bash
set -eou pipefail

# Track the location of the script and go there
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

# Load env variables
source env-vars.source_me

# Turn vpn off
wg-quick down /tmp/generated_wg0.conf

# Switch to the vendor terraform
# shellcheck disable=SC2154
cd "infra/${vendor}/"

terraform destroy -auto-approve
