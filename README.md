# DevSecOps & Cloud Security Automation Lab

A hands-on Infrastructure as Code (IaC) security project
demonstrating automated detection, remediation, and
regression testing of AWS cloud misconfigurations.

## Technology Stack
- Terraform
- AWS infrastructure definitions
- Checkov
- Python 3.12
- Bash
- GitHub Actions

## Security Scenarios

### 1. Unrestricted SSH Access
- Policy: CKV_AWS_24
- Insecure: SSH port 22 accessible from 0.0.0.0/0
- Remediation: Remove unnecessary inbound SSH access
- Validation: Automated positive and negative tests

### 2. S3 Public Access Protections
- Policies: CKV_AWS_53, CKV_AWS_54,
  CKV_AWS_55, CKV_AWS_56
- Insecure: Four public-access-block settings disabled
- Remediation: Enable all four protections
- Validation: Automated positive and negative tests

## Local Security Tests

Activate the Python environment and install dependencies:

    python3 -m venv .venv
    source .venv/bin/activate
    python -m pip install -r requirements-dev.txt

Run the regression tests:

    bash scripts/test_ssh_policy.sh
    bash scripts/test_s3_policy.sh

## Terraform Validation

The secure configuration uses the HashiCorp AWS provider.

    terraform -chdir=terraform/secure init -backend=false
    terraform -chdir=terraform/secure validate

## CI/CD Pipeline

The GitHub Actions workflow is configured to perform:
- Terraform formatting checks
- Terraform configuration validation
- Automated SSH security regression testing
- Automated S3 security regression testing

GitHub-hosted execution is pending verification.

## Known Limitations

The secure standalone security group still triggers
CKV2_AWS_5 because it is not attached to another resource.

The automated tests cover five selected Checkov policies,
not a complete infrastructure security assessment.

The insecure configurations are demonstration fixtures.
No AWS resources are deployed by this project.

## Future Enhancements

- Trivy integration
- Additional AWS security controls
- Stronger CI policy enforcement
- GitHub branch protection
- Security evidence and reporting
