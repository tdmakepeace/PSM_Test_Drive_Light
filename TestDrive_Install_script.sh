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
				updatesred
				
		fi 
		cd /
		
		if [ ! -d "$rootfolder" ]; then
				sudo mkdir $rootfolder
  			chown $real_user:$real_user $rootfolder
		fi


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
		
		cd PSM
		chmod +x *.sh
		cd ..
		




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
				updatesred
				
		fi 

	
	}
	
	
instruction()
{
	
	echo """
	To run the TestDrive code you need to be running in Powershell.
	To run powershell you need to run the following command (recommend a second terminal window).
	
	\"pwsh\" 
	
	Once in Powershell you need to import the PowerCli-Examples repo to be able to login to the the Vcentre server enviroment.
	
	to do that once in powershell in a second terminal screen copy the following lines.
		
		\" 

		cd /pensandotools/PSM_Test_Drive_Light/ESX
		Install-Module -Name VMware.PowerCLI -Confirm:$false
		cd "PowerCLI-Example-Scripts\Modules\VMware.vSphere.SsoAdmin"
		Import-Module .\VMware.vSphere.SsoAdmin.psd1
	
		cd ../../../
		
		\"
		
	
	"""
	read -p "	Select option (A) on the install 
	
	once the install complete and back at the command prompt and hit enter on this screen"
	clear
	
		echo """
		
		Now to set up the enviromental variables. You need to have access to the Vcenter Admin at this stage
		or access to the Vcentre server. run from the powershell terminal - BuildVaribles.ps1
		
		Vcenter Server IP eg. vcenter.testdrive.com or 10.10.10.10
		Vcenter Administrator eg administrator@vsphere.local
		Vcenter password
		ESXi host IP eg. 192.168.102.101
		Vmware image to be cloned eg. TinyVMDeploy (this is in the /pensandotools/PSM_Test_Drive_Light/ folder)
		Vmware Disk for the images to be stored eg. DL360SSD
		Vmware Vcenter Domain eg. Makepeacehouse
		The name of the distributed switch you want to create eg. VRF-Demo
		The of the TAG catogary to be used for the workload grouping. eg. Demo
		The of the TAG catogary to be used for the VRF grouping eg. VRFs
		The number of VRFs you want to create eg. 3
		The number of workloads per VRF you want to create eg. 3 or 5 recommended based on resources.



		\" 
					
		BuildVaribles.ps1

		\"
		
	
	"""
	read -p "Once complete hit enter"
	
	
	}	
	

runnotes()
{
	
		echo """
	To run the TestDrive code you need to be running in Powershell.
	To run powershell you need to run the following command (recommend a second terminal window).
	
	\"
	
	pwsh
	
	\" 
	
		
	
	"""
	read -p "	once in powershell hit enter to continue. "
	clear
	
		echo """
		
	In the ESX folder you have a number of scripts the follow explains there function. 
	
		
	BuildVaribles.ps1                     - recreate the enviromental variables. output is stored in the TestDrive.ps1, and therefore should only be performed in a 
                                                secure envrioment and on a system allocated for TestDrives.

	ESXI-testdrive-Build1.ps1             - The Build 1 and Build 2 scripts set up the ESX enviroment based on the options you defined at the time of building the
	                                        variables. The reason the build is broken in to two scripts are there are some middle manual steps needing to be run.
	ESXI-testdrive-Build2.ps1             -

	ESXI-testdrive-clean1.ps1             - The Clean scripts are to clean the enviroment in the event of a full clean of the VMware enviroment required including 
	                                        the networkings, if you only run clean1, you can re-run Build2 to get back to the same place. 
	                                        if however you run clean1 and then clean2, you need to start from Build1 including the manual steps.

	ESXI-testdrive-clean2.ps1             -

	ESXI-testdrive-resetpod_all.ps1       - Post a full testdrive session and to reset all the ESX pods, you can run the reset_all script.

	ESXI-testdrive-resetpod.ps1           - if during a lab, or where needed you can reset just a single ESX pod the menu will ask you what pod you wish to reset.


		\" 
					
		Becarefull and make sure you understand what you are doing. 
		
		\"
		
	
	"""
	read -p "hit enter to read notes on each"
	clear 
	while true ;
		do 
			echo "File you want more notes and steps on.
			
				BuildVaribles.ps1                 - 1
				ESXI-testdrive-Build1.ps1         - 2
				ESXI-testdrive-Build2.ps1         - 3
				ESXI-testdrive-clean1.ps1         - 4
				ESXI-testdrive-clean2.ps1         - 5
				ESXI-testdrive-resetpod_all.ps1   - 6
				ESXI-testdrive-resetpod.ps1       - 7
				
				exit - x

			
		  	"
				
				read x
				clear
			  	  
		  	if  [ "$x" == "1" ]; then
		  		
		  		echo """
				The BuildVaribles.ps1 is for setting up the enviromental variables for the other scripts.
				you require to have the VMware enviromental knowledge accessable when setting it up.
				The output is TestDrive.ps1, that can be manaual edited rather than re-running the script.
				It should only be hosted in a secure enviroment.
				
				Vcenter Server IP eg. vcenter.testdrive.com or 10.10.10.10
				Vcenter Administrator eg administrator@vsphere.local
				Vcenter password
				ESXi host IP eg. 192.168.102.101
				Vmware image to be cloned eg. TinyVMDeploy (this is in the /pensandotools/PSM_Test_Drive_Light/ folder)
				Vmware Disk for the images to be stored eg. DL360SSD
				Vmware Vcenter Domain eg. Makepeacehouse
				The name of the distributed switch you want to create eg. VRF-Demo
				The of the TAG catogary to be used for the workload grouping. eg. Demo
				The of the TAG catogary to be used for the VRF grouping eg. VRFs
				The number of VRFs you want to create eg. 3
				The number of workloads per VRF you want to create eg. 3 or 5 recommended based on resources.

		  		"""
				elif  [ "$x" == "2" ]; then				
					echo """
					The ESXI-testdrive-Build1.ps1 script sets up all the base networking on the VMware enviroment, once this script 
					is complete you need to manaually assign the uplinks to the distributed switch.
					it is recommened that you just use 2 interfaces, one to each CX switch.
					1. Under the disributed switch, select the add host option, and select your ESXi host.
					2. Assign the interfaces from the host you wish to use, and just accept all the defaults.
					
					Read and review the script for more info.
					"""
				elif  [ "$x" == "3" ]; then				
					echo """
					The ESXI-testdrive-Build2.ps1 script should only be run after the The ESXI-testdrive-Build1.ps1 has been run, and the interfaces 
					assigned to the distributed switch. This will then build the VM resource groups, workloads, and permissions, for the pods.
					It will take about 3 minutes per pod assigned.
					
					Read and review the script for more info.
					"""
				elif  [ "$x" == "4" ]; then				
					echo """
					The ESXI-testdrive-clean1.ps1 script will clean down the VM resource groups, workloads, and permissions, for the pods.
					It will take about 3 minutes per pod assigned.
					
					Read and review the script for more info.
					
					"""

				elif  [ "$x" == "5" ]; then				
					echo """
					The ESXI-testdrive-clean2.ps1 script will clean down the VM users, and disributed switching. 
					It will take about 2 minutes to run.
					
					Read and review the script for more info.
					
					"""
				elif  [ "$x" == "6" ]; then				
					echo """
					The ESXI-testdrive-resetall.ps1 script will run both the Clean1 and Build2 scripts so as to reset the enviroment for the next
					class, this is just for the ESXi enviroment.
						
										
					Read and review the script for more info.
					
					"""
				elif  [ "$x" == "7" ]; then				
					echo """
					The ESXI-testdrive-reset.ps1 script will run both the Clean and Build function for a specific pod
					This is only needed when a user has had diffculties, or you are allocating single pods.
						
										
					Read and review the script for more info.
					"""
				elif  [ "$x" == "8" ]; then				
					echo """
					you can not count.
					"""
				elif [  $x ==  "x" ]; then
						break


		  	else
		    	echo "try again"
		  	fi

		done
	
	}	



psmnotes()
{
		echo """
		The following notes will take you through the setup and clean down scripts for PSM.
		The scripts are based on the fact you have already set up the CX and PSM for base functionality.
		and is focussed on the pod build and resets.
			
		The first thing you need to do is edit the logindetails.py file in the PSM\PythonScripts folder.
		The second thing is to set the variable parameters in the CSV_example folder. - Examples give and are expect to 
		work for most customers.
			
		In the PSM\PythonScripts folder are all the indervidual python scripts that are called from the shell scripts
		
		build.sh - takes the contents of the CSV files and builds the JSON and TXT payloads.
		           It then runs the json files against the PSM to build the objects.
		           if the objects exists they will return 404 or 414 errors.
							
		clean.sh - takes the contents of the CSV files and builds the JSON and TXT payloads.
		           It then runs the txt files against the PSM to delete the objects.
		           if the objects does not exists they will return 404 or 414 errors.
							
		rebuild.sh - takes the taks of clean and build and runs them to reset all the pods.				
							
	
		
	
	"""
	
	
	
	read -p "Once complete hit enter"
	
	
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


If the ELK stack has not been installed, exit the script and deploy the ELK stack by running the single script installer. At minimun the base option of the ELK install needs to have been completed.

\"

wget -O ELK_Install_Ubuntu_script.sh  https://raw.githubusercontent.com/tdmakepeace/ELK_Single_script/refs/heads/main/ELK_Install_Ubuntu_script.sh && chmod +x ELK_Install_Ubuntu_script.sh  &&  ./ELK_Install_Ubuntu_script.sh

\"

Options with regards VMWare setup :

D - Download and clone the Git repo for the testdrive. 
B - Base setup of the powershell enviroment.
I - Install the modules required in powershell.
R - Read notes on using the tools. 

Option with regards to PSM managment :

P - Read notes on using the tools. 


x - to exit
  		
  	"
	echo "D or B or I or R or P"
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
				  
		elif [  $x ==  "i" ]; then
			
					instruction
					
		elif [  $x ==  "r" ]; then
					runnotes
					
										
		elif [  $x ==  "p" ]; then
					psmnotes
					
		elif [  $x ==  "t" ]; then
					testcode
				  

		elif [  $x ==  "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done