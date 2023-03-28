
$vmnames =@()
$mgtarray = @()
$svtarray = @()
$perarray = @()
$sitarray = @()
$devarray = @()

$Tags = @{"Application Name"="DXC Oracle Enterprise Manager";"Application Service"="Database"}

Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Copy of VM PDC NP 220929vuln log4J (1).csv" | ForEach-Object {$vmnames += $_.Name} 

foreach ($vmname in $vmnames) {
    if($vmname.Contains("mgt"))
    { 
        $mgtarray += $vmname   
    }
    elseif ($vmname.Contains("svt")) {
        
        $svtarray += $vmname  
    }
    elseif ($vmname.Contains("per")) {
       
        $perarray += $vmname  
    }
    elseif ($vmname.Contains("sit")) {
      
        $sitarray += $vmname  
    }
    else 
    {
        $devarray += $vmname  
    }
   
}

Select-AzSubscription -SubscriptionName "NINP-Management"
foreach ($vmname in $mgtarray) {
  $vmd = Get-AzResource -Name $vmname
  Update-AzTag -ResourceId $vmd.id -Tag $Tags -Operation Merge
}

Select-AzSubscription -SubscriptionName "NINP-SVT"
foreach ($vmname in $svtarray) {
  $vmd = Get-AzResource -Name $vmname
  Update-AzTag -ResourceId $vmd.id -Tag $Tags -Operation Merge
}

Select-AzSubscription -SubscriptionName "NINP-PERF"
foreach ($vmname in $perarray) {
  $vmd = Get-AzResource -Name $vmname
  Update-AzTag -ResourceId $vmd.id -Tag $Tags -Operation Merge
}

Select-AzSubscription -SubscriptionName "NINP-SIT"
foreach ($vmname in $sitarray) {
  $vmd = Get-AzResource -Name $vmname
  Update-AzTag -ResourceId $vmd.id -Tag $Tags -Operation Merge
}

Select-AzSubscription -SubscriptionName "NINP-DEV"
foreach ($vmname in $devarray) {
  $vmd = Get-AzResource -Name $vmname
  Update-AzTag -ResourceId $vmd.id -Tag $Tags -Operation Merge
}