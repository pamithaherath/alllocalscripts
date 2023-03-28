Param($DryRun = $true)

#these parameters MUST be set first
$activeFirewall = "apnppconnsfw01"
$publicIpPrefix = "pip-npp-con-ns-aue"


if ($DryRun) {
    write-host "Note: Running in dry-run mode only. NIC configuration will not be saved at the end."
}

write-host -ForegroundColor Red "WARNING, `$activeFirewall is set to $activeFirewall. If this isn't correct, cancel immediately."

function Add-IpAddressToNic {
	param ( $nicObject,
			$nicSubnetPrefix,
			$nicSubnetId,
			$internalIpNumber

	)
	$internalIp = "$nicSubnetPrefix.$internalIpNumber"
    $internalIpName = "untrust-app$('{0:d3}' -f ($internalIpNumber-9))"

	$publicIpName = "$($publicIpPrefix)-$('{0:d3}' -f ($internalIpNumber-5))"
	$publicIp = Get-AzPublicIpAddress -Name $publicIpName

	write-host "`tAdding $internalIp as $internalIpName with $publicIpName to $($nicObject.name)"
	$null = Add-AzNetworkInterfaceIpConfig -Name $internalIpName -NetworkInterface $nicObject -PrivateIpAddress $internalIp -PrivateIpAddressVersion IPv4 -SubnetId $nicSubnetId
	$s = Set-AzNetworkInterfaceIpConfig -Name $internalIpName -PublicIpAddress $publicIp -Subnet $nicSubnetId -NetworkInterface $nicObject

}

$untrust1Nic = Get-AzNetworkInterface -Name "nic-003-$activeFirewall"
$untrust2Nic = Get-AzNetworkInterface -Name "nic-005-$activeFirewall"

#Obtain subnetIds for untrust from ipconfig1 IP, which doesn't get moved/dropped
$untrust1SubnetId = Get-AzVirtualNetworkSubnetConfig -ResourceId $untrust1Nic.IpConfigurations[0].Subnet.id
$untrust1SubnetMatch = $untrust1SubnetId.AddressPrefix[0] -match "\d*\.\d*\.\d*"
$untrust1SubnetPrefix = $matches[0]

$untrust2SubnetId = Get-AzVirtualNetworkSubnetConfig -ResourceId $untrust2Nic.IpConfigurations[0].Subnet.id
$untrust2SubnetMatch = $untrust2SubnetId.AddressPrefix[0] -match "\d*\.\d*\.\d*"
$untrust2SubnetPrefix = $matches[0]

write-host -ForegroundColor Blue "Untrust1 - Attaching 3x egress IPs"
#These are on untrust1
$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-001"
write-host "`tAdding $untrust1SubnetPrefix.6 as untrust-vip1 with $($publicIp.Name) to $($untrust1Nic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -NetworkInterface $untrust1Nic -PrivateIpAddress "$untrust1SubnetPrefix.6" -PrivateIpAddressVersion IPv4 -SubnetId $untrust1Subnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -PublicIpAddress $publicIp -Subnet $untrust1Subnetid -NetworkInterface $untrust1Nic


$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-002"
write-host "`tAdding $untrust1SubnetPrefix.7 as untrust-vip2 with $($publicIp.Name) to $($untrust1Nic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip2" -NetworkInterface $untrust1Nic -PrivateIpAddress "$untrust1SubnetPrefix.7" -PrivateIpAddressVersion IPv4 -SubnetId $untrust1Subnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip2" -PublicIpAddress $publicIp -Subnet $untrust1Subnetid -NetworkInterface $untrust1Nic

$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-003"
write-host "`tAdding $untrust1SubnetPrefix.8 as untrust-vip3 with $($publicIp.Name) to $($untrust1Nic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip3" -NetworkInterface $untrust1Nic -PrivateIpAddress "$untrust1SubnetPrefix.8" -PrivateIpAddressVersion IPv4 -SubnetId $untrust1Subnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip3" -PublicIpAddress $publicIp -Subnet $untrust1Subnetid -NetworkInterface $untrust1Nic

write-host -ForegroundColor Blue "Untrust2 - Attaching 1x egress IPs"
#This one is on untrust2
$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-004"
write-host "`tAdding $untrust2SubnetPrefix.6 as untrust-vip1 with $($publicIp.Name) to $($untrust2Nic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -NetworkInterface $untrust2Nic -PrivateIpAddress "$untrust2SubnetPrefix.6" -PrivateIpAddressVersion IPv4 -SubnetId $untrust2Subnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -PublicIpAddress $publicIp -Subnet $untrust2Subnetid -NetworkInterface $untrust2Nic


#untrust1 - two tranches
write-host -ForegroundColor Blue "Untrust1 - Attaching two tranches."
for ($internalIpNumber = 10; $internalIpNumber -le 70; $internalIpNumber++) {
	Add-IpAddressToNic -nicObject $untrust1Nic -nicSubnetPrefix $untrust1SubnetPrefix -nicSubnetId $untrust1SubnetId -internalIpNumber $internalIpNumber
}
for ($internalIpNumber = 160; $internalIpNumber -le 179; $internalIpNumber++) {
	Add-IpAddressToNic -nicObject $untrust1Nic -nicSubnetPrefix $untrust1SubnetPrefix -nicSubnetId $untrust1SubnetId -internalIpNumber $internalIpNumber
}

#untrust2 - two tranches
write-host -ForegroundColor Blue "Untrust2 - Attaching two tranches."
for ($internalIpNumber = 71; $internalIpNumber -le 159; $internalIpNumber++) {
	Add-IpAddressToNic -nicObject $untrust2Nic -nicSubnetPrefix $untrust2SubnetPrefix -nicSubnetId $untrust2SubnetId -internalIpNumber $internalIpNumber
}
for ($internalIpNumber = 180; $internalIpNumber -le 190; $internalIpNumber++) {
	Add-IpAddressToNic -nicObject $untrust2Nic -nicSubnetPrefix $untrust2SubnetPrefix -nicSubnetId $untrust2SubnetId -internalIpNumber $internalIpNumber
}

write-host -ForegroundColor Blue "Setting all IPs to static."
#Force all IPs to static. Unclear why I can't do this during the bind but it doesn't seem to work
foreach ($ipConfigs in $untrust1Nic.ipconfigurations) {
	$ipConfigs.PrivateIpAllocationMethod = "Static"
}
foreach ($ipConfigs in $untrust2Nic.ipconfigurations) {
	$ipConfigs.PrivateIpAllocationMethod = "Static"
}

if (!$DryRun) {
	write-host -ForegroundColor Blue "Saving untrust1 configuration."
	$null = Set-AzNetworkInterface -NetworkInterface $untrust1Nic
	write-host -ForegroundColor Blue "Saving untrust2 configuration."
	$null = Set-AzNetworkInterface -NetworkInterface $untrust2Nic
}
