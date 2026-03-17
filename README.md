# ☁️ AWS EC2 & IAM Automation Lab

This repository contains a professional orchestration suite to deploy secure AWS infrastructure using the **AWS CLI** and **Bash scripting**. 

The project demonstrates the automated integration of Identity and Access Management (IAM) with Compute resources (EC2), following cloud security best practices.

---

## 🏗️ Project Architecture

The lab automates the creation of a secure environment where an EC2 instance is granted specific, limited permissions to interact with S3 without using hardcoded credentials.



### Key Features:
* **Automated Identity Management:** Creates IAM Roles and Instance Profiles dynamically.
* **Network Hardening:** Provisions Security Groups restricted to the administrator's Public IP.
* **Bootstrapping:** Uses `user-data` scripts to auto-configure the instance on first boot.
* **Clean-up Suite:** Includes a full teardown script to avoid AWS costs.

---

## 📂 Repository Structure

```text
aws-ec2-iam-lab/
├── scripts/                # Bash automation scripts
│   ├── 01-create-keypair.sh
│   ├── 02-create-security-group.sh
│   ├── 03-create-iam-role.sh
│   ├── 04-launch-ec2.sh
│   ├── 05-verify-instance.sh
│   ├── 06-cleanup.sh
│   └── master.sh           # Main orchestrator
├── docs/                   # Detailed technical documentation
│   ├── 01-keypair.md
│   ├── 02-security-group.md
│   ├── 03-iam-role.md
│   ├── 04-launch-ec2.md
│   ├── 05-troubleshooting.md
│   └── ARCHITECTURE.md     # Deep dive into the design
└── README.md
