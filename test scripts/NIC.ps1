Select-AzSubscription -SubscriptionName 'NINP-Connectivity'

$nic = Get-AzNetworkInterface -Name "nic-003-apnppconnsfw02" 

foreach ($ipc in $nic.ipConfigurations.name) {
  if ($ipc -ne $null -and $ipc -ne "ipconfig1") {
   $x = remove-aznetworkinterfaceipconfig -name $ipc -networkinterface $nic
    Set-AzNetworkInterface -NetworkInterface $x

  }
   

}