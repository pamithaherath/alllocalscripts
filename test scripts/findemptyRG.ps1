$scopedSubscriptions = "NINP-Management","NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"




foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
$RGs = Get-AzResourceGroup


ForEach ($RG in $RGs)
{
   
    $resorce = Get-AzResource -ResourceGroupName $RG.ResourceGroupName

      If($resorce.Length -ge 1 -and $RG.Location -eq "australiacentral")
      {
       
        Write-Host $RG.ResourceGroupname "Deletion in progress" -ForegroundColor Red
      #$res =  Remove-AzResourceGroup -Name $RG.ResourceGroupname  -Force
       
       #if($res)

       #{
       # Write-Host $RG.ResourceGroupname "Deletion completed" -ForegroundColor Green
       #}
      #else {
       # Write-Error
       #}
      
      }

      
}


}