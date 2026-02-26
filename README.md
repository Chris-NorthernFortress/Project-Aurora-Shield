# Project Aurora Shield 🛡️
**Advanced Cloud Networking & Security Hardening Lab**

## Overview
This project demonstrates a production-grade deployment of a hardened Linux infrastructure on AWS. It features a custom-built network topology and active security monitoring tools.

## Key Evolution: Phase 2 & 3
We transitioned from a default AWS setup to a **Custom VPC Architecture**, implementing network isolation and real-time threat detection.

## Architecture Features
* **Infrastructure as Code:** 100% automated with Terraform.
* **Networking (VPC):** * Custom VPC (10.0.0.0/16) for complete isolation.
    * Public Subnet with specific Route Tables and Internet Gateway.
* **Security & Hardening:**
    * **ZRAM Optimization:** Kernel-level memory compression (zstd) via User Data.
    * **SIEM Junior Lab:** Custom Bash monitoring scripts for `systemd-journald` to detect SSH brute-force attacks.
    * **Security Groups:** "Allow-list" approach for SSH traffic.

## Security Insights
During testing, the system successfully identified and logged unauthorized access attempts from external IPs (e.g., brute-force bots), confirming the effectiveness of the monitoring layer.

## How to Deploy
1. `terraform init`
2. `terraform apply`
3. Run `./check_attacks.sh` to see real-time security logs.

---
*Developed by Christian | Northern Fortress Labs*
