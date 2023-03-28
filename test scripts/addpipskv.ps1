#$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT","NINP-PERF2"
$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"

$ips = @("3.104.252.91/32","13.54.241.27/32","13.211.100.18/32","13.239.110.68/32","52.62.194.176/32","52.62.231.151/32","13.77.50.99/32")

foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname

    $kvs = Get-AzKeyVault

 
       foreach ($kv in $kvs) 
    {
       Add-Content -Path "C:\Users\pherathmudiy\OneDrive - DXC Production\Desktop\prdkvs.txt" -Value $kv.VaultName

        foreach ($ip in $ips)
        {
        # Add-AzKeyVaultNetworkRule -VaultName $kv.VaultName  -IpAddressRange $ip
       #  Write-Host "$ip has been added!" -ForegroundColor Green 
        }
    }
   


}

