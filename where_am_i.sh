#!/usr/bin/env bash

set -eofu pipefail

whois "$(curl -s ifconfig.me)" | grep 'country' | head -1 | awk '{print $2}'
