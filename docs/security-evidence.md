# Security Validation and Evidence

## Project Overview

This lab demonstrates automated Infrastructure as Code
security validation using Terraform, Checkov, Trivy,
Python, Bash, and GitHub Actions.

All Terraform infrastructure examples are evaluated
without deploying resources to AWS.

## 1. Security Scenarios

### Unrestricted SSH Access

Risk:
Inbound TCP port 22 accessible from 0.0.0.0/0.

Detection:
- Checkov CKV_AWS_24
- Trivy AWS-0107

Remediation:
Remove unnecessary inbound SSH access.

Validation:
The insecure configuration was rejected and the
remediated configuration passed the targeted tests.

### S3 Public Access

Risk:
Four public-access-block controls disabled.

Detection:
- Checkov CKV_AWS_53
- Checkov CKV_AWS_54
- Checkov CKV_AWS_55
- Checkov CKV_AWS_56

Remediation:
Enable all four S3 public-access-block settings.

Validation:
All four expected violations were detected, and the
remediated configuration passed the targeted checks.

### S3 Versioning and Lifecycle

Improvements:
- Enabled bucket versioning.
- Added a lifecycle rule for noncurrent object versions.

Validation:
- Terraform configuration validation passed.
- Checkov CKV_AWS_21 was addressed.
- Checkov CKV2_AWS_61 passed.
- Trivy AWS-0090 was no longer reported.

## 2. Trivy Findings

Initial insecure configuration:
- 8 findings
- 6 HIGH
- 1 MEDIUM
- 1 LOW

Latest validated remediated configuration:
- 2 findings
- AWS-0089: S3 access logging (LOW)
- AWS-0132: Customer-managed KMS encryption (HIGH)

Result:
Six fewer findings in the remediated configuration.

These findings are documented limitations, not
claims of production compliance.

## 3. GitHub Actions Security Gate

Test branch:
test/insecure-ssh-gate

Controlled test:
Unrestricted SSH ingress was introduced into
terraform/secure/main.tf.

Expected behavior:
- Terraform validation passes.
- Checkov detects CKV_AWS_24.
- Required GitHub Actions security validation fails.
- Pull request merging is blocked.

Observed behavior:
- Security validation failed.
- GitHub displayed the check as required.
- The merge button was disabled.
- After remediation, the workflow passed.
- The test pull request was closed without merging.

No insecure infrastructure was deployed.

## 4. Security Limitations

- The lab is based on static Terraform configuration.
- No AWS deployment or runtime penetration test
  was performed.
- Targeted regression tests do not constitute a
  complete security assessment.
- The standalone security group has no attachment
  to a workload.
- S3 access logging and customer-managed KMS
  encryption remain outstanding Trivy findings.
- Additional full-scan Checkov findings must be
  assessed separately.
- GitHub Actions and scanner dependencies require
  ongoing maintenance and periodic review.

## 5. Evidence Locations

GitHub Actions:
https://github.com/saintgab/devsecops-cloud-security-lab/actions

Repository:
https://github.com/saintgab/devsecops-cloud-security-lab

Supporting evidence:
- Terraform configurations
- Automated security regression tests
- GitHub Actions execution history
- Closed security test pull request
