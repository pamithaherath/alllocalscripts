$scopedSubscriptions = "NINP-AppTools","NINP-Connectivity","NINP-DEV","NINP-Identity","NINP-Management","NINP-PERF","NINP-Sandbox","NINP-SIT","NINP-SVT"
#$scopedSubscriptions = "NINP-Management","NINP-SIT"
#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"



foreach ($subname in $scopedSubscriptions)
{
    Select-AzSubscription -SubscriptionName $subname
    $vnets = (Get-AzVirtualNetwork)
    foreach ($vnet in $vnets) {
    
        $vnetRegion = $vnet.Location.ToString()

        if ($vnetRegion -eq "australiacentral" -or $vnetRegion -eq "australiacentral2" ) 
        { 
           $subnets = ($vnet.Subnets)
                foreach($subnet in $subnets)
                {
                   #$ipadd = (get-aznetwo)
                                  
                  $RG = $vnet.ResourceGroupName
                if ($subnet.IpConfigurations.Count -eq 0) 
                   {
                    Write-Host $vnet.Name "can deleted" -ForegroundColor Green 
                    Remove-AzVirtualNetwork -Name $vnet.Name -ResourceGroupName $RG -Force
                    #Write-Host $subnet.IpAllocations.Count -ForegroundColor Green 
                    #Write-Host $subnet.IpConoString()figurations.Name.T "can deleted" -ForegroundColor Green 
                    Break
                   }

                   else
                   {
   
                       Write-Host $vnet.Name "can't be deleted" -ForegroundColor Blue 
                       #Write-Host $subnet.IpAllocations.Count -ForegroundColor Blue
                       Break
                   }
                }
               


        
            }
    }
}

        #$vnetname = $vnet.Name | Select Name
    
      <#  $vnetRegion = $vnet.Location.ToString()
        $vnetRGname = $vnet.ResourceGroupName
        if (($vnetname -eq $null) -and ($vnetRegion -eq "australiacentral" -or $vnetRegion -eq "australiacentral2"))
         {
            
                #Write-Host $vnet.Name "in" $vnetRegion "is deleting..." -ForegroundColor Blue
                #Remove-AzRouteTable -ResourceGroupName $vnetRGname -Name $vnet.Name  -Force
                #Write-Host $vnet.Name $vnetRegion "is deleted!!" -ForegroundColor Green
                Write-Host $vnet.Name "is in" $vnetRegion -ForegroundColor Blue 
           }
            
        }#>

 

