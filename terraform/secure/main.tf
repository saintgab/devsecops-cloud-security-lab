resource "aws_security_group" "secure_access" {
  name        = "devsecops-lab-secure-access"
  description = "Security group with no inbound SSH access"

  ingress {
    description = "CI security gate test only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = "DevSecOps-Security-Lab"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}
