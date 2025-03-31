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


## Create a role 
New-VIRole -Name TestDrive

Set-VIRole -Role TestDrive -AddPrivilege "Anonymous"
Set-VIRole -Role TestDrive -AddPrivilege "View"
Set-VIRole -Role TestDrive -AddPrivilege "Read"
Set-VIRole -Role TestDrive -AddPrivilege "Move network"
Set-VIRole -Role TestDrive -AddPrivilege "Configure"
Set-VIRole -Role TestDrive -AddPrivilege "Assign network"
Set-VIRole -Role TestDrive -AddPrivilege "Move"
Set-VIRole -Role TestDrive -AddPrivilege "Power on"
Set-VIRole -Role TestDrive -AddPrivilege "Power off"
Set-VIRole -Role TestDrive -AddPrivilege "Suspend"
Set-VIRole -Role TestDrive -AddPrivilege "Reset"
Set-VIRole -Role TestDrive -AddPrivilege "Pause or Unpause"
Set-VIRole -Role TestDrive -AddPrivilege "Console interaction"
Set-VIRole -Role TestDrive -AddPrivilege "Add new disk"
Set-VIRole -Role TestDrive -AddPrivilege "Modify device settings"
Set-VIRole -Role TestDrive -AddPrivilege "Change Settings"
Set-VIRole -Role TestDrive -AddPrivilege "Advanced configuration"
Set-VIRole -Role TestDrive -AddPrivilege "Display connection settings" 
Set-VIRole -Role TestDrive -AddPrivilege "AttachTag" 
Set-VIRole -Role TestDrive -AddPrivilege "ObjectAttachable"


## create Workloadgroup and Demo TagCategory 
$Workloadgroup = New-TagCategory -Name $Workloadgroupname -Cardinality Multiple
$TagCategory = New-TagCategory -Name $TagCategoryname -Cardinality Multiple


$VRFworkloads | ForEach-Object {
					$workloadnumber =  $_
					$workloadtag = "Workload"+"$workloadnumber"
					$TagCategory = Get-TagCategory -Name $TagCategoryname 
					$workload = New-Tag -Name $workloadtag -Category $TagCategory					
					
		}
		
#		
#
#
#$workload2 = New-Tag -Name "workload2" -Category $TagCategory
#$workload3 = New-Tag -Name "workload3" -Category $TagCategory


## Create VDS and Networks
$location = Get-Datacenter -Name $DCName
echo $location
 # New-VDSwitch -Name $VmDS -Location $location -MaxPorts 60 -NumUplinkPorts 4 -Mtu 9000 -WithoutPortGroups
New-VDSwitch -Name $VmDS -Location $location  -MaxPorts 512 -NumUplinkPorts 4 -Mtu 9000 -LinkDiscoveryProtocol "LLDP" -LinkDiscoveryProtocolOperation Listen
# New-VDSwitch -Name $VmDS -Location $location  -MaxPorts 512 -NumUplinkPorts 4 -Mtu 9000 -LinkDiscoveryProtocol "LLDP" -LinkDiscoveryProtocolOperation Listen -Version "6.6.0"

$vds = Get-VDSwitch $VmDS


$VRFResPool | ForEach-Object {
		$vrf = "VRF"+$_
		$Workloadgroup = get-TagCategory -Name $Workloadgroupname
		$vrfg = New-Tag -Name "$vrf" -Category $Workloadgroup
		
    $netnum = 10 * $_
    $netnum1 = $netnum + 1
    $netnum2 = $netnum + 2
    $netnum3 = $netnum + 3
    
    $privnum1 = 1000 + $netnum1
    $privnum2 = 1000 + $netnum2
    $privnum3 = 1000 + $netnum3
    
    $VmInt1 = "$netnum1"+"_"+"$privnum1"+"_PRO"
    $VmInt2 = "$netnum1"+"_"+"$privnum1"+"_ISO"

## Create user 
		$vrfuser = "vrf"+$_+"_user"
		Connect-SsoAdminServer -Server $vcenter_server -User $vcenter_user -Password "$vcenter_pwd" -SkipCertificateCheck
		New-SsoPersonUser -UserName $vrfuser -Password "Pensando0$" -FirstName $vrfuser -LastName $vrfuser
		Disconnect-SsoAdminServer -Server $vcenter_server
		

#		$vdSwitch = Get-VDSwitch -Name $VmDS


		Get-VDSwitch $vds | New-VDSwitchPrivateVlan -PrimaryVlanId $netnum1 -SecondaryVlanId $netnum1 -PrivateVlanType Promiscuous
		Get-VDSwitch $vds | New-VDSwitchPrivateVlan -PrimaryVlanId $netnum1 -SecondaryVlanId $privnum1 -PrivateVlanType Isolated
    Get-VDSwitch $vds | New-VDSwitchPrivateVlan -PrimaryVlanId $netnum2 -SecondaryVlanId $netnum2 -PrivateVlanType Promiscuous
		Get-VDSwitch $vds | New-VDSwitchPrivateVlan -PrimaryVlanId $netnum2 -SecondaryVlanId $privnum2 -PrivateVlanType Isolated
    Get-VDSwitch $vds | New-VDSwitchPrivateVlan -PrimaryVlanId $netnum3 -SecondaryVlanId $netnum3 -PrivateVlanType Promiscuous
		Get-VDSwitch $vds | New-VDSwitchPrivateVlan -PrimaryVlanId $netnum3 -SecondaryVlanId $privnum3 -PrivateVlanType Isolated
    # Write-Output "PrimaryVlanId: $($item.primary), SecondaryVlanId: $($item.secondary)"
   
		$name_iso1 = "$netnum1"+"_"+"$privnum1"+"_ISO"
		$name_pro1 = "$netnum1"+"_"+"$privnum1"+"_PRO"

    New-VDPortgroup -name "$name_pro1" -VDSwitch $VmDS -NumPorts 4
		Set-VDPortgroup -VDPortgroup $name_pro1 -PrivateVlanId $netnum1
		
    New-VDPortgroup -name "$name_iso1" -VDSwitch $VmDS -NumPorts 4
		Set-VDPortgroup -VDPortgroup $name_iso1 -PrivateVlanId $privnum1

		$name_iso2 = "$netnum2"+"_"+"$privnum2"+"_ISO"
		$name_pro2 = "$netnum2"+"_"+"$privnum2"+"_PRO"

    New-VDPortgroup -name "$name_pro2" -VDSwitch $VmDS -NumPorts 4
		Set-VDPortgroup -VDPortgroup $name_pro2 -PrivateVlanId $netnum2
		
    New-VDPortgroup -name "$name_iso2" -VDSwitch $VmDS -NumPorts 4
		Set-VDPortgroup -VDPortgroup $name_iso2 -PrivateVlanId $privnum2
		
		$name_iso3 = "$netnum3"+"_"+"$privnum3"+"_ISO"
		$name_pro3 = "$netnum3"+"_"+"$privnum3"+"_PRO"

    New-VDPortgroup -name "$name_pro3" -VDSwitch $VmDS -NumPorts 4
		Set-VDPortgroup -VDPortgroup $name_pro3 -PrivateVlanId $netnum3
		
    New-VDPortgroup -name "$name_iso3" -VDSwitch $VmDS -NumPorts 4
		Set-VDPortgroup -VDPortgroup $name_iso3 -PrivateVlanId $privnum3


}


disconnect-viserver -server $vcenter_server -Confirm:$false

#Connect-SsoAdminServer -Server $vcenter_server -User $vcenter_user -Password $vcenter_pwd -SkipCertificateCheck
#New-SsoGroup -Name "TestDriveGroup" -Description "TestDriveTAGpermissions"
#Disconnect-SsoAdminServer -Server $vcenter_server
