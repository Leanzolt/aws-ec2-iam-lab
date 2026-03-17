#!/bin/bash
# Script to create Security Group
# Author: Leandro Zenteno 

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

set -e

echo -e "\n${greenColour}Script to create a security group Default ssh port 22 my IP address.${endColour}"
echo -e "\n${grayColour}Enter the group name:${endColour} "
read nameg
echo -e "${grayColour}Enter the description:${endColour} "
read description

echo -e "\n🚀 ${yellowColour}Creating security group...${endColour}"

# Get Default VPC ID
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query "Vpcs[0].VpcId" --output text)

# Creation of the security group
SG_ID=$(aws ec2 create-security-group \
      --group-name "$nameg" \
      --description "$description" \
      --vpc-id "$VPC_ID" \
      --query 'GroupId' \
      --output text)

# Authorize Inbound Rule
aws ec2 authorize-security-group-ingress \
      --group-id "$SG_ID" \
      --protocol tcp \
      --port 22 \
      --cidr $(curl -s checkip.amazonaws.com)/32

echo -e "${greenColour}Successful group creation: $SG_ID${endColour}"
echo -e "\n${grayColour}¿Do you want to keep this group? (y/n):${endColour} "
read respuesta

if [[ "$respuesta" != "y" ]]; then
   echo -e "${redColour}Deleting Group...${endColour}"
   aws ec2 delete-security-group --group-id "$SG_ID"
   exit 0
else
   echo -e "${greenColour}Group saved.${endColour}"
   # Corregido: Ahora usa el SG_ID para que siempre lo encuentre
   aws ec2 describe-security-groups --group-ids "$SG_ID" \
   --query "SecurityGroups[*].{ID:GroupId, Name:GroupName, Description:Description, VPC:VpcId}" \
   --output table
fi

# Save for others scripts 
echo "$SG_ID" > .sg-id.txt
