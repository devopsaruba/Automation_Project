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

apache_runlevel_enabled(){
        serviceName=$1
        cmd=$(systemctl status $serviceName | grep -i Active)
        if [[ $cmd == *"active (running)"* ]]
        then
                echo "'$serviceName' ACTIVE!!!!!"
        #elif [[ $cmd ]]
        #then
#               echo "'$serviceName': START ENABLING AT BOOT LEVEL"
#               update-rc.d $serviceName defaults
#               echo "'$serviceName': END ENABLING AT BOOT LEVEL"
        else
                echo "WARNING : 'serviceName' NOT at BOOT LEVEL"
                update-rc.d $serviceName defaults
		echo "WARNING : 'serviceName' UPDATED to RUN at the BOOT LEVEL"
        fi
}

update_inventory(){
        inventory_file=/var/www/html/inventory.html
        logType="http-logs"
        #fileName=$filename
        file_type=${filename##*.}
        size=$(ls -lh /tmp/${filename} | cut -d " " -f5)
        #timestamp=$(ls -lh /tmp/${fielName} | cut -d " " -f9)
        timestamp=$(stat --printf=%y /tmp/$filename | cut -d.  -f1)

        echo "logType:$logType" 
        echo "FileName:$filename"
        echo "Type:$file_type"
        echo "Size:$size"
        echo "TimeStamp:$timestamp"

        if ! test -f "$inventory_file"
        then
                echo "Creating '$inventory_file'"
                `touch ${inventory_file}`
                echo "<b>Log Type&nbsp;&nbsp;&nbsp;&nbsp;Date Created&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type&nbsp;&nbsp;Size</b>">"${inventory_file}" 2>&1
                echo "UPDATED '$inventory_file' HEADER"
        else
                echo "<br>${logType}&nbsp;&nbsp;&nbsp;&nbsp;${timestamp}&nbsp;&nbsp;&nbsp;&nbsp;${file_type}&nbsp;&nbsp;&nbsp;&nbsp;${size}">>"${inventory_file}" 2>&1
                echo "Inventory file has been updated";
        fi

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
	apache_runlevel_enabled
	apache_start "$service"
	apache_enable "$service"
	archive_logs
	
	#S3 Bucket Name
	bucketName=$s3bucketName
	copy_archive "$bucketName"
<<<<<<< HEAD
=======
	update_inventory
>>>>>>> 8850f931cac4027b29bd249865b4135c55ebeb61
	cron_job
	echo "my_program:END";
}
echo "Program STARTS"
my_program;
echo "Program END's""
