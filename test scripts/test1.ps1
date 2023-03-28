
$serverList = get-content "C:\Users\pherathmudiy\Downloads\PDC App server list.txt"
foreach ($row in $serverList)
 {
$serverName = $row.Split("`t ")[0]
$Vm = Get-AzVM -Name $serverName
$rgName = $Vm.ResourceGroupName
$location = $Vm.Location

$storageType = 'Premium_LRS'
$dataDiskName = "disk-$($serverName)-apps-pcehr"


$diskConfig = New-AzDiskConfig -SkuName $storageType -Location $location -CreateOption Empty -DiskSizeGB 64
$dataDisk1 = New-AzDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $rgName
$Vm = Add-AzVMDataDisk -VM $Vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1
Update-AzVM -VM $Vm -ResourceGroupName $rgName
}