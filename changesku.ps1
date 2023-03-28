Select-AzSubscription -SubscriptionName "NIPD-PDC"

#


$serverList = get-content "C:\Users\pherathmudiy\OneDrive - DXC Production\Desktop\list.txt"

foreach ($row in $serverList) {

    $serverName = $row.Split("`t ")[0]

    $VM = Get-AzVM -Name $serverName -ResourceGroupName "rg-prd-pdc-app-aue"
    Write-Host $VM.Name "is upgrading" -ForegroundColor Red
    $VM.HardwareProfile.VMsize = 'Standard_D4s_v4'
    Update-AzVM -VM $VM -ResourceGroupName "rg-prd-pdc-app-aue" -NoWait
    Write-Host $VM.Name "upgraded" -ForegroundColor Green

}


<#foreach ($VM in $VMs) 
{
    if ($VM.Name.Contains('vmprdpdcoid')) 
    {
        
        try {
            Write-Host $VM.Name "is upgrading" -ForegroundColor Red
            $VM.HardwareProfile.VMsize = 'Standard_D4s_v4'
            Update-AzVM -VM $VM -ResourceGroupName "rg-prd-pdc-app-aue"
            Write-Host $VM.Name "upgraded" -ForegroundColor Green
        
        }
        catch {
            
            Write-Error $_
        }
        
    }
}#>
