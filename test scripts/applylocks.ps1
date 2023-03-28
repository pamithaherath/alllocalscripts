
$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"

$LockName = "DXC-Automation-RG-Lock"


foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
$RGs = Get-AzResourceGroup

ForEach ($RG in $RGs)
{
 
    
  
      If($RG.location -eq "australiasoutheast")
      {
        
        Write-Host "Applying Resource Lock for Resource Group..." + $RG.ResourceGroupname
         
        New-AzResourceLock `
        -LockName $LockName `
        -LockLevel "CanNotDelete" `
        -LockNotes "Cannot Delete Lock applied on this Resource Group to avoid accidental deletion of all resources from automation resource group" `
        -ResourceGroupName $RG.ResourceGroupName `
        -Force
       
         
      }
}

}