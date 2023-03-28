Select-AzSubscription -SubscriptionName 'NINP-AppTools'
$vm = Get-AzResource -ResourceGroupName "RG-NPP-APT-DOPS-AUE-001" -Name "vmnppaptdoc12"
$RiD =  $vm.ResourceId
 $tag = Get-AzTag -ResourceId $RiD

if($tag.Value -eq "DOC")
{
Write-Host "yes"

}



