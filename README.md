# Project Aurora Shield 🛡️
**Cloud Infrastructure & Security Hardening Lab**

## Overview
This project demonstrates an automated deployment of a hardened Linux node on AWS using **Infrastructure as Code (Terraform)**. It focuses on resource optimization and security best practices for cloud environments.

## Architecture Features
* **Provider:** AWS (us-east-1)
* **Infrastructure:** Immutable EC2 Instance (Amazon Linux 2023)
* **Security:** * Automated SSH Key Pair provisioning.
    * Strict Security Group rules (Port 22 restricted).
* **Performance Optimization:** * **ZRAM Implementation:** Configured via User Data to optimize memory efficiency using zstd compression.
    * Dynamic AMI Fetching using Terraform Data Sources.

## How to Deploy
1. Clone the repository.
2. Initialize Terraform: `terraform init`
3. Deploy: `terraform apply`

---
*Maintained by Christian | Northern Fortress Labs*
