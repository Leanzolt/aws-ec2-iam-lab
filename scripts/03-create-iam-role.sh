#!/bin/bash

# Script to create IAM Role for EC2
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

echo -e "\n${yellowColour}🚀 Creating IAM ROLE...${endColour}"

ROLE_NAME="lab-ec2-role-$(date +%Y%m%d)"
PROFILE_NAME="lab-ec2-profile-$(date +%Y%m%d)"

echo -e "${grayColour}Role Name:${endColour} ${greenColour}$ROLE_NAME${endColour}"
echo -e "${grayColour}Profile Name:${endColour} ${greenColour}$PROFILE_NAME${endColour}"

# Trust policy for EC2
cat > trust-policy-lab.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create Role 
aws iam create-role \
   --role-name $ROLE_NAME \
   --assume-role-policy-document file://trust-policy-lab.json 

echo -e "\n✅ Role created: $ROLE_NAME"

# Attach S3 ReadOnly policy 
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

echo "✅ S3 ReadOnly policy attached."

# Create instance profile 
aws iam create-instance-profile \
  --instance-profile-name $PROFILE_NAME 

echo -e "✅ Instance profile created: $PROFILE_NAME"

# Add role to profile (Allow time for propagation)
sleep 5
aws iam add-role-to-instance-profile \
  --instance-profile-name $PROFILE_NAME \
  --role-name $ROLE_NAME 

echo "✅ Role added to profile."

# Clean up 
rm trust-policy-lab.json 

# Save Names 
echo $ROLE_NAME > .role-name.txt
echo $PROFILE_NAME > .profile-name.txt 
