Select-AzSubscription -SubscriptionName 'NIPD-SDC'

$serverList = get-content "C:\Users\pherathmudiy\OneDrive - DXC Production\Desktop\SDC.txt"
foreach ($row in $serverList) 
{ $serverName = $row.Split("`t ")[0]

$Vm = Get-AzVM -Name $serverName
$RG = $Vm.ResourceGroupName
#Restart-AzVM -ResourceGroupName $RG -Name $serverName
}

