

for($i=1; $i -le 10; $i++)
{
   

    $ip = @{
        Name = "pip-npp-con-ns-aue-00$i"
        ResourceGroupName = 'rg-dxg'
        Location = 'australiaeast'
        Sku = 'Standard'
        AllocationMethod = 'Static'
        IpAddressVersion = 'IPv4'
        Zone = 1,2,3
    }
    New-AzPublicIpAddress @ip
   
}

$pips = Get-AzPublicIpAddress

#$nic = Get-AzNetworkInterface -name "nic-003-apnppconnsfw01" -ResourceGroupName "rg-dxg"

foreach($pip in $pips)
{
  
   write-host $pip.name
}

#Add-AzNetworkInterfaceIpConfig -Name ipconfig2 -networkinterface $nic -PrivateIpAddress ""