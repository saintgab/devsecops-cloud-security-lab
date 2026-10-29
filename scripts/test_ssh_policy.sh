#!/usr/bin/env bash
set -euo pipefail

echo "TEST 1: Secure SSH configuration"

if secure_output=$(checkov \
  -f terraform/secure/main.tf \
  --framework terraform \
  --check CKV_AWS_24 \
  --quiet --compact 2>&1); then
  echo "$secure_output"
else
  echo "$secure_output"
  echo "FAIL: Secure configuration rejected"
  exit 1
fi

if ! grep -q "Passed checks: 1, Failed checks: 0" <<< "$secure_output"; then
  echo "FAIL: Expected one passing SSH policy check"
  exit 1
fi

echo "PASS: Secure SSH configuration verified"
echo ""
echo "TEST 2: Insecure SSH configuration"

if insecure_output=$(checkov \
  -f terraform/insecure/main.tf \
  --framework terraform \
  --check CKV_AWS_24 \
  --quiet --compact 2>&1); then
  echo "$insecure_output"
  echo "FAIL: Insecure configuration accepted"
  exit 1
else
  echo "$insecure_output"
fi

if ! grep -q "Passed checks: 0, Failed checks: 1" <<< "$insecure_output"; then
  echo "FAIL: Expected exactly one security violation"
  exit 1
fi

if ! grep -q "Check: CKV_AWS_24:" <<< "$insecure_output"; then
  echo "FAIL: Expected SSH exposure finding is missing"
  exit 1
fi

echo "PASS: Insecure SSH configuration correctly rejected"
echo ""
echo "SUCCESS: SSH security regression tests passed"
