resource "aws_security_group" "secure_access" {
  name        = "devsecops-lab-secure-access"
  description = "Security group with no inbound SSH access"

  tags = {
    Project     = "DevSecOps-Security-Lab"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}
