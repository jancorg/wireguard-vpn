#!/usr/bin/env bash
set -xeou pipefail

# Track the location of the script and go there
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

# Load and save env variables
source env-vars.source_me

# Detect the active vendor
# shellcheck disable=SC2154
echo "[Info] Vendor is ${vendor}"

echo "[Info] ${vendor} detected"
# Switch to the vendor terraform
cd "infra/${vendor}/"

echo "[Info] Terraform phase"
terraform apply -auto-approve

echo "[Info] Hosts configuration"
cat ../../hosts

# Go to ansible now to do ansible stuff
cd ../../ansible

# Give some extra time
echo "[Info] Waiting a bit for all routing to be online..."
sleep 30
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i "../hosts" site.yml --skip-tags ddclient

# Start VPN connection
echo "[Info] Connecting to vpn defines in /tmp/generated_wg0.conf"
echo "[Info] You have 10 seconds to cancel."
sleep 10
wg-quick up /tmp/generated_wg0.conf

echo "[Info] wg-quick down /tmp/generated_wg0.conf when you want"