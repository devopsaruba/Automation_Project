#!/bin/bash

s3bucketName=upgrad-samarthi
myname=sumansamarthi
update_package(){
	echo "update_package:START"
	sudo apt update -y
	echo "Updating ubuntu linux finished"
}

apache_installation(){
	serviceName=$1
	if [ systemctl --all --type service  | grep -q "$serviceName" ]
	then
		echo "'$serviceName': is already installed!!!"
	else
		echo "'$serviceName': is not installed"
		echo "Installing    : '$serviceName'"
		sudo apt install apache2 -y
		echo "Installed     : '$serviceName'"
	fi	
}

apache_start(){
	serviceNam=$1
	if sudo systemctl is-active "$serviceName"
	then
		echo "'$serviceName':IS RUNNING"
	else
		echo "'$serviceName':STARTING"
		sudo systemctl start "$serviceName"
		echo "'$serviceName':STARTED"
	fi			
}
apache_enable(){
	serviceName=$1
	if sudo systemctl is-enabled "$serviceName"
	then
		echo "$serviceName:ENABLED ALREADY"
	else
		echo "$serviceName:Enabling NOW"
		sudo systemctl enable "$servicename"
	fi	
		
}
archive_logs(){
	echo "LOGS:Archive STARTED"
	#time=`date +%m-%d-%Y-%H-%M-%S`
	timestamp=$(date '+%d%m%Y-%H%M%S')
	filename="sumansamarthi-httpd-logs-$timestamp.tar"
	tar -cvf $filename /var/log/apache2/*.log
	mv $filename /tmp/
	echo "LOGS:Archive COMPLETED"
}

copy_archive(){
	echo "S3:COPYING:STARETD";
	bucketName=$1
	aws s3 cp /tmp/$filename s3://$bucketName/$filename;
}
cron_job(){
        cron_file='/etc/cron.d/automation'
        if test -f $cron_file
        then
                echo "CRON: File Present ALREADY"
        else
                echo "CRON: File not Present CREATING"
                sudo touch ${cron_file}
		sudo echo "SHELL=/bin/bash">${cron_file}
		sudo echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin">>${cron_file}
                sudo echo "5 * * * * root /root/Automation_Project/automation.sh">>${cron_file}
                echo "CRON: File CREATED "
        fi
}

my_program(){
	echo "my_program:START";	
	update_package;

	#Service Nme
	service=apache2
	apache_installation "$service"
	apache_start "$service"
	apache_enable "$service"
	archive_logs
	
	#S3 Bucket Name
	bucketName=$s3bucketName
	copy_archive "$bucketName"
	cron_job
	echo "my_program:END";
}
echo "Program STARTS"
my_program;
echo "Program END's""
