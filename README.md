# 🏗️ AWS High Availability Web Architecture

> Production-grade, highly available web infrastructure on AWS — built with Terraform (IaC), automated with GitHub Actions CI/CD, and designed for resilience, security, and scalability.

[![Terraform](https://img.shields.io/badge/Terraform-1.x-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws)](https://aws.amazon.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions)](https://github.com/features/actions)
[![Nginx](https://img.shields.io/badge/Web%20Server-Nginx-009639?logo=nginx)](https://nginx.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📌 Project Overview

This project provisions and manages a **production-ready, fault-tolerant web infrastructure** on AWS using infrastructure as code principles. It demonstrates a complete DevOps lifecycle — from manual cloud provisioning to a fully automated deployment pipeline.

The architecture is designed around AWS best practices:
- **High availability** across multiple Availability Zones
- **Security by design** with private subnets, NAT Gateways, and no direct EC2 exposure
- **Auto Scaling** to handle variable traffic loads automatically
- **Remote state management** for safe team collaboration
- **Full CI/CD automation** with validation, security scanning, and zero-touch deployments

---

## 🚀 Project Evolution

This project was built iteratively, reflecting a real-world DevOps maturity journey:

### Phase 1  
Manual AWS Console Setup "Click-ops" — resources created manually via AWS Management Console. Functional but not reproducible, version-controlled, or scalable.

### Phase 2 
Terraform (Infrastructure as Code) All AWS resources converted into modular Terraform configurations. Infrastructure became reproducible, versionable, and reviewable via Pull Requests.

### Phase 3
GitHub Actions CI/CD Pipeline Deployment fully automated — every push triggers validation, security scans, planning, and controlled apply. Zero manual steps required.

This progression reflects how modern cloud infrastructure evolves from experimentation to enterprise-grade automation.

---

## 🏛️ Architecture Overview

![image alt](https://github.com/Mohan41204/AWS-High-Availability-Web-Architecture-Task/blob/main/Task-2-Images/Architecture-Diagram.png?raw=true)

**Traffic Flow:**
1. User request hits the **Application Load Balancer** (ALB) in the public subnet
2. ALB routes traffic to healthy **EC2 instances** (Nginx) in private subnets
3. EC2 instances access the internet via **NAT Gateway** (outbound only)
4. Auto Scaling Group ensures the right number of instances are always running

---

## 🛠️ Technologies Used

| Category | Technology | Purpose |
|---|---|---|
| **Cloud Provider** | AWS | Core infrastructure platform |
| **IaC** | Terraform | Infrastructure provisioning & management |
| **Compute** | EC2 + Auto Scaling Group | Web server instances with automatic scaling |
| **Networking** | VPC, Subnets, NAT Gateway | Isolated, secure network architecture |
| **Load Balancing** | Application Load Balancer (ALB) | Traffic distribution & health checks |
| **Web Server** | Nginx | HTTP server on EC2 instances |
| **State Backend** | S3 + DynamoDB | Remote state storage and locking |
| **CI/CD** | GitHub Actions | Automated pipeline for validate → plan → apply |
| **Linting** | TFLint | Terraform code quality checks |
---

## 📦 Terraform Module Structure

The project follows a **modular Terraform design** — each AWS concern is encapsulated in its own reusable module.

```
AWS-High_Availability-Web-Architecture/
├── main.tf                  # Root module — calls the modules
├── variables.tf             # Input variables for root module
├── outputs.tf               # Output values
├── provider.tf              # AWS provider configuration
├── backend.tf               # Remote backend (S3 + DynamoDB)
├── .terraform.lock.hcl      # Dependency lock file
├── .gitignore               # Git ignore rules
│
├── modules/                 # Single reusable module
│   ├── main.tf              # All resources (VPC, ALB, ASG, NAT, etc.)
│   ├── variables.tf         # Module input variables
│   └── outputs.tf           # Module outputs
│
├── .terraform/              # Terraform working directory (auto-generated)
│
└── Task-2-Images/           # Architecture diagrams & screenshots
```

**Why modular?**
- Each module has a **single responsibility** — easier to test and maintain
- Modules can be **reused** across environments (dev, staging, prod) with different variables
- Changes to one module don't affect others, reducing blast radius
- Outputs from one module are passed as inputs to another (e.g., VPC outputs feed ALB and ASG)

---

## 🗄️ Remote State Management

Terraform state is stored remotely to enable **team collaboration** and **state locking**.

### S3 — State Storage

The `terraform.tfstate` file is stored in a versioned S3 bucket, providing:
- A single source of truth for infrastructure state
- State history via S3 versioning (easy rollback)
- Encrypted at rest using SSE-S3

### DynamoDB — State Locking

A DynamoDB table handles distributed locking:
- Prevents two users (or pipeline runs) from applying simultaneously
- Lock is automatically acquired before `terraform apply` and released after
- Avoids state corruption in team environments

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "tfbackend24426"
    key            = "dev/network/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

---

## ⚙️ CI/CD Pipeline

The GitHub Actions pipeline enforces a **validate → scan → plan → apply** workflow, ensuring that only safe, reviewed infrastructure changes are deployed.

```
┌──────────────────────────────────────────────────────────────────┐
│                      CI Stage (on every PR/push)                 │
│                                                                  │
│  terraform init → terraform validate → terraform plan            │
│       ↓                   ↓                  ↓                   │
│  tflint (lint)       tfsec (security)   Save tfplan artifact     │
└──────────────────────────────────────────────────────────────────┘
                              │
                    (merge to main only)
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      CD Stage (on main merge)                    │
│                                                                  │
│    Download tfplan artifact → terraform apply (auto-approved)    │
└──────────────────────────────────────────────────────────────────┘
```

### CI Stage — Continuous Integration

| Step | Tool | Purpose |
|---|---|---|
| `terraform init` | Terraform | Initializes providers and remote backend |
| `terraform validate` | Terraform | Validates HCL syntax and configuration correctness |
| `terraform plan` | Terraform | Generates and saves execution plan (`tfplan` artifact) |
| `tflint` | TFLint | Enforces Terraform best practices and catches common errors |

### CD Stage — Continuous Deployment

| Step | Tool | Purpose |
|---|---|---|
| Download artifact | GitHub Actions | Retrieves the `tfplan` from the CI stage |
| `terraform apply` | Terraform | Applies the exact plan generated in CI — no surprises |

> **Why use the tfplan artifact?**
> The apply stage uses the exact same plan generated during CI. This means what was reviewed and validated is exactly what gets deployed — no drift between plan and apply.

---

## ✨ Key Features

### 🌐 Networking
- **Custom VPC** with public and private subnet separation across multiple AZs
- **Internet Gateway** for public subnet outbound access
- **NAT Gateway** allows private EC2 instances to pull updates/packages without being publicly accessible
- **Route tables** strictly control traffic flow between subnets

### ⚖️ Load Balancing & Auto Scaling
- **ALB** performs health checks and only routes to healthy targets
- **Auto Scaling Group** maintains the desired instance count and replaces unhealthy instances automatically
- Scaling configuration: **min: 1 | desired: 2 | max: 3**
- EC2 instances are spread across AZs for fault tolerance

### 🔒 Security
- EC2 instances live in **private subnets** — no direct internet exposure
- **Security groups** follow least-privilege: ALB accepts HTTP/HTTPS; EC2 only accepts traffic from ALB
- tfsec integrated into CI catches security misconfigurations before deployment
- State stored encrypted in S3

### 🤖 Automation
- Every infrastructure change goes through automated **lint → security scan → plan → apply**
- **No manual AWS Console changes** required after initial setup
- Pipeline artifacts ensure CI-generated plan is exactly what gets applied in CD

---

## 🚀 Deployment Steps

### Prerequisites

- AWS account with appropriate IAM permissions
- Terraform `>= 1.0` installed
- AWS CLI configured (`aws configure`)
- GitHub repository with Actions enabled

### 1. Clone the Repository

```bash
git clone https://github.com/Mohan41204/AWS-High-Availability-Web-Architecture-Task
cd AWS-High-Availability-Web-Architecture-Task
```

### 2. Create Remote Backend Resources

Before initializing Terraform, create the S3 bucket and DynamoDB table manually (one-time setup):

```bash
# Create S3 bucket for state
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### 3. Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values (region, AMI ID, key pair, etc.)
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Plan & Review

```bash
terraform plan
```

### 6. Apply Infrastructure

```bash
terraform apply
```

### 7. CI/CD (Automated)

Add the following secrets to your GitHub repository:

| Secret | Description |
|---|---|
| `MY_ARN` | AWS OIDC ARN |
Push to `main` (or open a PR) — the pipeline handles everything from there.

---

## 🧪 Testing

### Infrastructure Validation

```bash
# Validate Terraform syntax and configuration
terraform validate

# Check for Terraform best practice violations
tflint --recursive
```

### Connectivity Testing

Once deployed, retrieve the ALB DNS name from Terraform outputs:

```bash
terraform output alb_dns_name
```

Then verify the web server is reachable:

```bash
# Basic HTTP check
curl http://<alb_dns_name>

# Expect HTTP 200 from Nginx
curl -o /dev/null -s -w "%{http_code}" http://<alb_dns_name>
```

### Auto Scaling Verification

1. Navigate to **EC2 → Auto Scaling Groups** in the AWS Console
2. Manually terminate one EC2 instance
3. Observe the ASG automatically launch a replacement within ~2 minutes

### ALB Health Checks

1. Navigate to **EC2 → Target Groups** in the AWS Console
2. Verify all targets show status `healthy`
3. Check health check thresholds and response codes

---

## 🔮 Future Improvements

| Improvement | Description |
|---|---|
| **HTTPS / SSL** | Add ACM certificate and HTTPS listener to ALB |
| **Custom Domain** | Integrate Route 53 for a custom domain with DNS failover |
| **WAF** | Attach AWS WAF to ALB for Layer 7 protection |
| **CloudWatch Alarms** | Add CPU/request-based alarms tied to scaling policies |
| **Multi-environment** | Separate Terraform workspaces or directories for dev/staging/prod |
| **RDS Backend** | Add a managed relational database in private subnets |
| **Cost Optimization** | Introduce Spot Instances in the ASG for non-critical capacity |
| **Terratest** | Write automated infrastructure tests using Terratest (Go) |
| **Terraform Drift Detection** | Scheduled pipeline job to detect config drift |
| **Secrets Manager** | Migrate sensitive config to AWS Secrets Manager |

---

## 📁 Repository Structure

```
AWS-High-Availability-Web-Architecture-Task/
├── main.tf                  # Root module — calls the modules
├── variables.tf             # Input variables for root module
├── outputs.tf               # Output values
├── provider.tf              # AWS provider configuration
├── backend.tf               # Remote backend (S3 + DynamoDB)
├── .terraform.lock.hcl      # Dependency lock file
├── .gitignore               # Git ignore rules
│
├── modules/                 # Single reusable module
│   ├── main.tf              # All resources (VPC, ALB, ASG, NAT, etc.)
│   ├── variables.tf         # Module input variables
│   └── outputs.tf           # Module outputs
│
├── .terraform/              # Terraform working directory (auto-generated)
│
└── Task-2-Images/           # Architecture diagrams & screenshots
```

---

## 👤 Author

**Mohankumar.U**
- GitHub: [@your-username](https://github.com/Mohan41204)
- LinkedIn: [linkedin.com/in/your-profile](www.linkedin.com/in/mohandevop)

> ⭐ If you found this project useful or learned something from it, consider giving it a star!
