$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"




foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname

    $lbs = Get-AzNetworkInterface

    foreach($lb in $lbs)
    {
           if($lb.Location -eq "australiacentral")

           {
            Write-Host $lb.Name "Deleting" -ForegroundColor Red
            Remove-AzNetworkInterface -Name $lb.Name -ResourceGroupName $lb.ResourceGroupName -Force
            Write-Host $lb.Name "Deleted" -ForegroundColor Green
            
           }

    }
}