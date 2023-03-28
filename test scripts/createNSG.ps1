Select-AzSubscription -SubscriptionName 'NINP-PERF'

$webports = 7,22,80,81,82,389,443,444,636,639,686,1521,1527,3060,3131,3872,3873,3874,4443,4444,4445,4446,4447,4448,4848,4899,4900,4901,5162,5556,5557,5575,5800,6700,6701,6707,7000,7001,7006,7008,7009,7012,7013,7101,7102,7103,7104,7199,7201,7270,7272,7273,7450,7499,7500,7501,7777,7778,7890,8001,8002,8044,8080,8090,8101,8102,8180,8181,8280,8281,8282,8443,8444,8834,9000,9100,9160,9703,9704,9804,11211,14000,14001,14100,14101,14942,14943,18089,19000,19013,19043,19080,19999,28002,30000,30100,35080,61616
$appports = 7,22,80,81,82,389,443,444,636,639,686,1521,1527,3060,3131,3872,3873,3874,4443,4444,4445,4446,4447,4448,4848,4899,4900,4901,5162,5556,5557,5575,5800,6700,6701,6707,7000,7001,7006,7008,7009,7012,7013,7101,7102,7103,7104,7199,7201,7270,7272,7273,7450,7499,7500,7501,7777,7778,7890,8001,8002,8044,8080,8090,8101,8102,8180,8181,8280,8281,8282,8443,8444,8834,9000,9100,9160,9703,9704,9804,11211,14000,14001,14100,14101,14942,14943,18089,19000,19013,19043,19080,19999,28002,30000,30100,35080,61616

$NSG1 = Get-AzNetworkSecurityGroup -Name "nsg-sn-pfb-aue-per-web" -ResourceGroupName "rg-per-network-aue-001"
$NSG2 = Get-AzNetworkSecurityGroup -Name "nsg-sn-pfb-aue-per-app" -ResourceGroupName "rg-per-network-aue-001"

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
 -Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
 -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $webports
$NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrWindowsInBound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 445,3389
$NSG1 | Set-AzNetworkSecurityGroup



$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1003 -SourceAddressPrefix "10.98.46.0/24" -SourcePortRange * `
-DestinationAddressPrefix "10.98.46.0/24" -DestinationPortRange *
$NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG1 | Set-AzNetworkSecurityGroup


#Adding app nsg rules

$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
 -Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
 -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG2 | Set-AzNetworkSecurityGroup


$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $appports
$NSG2 | Set-AzNetworkSecurityGroup


$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrWindowsInBound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 445,3389
$NSG2 | Set-AzNetworkSecurityGroup



$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1003 -SourceAddressPrefix "10.98.47.0/24" -SourcePortRange * `
-DestinationAddressPrefix "10.98.47.0/24" -DestinationPortRange *
$NSG2 | Set-AzNetworkSecurityGroup


$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG2 | Set-AzNetworkSecurityGroup

