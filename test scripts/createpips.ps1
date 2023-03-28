<#Select-AzSubscription -SubscriptionName "NINP-Connectivity"
$rgName="rg-npp-con-northsouth-ase-001"
$location = "australiaeast"

for ($i = 186; $i -ne 194 ; $i++) {
    
    New-AzPublicIpAddress -Name "pip-npp-con-ns-ase-$i" -ResourceGroupName $rgName -AllocationMethod Static -Location $location | Out-Null
    Write-Host "pip-npp-con-ns-ase- $i Created"
}#>
Select-AzSubscription -SubscriptionName "NINP-CTV"
Remove-AzResourceGroup -Name "rg-ctb-network-aue-001" -Force
Remove-AzResourceGroup -Name "rg-cta-network-ase-001" -Force
Remove-AzResourceGroup -Name "rg-npp-ctv-managed-service-ase" -Force
