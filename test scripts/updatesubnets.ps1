
#Select-AzSubscription -SubscriptionName "NINP-SIT"
Select-AzSubscription -SubscriptionName "Visual Studio Enterprise Subscription"

#New-AzNetworkSecurityGroup -Name "nsg-sn-ptg-aue-sit-web" -ResourceGroupName "rg-sit-network-aue-001"  -Location  "australiaeast"
#New-AzNetworkSecurityGroup -Name "nsg-sn-ptg-aue-sit-app" -ResourceGroupName "rg-sit-network-aue-001"  -Location  "australiaeast"
#New-AzRouteTable -Name "rt-sn-ptg-aue-sit-web" -ResourceGroupName "rg-sit-network-aue-001"  -Location  "australiaeast"
#New-AzRouteTable -Name "rt-sn-ptg-aue-sit-app" -ResourceGroupName "rg-sit-network-aue-001"  -Location  "australiaeast"


#Param(  [Parameter(Mandatory=$true)]$RouteTableName)

$existingRouteTable = Get-AzRouteTable #-Name $RouteTableName

foreach ($rt in $existingRouteTable) {
    if ($rt.Name -contains "rt-sn-ptd-aue-sit-web") {
        $temproute = $rt.Routes.Name
      #$existingRouteTable | Remove-AzRouteconfig -Name "route-to-virtual-appliance"
     Write-Host $temproute[2]
   
   }
}




#$vnet = Get-AzVirtualNetwork -Name "vnet-sit-workload-aue-001" -ResourceGroupName "rg-sit-network-aue-001"
<#
$nsgrules = Get-AzNetworkSecurityGroup -Name "nsg-sn-ptd-aue-sit-web" -ResourceGroupName "rg-sit-network-aue-001"
    | Get-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound"

    write-host $nsgrules.ToString #>
#Remove-AzVirtualNetworkSubnetConfig -Name sn-ptd-aue-sit-web -VirtualNetwork $vnet
#$vnet | Set-AzVirtualNetwork
#Remove-AzVirtualNetworkSubnetConfig -Name sn-ptd-aue-sit-app -VirtualNetwork $vnet
#$vnet | Set-AzVirtualNetwork

#Remove-AzNetworkSecurityGroup -Name "nsg-sn-ptd-aue-sit-web" -ResourceGroupName "rg-sit-network-aue-001" 
#Remove-AzNetworkSecurityGroup -Name "nsg-sn-ptd-aue-sit-app" -ResourceGroupName "rg-sit-network-aue-001" 
#Remove-AzRouteTable -ResourceGroupName "rg-sit-network-aue-001"  -Name "rt-sn-ptd-aue-sit-web" 
#Remove-AzRouteTable -ResourceGroupName "rg-sit-network-aue-001"  -Name "rt-sn-ptd-aue-sit-app" 

#Add-AzVirtualNetworkSubnetConfig -Name sn-ptg-aue-sit-web -VirtualNetwork $vnet -AddressPrefix "10.98.48.0/25" 
#$vnet | Set-AzVirtualNetwork
#Add-AzVirtualNetworkSubnetConfig -Name sn-ptg-aue-sit-app -VirtualNetwork $vnet -AddressPrefix "10.98.48.128/25" 
#$vnet | Set-AzVirtualNetwork
#Add-AzVirtualNetworkSubnetConfig -Name sn-ptg-aue-sit-database -VirtualNetwork $vnet -AddressPrefix "10.98.49.0/26" 
#$vnet | Set-AzVirtualNetwork
#$vnet | Set-AzVirtualNetwork