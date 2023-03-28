Select-AzSubscription -SubscriptionName 'NIPD-Management'

$NSGs =  Get-AzNetworkSecurityGroup -ResourceGroupName "rg-prd-mgt-network-aue"

foreach ($NSG in $NSGs) {
   Remove-AzNetworkSecurityRuleConfig -Name "Allow TCP-Ports" -NetworkSecurityGroup $NSG
    $NSG | Set-AzNetworkSecurityGroup
    Remove-AzNetworkSecurityRuleConfig -Name "Allow UDP-Ports" -NetworkSecurityGroup $NSG
    $NSG | Set-AzNetworkSecurityGroup
    Remove-AzNetworkSecurityRuleConfig -Name "Allow RPC" -NetworkSecurityGroup $NSG 
    $NSG | Set-AzNetworkSecurityGroup
    Remove-AzNetworkSecurityRuleConfig -Name "Deny All" -NetworkSecurityGroup $NSG
    $NSG | Set-AzNetworkSecurityGroup
    Remove-AzNetworkSecurityRuleConfig -Name "Deny-All" -NetworkSecurityGroup $NSG
    $NSG | Set-AzNetworkSecurityGroup
    Write-Host $NSG.Name
      
}





