#!/usr/bin/env bash
set -euo pipefail

CHECKS="CKV_AWS_53,CKV_AWS_54,CKV_AWS_55,CKV_AWS_56"

echo "TEST 1: Secure S3 configuration"

if secure_output=$(checkov \
  -f terraform/secure/s3.tf \
  --framework terraform \
  --check "$CHECKS" \
  --quiet --compact 2>&1); then
  echo "$secure_output"
else
  echo "$secure_output"
  echo "FAIL: Secure configuration rejected"
  exit 1
fi

if ! grep -q "Passed checks: 4, Failed checks: 0" <<< "$secure_output"; then
  echo "FAIL: Expected four passing checks"
  exit 1
fi

echo "PASS: All four secure S3 controls verified"
echo ""
echo "TEST 2: Insecure S3 configuration"

if insecure_output=$(checkov \
  -f terraform/insecure/s3.tf \
  --framework terraform \
  --check "$CHECKS" \
  --quiet --compact 2>&1); then
  echo "$insecure_output"
  echo "FAIL: Insecure configuration accepted"
  exit 1
fi

echo "$insecure_output"

if ! grep -q "Failed checks: 4" <<< "$insecure_output"; then
  echo "FAIL: Expected four security violations"
  exit 1
fi

for id in CKV_AWS_53 CKV_AWS_54 CKV_AWS_55 CKV_AWS_56; do
  if ! grep -q "Check: ${id}:" <<< "$insecure_output"; then
    echo "FAIL: Missing violation $id"
    exit 1
  fi
done

echo "PASS: All four insecure settings rejected"
echo ""
echo "SUCCESS: S3 security regression tests passed"
