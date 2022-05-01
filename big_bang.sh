#!/usr/bin/env bash
set -xeou pipefail

# Track the location of the script and go there
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

# Detect the active vendor
echo "[Info] Detecting vendor..."

vendor='exoscale'

echo "[Info] ${vendor} detected"
# Switch to the vendor terraform
cd "infra/${vendor}/"

echo "[Info] Terraform phase"
terraform apply

echo "[Info] Hosts configuration"
cat ../../hosts

# Go to ansible now to do ansible stuff
cd ../../ansible

# Give some extra time
echo "[Info] Waiting a bit for all routing to be online..."
sleep 30
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i "../hosts" site.yml --skip-tags ddclient
