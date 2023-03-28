$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"



foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $Vnets= (Get-AzVirtualNetwork)
    foreach ($Vnet in $Vnets) 
{
    if ($Vnet.Location -eq "australiacentral") 
    {
        $sub1name = $Vnet.Subnets 
       $i = 0
       while ($sub1name[$i] -ne $null) {
       Write-Host "Setting AUC1 subnets to null"
       Set-AzVirtualNetworkSubnetConfig -Name $sub1name[$i].Name -VirtualNetwork $Vnet -AddressPrefix $sub1name[$i].AddressPrefix -NetworkSecurityGroupId $null -RouteTableID $null
        $Vnet | Set-AzVirtualNetwork
        
        #Write-Host $Vnet.Name
       $i++
    }

   
}
}
}