#!/bin/bash
sudo apt update -y
name=Alok
s3=upgrad-alok
a=$(dpkg --get-selections | grep apache2)


if [ "$a" == "" ]
then
      echo -e "Apache2 is not installed \ninstalling apache2."
     sudo apt install apache2 -y
else
        echo "Apache2 is aleady installed"
fi

b=$(systemctl is-active apache2)


if [ "$b" == "active" ]
then
        echo "Apache2 is aleady running"

else
        echo -e  "Apache2 is in stopped state  \n stating apache2"
        sudo systemctl stat apache2
        echo Apache2 has been stated.
fi

c=$(systemctl is-enabled apache2)
if [ "$c" == "enabled" ]
then
        echo "Apache2 is aleady enabled"

else
        echo -e  "Apache2 is in disabled state  \n enabling apache2"
        sudo systemctl enable apache2

fi

timestamp=$(date '+%d%m%Y-%H%M%S')

tar -cvf $name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
mv $name-httpd-logs-$timestamp.tar /tmp

aws s3 \
cp /tmp/$name-httpd-logs-$timestamp.tar \
s3://$s3/$name-httpd-logs-$timestamp.tar

FILE=/var/www/html/newinventory.html
FILE1=/var/www/html/inventory.html
if [ -f "$FILE" ]
then
    echo "$FILE exists."
else
    echo -e "$FILE doesn't exist \n creating the file"
    sudo touch $FILE
    touch $FILE1
    echo "Log Type             Time Created                Type             Size" > $FILE
fi

size=$(du -s -h /tmp/$name-httpd-logs-$timestamp.tar | awk '{ print $1 }')


for file in /tmp/*.tar
do
             echo "httpd-logs           $timestamp                tar        $size" >> $FILE
             uniq $FILE $FILE1

done

cronfile=/etc/cron.d/automation

if [ -f "$cronfile" ]
then
        echo "cron job is already scheduled"
else
        echo -e "cron job is not scheduled \n scheduling the cron job"
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "Cron job is scheduled now"

fi

