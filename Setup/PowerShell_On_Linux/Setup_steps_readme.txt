Under you ubuntu enviroment in your home directory or where you want it. 

### run 
### Step 1 
 
git clone https://github.com/vmware/PowerCLI-Example-Scripts.git

### run
## Step 2

sudo chmod +x Setup_Powershell.sh
./Setup_Powershell.sh


### run within powershell
### Step 3 (select option 'A')  - sometime it take time to run.

Install-Module -Name VMware.PowerCLI -Confirm:$false
cd "PowerCLI-Example-Scripts\Modules\VMware.vSphere.SsoAdmin"
Import-Module .\VMware.vSphere.SsoAdmin.psd1
# Import-Module VMware.VimAutomation.Sso
cd ../../../


### Step 4 
#### Change directory to where the scripts for the ESX enviroment are installed.

### upload to the VMware enviroment the base image you want to use and in the case of tinyvm, install bash.


### SSH upload the scripts and Run. 
ESXI-testdrive-Build1.ps1


#### Manual 
Manaully add interfaces, and all the users that have been created with the role "TestDrive" to the TAG Catagories with propergation
This is because there is no script to do this, without breaking read--only rights.


### SSH upload the scripts and Run. 
ESXI-testdrive-Build2.ps1


### SSH upload the scripts and Run
## Reset a POD
ESXI-testdrive-reset.ps1


