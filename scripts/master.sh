#!/bin/bash
# Main Orchestrator
# Author: Leandro Fabian Zenteno Soliz

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
turquoiseColour="\e[0;36m\033[1m"

echo -e "\n🚀 ${redColour}AWS EC2 + IAM Lab - Complete Orchestration${endColour}"
echo "=============================================="

# 1. Create everything
echo -e "\n📌 ${yellowColour}Phase 1: Creating infrastructure...${endColour}"
./01-create-keypair.sh
./02-create-security-group.sh
./03-create-iam-role.sh
./04-launch-ec2.sh

# 2. verify instance 
echo -e "\n📌 ${yellowColour}Phase 2: Verifying deployment...${endColour}"
./05-verify-instance.sh

# 3. Show connection instructions
INSTANCE_ID=$(cat .instance-id.txt)
KEY_NAME=$(cat .key-name.txt)
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo -e "\n📝 ${greenColour}Connection Instructions:${endColour}"
echo "==========================="
echo -e "${yellowColour}ssh -i ${KEY_NAME}.pem ec2-user@$PUBLIC_IP${endColour}"
echo -e "\n📌 ${turquoiseColour}Test S3 access inside instance:${endColour}"
echo -e "aws s3 ls"
echo ""

# 4. Ask about cleanup
echo -e "${redColour}⚠️  Remember to clean up resources to avoid charges!${endColour}"
read -p "Clean up now? (y/N): " CLEAN

if [[ "$CLEAN" =~ ^[yY]$ ]]; then
     ./06-cleanup.sh
else
     echo -e "⚠️  ${yellowColour}Resources still running. Run ./06-cleanup.sh later${endColour}"
fi
