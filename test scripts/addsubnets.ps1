    Select-AzSubscription -SubscriptionName 'NINP-Management'

    $auelocation =  "australiaeast"
    $aselocation =  "australiasoutheast"
    $auesubnet   =  "sn-prd-aue-mgt-utility"
    $asesubnet   =  "sn-prd-ase-mgt-utility"
    $auensg      =  "nsg-sn-prd-aue-mgt-utility"
    $asensg      =  "nsg-sn-prd-ase-mgt-utility"
    $auert       =  "rt-sn-prd-aue-mgt-utility"
    $asert       =  "rt-sn-prd-ase-mgt-utility"
    $auerg       =  "rg-prd-mgt-network-aue"
    $aserg       =  "rg-prd-mgt-network-ase"
    $AUEVN       = Get-AzVirtualNetwork -Name "vnet-prd-mgt-network-aue" -ResourceGroupName $auerg
    $ASEVN       = Get-AzVirtualNetwork -Name "vnet-prd-mgt-network-ase" -ResourceGroupName $aserg



    <#$AUE_NSG = New-AzNetworkSecurityGroup `
                 -Name $auensg  `
                 -ResourceGroupName $auerg `
                 -Location  $auelocation
      
    $AUE_RT = New-AzRouteTable `
                 -Name $auert `
                 -ResourceGroupName $auerg `
                 -location $auelocation#>

    $ASE_NSG = New-AzNetworkSecurityGroup `
                 -Name $asensg  `
                 -ResourceGroupName $aserg `
                 -Location  $aselocation

    $ASE_RT = New-AzRouteTable `
                 -Name $asert `
                 -ResourceGroupName $aserg `
                 -location $aselocation



    
    #Add-AzVirtualNetworkSubnetConfig -Name $auesubnet -VirtualNetwork $AUEVN -AddressPrefix "10.102.18.32/27" -NetworkSecurityGroupId $AUE_NSG.Id -RouteTableId $AUE_RT.Id
    #$AUEVN | Set-AzVirtualNetwork
    Add-AzVirtualNetworkSubnetConfig -Name $asesubnet -VirtualNetwork $ASEVN -AddressPrefix "10.103.18.32/27" -NetworkSecurityGroupId $ASE_NSG.Id -RouteTableId $ASE_RT.Id
    $ASEVN | Set-AzVirtualNetwork



