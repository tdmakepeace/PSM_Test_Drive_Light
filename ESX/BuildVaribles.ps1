Write-Host "

This writes the variables to local varaible file to be used as part of the other scripts. 
This is supposed to be a one of process, but values can be edited or script re-run.
However the VMware server should be in a clean state before you make any changes.

The Vmware Password is stored in the file if you chose to do so.
	
THIS IS ONLY TO BE USED IN LAB ENVIORMENTS

If you want to change it not to store the password but request it every time, comment out the following line.
`$vcenter_pwd = Read-Host `"Enter Vcenter password`"

And uncomment and comment the set-content output.

If this needs explaining, you should not be editing the file.


"



$vcenter_server = Read-Host "Enter Vcenter Server IP eg. vcenter.testdrive.com or 10.10.10.10"
$vcenter_user = Read-Host "Enter Vcenter Administrator eg administrator@vsphere.local"
#### this is the line to comment out if you do not want to store the password in the TestDrive.ps1
$vcenter_pwd = Read-Host "Enter Vcenter password"
$Hostesxi = Read-Host "Enter ESXi host IP eg. 192.168.102.101"
$VMsource = Read-Host "Enter Vmware image to be cloned eg. TinyVMDeploy"
$DataStore = Read-Host "Enter Vmware Disk for the images to be stored eg. DL360SSD"
$DCName = Read-Host "Enter Vmware Vcenter Domain eg. Makepeacehouse"
$VmDS = Read-Host "Enter the name of the distributed switch you want to create eg. VRF-Demo"
$TagCategoryname = Read-Host "Enter the of the TAG catogary to be used for the workload grouping. eg. Demo"
$Workloadgroupname = Read-Host "Enter the of the TAG catogary to be used for the VRF grouping eg. VRFs"
$VRFpool = Read-Host "Enter the number of VRFs you want to create eg. 3"
$VRFimages = Read-Host "Enter the number of workloads per VRF you want to create eg. 3"


$VRFResPool = @()

for ($i = 0; $i -lt $VRFpool; $i++) { 
	$VRFResPool +=$i+1
	
	}
$VRFResPool = $VRFResPool -join ","



$VRFworkloads = @()	
for ($i = 0; $i -lt $VRFimages; $i++) { 

	$VRFworkloads +=$i+1

	}
	
$VRFworkloads = $VRFworkloads -join ","
		

Set-Content -Path TestDrive.ps1 -Value "
`$Global:vcenter_server=`"$vcenter_server`"
`$Global:vcenter_user=`"$vcenter_user`"
`$Global:vcenter_pwd=`"$vcenter_pwd`"
`$Global:Hostesxi=`"$Hostesxi`"
`$Global:VMsource=`"$VMsource`"
`$Global:DataStore=`"$DataStore`"
`$Global:DCName=`"$DCName`"
`$Global:dateofclone=date
`$Global:VmDS=`"$VmDS`"
`$Global:TagCategoryname=`"$TagCategoryname`"
`$Global:Workloadgroupname=`"$Workloadgroupname`"
`$Global:VRFResPool=`@($VRFResPool)
`$Global:VRFworkloads=`@($VRFworkloads)	

" 


#[System.IO.File]::ReadAllText("TestDrive.ps1").replace(" ",",")|sc TestDrive.ps1

#Set-Content -Path TestDrive.ps1 -Value "
#`$Global:vcenter_server =`"$vcenter_server`"
#`$Global:vcenter_user =`"$vcenter_user`"
#`$Global:vcenter_pwd = Read-Host `"Enter Vcenter password`"
#`$Global:Hostesxi = `"$Hostesxi`"
#`$Global:VMsource = `"$VMsource`"
#`$Global:DataStore = `"$DataStore`"
#`$Global:DCName = `"$DCName`"
#`$Global:dateofclone = date
#`$Global:VmDS = `"$VmDS`"
#`$Global:TagCategoryname = `"$TagCategoryname`"
#`$Global:Workloadgroupname =`"$Workloadgroupname`"
#`$Global:VRFResPool = @(1,2,3,4,5)
#`$Global:VRFworkloads = @(1,2,3,4,5)	
#
#" 

