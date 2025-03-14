#!/bin/bash

###
### This script has been build to set up the enviroment for the TestDrive Management and is based on a default Ubuntu 22.04/24.04 servers install.
### The only packages needing to be installed as part of the deployment of the Ubuntu servers is openSSH.
###
### you can do a minimun install, but i would just stick with the servers install.
###
### Also it is recommended that you run a static-IP configuration, with a single or dual network interface.
### The script should be run as the first user create as part of the install, and uses SUDO for the deployment process.





###	


gitlocation="https://github.com/tdmakepeace/PSM_Test_Drive_Light"
basefolder="PSM_Test_Drive_Light"
rootfolder="pensandotools"

###
	
rebootserver()
{
		echo "rebooting"
		
		sleep 5
		sudo reboot
		break
}

updates()
{
		
		sudo apt-get update 
		sudo NEEDRESTART_SUSPEND=1 apt-get dist-upgrade --yes 

		sleep 10
}

updatesred()
{
		subscription-manager attach --auto
		subscription-manager repos
		sudo yum update -y -q 

		sleep 10
}


download()
{
		real_user=$(whoami)


		os=`more /etc/os-release |grep PRETTY_NAME | cut -d  \" -f2 | cut -d " " -f1`
		if [ "$os" == "Ubuntu" ]; then 
				updates
				
		elif [ "$os" == "Red" ]; then
				updatesred()
				
		fi 
		cd /
		cd /$rootfolder/
		git clone $gitlocation
		cd 	$basefolder
		
		
		`git branch --all | cut -d "/" -f3 > gitversion.txt`
		echo "choose a branch "
		git branch --all | cut -d "/" -f3 |grep -n ''

		echo " Select the line number

		"
		read x
		testdrivever=`sed "$x,1!d" gitversion.txt`
		git checkout  $testdrivever
		echo $testdrivever >installedversion.txt

		git pull




	}

basesetup()
{
		cd /$rootfolder/$basefolder
		cd ESX
		git clone https://github.com/vmware/PowerCLI-Example-Scripts.git

		if [ "$os" == "Ubuntu" ]; then 
				###################################
				# Prerequisites

				# Update the list of packages
				sudo apt-get update

				# Install pre-requisite packages.
				sudo apt-get install -y wget apt-transport-https software-properties-common

				# Get the version of Ubuntu
				source /etc/os-release

				# Download the Microsoft repository keys
				wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

				# Register the Microsoft repository keys
				sudo dpkg -i packages-microsoft-prod.deb

				# Delete the Microsoft repository keys file
				rm packages-microsoft-prod.deb

				# Update the list of packages after we added packages.microsoft.com
				sudo apt-get update

				###################################
				# Install PowerShell
				sudo apt-get install -y powershell

				
		elif [ "$os" == "Red" ]; then
				updatesred()
				
		fi 

	
	}



testcode()
{
		echo " 
		Space for testing
					"

					dockerupnote
					
}

while true ;
do
	clear
  echo "press cntl-c  or x to exit at any time.
  
  
  
  "
  echo "
### This script has been build to set up the enviroment for the TestDrive Management and is based on a default Ubuntu 22.04/24.04 servers install.                 ###
### The only packages needing to be installed as part of the deployment of the Ubuntu servers is openSSH.                                                          ###
###                                                                                                                                                                ###
### you can do a minimun install, but i would just stick with the servers install.                                                                                 ###
###                                                                                                                                                                ###
### Also it is recommended that you run a static-IP configuration, with a single or dual network interface.                                                        ###
### The script should be run as the first user create as part of the install, and uses SUDO for the deployment process.                                            ###


If the ELK stack has not been installed, exit the script and deploy the ELK stack but running the single script installer.

\"wget -O ELK_Install_Ubuntu_script.sh  https://raw.githubusercontent.com/tdmakepeace/ELK_Single_script/refs/heads/main/ELK_Install_Ubuntu_script.sh && chmod +x ELK_Install_Ubuntu_script.sh  &&  ./ELK_Install_Ubuntu_script.sh\"

Options: 
D - Download and clone the Git repo for the testdrive. 
B - Base setup of the powershell enviroment.
  		
  	"
	echo "D or B "
	read x
  x=${x,,}
  
  clear

		if  [ $x == "d" ]; then
				echo "
This should be a one off process do not repeat unless you have cancelled it for some reason.
	
		        "
				  echo "cntl-c  or x to exit"
				  echo ""    
				  echo "Enter 'C' to continue :"
				  read x
				    x=${x,,}
					  clear
				   while [ $x ==  "c" ] ;
				    do
				    	download
					  	x="done"
				  done
  		

		elif [  $x ==  "b" ]; then
			
					echo "(select option 'A')  - sometime it take time to run."
					basesetup
				  

		elif [  $x ==  "t" ]; then
					testcode
				  

		elif [  $x ==  "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done