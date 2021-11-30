"# Automation_Project" 
This project consist of bash script which will perform the following task:
1)First , it will perform an update of the package details and the package list at the start of the script.
2)Install the apache2 package if it is not already installed. 
3)Ensure that the apache2 service is running and enabled.
4)Enabling apache2 as a service ensures that it runs as soon as our machine reboots. It is a daemon process that runs in the background.
5)Create a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory.
6)Lastly , the script will run the AWS CLI command and copy the archive to the s3 bucket. 
