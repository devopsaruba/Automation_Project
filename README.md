# Automation_Project
### This project is about creation AWS infra for hosting a WEBSERVER
### Hosted WEBSERVER will push all the access logs to S3 bucket in a PERIODIC fashion
### Logs collected at EC2 instance will be deleted using LOGTOTATE mechanism

## AWS Service used to deloy the Infra are:
# IAM : To implement a policy for EC2 to access S3 to transfer files
# Security Group : To allow HTTP/HTTPS and SSH to access EC2 instance to access the web server
# S3 : Storage of logs files
# EC2: The IAS/PAS to HOST or implement the Application:WEBSERBVER

### FInally access the WEBSERVER using CURL or HTTP to generate access logs
