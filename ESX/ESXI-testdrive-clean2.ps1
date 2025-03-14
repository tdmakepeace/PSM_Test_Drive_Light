## git clone https://github.com/vmware/PowerCLI-Example-Scripts.git
#cd "C:\Users\tmakepea\OneDrive - Advanced Micro Devices Inc\SE-stuff\Toby Technotes\Aruba\TestDriveLight\Testdrive light working folder"
#cd "PowerCLI-Example-Scripts\Modules\VMware.vSphere.SsoAdmin"
#Import-Module .\VMware.vSphere.SsoAdmin.psd1
## Import-Module VMware.VimAutomation.Sso
#cd ../../../
#
#cd "C:\Users\tmakepea\OneDrive - Advanced Micro Devices Inc\SE-stuff\Toby Technotes\Aruba\TestDriveLight\Testdrive light working folder\ESX_Build\"

##Import variables ##
.\TestDrive.ps1


################################################### (End of EDIT to Suit Customer Enviroment) ##################################################




## support unsigned certs
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers

##Connect to vCenter
connect-viserver -server $vcenter_server -User $vcenter_user -Password $vcenter_pwd



################################################## (End of EDIT to Suit Customer Enviroment) ##################################################


		Get-Tag -Category $Workloadgroupname | Remove-Tag -Confirm:$False
		Get-Tag -Category $TagCategoryname | Remove-Tag -Confirm:$False

		Get-TagCategory -Name $Workloadgroupname | Remove-TagCategory -Confirm:$False
		Get-TagCategory -Name $TagCategoryname | Remove-TagCategory -Confirm:$False


Start-Sleep -Seconds 10

		Get-VIrole -Name TestDrive |remove-VIRole -Confirm:$False 
		Get-VDSwitch -Name $VmDS | Remove-VDSwitch -Confirm:$False



disconnect-viserver -server $vcenter_server -Confirm:$false


#Connect-SsoAdminServer -Server $vcenter_server -User $vcenter_user -Password "$vcenter_pwd" -SkipCertificateCheck
#$myNewGroup =     Get-SsoGroup -domain "vsphere.local" -Name 'TestDriveGroup'
#Remove-SsoGroup -Group $myNewGroup
#Disconnect-SsoAdminServer -Server $vcenter_server

Start-Sleep -Seconds 10

Connect-SsoAdminServer -Server $vcenter_server -User $vcenter_user -Password "$vcenter_pwd" -SkipCertificateCheck

$VRFResPool | ForEach-Object {
				## Delete user 
				$vrfuser = "vrf"+$_+"_user"
				# $vrfuser = "vrf1_user"
				$deleteuser = Get-SsoPersonUser -domain "vsphere.local" | Where-Object { $_.Name -eq $vrfuser }
				echo $deleteuser
			  Remove-SsoPersonUser $deleteuser 
							
		}


Disconnect-SsoAdminServer -Server $vcenter_server	    