# 🔑 Key Pairs in AWS

## What is a Key Pair?
It's a pair of keys (public and private) that allows secure SSH access to EC2 instances.

## Best Practices
1. **NEVER** share your private key (.pem)
2. Always use `chmod 400`
3. Different keys for different environments
4. Rotate keys periodically

## Useful Commands
```bash
# List key pairs
aws ec2 describe-key-pairs

# Delete key pair
aws ec2 delete-key-pair \
   --key-name my-key

# Import existing key
aws ec2 import-key-pair \
   --key-name my-key \
   --public-key-material fileb://~/.ssh/id_rsa.pub

# Common Issues

* "Permission denied": Check file permissions (chmod 400)

* "Unprotected private key file": Same issue, fix with chmod

* "Key pair not found": Wrong region or key doesn't exist
