# 🚀 AWS EC2 + IAM Lab - Pro Mode

## 📋 Description
Complete hands-on lab to deploy an EC2 instance with:
- ✅ Custom Key Pair
- ✅ Security Group with restricted access
- ✅ IAM Role with S3 permissions
- ✅ User Data for auto-configuration
- ✅ Secure SSH access

## 🎯 Learning Objectives
- Create and manage Key Pairs
- Configure Security Groups professionally
- Implement IAM Roles for EC2
- Launch instances with specific permissions
- Clean up resources to avoid costs

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
```

## 🛠️ Prerequisites
- AWS CLI installed and configured
- AWS account with sufficient permissions
- Git installed
- Text editor (vim/nvim/code)

## 🚦 Lab Steps

### Phase 1: Preparation
1. Configure AWS CLI
2. Clone/create project structure
3. Check region and credentials

### Phase 2: Base Infrastructure
4. Create secure Key Pair
5. Create Security Group with restricted access
6. Create IAM Role and Policy

### Phase 3: Deployment
7. Prepare User Data script
8. Launch EC2 instance
9. Verify access and permissions

### Phase 4: Cleanup
10. Terminate instance
11. Delete resources
12. Check billing

## ⚠️ SECURITY WARNING
**NEVER** upload to GitHub:
- ❌ `.pem` files (private keys)
- ❌ AWS credentials
- ❌ Sensitive IDs

## 📊 Architecture Diagram
```text
[Your IP] ──SSH:22──> [Security Group] ──> [EC2 Instance]
│
[IAM Role] ──S3 Read──> [S3 Bucket]
```

## 🧪 Main Commands

```bash
# Create Key Pair
aws ec2 create-key-pair \
   --key-name lab-key \
   --query 'KeyMaterial' \
   --output text > lab-key.pem

# Create Security Group
SG_ID=$(aws ec2 create-security-group \
           --group-name lab-sg \
           --description "Lab security group" \
           --vpc-id $(aws ec2 describe-vpcs --filters Name=is-default,Values=true --query Vpcs[0].VpcId --output text) \
           --query GroupId \
           --output text)

# Authorize SSH
aws ec2 authorize-security-group-ingress \
   --group-id $SG_ID \
   --protocol tcp \
   --port 22 \
   --cidr $(curl -s ifconfig.me)/32

# Create IAM Role
aws iam create-role \
   --role-name lab-ec2-role \
   --assume-role-policy-document file://trust-policy.json

# Launch instance
INSTANCE_ID=$(aws ec2 run-instances \
                --image-id $(aws ec2 describe-images --owners amazon --filters Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2 --query Images[0].ImageId --output text) \
                --instance-type t2.micro \
                --key-name lab-key \
                --security-group-ids $SG_ID \
                --iam-instance-profile Name=lab-ec2-profile \
                --user-data file://user-data.sh \
                --query Instances[0].InstanceId \
                --output text)
```


