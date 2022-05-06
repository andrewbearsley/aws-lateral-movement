# Sample AWS Exploit

This script performs AWS CLI commands to simulate offensive security actions. 
- lists EC2 instances, security groups, secrets for each region
- creates a new AWS IAM user eg. 'baduser' with power user privileges
- using 'baduser', creates an S3 bucket, and puts a file into it
- cleans up: deletes the bucket, deletes 'baduser'

Accepts an optional argument for the username that gets created, otherwise defaults to 'baduser'<br>

## Prerequisites
AWS CLI with profile set

## Usage
Arguments: newusername awsprofile<br>
```
cd aws-lateral-movement
sh ./aws-lateral-movement.sh baduser default
```
