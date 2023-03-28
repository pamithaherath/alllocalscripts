[System.Collections.ArrayList]$newvmnames =@()

Select-AzSubscription -SubscriptionName "NINP-SIT"
Import-Excel "C:\Users\pherathmudiy\OneDrive - DXC Production\All downloads\ADHA-Application-Build-Specification-PTE v1.0.xlsx" | ForEach-Object {$newvmnames += $_."VM Name"} 

$sitvms = Get-AzVM

foreach ($vmname in $newvmnames) {
   foreach ($sitvm in $sitvms) {
    if ($sitvm.Name.Contains("pte")) {
       
    
     if ($vmname -ne $sitvm.Name) {
       Write-Host $sitvm.Name
        $newvmnames.Remove($sitvm.Name)
     }
   }
}
}