## **📄 docs/02-security-group.md**

# 🛡️ Security Groups in AWS

## What is a Security Group?
A virtual firewall that controls traffic to/from your EC2 instances.

## Key Concepts
- **Stateful**: Return traffic automatically allowed
- **Deny by default**: All traffic blocked initially
- **Only allow rules**: No deny rules, only allow
- **Region/VPC specific**: Can't use across regions

## Best Practices
1. **Principle of least privilege**: Only open necessary ports
2. **Specific IPs**: Avoid 0.0.0.0/0 for SSH
3. **Separate SGs**: Web server vs Database
4. **Document rules**: Why is each port open?

## Useful Commands
```bash
# List security groups
aws ec2 describe-security-groups

# Add HTTP rule
aws ec2 authorize-security-group-ingress \
   --group-id sg-123 \
   --protocol tcp --port 80 \
   --cidr 0.0.0.0/0

# Remove rule
aws ec2 revoke-security-group-ingress \
   --group-id sg-123 --protocol tcp \
   --port 22 \
   --cidr YOUR-IP/32
```

# Common Issues

* "Timeout": SG blocking or instance not running

* "Connection refused": Service not running on instance

* "Can't connect from work": IP changed, update SG
