# 🚀 AWS High Availability Web Architecture (Terraform)

## 📌 Project Overview

This project demonstrates a **production-style, highly available web architecture on AWS** using **Terraform (Infrastructure as Code)**.

The setup follows DevOps best practices:

* Multi-AZ deployment
* Private EC2 instances
* Public-facing Application Load Balancer (ALB)
* Auto Scaling Group (ASG)
* Secure networking with VPC, NAT Gateway, and Security Groups

---

## 🏗️ Architecture

```
Internet
   ↓
Application Load Balancer (Public Subnets)
   ↓
Auto Scaling Group (Private Subnets)
   ↓
EC2 Instances (Nginx)
   ↓
NAT Gateway (Outbound Internet Access)
```

---

## ⚙️ Technologies Used

* AWS (VPC, EC2, ALB, ASG, NAT Gateway)
* Terraform
* Linux (Amazon Linux)
* Nginx

---

## 🔧 Key Features

### 🌐 Networking

* Custom VPC (10.0.0.0/16)
* Public & Private Subnets across multiple Availability Zones
* Internet Gateway for public access
* NAT Gateway for secure outbound traffic from private instances

### ⚖️ Load Balancing

* Application Load Balancer (ALB)
* HTTP listener on port 80
* Target Group with health checks

### 🔄 Auto Scaling

* Launch Template for EC2 configuration
* Auto Scaling Group:

  * Min: 1
  * Desired: 2
  * Max: 3
* Automatic instance replacement (self-healing)

### 🔐 Security

* Private EC2 instances (no public IP)
* Security Groups:

  * ALB → allows HTTP from internet
  * EC2 → allows HTTP only from ALB

### ⚡ Automation

* EC2 bootstrapped using user_data
* Nginx installed and started automatically

---

## 🚀 How to Deploy

### 1️⃣ Clone the repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Apply the configuration

```bash
terraform apply
```

### 4️⃣ Access the Application

After deployment, Terraform outputs:

```
alb_dns_name = "test-lb-tf-1860575745.ap-south-1.elb.amazonaws.com"
```

Open in browser:

```
http://test-lb-tf-1860575745.ap-south-1.elb.amazonaws.com
```

---

## 🧪 Testing

### ✅ Test Auto-Healing

* Manually terminate an EC2 instance
* ASG will automatically launch a new instance

### ✅ Test Load Balancing

* Refresh browser multiple times
* Traffic is distributed across instances

---

## 📊 Future Improvements

* Add HTTPS using AWS Certificate Manager (ACM)
* Implement Auto Scaling policies (CPU-based scaling)
* Add CloudWatch monitoring & alerts
* CI/CD pipeline integration (GitHub Actions / GitLab CI)

---

## 📸 Screenshots

(Add screenshots here: ALB, ASG, Target Group Health, etc.)
![image alt](https://github.com/Mohan41204/AWS-High-Availability-Web-Architecture-Task/blob/main/Task-2-Images/Architecture-Diagram.png?raw=true)
![image alt](https://github.com/Mohan41204/AWS-High-Availability-Web-Architecture-Task/blob/main/Task-2-Images/VPC.png?raw=true)

---

## 👨‍💻 Author

Mohankumar U

---

## ⭐ If you found this useful

Give this repo a star ⭐
