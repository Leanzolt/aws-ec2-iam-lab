# 🔧 Troubleshooting Guide

## SSH Connection Issues

### "Connection Timeout"
* **Reason:** Your public IP might have changed, or the Security Group is not allowing Port 22.
* **Fix:** 1. Check your current IP: `curl checkip.amazonaws.com`.
  2. Verify Security Group rules: 
     ```bash
     aws ec2 describe-security-groups --group-ids sg-YOURID
     ```

## IAM Propagation Latency
* **Issue:** You log in, run `aws s3 ls`, and get an "Access Denied" even though the role is attached.
* **Reason:** IAM roles can take up to 60-90 seconds to fully propagate through AWS globally.
* **Fix:** Wait 2 minutes and try again. If it persists, verify the **Trust Policy** in the `03-iam-role.md` documentation.

## User Data Logs
* **Issue:** The software (httpd, git) didn't install.
* **Fix:** Check the logs inside the instance:
  ```bash
  cat /var/log/user-data.log

### "Permission denied (publickey)"
```bash
# Check key permissions
ls -la *.pem
chmod 400 your-key.pem

# Verify key name matches
aws ec2 describe-instances \
   --instance-ids i-123 \
   --query 'Reservations[0].Instances[0].KeyName'

# Try connecting with -v for verbose
ssh -v -i your-key.pem ec2-user@IP
```

