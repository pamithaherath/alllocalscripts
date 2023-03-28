Param($DryRun = $true)

#these parameters MUST be set first
$activeFirewall = "apprdconnsfw03"
$publicIpPrefix = "pip-prd-con-ns-ase"


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
    $internalIpName = "untrust-app$('{0:d3}' -f ($internalIpNumber-137))"

	$publicIpName = "$($publicIpPrefix)-$('{0:d3}' -f ($internalIpNumber-133))"
	$publicIp = Get-AzPublicIpAddress -Name $publicIpName

	write-host "`tAdding $internalIp as $internalIpName with $publicIpName to $($nicObject.name)"
	$null = Add-AzNetworkInterfaceIpConfig -Name $internalIpName -NetworkInterface $nicObject -PrivateIpAddress $internalIp -PrivateIpAddressVersion IPv4 -SubnetId $nicSubnetId
	$s = Set-AzNetworkInterfaceIpConfig -Name $internalIpName -PublicIpAddress $publicIp -Subnet $nicSubnetId -NetworkInterface $nicObject

}

$untrustNic = Get-AzNetworkInterface -Name "nic-002-$activeFirewall"

#Obtain subnetIds for untrust from ipconfig1 IP, which doesn't get moved/dropped
$untrustSubnetId = Get-AzVirtualNetworkSubnetConfig -ResourceId $untrustNic.IpConfigurations[0].Subnet.id
$untrustSubnetMatch = $untrustSubnetId.AddressPrefix[0] -match "\d*\.\d*\.\d*"
$untrustSubnetPrefix = $matches[0]

write-host -ForegroundColor Blue "Untrust - Attaching 4x egress IPs"

$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-001"
write-host "`tAdding $untrustSubnetPrefix.134 as untrust-vip1 with $($publicIp.Name) to $($untrustNic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -NetworkInterface $untrustNic -PrivateIpAddress "$untrustSubnetPrefix.134" -PrivateIpAddressVersion IPv4 -SubnetId $untrustSubnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -PublicIpAddress $publicIp -Subnet $untrustSubnetid -NetworkInterface $untrustNic


$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-002"
write-host "`tAdding $untrustSubnetPrefix.135 as untrust-vip2 with $($publicIp.Name) to $($untrustNic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip2" -NetworkInterface $untrustNic -PrivateIpAddress "$untrustSubnetPrefix.135" -PrivateIpAddressVersion IPv4 -SubnetId $untrustSubnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip2" -PublicIpAddress $publicIp -Subnet $untrustSubnetid -NetworkInterface $untrustNic

$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-003"
write-host "`tAdding $untrustSubnetPrefix.136 as untrust-vip3 with $($publicIp.Name) to $($untrustNic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip3" -NetworkInterface $untrustNic -PrivateIpAddress "$untrustSubnetPrefix.136" -PrivateIpAddressVersion IPv4 -SubnetId $untrustSubnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip3" -PublicIpAddress $publicIp -Subnet $untrustSubnetid -NetworkInterface $untrustNic

$publicIP = Get-AzPublicIpAddress -Name "$publicIpPrefix-004"
write-host "`tAdding $untrustSubnetPrefix.137 as untrust-vip4 with $($publicIp.Name) to $($untrustNic.name)"
$null = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip4" -NetworkInterface $untrustNic -PrivateIpAddress "$untrustSubnetPrefix.137" -PrivateIpAddressVersion IPv4 -SubnetId $untrustSubnetid
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip4" -PublicIpAddress $publicIp -Subnet $untrustSubnetid -NetworkInterface $untrustNic


#untrust - one tranches
write-host -ForegroundColor Blue "Untrust - Attaching tranche."
for ($internalIpNumber = 138; $internalIpNumber -le 162; $internalIpNumber++) {
	Add-IpAddressToNic -nicObject $untrustNic -nicSubnetPrefix $untrustSubnetPrefix -nicSubnetId $untrustSubnetId -internalIpNumber $internalIpNumber
}


write-host -ForegroundColor Blue "Setting all IPs to static."
#Force all IPs to static. Unclear why I can't do this during the bind but it doesn't seem to work
foreach ($ipConfigs in $untrustNic.ipconfigurations) {
	$ipConfigs.PrivateIpAllocationMethod = "Static"
}

if (!$DryRun) {
	write-host -ForegroundColor Blue "Saving untrust configuration."
	$null = Set-AzNetworkInterface -NetworkInterface $untrustNic
}
