$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"

foreach ($sub in $scopedSubscriptions) {
    Select-AzSubscription -SubscriptionName $sub
    $getNW = @(Get-AzNetworkWatcher -Location "australiacentral")

   $i = 0
    while ($getNW[$i] -ne $null) {
        $NWName = $getNW[$i].Name
        Write-Host $NWName "Will be deleted"
        Remove-AzNetworkWatcher -Name $NWName -ResourceGroupName "NetworkWatcherRG"
        $i++
    }

  
   
        #$FL | Select-Object Name,Location,workspaces | Export-Excel -Path "C:\FL.xlsx" -Append -AutoSize -BoldTopRow
 
    
}

<#foreach ($sub in $scopedSubscriptions) {
    Select-AzSubscription -SubscriptionName $sub
    $getNW = @(Get-AzNetworkInterface)

   $i = 0
    while ($getNW[$i] -ne $null) {
        $NWName = $getNW[$i].Name
        $NILocation = $getNW[$i].Location
        if ($NILocation -eq "australiacentral") 
        {
            Write-Host $NWName "of Location $NILocation  Will be deleted"
        }

    
       
        #Remove-AzNetworkWatcher -Name $NWName -ResourceGroupName "NetworkWatcherRG"
        $i++
    }

  Write-Host $i
   
        #$FL | Select-Object Name,Location,workspaces | Export-Excel -Path "C:\FL.xlsx" -Append -AutoSize -BoldTopRow
 
    
}#>



