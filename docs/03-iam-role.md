
---

## **📄 docs/03-iam-role.md**

```markdown
# 🔑 IAM Roles for EC2

## What is an IAM Role?
An identity with permissions that can be assumed by AWS services (like EC2).

## Why Roles Instead of Users?
- ✅ No long-term credentials on instances
- ✅ Automatic key rotation
- ✅ Centralized permissions management
- ✅ Audit trail in CloudTrail

## Components
1. **Trust Policy**: Who can assume the role (EC2 service)
2. **Permissions Policy**: What actions are allowed (S3 ReadOnly)
3. **Instance Profile**: Container for the role (EC2 requirement)

## Useful Commands
```bash
# List roles
aws iam list-roles

# Attach policy
aws iam attach-role-policy \
   --role-name my-role \
   --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Remove policy
aws iam detach-role-policy \
   --role-name my-role \
   --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Common Issues

* "Not authorized": Role missing permissions

* "Profile not found": Forgot to create instance profile

* "Can't assume role": Trust policy incorrect
