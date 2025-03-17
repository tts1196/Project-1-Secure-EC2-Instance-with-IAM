# 🚀 Terraform Workflow: Secure EC2 Instance Deployment

This guide provides a step-by-step **workflow** for deploying a secure EC2 instance using Terraform.

---

## 📌 **1. Define Variables (`variables.tf`)**
This file contains configurable parameters:
- **AWS region** (`ap-northeast-1` for Tokyo)
- **AMI ID** (Ubuntu 22.04)
- **Instance Type** (t2.micro for free tier)

These variables make the configuration flexible.

```hcl
variable "region" {
  default = "ap-northeast-1"
}

variable "ami_id" {
  default = "ami-0abcdef1234567890"
}

variable "instance_type" {
  default = "t2.micro"
}
```

---

## 🔒 **2. Create a Security Group (`securitygroup.tf`)**
A security group is created to **block all inbound traffic** and allow **all outbound traffic**.

```hcl
resource "aws_security_group" "secure_sg" {
  name        = "SecureSG"
  description = "Security group with no inbound traffic and unrestricted outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

## 🛠 **3. Create an IAM Role for EC2 (`role.tf`)**
This IAM Role allows EC2 to communicate with **AWS SSM (Systems Manager)** for remote management **without SSH**.

```hcl
resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
```

---

## 📜 **4. Attach SSM Permissions to the IAM Role**
This allows **remote access via AWS SSM** instead of SSH.

```hcl
resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "SSMPolicyAttachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
```

---

## ☁️ **5. Define the AWS Provider (`provider.tf`)**
This tells Terraform to use AWS as the cloud provider.

```hcl
provider "aws" {
  region = var.region
}
```

---

## 🚀 **6. Deploy an EC2 Instance (`ec2.tf`)**
A **secure Ubuntu EC2 instance** with IAM Role and Security Group.

```hcl
resource "aws_instance" "secure_ubuntu" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  security_groups      = [aws_security_group.secure_sg.name]

  tags = {
    Name    = "Ubuntu-Instance"
    Project = "Week1"
  }
}
```

---

## 👨‍💻 **7. Create a Developer IAM User (`devusers.tf`)**
A separate **IAM user** is created for secure access.

```hcl
resource "aws_iam_user" "dev_user" {
  name = "DevUser"
}
```

---

## 🔐 **8. Grant Developer Permissions**
This IAM policy grants limited access to **SSM and EC2 descriptions**.

```hcl
resource "aws_iam_user_policy" "dev_user_policy" {
  name = "DevUserPolicy"
  user = aws_iam_user.dev_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:StartSession",
          "ssm:DescribeSessions",
          "ssm:TerminateSession",
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}
```

---

## 📤 **9. Output Important Information (`outputs.tf`)**
After deployment, Terraform outputs:

```hcl
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.secure_ubuntu.id
}
```

---

## 🔄 **10. Workflow Execution Steps**

### ✅ **1. Clone the Repository**
```sh
git clone https://github.com/your-username/terraform-secure-ec2-instance.git
cd terraform-secure-ec2-instance
```

### ✅ **2. Initialize Terraform**
```sh
terraform init
```

### ✅ **3. Apply the Configuration**
```sh
terraform apply -auto-approve
```

### ✅ **4. Connect Securely to EC2 (No SSH!)**
```sh
aws ssm start-session --target <instance-id>
```

---

## 🧹 **Destroy Resources (Cleanup)**
To remove all AWS resources:

```sh
terraform destroy -auto-approve
```

---

## 🎯 **Summary**
This Terraform workflow:
✅ Deploys a **secure EC2 instance** (No public access)  
✅ Uses **IAM Roles for SSM access** instead of SSH  
✅ Creates **a developer IAM user with limited permissions**  
✅ Uses **Terraform Cloud** for backend storage  

---

## 🚀 **Next Steps**
- ✅ **Add logging & monitoring (CloudWatch)**
- ✅ **Use Terraform modules for better structure**
- ✅ **Restrict IAM permissions further**

---

## 🤝 **Contribute**
Feel free to **fork** this repo and improve it! 🚀