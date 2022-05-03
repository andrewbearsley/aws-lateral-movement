#!/bin/sh
# Sample AWS exploit
# Creates a new user with power user privileges, then creates an S3 bucket and puts a file into it.
# The script then cleans up after itself, deleting the bucket and the user.
# Accepts a first optional argument for the username that gets created, otherwise defaults to 'exfiltest'
# Accepts a second optional argument for the AWS profile, otherwise defaults to 'lacework'
set -e

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

AWSREGION=ap-southeast-2
USERNAME=${1:-exfiltest}
PROFILE=${2:-lacework}

# Create a new IAM user
echo "${grn}Creating a new IAM user called ${mag}$USERNAME${end}..."
echo ""
aws iam create-user --user-name $USERNAME --profile $PROFILE | jq
aws iam create-access-key --user-name $USERNAME --profile $PROFILE > creds.json
echo ""
echo "${grn}Granting PowerUser access to ${mag}$USERNAME${end}..."
aws iam attach-user-policy --user-name $USERNAME --profile $PROFILE --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
export KEY=$(cat creds.json | jq -r .AccessKey.AccessKeyId)
export SECRET=$(cat creds.json | jq -r .AccessKey.SecretAccessKey)

# Here we start using the new account profile and creds
echo ""
echo "${grn}Creating a new S3 bucket...${end}"
aws configure set aws_access_key_id "$KEY" --profile $PROFILE
aws configure set aws_secret_access_key "$SECRET" --profile $PROFILE
sleep 10
BUCKETNAME="exploit$RANDOM"
aws s3api create-bucket --bucket $BUCKETNAME --region $AWSREGION --create-bucket-configuration LocationConstraint=$AWSREGION --profile $PROFILE | jq

echo ""
echo "${grn}Uploading file to the bucket...${end}"
curl -H "Accept: application/json" https://icanhazdadjoke.com/ > badfile.json
aws s3api put-object --bucket $BUCKETNAME --key badfile.json --body badfile.json  --profile $PROFILE | jq

echo ""
echo "${grn}Data uploaded. Preparing to destroy...${end}"
sleep 10
echo "${grn}Deleting file and S3 bucket...${end}"
aws s3api delete-object --bucket $BUCKETNAME --key badfile.json --profile $PROFILE 
aws s3api delete-bucket --bucket $BUCKETNAME --profile $PROFILE 

# Exit back out to our regular context
echo "${grn}Deleting access key and IAM user ${mag}$USERNAME${end}..."
aws iam detach-user-policy --user-name $USERNAME --profile $PROFILE --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
aws iam delete-access-key --access-key-id $KEY --user-name $USERNAME --profile $PROFILE
aws iam delete-user --user-name $USERNAME --profile $PROFILE
rm creds.json

echo ""
echo "${cyn}Script complete. Check your Lacework console for activity in about an hour.${end}"
