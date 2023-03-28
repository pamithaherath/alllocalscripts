#$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"
$scopedSubscriptions = "NINP-PERF"


$NSG1 = Get-AZNetworkSecurityGroup | Where-Object { $_.NetworkInterfaces.count -eq 0 } | Select-Object name
$NSG2 = Get-AZNetworkSecurityGroup | Where-Object { $_.Subnets.count -eq 0 } | Select-Object name, ResourceGroupName
$i =0
while ($NSG2[$i] -ne $null)
 {
    
    Write-Host $NSG2.Name[$i] $NSGRegion "in" $NSG2.ResourceGroupName[$i] "is deleting..." -ForegroundColor Red
    Remove-AzNetworkSecurityGroup -Name $NSG2.Name[$i] -ResourceGroupName $NSG2.ResourceGroupName[$i] -Force
    Write-Host $NSG2.Name[$i] $NSGRegion "in" $NSG2.ResourceGroupName[$i] "is deleted!!" -ForegroundColor Green
    
    $i++
}

<#
foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $NSGs = (Get-AzNetworkSecurityGroup)
    foreach ($NSG in $NSGs) {
        $subnetname = $NSG.Subnets
        $name = $subnetname.Name
         $NICName = $NSG.NetworkInterfaces
        $NSGRegion = $NSG.Location.ToString()
        $NSGRGname = $NSG.ResourceGroupName
        
        
       #$auc1convnet = vnet-prd-con-hub-auc1

            if ($subnetname.Name -eq $null){ #-and $NICName -eq $null) {
                Write-Host $NSG.Name $NSGRegion "in" $NSGRGname "is deleting..." -ForegroundColor Red
                #Write-Host $subnetname.Name
            }
          
            
          
        

             
                #Remove-AzNetworkSecurityGroup -Name $NSG.Name -ResourceGroupName $NSGRGname -Force
                #Write-Host $NSG.Name $NSGRegion "in" $NSGRGname "is deleted!!" -ForegroundColor Green
            
            
        }

       
   
}#>
