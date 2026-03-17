## **📄 docs/04-launch-ec2.md**

# 🚀 Launching EC2 Instances

## Required Parameters
| Parameter | Description | Example |
|-----------|-------------|---------|
| `--image-id` | AMI ID (operating system) | ami-0c02fb55956c7d316 |
| `--instance-type` | Hardware specs | t2.micro |
| `--key-name` | Key pair for SSH | lab-key |
| `--security-group-ids` | Firewall rules | sg-123456 |
| `--count` | Number of instances | 1 |

## Optional but Important
- `--user-data`: Bootstrap script
- `--iam-instance-profile`: IAM role
- `--tag-specifications`: Resource tags

## User Data Script Tips
- Script runs as root
- Logs at `/var/log/cloud-init-output.log`
- Only runs on first boot
- Must start with `#!/bin/bash`

## Common Issues
- **"InvalidAMIID.NotFound"**: Wrong region or AMI ID
- **"Max spot instance count exceeded"**: Account limits
- **"InsufficientInstanceCapacity"": AWS capacity issues (try different AZ)
