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

# Loop through each item in the array using ForEach-Object
$VRFResPool | ForEach-Object {
		## create the resourcepool
		$vrf = "VRF"+$_
		$netnum = 10 * $_
    $netnum1 = $netnum + 1
    $privnum = 1000 + $netnum
    $VmInt1 = "$netnum"+"_"+"$privnum"+"_PRO"
    $VmInt2 = "$netnum"+"_"+"$privnum"+"_ISO"


	$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					
					Stop-VM -VM $VMclone -Kill -Confirm:$false
					Remove-VM -DeletePermanently -RunAsync -VM $VMclone -Server $vcenter_server -Confirm:$False
		}
		
		


#		  
#		$VMclone1 = "Workstation"+"$netnum"+"_11"
#		$VMclone2 = "Workstation"+"$netnum"+"_12"
#		$VMclone3 = "Workstation"+"$netnum"+"_13"
#		
#		Stop-VM -VM $VMclone1 -Kill -Confirm:$false
#		Stop-VM -VM $VMclone2 -Kill -Confirm:$false
#		Stop-VM -VM $VMclone3 -Kill -Confirm:$false
#					
#		Remove-VM -DeletePermanently -RunAsync -VM $VMclone1 -Server $vcenter_server -Confirm:$False
#		Remove-VM -DeletePermanently -RunAsync -VM $VMclone2 -Server $vcenter_server -Confirm:$False
#		Remove-VM -DeletePermanently -RunAsync -VM $VMclone3 -Server $vcenter_server -Confirm:$False
#		
		Remove-ResourcePool -ResourcePool $vrf -Confirm:$False
		

					
}

disconnect-viserver -server $vcenter_server -Confirm:$false
	

	




    