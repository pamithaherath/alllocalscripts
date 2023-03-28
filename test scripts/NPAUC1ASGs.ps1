

$scopedSubscriptions = "NINP-AppTools","NINP-DEV","NINP-Identity","NINP-Sandbox","NINP-PERF","NINP-Connectivity","NINP-SIT","NINP-SVT","NINP-Management"
$Data = ""

foreach ($sub in $scopedSubscriptions) {

    Select-AzSubscription -SubscriptionName $sub
    $asgs = Get-AzApplicationSecurityGroup
     foreach ($asg in $asgs) {

       
        
        $location = $asg.Location
        if ($location -eq "australiacentral")
         {
           
            
        $asg | Select-Object Name,Location,ResourceGroupName | Export-Excel -Path "C:\auc1asg.xlsx" -Append -AutoSize -BoldTopRow

        }
        else {
            
        $asg | Select-Object Name,Location,ResourceGroupName | Export-Excel -Path "C:\otherlocs.xlsx" -Append -AutoSize -BoldTopRow

            
        }
    }
}

