# Sample AWS Exploit

This script performs discovery, then creates a new AWS IAM user with power user privileges, creates an S3 bucket, and puts a file into it.<br>
The script then cleans up after itself, deleting the bucket and the user.<br>
Accepts an optional argument for the username that gets created, otherwise defaults to 'exfiltest'<br>

## Prerequisites
AWS CLI with profile set

## Usage
Arguments: newusername awsprofile<br>
```
cd aws-lateral-movement
sh ./aws-lateral-movement.sh baduser default
```
