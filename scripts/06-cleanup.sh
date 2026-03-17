#!/bin/bash 
# Cleanup Script
# Author Leandro 

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"

set -e 

echo -e "${redColour}⚠️  Warning: This will delete all resources.${endColour}"
read -p "¿Are you sure? (y/n): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[yY]$ ]]; then
   echo "❌ Cancelled"
   exit 1 
fi

# Load IDs
[ -f .instance-id.txt ] && INSTANCE_ID=$(cat .instance-id.txt)
[ -f .sg-id.txt ] && SG_ID=$(cat .sg-id.txt)
[ -f .key-name.txt ] && KEY_NAME=$(cat .key-name.txt)
[ -f .profile-name.txt ] && PROFILE_NAME=$(cat .profile-name.txt)
[ -f .role-name.txt ] && ROLE_NAME=$(cat .role-name.txt)

# 1. Terminate instance
if [[ ! -z "$INSTANCE_ID" ]]; then
   echo -e "🔴 ${redColour}Terminating Instance $INSTANCE_ID...${endColour}"
   aws ec2 terminate-instances \
     --instance-ids "$INSTANCE_ID"
   aws ec2 wait instance-terminated \
     --instance-ids "$INSTANCE_ID"
   echo -e "✅ ${greenColour}Instance terminated.${endColour}"
fi

# 2. Delete security group
if [[ ! -z "$SG_ID" ]]; then
   echo -e "\n🔴 ${redColour}Deleting security group $SG_ID...${endColour}"
   # Reintento por si el ENI de la instancia tarda en soltarse
   sleep 5
   aws ec2 delete-security-group \
     --group-id "$SG_ID" || echo "⚠️  Manual delete might be needed if SG is still in use."
   echo -e "✅ ${greenColour}Security group cleanup attempted.${endColour}"
fi

# 3. Delete key pair
if [[ ! -z "$KEY_NAME" ]]; then
   echo -e "\n🔴 ${redColour}Deleting key pair $KEY_NAME...${endColour}"
   aws ec2 delete-key-pair \
     --key-name "$KEY_NAME"
   rm -f "${KEY_NAME}.pem" 
   echo -e "✅ ${greenColour}Key pair and file deleted.${endColour}"
fi

# 4. Clean up IAM
if [[ ! -z "$ROLE_NAME" ]] && [[ ! -z "$PROFILE_NAME" ]]; then
   echo -e "\n🔴 ${redColour}Cleaning up IAM...${endColour}"
   aws iam remove-role-from-instance-profile \
     --instance-profile-name "$PROFILE_NAME" \
     --role-name "$ROLE_NAME" || true 
   aws iam delete-instance-profile \
     --instance-profile-name "$PROFILE_NAME" || true 
   aws iam detach-role-policy \
     --role-name "$ROLE_NAME" \
     --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess || true 
   sleep 2
   aws iam delete-role --role-name "$ROLE_NAME" || true 
   echo -e "✅ ${greenColour}IAM cleaned up.${endColour}"
fi

rm -f .*.txt
echo -e "\n🎉 ${greenColour}Cleanup complete!${endColour}"
