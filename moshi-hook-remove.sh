#!/usr/bin/env bash
set -euo pipefail

# Revoke every active Moshi SSH key
moshi-hook host list | awk '$NF=="active"{print $1}' | while read -r id; do
  moshi-hook host revoke "$id"
done

moshi-hook host list

# Start a fresh pairing (prints a new QR code)
moshi-hook host setup
