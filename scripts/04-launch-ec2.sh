#!/bin/bash
# Script to launch EC2 Instance
# Author: Leandro Fabian Zenteno Soliz 

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
yellowColour="\e[0;33m\033[1m"

set -e

echo -e "\n${yellowColour}🚀 Launching EC2 instance...${endColour}"

# Load saved IDs 
KEY_NAME=$(cat .key-name.txt)
SG_ID=$(cat .sg-id.txt)
PROFILE_NAME=$(cat .profile-name.txt)

echo -e "\n📌 Key: ${greenColour}$KEY_NAME${endColour}"
echo -e "📌 SG: ${greenColour}$SG_ID${endColour}"
echo -e "📌 Profile: ${greenColour}$PROFILE_NAME${endColour}"

# Find latest Amazon Linux 2023 AMI (Actualizado de amzn2 a al2023)
AMI_ID=$(aws ec2 describe-images \
     --owners amazon \
     --filters "Name=name,Values=al2023-ami-2023*-x86_64" \
     --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' \
     --output text)

echo -e "📌 AMI: ${greenColour}$AMI_ID${endColour}"

# Launch Instance 
INSTANCE_ID=$(aws ec2 run-instances \
   --image-id "$AMI_ID" \
   --instance-type t2.micro \
   --key-name "$KEY_NAME" \
   --security-group-ids "$SG_ID" \
   --iam-instance-profile Name="$PROFILE_NAME" \
   --user-data "file://user-data.sh" \
   --query 'Instances[0].InstanceId' \
   --output text)

echo -e "✅ Instance launched: ${greenColour}$INSTANCE_ID${endColour}"

# Save Instance ID 
echo "$INSTANCE_ID" > .instance-id.txt

# Wait for instance to be running
echo -e "\n⏳ ${yellowColour}Waiting for instance to be running...${endColour}"
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get public IP 
PUBLIC_IP=$(aws ec2 describe-instances \
   --instance-ids "$INSTANCE_ID" \
   --query 'Reservations[0].Instances[0].PublicIpAddress' \
   --output text)

echo -e "🌐 Public IP: ${greenColour}$PUBLIC_IP${endColour}"
