# aws-lateral-movement
Sample AWS exploit<br>
Creates a new user with power user privileges, then creates an S3 bucket and puts a file into it.<br>
The script then cleans up after itself, deleting the bucket and the user.<br>
Accepts an optional argument for the username that gets created, otherwise defaults to 'exfiltest'<br>

## prerequisites
AWS CLI with profile set

## usage
cd aws-lateral-movement<br>
sh ./aws-lateral-movement.sh<br>
