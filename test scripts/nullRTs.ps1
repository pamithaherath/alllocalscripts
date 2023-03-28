#$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NINP-Management","NINP-SIT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"
$scopedSubscriptions = "NINP-PERF"


$RT1= Get-AzRouteTable | Where-Object { $_.Subnets.count -eq 0 } | Select-Object name, ResourceGroupName
$i =0
while ($RT1[$i] -ne $null)
 {
    
    Write-Host $RT1.Name[$i]  "in" $RT1.ResourceGroupName[$i] "is deleting..." -ForegroundColor Red
    Remove-AzRouteTable -ResourceGroupName $RT1.ResourceGroupName[$i] -Name $RT1.Name[$i] -Force
    Write-Host $RT1.Name[$i] $NSGRegion "in" $RT1.ResourceGroupName[$i] "is deleted!!" -ForegroundColor Green
    
    $i++
}
            
                #Write-Host $RT.Name "in" $RTRegion "is deleting..." -ForegroundColor Blue
                #Remove-AzRouteTable -ResourceGroupName $RTRGname -Name $RT.Name  -Force
                #Write-Host $RT.Name $RTRegion "is deleted!!" -ForegroundColor Green
          