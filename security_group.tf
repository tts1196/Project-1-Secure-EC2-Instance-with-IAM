# Security group for EC2 instance
resource "aws_security_group" "secure_sg" {
  name        = "SecureSG"
  description = "Security group with no inbound traffic and unrestricted outbound traffic"

  # No inbound traffic allowed
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Deny all protocols
    cidr_blocks = []
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SecureSG"
    Project = "Week1"
  }
}
