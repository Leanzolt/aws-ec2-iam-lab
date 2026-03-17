#!/bin/bash

# Script for create Key Pairs
# Author: Leandro
# date: 2026-03-06

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

echo -e "\n🚀 ${yellowColour}Create Key Pair...${endColour}"

KEY_NAME="lab-key-$(date +%Y%m%d)"
KEY_FILE="${KEY_NAME}.pem"

# Command for create key pair 
aws ec2 create-key-pair \
  --key-name $KEY_NAME  \
  --query 'KeyMaterial' \
  --output text > $KEY_FILE

# Protect the File
chmod 400 $KEY_FILE

echo -e "✅ Key Pair created: ${greenColour}$KEY_NAME${endColour}"
echo -e "📁 File saved: ${greenColour}$KEY_FILE${endColour}"
echo -e "🔐 Permissions: ${greenColour}400${endColour}"

echo $KEY_NAME > .key-name.txt
