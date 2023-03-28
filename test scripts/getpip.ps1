#$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
<#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"

foreach ($sub in $scopedSubscriptions) {
    Select-AzSubscription -SubscriptionName $sub
    $getpip = @(Get-AzPublicIpAddress)

   $i = 0
    while ($getpip[$i] -ne $null) {
        $pipname = $getpip[$i].Name
        $pipRG = $getpip[$i].ResourceGroupName

        if($getpip[$i].Location -eq "australiacentral")

    {

        Write-Host $pipname "of RG $pipRG Will be deleted"
        Remove-AzPublicIpAddress -Name $pipname -ResourceGroupName $pipRG -Force
    }
        
        #Remove-AzNetworkWatcher -Name $pipname -ResourceGroupName "NetworkWatcherRG"
        $i++
    }
    
  
   
        #$FL | Select-Object Name,Location,workspaces | Export-Excel -Path "C:\FL.xlsx" -Append -AutoSize -BoldTopRow
 
    
}#>

Select-AzSubscription -SubscriptionName "NIPD-Management"
$LockName = "DXC-Automation-RG-Lock"
Remove-AzResourceLock `
-LockName $LockName `
-ResourceGroupName "rg-prd-mgt-doa-auc1" `
-Force

$LockName = "DXC-Automation-RG-Lock"
Remove-AzResourceLock `
-LockName $LockName `
-ResourceGroupName "rg-prd-mgt-netapp-auc1" `
-Force
#Select
$vault2 = Get-AzRecoveryServicesVault -ResourceGroupName "rg-prd-mgt-doa-auc1" -Name "rcv-prd-mgt-doa-backup-auc1"

Remove-AzRecoveryServicesVault -Vault $vault2 

$vault3 = Get-AzRecoveryServicesVault -ResourceGroupName "rg-prd-mgt-doa-auc2" -Name "rcv-prd-mgt-doa-backup-auc2"

Remove-AzRecoveryServicesVault -Vault $vault3