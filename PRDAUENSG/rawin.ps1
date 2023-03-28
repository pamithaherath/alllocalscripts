Select-AzSubscription -SubscriptionName 'NIPD-Management'

$inFile1 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\rawin RPC.csv"
$inFile2 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\rawinudp.csv"



        $destinationport = $inFile1.DestPort_d
        $Udestinationport = $inFile2.DestPort_d
     
       
$NSG1 = Get-AzNetworkSecurityGroup -Name "nsg-sn-prd-aue-mgt-ra-win" -ResourceGroupName "rg-prd-mgt-network-aue"  



$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow TCP-Ports" -Access Allow `
                        -Protocol "TCP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $destinationport
                        $NSG1 | Set-AzNetworkSecurityGroup
                          

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow UDP-Ports" -Access Allow `
                        -Protocol "UDP" -Direction Inbound -Priority 2000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $Udestinationport
                        $NSG1 | Set-AzNetworkSecurityGroup

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow RPC" -Access Allow `
                        -Protocol * -Direction Inbound -Priority 3000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange "49152-65535"
                        $NSG1 | Set-AzNetworkSecurityGroup

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Deny All" -Access Deny `
                        -Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
                        $NSG1 | Set-AzNetworkSecurityGroup

Select-AzSubscription -SubscriptionName 'NIPD-Management'
$NSG1 = Get-AzNetworkSecurityGroup -Name "nsg-sn-prd-aue-mgt-ra-win" -ResourceGroupName "rg-prd-mgt-network-aue"  

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "All All Traffic" -Access Allow `
                        -Protocol * -Direction Inbound -Priority 3010 -SourceAddressPrefix "10.98.16.0/27" -SourcePortRange * `
                        -DestinationAddressPrefix "10.98.16.0/27" -DestinationPortRange *
                        $NSG1 | Set-AzNetworkSecurityGroup




