#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"
$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"



foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $RTs = (Get-AzRouteTable)
    foreach ($RT in $RTs) {

        $RTRegion = $RT.Location.ToString()
        $RTRGname = $RT.ResourceGroupName
        
       #$auc1convnet = vnet-prd-con-hub-auc1
        if ($RTRegion -eq "australiacentral")
         {
            Write-Host $RT.Name $RTRegion "in" $RTRGname "is deleting..." -ForegroundColor Red
            Remove-AzRouteTable -ResourceGroupName $RTRGname -Name $RT.Name -Force
            Write-Host $RT.Name $RTRegion "in" $RTRGname "is deleted!..." -ForegroundColor Green
         }

        }
}



