#!bin/bash
sudo apt update -y
name=Alok
s3=upgrad-alok
a=$(dpkg --get-selections | grep apache2)


if [ "$a" == "" ]
then
      echo -e "Apache2 is not installed \ninstalling it."
     sudo apt install apache2 -y
else
        echo "Apache2 is already installed"
fi

b=$(systemctl is-active apache2)


if [ "$b" == "active" ]
then
        echo "Apache2 is already running"
        
else
        echo -e  "Apache2 is in stopped state  \n starting apache2"
        sudo systemctl start apache2
        
fi

c=$(systemctl is-enabled apache2)
if [ "$c" == "enabled" ]
then
        echo "Apache2 is already enabled"
        
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


