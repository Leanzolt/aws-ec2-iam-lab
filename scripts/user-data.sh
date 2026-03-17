#!/bin/bash
# User Data script for EC2
# Executes on instance first boot

# Log everything
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "🚀 Starting instance configuration..."

# Update system
yum update -y

# Install useful tools
yum install -y \
    git \
    vim \
    htop \
    awscli

# Create welcome message
cat > /etc/motd << "EOF"
╔════════════════════════════════════════╗
║   AWS EC2 + IAM Lab                    ║
║   Instance configured with User Data    ║
║   S3 Access: CONFIGURED ✅              ║
╚════════════════════════════════════════╝
EOF

# Test S3 access
echo "📦 Testing S3 access..."
aws s3 ls > /tmp/s3-test.log 2>&1

if [ $? -eq 0 ]; then
    echo "✅ S3 access working" >> /tmp/s3-test.log
else
    echo "❌ S3 access error" >> /tmp/s3-test.log
fi

# Install and start web server (optional)
yum install -y httpd
echo "<h1>EC2 + IAM Lab - $(date)</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd

echo "✅ Configuration complete"
