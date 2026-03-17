#!/bin/bash 

# Scrip to verify instance
# Author: Leandro Fabian Zenteno Soliz

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

set -e 

INSTANCE_ID=$(cat .instance-id.txt)
KEY_NAME=$(cat .key-name.txt)

echo -e "\n🔍 ${yellowColour}Verifying instance $INSTANCE_ID...${endColour}"

# State 
STATE=$(aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].State.Name' \
  --output text)
echo -e "\n📊 ${grayColour}State:${endColour} $STATE"

# IPs 
IPS=$(aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].[PublicIpAddress,PrivateIpAddress]' \
  --output text) 
echo -e "🌐 ${grayColour}IPs:${endColour} $IPS"

# Security Group 
echo -e "${grayColour}🛡️ Security Groups:${endColour} "
aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].SecurityGroups' \
  --output text 

# IAM Profile 
echo -e "🔑 ${grayColour}IAM Profile:${endColour} "
aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].IamInstanceProfile' \
  --output text 

# User Data (if you want to verify)
echo "📜 User Data (first lines): "
aws ec2 describe-instance-attribute \
    --instance-id $INSTANCE_ID \
    --attribute userData \
    --query 'UserData.Value' \
    --output text | base64 -d | head -15

echo ""
echo -e "✅ ${greenColour}Verification complete${endColour}"
