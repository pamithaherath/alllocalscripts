#$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"
#$scopedSubscriptions = "NINP-Management","NINP-SIT"



foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $Vnets = (Get-AzVirtualNetwork)

    foreach ($vnet in $Vnets) {
       if($vnet.Location.ToString() -eq "australiacentral")
       {
          Write-Host $Vnet.
                 
       }
    }

}