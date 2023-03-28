
$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"

$LockName = "DXC-Automation-RG-Lock"


foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
$RGs = Get-AzResourceGroup

ForEach ($RG in $RGs)
{
 
    
      #If (($RG.ResourceGroupName.StartsWith('rg-npp')) -OR ($RG.ResourceGroupName.StartsWith('rg-ninp')) -AND $RG.Location -eq "australiaeast")
      If($RG.location -eq "australiacentral")
      {
        
         Write-Host "Removing Resource Lock for Resource Group..." $RG.ResourceGroupname "and" $RG.Location
         Remove-AzResourceLock `
         -LockName $LockName `
         -ResourceGroupName $RG.ResourceGroupName `
         -Force
       
         
      }
}

}