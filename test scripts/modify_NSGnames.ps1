
#$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
$scopedSubscriptions = "NINP-DEV","NINP-SIT"
#$scopedSubscriptions = "Visual Studio Enterprise Subscription"

foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $AllNSGs = (Get-AzNetworkSecurityGroup)
    $vnets = (Get-AzVirtualNetwork)
   
    foreach ($NSG in $AllNSGs) {

                 #$RGVNET =   $vnet.ResourceGroupName
                 $NSGname = $NSG.Name
                 #$addpfx = $subnet.AddressPrefix
                 #$Location = Get-AzResourceGroup -Name $RGVNET | select-object -expandproperty location
                 #Write-Host  $NSGname -ForegroundColor Blue
                 $NSGRGname = $NSG.ResourceGroupName
        if ($NSGname -match "databse" ) 
        {
           
           # $NSG = Get-AzNetworkSecurityGroup| Select-Object -Property Name, ResourceGroupname, @{label='Location';expression={$_.Location}}
                Write-Host $NSG.Name $NSGRegion "in" $NSGRGname "is deleting..." -ForegroundColor Red
                Remove-AzNetworkSecurityGroup -Name $NSG.Name -ResourceGroupName $NSGRGname -Force
                Write-Host $NSG.Name $NSGRegion "in" $NSGRGname "is deleted!!" -ForegroundColor Green

                #Write-Host  $NSGname -ForegroundColor Blue
            

        }
        else
        {

            #Write-Host  $NSGname -ForegroundColor Green
         
           #// Write-Host "Subscription of " $subname "Subnet" $subnetname "has NSG" -ForegroundColor Green
        }
        
    }
}

