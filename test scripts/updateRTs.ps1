Select-AzSubscription -SubscriptionName "NIPD-Management"



$AUERouteTable = Get-AzRouteTable -ResourceGroupName "rg-prd-mgt-network-aue" -Name "rt-sn-prd-aue-mgt-utility"
$ASERouteTable = Get-AzRouteTable -ResourceGroupName "rg-prd-mgt-network-ase" -Name "rt-sn-prd-ase-mgt-utility"

<#$AUERouteTable | Add-AzRouteConfig -Name "route-to-sn-prd-aue-mgt-utility" `
                -AddressPrefix 10.102.18.32/27 `
                -NextHopType VnetLocal 
                


$AUERouteTable | Add-AzRouteConfig -Name "route-to-vnet-prd-mgt-network-aue" `
                  -AddressPrefix 10.102.16.0/21 `
                  -NextHopType VirtualAppliance `
                  -NextHopIpAddress "10.102.0.14" `
                  

$AUERouteTable | Add-AzRouteConfig -Name "route-via-ew-firewall" `
                  -AddressPrefix 10.0.0.0/8 `
                  -NextHopType VirtualAppliance `
                  -NextHopIpAddress "10.102.0.14" `
                  

$AUERouteTable | Add-AzRouteConfig -Name "route-via-NS-firewall" `
                  -AddressPrefix 0.0.0.0/0 `
                  -NextHopType VirtualAppliance `
                  -NextHopIpAddress "10.102.0.38" `
                  

Set-AzRouteTable -RouteTable $AUERouteTable#>

#ASE Routes

$ASERouteTable | Add-AzRouteConfig -Name "route-to-sn-prd-ase-mgt-utility" `
                  -AddressPrefix 10.103.18.32/27 `
                  -NextHopType "VnetLocal" `
                  
  
$ASERouteTable | Add-AzRouteConfig -Name "route-to-vnet-prd-mgt-network-ase" `
                    -AddressPrefix 10.103.16.0/21 `
                    -NextHopType VirtualAppliance `
                    -NextHopIpAddress "10.103.0.14" `
                    
  
$ASERouteTable | Add-AzRouteConfig -Name "route-via-ew-firewall" `
                    -AddressPrefix 10.0.0.0/8 `
                    -NextHopType VirtualAppliance `
                    -NextHopIpAddress "10.103.0.14" `
                
                    
                    
$ASERouteTable | Add-AzRouteConfig -Name "route-via-NS-firewall" `
                    -AddressPrefix 0.0.0.0/0 `
                    -NextHopType VirtualAppliance `
                    -NextHopIpAddress "10.103.0.38" `
                    
                    
                    
                    
Set-AzRouteTable -RouteTable $ASERouteTable