resource "aws_security_group" "insecure_ssh" {
  name        = "devsecops-lab-insecure-ssh"
  description = "Intentionally insecure SSH example for static scanning"

  ingress {
    description = "SSH open to the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "DevSecOps-Security-Lab"
  }
}
