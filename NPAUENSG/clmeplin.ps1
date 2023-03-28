Select-AzSubscription -SubscriptionName 'NINP-Management'

$inFile1 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\clmeplin.csv"
$inFile2 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\clmeplinudp.csv"



        $destinationport = $inFile1.DestPort_d
        $Udestinationport = $inFile2.DestPort_d
     
       
$NSG1 = Get-AzNetworkSecurityGroup -Name "nsg-sn-npp-aue-mgt-clmep-lin" -ResourceGroupName "rg-npp-mgt-network-aue-001"  



$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow TCP-Ports" -Access Allow `
                        -Protocol "TCP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $destinationport
                        $NSG1 | Set-AzNetworkSecurityGroup
                        
                   

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow UDP-Ports" -Access Allow `
                        -Protocol "UDP" -Direction Inbound -Priority 2000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $Udestinationport
                        $NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Deny All" -Access Deny `
                        -Protocol * -Direction Inbound -Priority 3000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange * `
                        $NSG1 | Set-AzNetworkSecurityGroup

Write-Host $destinationport END
Write-Host $Udestinationport