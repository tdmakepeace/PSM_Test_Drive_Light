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


$reset = Read-Host "Enter the Pod number you want to reset eg. 1:"

################################################## (End of EDIT to Suit Customer Enviroment) ##################################################


		$vrf = "VRF"+"$reset"
		$netnum = 10 * $reset
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
		
		
		Remove-ResourcePool -ResourcePool $vrf -Confirm:$False
		

Start-Sleep -Seconds 30


$location = Get-Datacenter -Name $DCName
echo $location


## working 


## Create the local resource pools for each 

$storeDisk = Get-Datastore -VMHost $Hostesxi | where { $_.Name -eq $DataStore }


		New-ResourcePool -Location $Hostesxi -Name $vrf
		$Location = Get-ResourcePool | where { $_.Name -eq $vrf } 

    $netnum = 10 * $reset
    $netnum1 = $netnum + 1
    
    $privnum1 = 1000 + $netnum1
    
    $VmInt1 = "$netnum1"+"_"+"$privnum1"+"_PRO"
    $VmInt2 = "$netnum1"+"_"+"$privnum1"+"_ISO"
		
		$vdSwitch = Get-VDSwitch -Name $Global:VmDS
		$vdPortGroup1 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt1
		$vdPortGroup2 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt2
		$net = $_
		
		$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					$VMIP = "192.168."+"$netnum1"+"."+"$workloadnumber"
					$VMgateway = "192.168."+"$netnum1"+".1"
					$VMtag = "Workload"+"$_"
					
							New-VM -VM $VMsource -Name $VMclone -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "sudo ifconfig eth0 $VMIP netmask 255.255.255.0 up
		sudo route add default gw $VMgateway

		user: tc or root
		password: VMware1!" 
			
					
					$vrfg = Get-Tag -Name "$vrf" -Category $Workloadgroupname
					$workload = Get-Tag -Name $VMtag -Category $TagCategoryname
					
					$vms = Get-VM -name $VMclone
					New-TagAssignment -Tag $workload -Entity $vms	
					New-TagAssignment -Tag $vrfg -Entity $vms
					Start-VM -VM $VMclone -Confirm:$false -RunAsync
						
						
						
					Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
					Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone | where {$_.Name -eq "Network adapter 1" } ) -connected:$true  -Confirm:$False
		}
		

Start-Sleep -Seconds 30

		$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					$VMIP = "192.168."+"$netnum1"+"."+"$workloadnumber"
			
					Invoke-VMScript -VM $VMclone -ScriptText "sudo /opt/set-ipv4-address.sh $VMIP 255.255.255.0 192.168.11.255 192.168.11.1 192.168.101.1 testdrive" -GuestUser "root" -GuestPassword "VMware1!"
		}
				















disconnect-viserver -server $vcenter_server -Confirm:$false
	





    