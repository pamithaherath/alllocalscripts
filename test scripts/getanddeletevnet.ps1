$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"




foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname

    $vnets = Get-AzVirtualNetwork

    foreach($vnet in $vnets)
    {
           if($vnet.Location -eq "australiacentral")

           {
            Write-Host $vnet.Name "Deleting" -ForegroundColor Red
            Remove-AzVirtualNetwork -Name $vnet.Name -ResourceGroupName $vnet.ResourceGroupName -Force
            Write-Host $vnet.Name "Deleted" -ForegroundColor Green
            
           }

    }
}