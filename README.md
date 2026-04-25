# 🚀 AWS High Availability Web Architecture

> Production-grade, highly available web infrastructure on AWS — built with Terraform (IaC), automated with GitHub Actions CI/CD, and designed for scalability, reliability, and security.

---

## 📌 Project Overview

This project demonstrates a **real-world DevOps workflow**, where a highly available AWS infrastructure is:

- Designed and deployed manually  
- Converted into **Infrastructure as Code (Terraform)**  
- Fully automated using a **CI/CD pipeline (GitHub Actions)**  

The architecture ensures:
- High availability across multiple AZs  
- Secure private infrastructure  
- Automated scaling and self-healing  
- Reproducible and version-controlled deployments  

---

## 🚀 Project Journey

### 🔹 Phase 1 — Manual Setup
- Infrastructure created using AWS Console  
- Understood core concepts (VPC, ALB, ASG, Networking)  

### 🔹 Phase 2 — Terraform (IaC)
- Entire setup converted into Terraform  
- Infrastructure became reusable, scalable, and version-controlled  

### 🔹 Phase 3 — CI/CD Automation
- Deployment automated using GitHub Actions  
- Pipeline handles validation, planning, and deployment  

---

## 🏗️ Architecture

![Architecture Diagram](https://github.com/Mohan41204/AWS-High-Availability-Web-Architecture-Task/blob/main/Task-2-Images/Architecture-Diagram.png?raw=true)

---

## 🛠️ Technologies Used

- AWS (VPC, EC2, ALB, Auto Scaling Group, NAT Gateway, S3, DynamoDB)  
- Terraform  
- GitHub Actions (CI/CD)  
- TFLint (linting)  
- Nginx  

---

## 🗄️ Remote State Management

To make the infrastructure production-ready:

- **S3 Bucket** → Stores Terraform state  
- **DynamoDB Table** → Provides state locking  

### Benefits:
- Prevents state conflicts  
- Enables team collaboration  
- Ensures safe deployments  

---

## ⚙️ CI/CD Pipeline

The pipeline follows a **CI → CD approach**:

### 🧪 CI Stage
- `terraform init`  
- `terraform validate`  
- `terraform plan`  
- `tflint` (code quality)  
- Generates **tfplan artifact**  

### 🚀 CD Stage
- Downloads saved plan  
- Executes `terraform apply`  

### Key Highlights:
- Separation of validation and deployment  
- Artifact-based deployment (same plan used in apply)  
- Fully automated infrastructure provisioning  

---

## ✨ Key Features

### 🌐 Networking
- Custom VPC with public & private subnets  
- Internet Gateway and NAT Gateway  
- Controlled routing between layers  

### ⚖️ Load Balancing & Scaling
- Application Load Balancer with health checks  
- Auto Scaling Group:
  - Min: 1  
  - Desired: 2  
  - Max: 3  
- Self-healing infrastructure  

### 🔒 Security
- EC2 instances in private subnets  
- No direct public access  
- Controlled access via security groups  

### 🤖 Automation
- Infrastructure fully managed via Terraform  
- CI/CD pipeline automates deployment  
- No manual intervention required  

---

## 🚀 Deployment Steps

```bash
git clone https://github.com/Mohan41204/AWS-High-Availability-Web-Architecture-Task
cd AWS-High-Availability-Web-Architecture-Task

terraform init
terraform apply
