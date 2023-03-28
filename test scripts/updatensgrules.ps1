#Select-AzSubscription -SubscriptionName 'NINP-Management'

$inFile = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\All downloads\siemsit.csv"
$p =1000 
#$NSG1 = Get-AzNetworkSecurityGroup -Name "nsg-sn-npp-auc1-mgt-siemsit" -ResourceGroupName "rg-npp-mgt-network-auc1-001"  


for ($i = 0; $i -le 17; $i++) {
        $destinationport = $inFile.DestPort_d[$i]
        $l7protocol = $inFile.L7Protocol_s[$i]
        $l4protocol = $inFile.L4Protocol_s[$i]

        if ($l4protocol -eq "T") 
        {
                $protocol = "TCP"
                $tcpports = @($destinationport)
        }
        else 
        {
                $protocol = "UDP"
                $udpports = @($destinationport)
        }


       
                <# if ($l7protocol -eq "Unknown") 
                      {

                        $rulename = "Allow Port $destinationport"
                        $NSG1 | Add-AzNetworkSecurityRuleConfig -Name $rulename -Access Allow `
                        -Protocol $protocol -Direction Inbound -Priority $p -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $destinationport
                        $NSG1 | Set-AzNetworkSecurityGroup
                        
                      }

                      else 
                      {
                        $NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow Port $l7protocol" -Access Allow `
                        -Protocol $protocol -Direction Inbound -Priority $p -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $destinationport
                        $NSG1 | Set-AzNetworkSecurityGroup
                        
                      }#>

                       $p = $p + 1
                
               
        
}

Write-Host $tcpports


