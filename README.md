# 🚀 Secure EC2 Deployment with Terraform Cloud
![image](https://github.com/user-attachments/assets/928c149a-9c5d-4bcf-a82f-3baea87c85d9)

## 📌 Project Purpose
This project automates the provisioning of a **secure EC2 instance** using **Terraform Cloud** and **AWS IAM best practices**. Key security measures include:
- Using **IAM roles** instead of hardcoded credentials
- **SSM Session Manager** for remote access (No SSH)
- **Terraform Cloud Remote Backend** for secure state management

---

## 🛠️ Used Technologies
| Technology       | Purpose |
|-----------------|---------|
| **Terraform**   | Infrastructure as Code (IaC) |
| **Terraform Cloud** | Remote State Management |
| **AWS IAM**     | Identity & Access Management |
| **AWS EC2**     | Virtual Machine Provisioning |
| **AWS SSM**     | Secure Instance Access |

---

## 📂 Code Structure
```bash
terraform-secure-ec2/
│── providers.tf       # AWS & Terraform Cloud Configuration
│── variables.tf       # Terraform Variables
│── security_group.tf  # Security Group Configuration
│── ec2.tf             # EC2 Instance Provisioning
│── iam_role.tf        # IAM Role for EC2
│── iam_user.tf        # IAM User for Developer
│── outputs.tf         # Outputs for EC2 & IAM User
│── README.md          # Project Documentation
```

---

## 🔄 Workflow Overview

### 1️⃣ **Setup AWS & Terraform Cloud**
 Obtain **AWS Access Key & Secret Key** for the master user (Admin permissions).
![week 1 - Frame 2](https://github.com/user-attachments/assets/b72928c3-f7a2-417e-8694-1f797b5be58e)


---

### 2️⃣ **Initialize Terraform Backend & Configure Provider**
- Configure **Terraform Cloud** as the backend (`provider.tf`):

```hcl
terraform {
  backend "remote" {
    organization = "Home_Labs_xvi"
    workspaces {
      name = "Week_1_Provision_a_Secure_EC2_Instance"
    }
  }
}

provider "aws" {
  region = var.region
}
```

---
![image](https://github.com/user-attachments/assets/e36b7c05-4279-44e2-bd87-16a155f58884)

### 3️⃣ **Define Security Policies**
- Create a **Security Group** that blocks all inbound traffic:

```hcl
resource "aws_security_group" "secure_sg" {
  name        = "SecureSG"
  description = "No inbound, unrestricted outbound"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []  # No inbound traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound
  }
}
```

---

### 4️⃣ **Provision an EC2 Instance**
- Deploy an **Ubuntu EC2 instance** with an **IAM role** for **SSM access**:

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

### 5️⃣ **Create IAM Role for EC2 (SSM Access)**
- Assign an **IAM Role** for EC2 to use AWS Systems Manager (SSM):

```hcl
resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "SSMPolicyAttachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}
```

---

### 6️⃣ **Create IAM User for Developer**
- Generate a **new IAM User** with limited EC2 & SSM permissions:

```hcl
resource "aws_iam_user" "dev_user" {
  name = "DevUser"
}

resource "aws_iam_user_policy" "dev_user_policy" {
  name = "DevUserPolicy"
  user = aws_iam_user.dev_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ssm:StartSession", "ssm:DescribeSessions", "ssm:TerminateSession",
        "ec2:DescribeInstances", "ec2:DescribeTags"
      ],
      Resource = "*"
    }]
  })
}
```

---

### 7️⃣ **Apply Terraform Configuration**
- Initialize Terraform & apply the changes:

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

---

### 8️⃣ **Get Output Values & Connect to EC2**
- Terraform provides output variables:

```hcl
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.secure_ubuntu.id
}

output "dev_user_access_key" {
  description = "Access key for the Dev User"
  value       = aws_iam_access_key.dev_user_access_key.id
  sensitive   = true
}
```

- Connect to EC2 securely using **AWS SSM**:

```sh
aws ssm start-session --target <INSTANCE_ID>
```

---

### 9️⃣ **Cleanup: Destroy Infrastructure**
- Remove all resources when no longer needed:

```sh
terraform destroy -auto-approve
```

---

## 📢 Conclusion
✅ **IAM-secured EC2 deployment with SSM access**
✅ **Remote state stored in Terraform Cloud**
✅ **Easily reproducible & secure Terraform automation**

---


