

# -ResourceGroupName MyResourceGroup -Name MyApplicationSecurityGroup1

$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"

foreach ($sub in $scopedSubscriptions) {
    Select-AzSubscription -SubscriptionName $sub
    $getASG = @(Get-AzApplicationSecurityGroup)

   $i = 0
    while ($getASG[$i] -ne $null) {
        $ASGName = $getASG[$i].Name
        $ASGLocation = $getASG[$i].Location
        $ASGRGName   = $getASG[$i].ResourceGroupName
        if ($ASGLocation -eq "australiacentral") 
        {
            Write-Host $ASGName "of Location $ASGLocation of Resource Group $ASGRGName is deleting" -ForegroundColor Red
            Remove-AzApplicationSecurityGroup -Name $ASGName -ResourceGroupName $ASGRGName -Force
            Write-Host $ASGName "of Location $ASGLocation of Resource Group $ASGRGName is deleted" -ForegroundColor Green
        }
        $i++
    }

  
   
        #$FL | Select-Object Name,Location,workspaces | Export-Excel -Path "C:\FL.xlsx" -Append -AutoSize -BoldTopRow
 
    
}