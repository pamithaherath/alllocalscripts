Select-AzSubscription -SubscriptionName 'NIPD-Management'

$inFile1 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\tenable.csv"
#$inFile2 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules non-prod management\aue\tenableudp.csv"



        $destinationport = $inFile1.DestPort_d
        #$Udestinationport = $inFile2.DestPort_d
     
       
$NSG1 = Get-AzNetworkSecurityGroup -Name "nsg-sn-prd-aue-mgt-tenable" -ResourceGroupName "rg-prd-mgt-network-aue"  



$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow TCP-Ports" -Access Allow `
                        -Protocol "TCP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $destinationport
                        $NSG1 | Set-AzNetworkSecurityGroup
                        
                   

$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Allow-Tenable-Traffic-Between-Subnets" -Access Allow `
                        -Protocol * -Direction Inbound -Priority 2000 -SourceAddressPrefix "10.102.17.160/27" -SourcePortRange * `
                        -DestinationAddressPrefix "10.102.17.160/27" -DestinationPortRange *
                        $NSG1 | Set-AzNetworkSecurityGroup



$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "Deny All" -Access Deny `
                        -Protocol * -Direction Inbound -Priority 3000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
                        -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
                        $NSG1 | Set-AzNetworkSecurityGroup




