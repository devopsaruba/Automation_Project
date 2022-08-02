# Automation_Project
### This project is about creation of  AWS infra for hosting a WEBSERVER
### Hosted WEBSERVER will push all the access logs to S3 bucket in a PERIODIC fashion
### Logs collected at EC2 instance will be deleted using LOGTOTATE mechanism

## AWS Service used to deloy the Infra are:
# IAM : To implement a policy for EC2 to access S3 to transfer files
# Security Group : To allow HTTP/HTTPS and SSH to access EC2 instance to access the web server
# S3 : Storage of logs files
# EC2: The IAS/PAS to HOST or implement the Application:WEBSERBVER

### FInally access the WEBSERVER using CURL or HTTP to generate access logs

# Creating BookKeping logic to update the inventopry.html to have data as below for every S3 copy:
<img width="491" alt="image" src="https://user-images.githubusercontent.com/98635422/182234258-ff74c296-eb2f-446f-abca-7ab232acc90e.png">

#Scheduling the script using CRON every day to see populate the inventory for access details. 
