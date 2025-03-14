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




## support unsigned certs
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers

##Connect to vCenter
connect-viserver -server $vcenter_server -User $vcenter_user -Password $vcenter_pwd



## working

## Create VDS and Networks
$location = Get-Datacenter -Name $DCName
echo $location


## working 


## Create the local resource pools for each 

$storeDisk = Get-Datastore -VMHost $Hostesxi | where { $_.Name -eq $DataStore }


# Loop through each item in the array using ForEach-Object
$VRFResPool | ForEach-Object {
		## create the resourcepool
		$vrf = "VRF"+$_
		New-ResourcePool -Location $Hostesxi -Name $vrf
		$Location = Get-ResourcePool | where { $_.Name -eq $vrf } 


		
		
    Write-Host "Resource Pool Created: $vrf"
    $netnum = 10 * $_
    $netnum1 = $netnum + 1
    $netnum2 = $netnum + 2
    $netnum3 = $netnum + 3
    
    $privnum1 = 1000 + $netnum1
    $privnum2 = 1000 + $netnum2
    $privnum3 = 1000 + $netnum3
    
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
		
		
		
		  
#		$VMclone1 = "Workstation"+"$netnum1"+"_11"
#		$VMclone2 = "Workstation"+"$netnum1"+"_12"
#		$VMclone3 = "Workstation"+"$netnum1"+"_13"
#		
#		$VMIP1 = "192.168."+"$netnum1"+".11"
#		$VMIP2 = "192.168."+"$netnum1"+".12"
#		$VMIP3 = "192.168."+"$netnum1"+".13"

#		New-VM -VM $VMsource -Name $VMclone1 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "sudo ifconfig eth0 192.168.x.11 netmask 255.255.255.0 up
#		sudo route add default gw 192.168.x.1
#
#		user: tc or root
#		password: VMware1!" -RunAsync
#
#
#		New-VM -VM $VMsource -Name $VMclone2 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "sudo ifconfig eth0 192.168.x.12 netmask 255.255.255.0 up
#		sudo route add default gw 192.168.x.1
#
#		user: tc or root
#		password: VMware1!" -RunAsync
#		
#
#		
#		New-VM -VM $VMsource -Name $VMclone3 -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "sudo ifconfig eth0 192.168.x.13 netmask 255.255.255.0 up
#		sudo route add default gw 192.168.x.1
#
#		user: tc or root
#		password: VMware1!" 
			
			
			
#		$vrfg = Get-Tag -Name "$vrf" -Category $Workloadgroupname
#		$workload1 = Get-Tag -Name "workload1" -Category $TagCategoryname
#		$workload2 = Get-Tag -Name "workload2" -Category $TagCategoryname
#		$workload3 = Get-Tag -Name "workload3" -Category $TagCategoryname
#			
#		$vms1 = Get-VM -name $VMclone1
#		New-TagAssignment -Tag $workload1 -Entity $vms1	
#		New-TagAssignment -Tag $vrfg -Entity $vms1	
#			
#		$vms2 = Get-VM -name $VMclone2
#		New-TagAssignment -Tag "workload2"-Entity $vms2
#		New-TagAssignment -Tag $vrfg -Entity $vms2		
#
#		$vms3 = Get-VM -name $VMclone3
#		New-TagAssignment -Tag "workload3" -Entity $vms3
#		New-TagAssignment -Tag $vrfg -Entity $vms3	
		
		
#		Start-VM -VM $VMclone1 -Confirm:$false -RunAsync
#		Start-VM -VM $VMclone2 -Confirm:$false -RunAsync
#		Start-VM -VM $VMclone3 -Confirm:$false -RunAsync
						
			
				
#		Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone1 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
#		Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone2 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
#		Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone3 | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
#					

		
		$viuser = "VSPHERE.LOCAL\"+"$vrf"+"_user"
		Get-ResourcePool $vrf |New-VIPermission -Role TestDrive -Principal $viuser
		Get-VirtualPortGroup -name $vdPortGroup1  |New-VIPermission -Role TestDrive -Principal $viuser
		Get-VirtualPortGroup -name $vdPortGroup2  |New-VIPermission -Role TestDrive -Principal $viuser
		
		$VmInt1 = "$netnum2"+"_"+"$privnum2"+"_PRO"
    $VmInt2 = "$netnum2"+"_"+"$privnum2"+"_ISO"
    $vdPortGroup1 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt1
		$vdPortGroup2 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt2
		Get-VirtualPortGroup -name $vdPortGroup1  |New-VIPermission -Role TestDrive -Principal $viuser
		Get-VirtualPortGroup -name $vdPortGroup2  |New-VIPermission -Role TestDrive -Principal $viuser
		$VmInt1 = "$netnum3"+"_"+"$privnum3"+"_PRO"
    $VmInt2 = "$netnum3"+"_"+"$privnum3"+"_ISO"
		$vdPortGroup1 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt1
		$vdPortGroup2 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt2
		Get-VirtualPortGroup -name $vdPortGroup1  |New-VIPermission -Role TestDrive -Principal $viuser
		Get-VirtualPortGroup -name $vdPortGroup2  |New-VIPermission -Role TestDrive -Principal $viuser
		
		

<#		
		$tagCategoryView = Get-View -ViewType TagCategory -Filter @{"Name"="Demo"}
		get-TagCategory -Name "Demo"  | New-VIPermission -Role TestDrive -Principal "vrf1_user"
		

$permission = New-VIPermission -Role Role -Principal Administrator -Entity (Get-Datacenter)
	$permission =  set-VIPermission -Role TestDrive -Principal "vsphere.local\vrf1_user" -Entity (get-TagCategory -Name "Demo")
 New-VIPermission -Role TestDrive -Principal "vsphere.local\vrf1_user"  -Entity (Get-Tag -name "workload1" -Category "Demo")
#		Get-Tag -name workload1 -Category 'Demo' |New-VIPermission -Role TestDrive -Principal $viuser -Entity (Get-Tag -name workload1 -Category 'Demo')#>
}







		Start-Sleep -Seconds 120
		
		

$VRFResPool | ForEach-Object {

    $netnum = 10 * $_
    $netnum1 = $netnum + 1
		  
		 
		$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					$VMIP = "192.168."+"$netnum1"+"."+"$workloadnumber"
			
					Invoke-VMScript -VM $VMclone -ScriptText "sudo /opt/set-ipv4-address.sh $VMIP 255.255.255.0 192.168.11.255 192.168.11.1 192.168.101.1 testdrive" -GuestUser "root" -GuestPassword "VMware1!"
		}
}
		
		
		


disconnect-viserver -server $vcenter_server -Confirm:$false
