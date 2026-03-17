# 🗺️ System Architecture

This lab orchestrates a secure connection between identity management and compute resources.

## Workflow
1. **IAM Role & Policy:** A Trust Policy allows the EC2 service to assume a specific role.
2. **Instance Profile:** Acts as a container for the IAM Role to pass credentials to the EC2.
3. **EC2 Provisioning:** The instance is launched with the Instance Profile attached.
4. **User Data Execution:** On first boot, the instance uses its assigned permissions to verify S3 access without needing manual credentials (using IMDSv2).

``` text
┌─────────────────┐
│ Internet │
└────────┬────────┘
│
┌────────▼────────┐
│ Security Group │
│ (Port 22 only) │
└────────┬────────┘
│
┌────────▼────────┐
┌─────────────────┐ │ EC2 Instance │
│ IAM Role │◄────────────────│ t2.micro │
│ (S3 ReadOnly) │ │ Amazon Linux 2 │
└─────────────────┘ └────────┬────────┘
│
┌────────▼────────┐
│ User Data │
│ (Bootstrap) │
└─────────────────┘
```

## Security Layers

### Layer 1: Network Security (Security Group)
- ✅ SSH access restricted to specific IP
- ✅ No unnecessary ports open
- ✅ Default deny all inbound

### Layer 2: Access Security (Key Pair)
- ✅ 400 permissions on private key
- ✅ Unique key per environment
- ✅ No shared keys

### Layer 3: Identity Security (IAM Role)
- ✅ No AWS keys on instance
- ✅ Least privilege permissions
- ✅ Automatic credential rotation

### Layer 4: Instance Security (User Data)
- ✅ Updated packages on boot
- ✅ Consistent configuration
- ✅ No manual steps needed

## Data Flow

### SSH Access Flow

1. User initiates SSH from authorized IP

2. Security Group allows port 22

3. Instance validates private key

4. Session established


### S3 Access Flow

1. Application calls S3 API

2. Instance metadata provides temporary credentials

3. IAM Role authorizes request

4. S3 returns data


## Resource Dependencies
```text
Key Pair (independent)
│
└──► EC2 Instance
▲
│
Security Group (independent)
│
└──► EC2 Instance
▲
│
IAM Role (independent)
│
└──► Instance Profile
│
└──► EC2 instance
```

