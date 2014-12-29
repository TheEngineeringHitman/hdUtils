#!/bin/bash
clear
echo "################################################"
echo "## Script: setup_diskMonitoring.sh"
echo "## By: Andrew Herren"
echo "## Date: 11/07/14"
echo "## Scrit instructions: http://www.theengineeringhitman.com/external-storage-raspberry-pi/"
echo "################################################"

shopt -s nocasematch
echo -e "\nThis script will place a script called disk_usage.sh in cron.daily"
echo "that will send an email when any disk in the system exceeds 90% usage."
echo "Would you like to continue? (y/n)>"
read answer
case "$answer" in
y|yes )
	echo "Enter the email address to report disk usage to. >"
	read email
	
	echo "#!/bin/bash
	
NOTIFYEMAIL="$email"
full_drives=\$(df -h | awk '//{if((\$5!~/Use/)&&(substr(\$5,0,length(\$5)) > 90)){print \"WARNING! Partition \"\$6\" is at \"\$5\" usage.\"}}')
if [[ \$full_drives ]]; then
	echo \"\$full_drives\" | mail -s \"Alert: Almost out of disk space on \$HOSTNAME\" \$NOTIFYEMAIL
fi
	" > /etc/cron.daily/disk_usage.sh
	chmod +x /etc/cron.daily/disk_usage.sh
	echo "/etc/cron.daily/disk_usage.sh file created"
	;;
* )
	echo "Exiting without changes..."
	;;
esac
shopt -u nocasematch
#!/bin/bash
