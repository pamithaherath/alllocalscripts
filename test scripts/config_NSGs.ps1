
$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"

foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $vnets = (Get-AzVirtualNetwork)
    $AllNSGs = (Get-AzNetworkSecurityGroup)
    foreach ($vnet in $vnets) {
    foreach ($subnet in $vnet.Subnets) {

                 $RGVNET =   $vnet.ResourceGroupName
                 $subnetname = $subnet.Name
                 $addpfx = $subnet.AddressPrefix
                 $Location = Get-AzResourceGroup -Name $RGVNET | select-object -expandproperty location
        
        if ($subnet.NetworkSecurityGroup -eq $null) 
        {
            if ($subnet.Name -eq "GatewaySubnet" -or $subnet.Name -eq "AzureBastionSubnet" -or $subnet.Name -eq "AzureFirewallSubnet") 
            {
                Write-Host  "Subscription of " $subname $subnet.Name "is skipped and needs configuring manually" -ForegroundColor Blue
            }
            else
            {

               
                 Write-Host "Subscription of " $subname  $subnetname "ready to assign nsg" -ForegroundColor Gray
                # New-AzNetworkSecurityGroup -Name "nsg-$subnetname" -ResourceGroupName $RGVNET  -Location $RGVNET
                 #$NSG = Get-AzNetworkSecurityGroup -Name "nsg-$subnetname" -ResourceGroupName $RGVNET
                 #Set-AzVirtualNetworkSubnetConfig -Name $subnetname -VirtualNetwork $vnet -AddressPrefix $addpfx -NetworkSecurityGroupId $NSG.Id -Verbose
                 #$vnet | Set-AzVirtualNetwork
             
            }
           

        }
        else
        {

            $RGVNET1 =   $vnet.ResourceGroupName
            $subnetname1 = $subnet.Name
            $NSGname = "nsg-$subnetname1"
            $addpfx1 = $subnet.AddressPrefix
            $Location1 = Get-AzResourceGroup -Name $RGVNET1 | select-object -expandproperty location

            foreach($newnsg in $AllNSGs)
            {
                if ()
                {
              
               }

            }
         
            Write-Host "Subscription of " $subname "Subnet" $subnetname "has NSG" -ForegroundColor Green
        }
        
    }
}

}
