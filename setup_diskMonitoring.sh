#!/bin/bash
clear
echo "################################################"
echo "## Script: setup_diskMonitoring.sh"
echo "## By: Andrew Herren"
echo "## Date: 11/07/14"
echo "################################################"

shopt -s nocasematch
echo -e "\nThis script will place a script in cron.daily that will send an email when any"
echo "disk in the system exceeds 90% usage. Would you like to continue? (y/n)>"
read answer
case "$answer" in
y|yes )
	echo "Enter the email address to report disk usage to. >"
	read email
	
	echo "
	#!/bin/bash
	
	NOTIFYEMAIL="$email"
	df -H | awk '/\/var\/www/{print $5 \" \" $1 }' | while read output;
	do
		echo \$output
		usep=\$(echo $output | awk '{print \$1}' | cut -d'%' -f1 )
		partition=\$(echo \$output | awk '{print \$2 }' )
		if [[ \$usep -ge 90 ]]; then
			echo \"Running out of space \\\"\$partition (\$usep%)\\\" on \$(hostname) as of \$(date)\" | mail -s \"Alert: Almost out of disk space \$usep%\" \$NOTIFYEMAIL
		fi
	done" > /etc/cron.daily/disk_usage.sh
	chmod +x /etc/cron.daily/disk_usage.sh
	;;
* )
	echo "Exiting without changes..."
	;;
esac
shopt -u nocasematch
