# aws-lateral-movement
Sample AWS exploit
Creates a new user with power user privileges, then creates an S3 bucket and puts a file into it.
The script then cleans up after itself, deleting the bucket and the user.
Accepts an optional argument for the username that gets created, otherwise defaults to 'exfiltest'

## prerequisites
AWS CLI with profile set

## usage
cd aws-lateral-movement
sh ./aws-lateral-movement.sh
