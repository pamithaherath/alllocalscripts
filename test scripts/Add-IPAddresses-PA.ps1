$f5InternalNic = Get-AzNetworkInterface -Name "nic-005-apnppconnsfw01" -ResourceGroupName "rg-npp-con-northsouth-aue-001"
$rgName = "rg-npp-con-northsouth-aue-001"
$publicIpPrefix = "pip-npp-con-ns-aue-"

$subnet = "10.98.2"
$subnetid = Get-AzVirtualNetworkSubnetConfig -ResourceId $f5internalNic.IpConfigurations[0].Subnet.id

<#
$publicIP = Get-AzPublicIpAddress -Name "pip-npp-con-ns-aue-001" -ResourceGroup $rgName
$f5InternalNic = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -NetworkInterface $f5InternalNic -PrivateIpAddress "10.98.2.6" -PrivateIpAddressVersion IPv4 -SubnetId $subnetId
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip1" -PublicIpAddress $publicIp -Subnet $subnetid -NetworkInterface $f5InternalNic

$publicIP = Get-AzPublicIpAddress -Name "pip-npp-con-ns-aue-002" -ResourceGroup $rgName
$f5InternalNic = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip2" -NetworkInterface $f5InternalNic -PrivateIpAddress "10.98.2.7" -PrivateIpAddressVersion IPv4 -SubnetId $subnetId
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip2" -PublicIpAddress $publicIp -Subnet $subnetid -NetworkInterface $f5InternalNic

$publicIP = Get-AzPublicIpAddress -Name "pip-npp-con-ns-aue-003" -ResourceGroup $rgName
$f5InternalNic = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip3" -NetworkInterface $f5InternalNic -PrivateIpAddress "10.98.2.8" -PrivateIpAddressVersion IPv4 -SubnetId $subnetId
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip3" -PublicIpAddress $publicIp -Subnet $subnetid -NetworkInterface $f5InternalNic

$publicIP = Get-AzPublicIpAddress -Name "pip-npp-con-ns-aue-004" -ResourceGroup $rgName
$f5InternalNic = Add-AzNetworkInterfaceIpConfig -Name "untrust-vip4" -NetworkInterface $f5InternalNic -PrivateIpAddress "10.98.2.9" -PrivateIpAddressVersion IPv4 -SubnetId $subnetId
$s = Set-AzNetworkInterfaceIpConfig -Name "untrust-vip4" -PublicIpAddress $publicIp -Subnet $subnetid -NetworkInterface $f5InternalNic
#>


#Needs to be adjusted based on IPs used.. But this will need more changes or manual work with nic-003/nic-005 split
for ($currentIp = 10; $currentIp -lt 191 ; $currentIp++) {
	$newIp = "$subnet.$currentIp"
        $number = '{0:d3}' -f ($currentIp-9)
	$newIpName = "untrust-app$number"

	$publicIpNumber = '{0:d3}' -f ($currentIp-5)
	$publicIpName = "$($publicIpPrefix)$($publicIpNumber)"
	$publicIP = Get-AzPublicIpAddress -Name $publicIpName -ResourceGroup $rgName

	write-host "Adding $newIp as $newIpName with $publicIpName"
	$f5InternalNic = Add-AzNetworkInterfaceIpConfig -Name $newIpName -NetworkInterface $f5InternalNic -PrivateIpAddress $newIp -PrivateIpAddressVersion IPv4 -SubnetId $subnetId #-PublicIpAddress $publicIp
	$s = Set-AzNetworkInterfaceIpConfig -Name $newIpName -PublicIpAddress $publicIp -Subnet $subnetid -NetworkInterface $f5InternalNic

}
#Can't seem to find another way to do this
foreach ($n in $f5internalNic.ipconfigurations) {
	$n.PrivateIpAllocationMethod = "Static"
}
#Apply changes - I do this manually
#Set-AzNetworkInterface -NetworkInterface $f5InternalNic

