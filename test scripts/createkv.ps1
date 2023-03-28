$scopedSubscriptions = "GSU POC Automation Sandbox","GSU POC Databox","GSU POC Online","GSU POC Platform"

foreach ($sub in $scopedSubscriptions) {
    Select-AzSubscription -SubscriptionName $sub
    
    $getsub = Get-AzSubscription -SubscriptionName $sub
    $kvname = "palapp$($getsub.SubscriptionId.Substring(0,4))"
    Write-Host $kvname
    New-AzResourceGroup -Name $kvname -Location "australia East"
    New-AzKeyVault -VaultName $kvname -ResourceGroupName $kvname -Location 'australia East'

}