Select-AzSubscription -SubscriptionName "NINP-PERF2"

 #Define Variables******"
$VNETName           = "vnet-pf2-workload-aue-001"
$MGTVNETName        = "vnet-pf2-managed-service-ase-001"
$Location           = "australiaeast"
$mgtlocation        = "australiasoutheast"
$RGName             = "rg-pf2-network-aue-001"
$MGTRGName          = "rg-npp-pf2-managed-service-ase"
$pfbaddspace        = "10.98.72.0/21"
$mgtaddspace        = "10.99.7.64/26"
$ewfwip             = "10.98.0.14"
$nsfwip             = "10.98.0.38"
$webports = 7,22,80,81,82,389,443,444,636,639,686,1521,1527,3060,3131,3872,3873,3874,4443,4444,4445,4446,4447,4448,4848,4899,4900,4901,5162,5556,5557,5575,5800,6700,6701,6707,7000,7001,7006,7008,7009,7012,7013,7101,7102,7103,7104,7199,7201,7270,7272,7273,7450,7499,7500,7501,7777,7778,7890,8001,8002,8044,8080,8090,8101,8102,8180,8181,8280,8281,8282,8443,8444,8834,9000,9100,9160,9703,9704,9804,11211,14000,14001,14100,14101,14942,14943,18089,19000,19013,19043,19080,19999,28002,30000,30100,35080,61616
$appports = 7,22,80,81,82,389,443,444,636,639,686,1521,1527,3060,3131,3872,3873,3874,4443,4444,4445,4446,4447,4448,4848,4899,4900,4901,5162,5556,5557,5575,5800,6700,6701,6707,7000,7001,7006,7008,7009,7012,7013,7101,7102,7103,7104,7199,7201,7270,7272,7273,7450,7499,7500,7501,7777,7778,7890,8001,8002,8044,8080,8090,8101,8102,8180,8181,8280,8281,8282,8443,8444,8834,9000,9100,9160,9703,9704,9804,11211,14000,14001,14100,14101,14942,14943,18089,19000,19013,19043,19080,19999,28002,30000,30100,35080,61616

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

    

$pfbweb = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-web"
    rtname   = "rt-sn-pfb-aue-pf2-web"
    nsgname  = "nsg-sn-pfb-aue-pf2-web"
    CIDR     = "10.98.72.0/24"

}

$pfbapp = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-app"
    rtname   = "rt-sn-pfb-aue-pf2-app"
    nsgname  = "nsg-sn-pfb-aue-pf2-app"
    CIDR     = "10.98.73.0/24"
}

$pfbdatabase = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-database"
    rtname   = "rt-sn-pfb-aue-pf2-database"
    nsgname  = "nsg-sn-pfb-aue-pf2-database"
    CIDR     = "10.98.74.0/26"
}

$f5mgmt = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-f5-mgmt"
    rtname   = "rt-sn-pfb-aue-pf2-f5-mgmt"
    nsgname  = "nsg-sn-pfb-aue-pf2-f5-mgmt"
    CIDR     = "10.98.74.128/28"
}

$f5bcked_web = [PSCustomObject]@{
    snetname ="sn-pfb-aue-pf2-lb-backend_web"
    rtname   = "rt-sn-pfb-aue-pf2-lb-backend_web"
    nsgname  = "nsg-sn-pfb-aue-pf2-lb-backend_web"
    CIDR     = "10.98.74.144/28"
    
}

$f5bcked_app = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-lb-backend_app"
    rtname   = "rt-pfb-aue-pf2-lb-backend_app"
    nsgname  = "nsg-pfb-aue-pf2-lb-backend_app"
    CIDR     = "10.98.74.160/28"
    
}

$f5externalvirtualsvrs = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-lb-external"
    rtname   = "rt-sn-pfb-aue-pf2-lb-external"
    nsgname  = "nsg-sn-pfb-aue-pf2-lb-external"
    CIDR     = "10.98.75.0/25"
}

$f5internalvirtualsvrs = [PSCustomObject]@{
    snetname = "sn-pfb-aue-pf2-lb-internal"
    rtname   = "rt-sn-pfb-aue-pf2-lb-internal"
    nsgname  = "nsg-sn-pfb-aue-pf2-lb-internal"
    CIDR     = "10.98.76.0/24"
  
}
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "Starting..............." 
Write-Host "`n"
Write-Host "`n"
Write-Host "#####################################################################################################################################################"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                   CREATE VNET IN PERF2!                                                                           #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#####################################################################################################################################################"
Write-Host "`n"
Write-Host "`n"
Write-Host "Creating UDRs...."


$pfbwebudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($f5bcked_app.snetname)" -AddressPrefix $f5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($f5externalvirtualsvrs.snetname)" -AddressPrefix $f5externalvirtualsvrs.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$($f5internalvirtualsvrs.snetname)" -AddressPrefix $f5internalvirtualsvrs.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.135"
    UDR4 = New-AzRouteConfig -Name "route-to-$($pfbapp.snetname)" -AddressPrefix $pfbapp.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.135"
    UDR5 = New-AzRouteConfig -Name "route-to-$($pfbweb.snetname)" -AddressPrefix $pfbweb.CIDR -NextHopType "VnetLocal"
    UDR6 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR7 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR8 = New-AzRouteConfig -Name "route-via-f5-appliance" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress "10.98.42.148"
}

$pfbappudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($f5bcked_app.snetname)" -AddressPrefix $f5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($f5internalvirtualsvrs.snetname)" -AddressPrefix $f5internalvirtualsvrs.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.151"
    UDR3 = New-AzRouteConfig -Name "route-to-$($pfbapp.snetname)" -AddressPrefix $pfbapp.CIDR -NextHopType "VnetLocal"
    UDR4 = New-AzRouteConfig -Name "route-to-$($pfbdatabase.snetname)" -AddressPrefix $pfbdatabase.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.151"
    UDR5 = New-AzRouteConfig -Name "route-to-$($pfbweb.snetname)" -AddressPrefix $pfbweb.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.151"
    UDR6 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR7 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR8 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
    }

$pfbdatabaseudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($pfbapp.snetname)" -AddressPrefix $pfbapp.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.167"
    UDR2 = New-AzRouteConfig -Name "route-to-$($pfbdatabase.snetname)" -AddressPrefix $pfbdatabase.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR5 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip

}

$f5mgmtudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($f5mgmt.snetname)" -AddressPrefix $f5mgmt.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip

}

$f5bcked_webudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($pfbweb.snetname)" -AddressPrefix $pfbweb.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip

}

$f5bcked_appudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($pfbweb.snetname)" -AddressPrefix $pfbweb.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($f5bcked_app.snetname)" -AddressPrefix $f5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip

}

 $f5externalvirtualsvrsudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR2 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip

}

$f5internalvirtualsvrsudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($pfbweb.snetname)" -AddressPrefix $pfbweb.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.135"
    UDR2 = New-AzRouteConfig -Name "route-to-$VNETName" -AddressPrefix $pfbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-to-null" -AddressPrefix "0.0.0.0/0" -NextHopType "None"
}


$chkRG = Get-AzResourceGroup -ResourceGroupName $RGName -ErrorVariable notP -ErrorAction SilentlyContinue 


if($notP)
{
    Write-Host "Resource Group $RGName is creating...." -ForegroundColor Red 
    New-AzResourceGroup -Name $RGName -Location $Location 
    Write-Host "Resource Group $RGName is created...." -ForegroundColor Green
}
else 
{
    Write-Host "Resource Group $RGName is available" 
    $chkRG | Out-Null
}


Write-Host "Creating Routetables!!" 
$RTs = [PSCustomObject]@{

RT1 = New-AzRouteTable -Name $pfbweb.rtname  -ResourceGroupName $RGName -Location $Location -Route $pfbwebudrs.UDR1, $pfbwebudrs.UDR2, $pfbwebudrs.UDR3, $pfbwebudrs.UDR4, $pfbwebudrs.UDR5, $pfbwebudrs.UDR6, $pfbwebudrs.UDR7, $pfbwebudrs.UDR8
RT2 = New-AzRouteTable -Name $pfbapp.rtname  -ResourceGroupName $RGName -Location $Location -Route $pfbappudrs.UDR1, $pfbappudrs.UDR2, $pfbappudrs.UDR3, $pfbappudrs.UDR4, $pfbappudrs.UDR5, $pfbappudrs.UDR6, $pfbappudrs.UDR7, $pfbappudrs.UDR8
RT3 = New-AzRouteTable -Name $pfbdatabase.rtname  -ResourceGroupName $RGName -Location $Location -Route $pfbdatabaseudrs.UDR1, $pfbdatabaseudrs.UDR2, $pfbdatabaseudrs.UDR3, $pfbdatabaseudrs.UDR4, $pfbdatabaseudrs.UDR5
RT4 = New-AzRouteTable -Name $f5mgmt.rtname  -ResourceGroupName $RGName -Location $Location -Route $f5mgmtudrs.UDR1, $f5mgmtudrs.UDR2, $f5mgmtudrs.UDR3, $f5mgmtudrs.UDR4
RT5 = New-AzRouteTable -Name $f5bcked_web.rtname  -ResourceGroupName $RGName -Location $Location -Route $f5bcked_webudrs.UDR1, $f5bcked_webudrs.UDR2, $f5bcked_webudrs.UDR3
RT6 = New-AzRouteTable -Name $f5bcked_app.rtname  -ResourceGroupName $RGName -Location $Location -Route $f5bcked_appudrs.UDR1, $f5bcked_appudrs.UDR2, $f5bcked_appudrs.UDR3, $f5bcked_appudrs.UDR4
RT7 = New-AzRouteTable -Name $f5externalvirtualsvrs.rtname  -ResourceGroupName $RGName -Location $Location -Route $f5externalvirtualsvrsudrs.UDR1, $f5externalvirtualsvrsudrs.UDR2
RT8 = New-AzRouteTable -Name $f5internalvirtualsvrs.rtname  -ResourceGroupName $RGName -Location $Location -Route  $f5internalvirtualsvrsudrs.UDR1, $f5internalvirtualsvrsudrs.UDR2, $f5internalvirtualsvrsudrs.UDR3, $f5internalvirtualsvrsudrs.UDR4

}

Write-Host "Creating NSGs!!"
 $NSG1 = New-AzNetworkSecurityGroup -Name $pfbweb.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG2 = New-AzNetworkSecurityGroup -Name $pfbapp.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG3 = New-AzNetworkSecurityGroup -Name $pfbdatabase.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG4 = New-AzNetworkSecurityGroup -Name $f5mgmt.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG5 = New-AzNetworkSecurityGroup -Name $f5bcked_web.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG6 = New-AzNetworkSecurityGroup -Name $f5bcked_app.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG7 = New-AzNetworkSecurityGroup -Name $f5externalvirtualsvrs.nsgname -ResourceGroupName $RGName -Location  $Location
 $NSG8 = New-AzNetworkSecurityGroup -Name $f5internalvirtualsvrs.nsgname -ResourceGroupName $RGName -Location  $Location

#adding nsg-sn-pfb-aue-pf2-web nsg rules
 $NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
 -Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
 -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $webports
$NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrWindowsInBound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 445,3389
$NSG1 | Set-AzNetworkSecurityGroup



$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1003 -SourceAddressPrefix $pfbweb.CIDR -SourcePortRange * `
-DestinationAddressPrefix $pfbweb.CIDR -DestinationPortRange *
$NSG1 | Set-AzNetworkSecurityGroup


$NSG1 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG1 | Set-AzNetworkSecurityGroup

#adding nsg-sn-pfb-aue-pf2-app nsg rules
$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
 -Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
 -DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$NSG2 | Set-AzNetworkSecurityGroup


$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $appports
$NSG2 | Set-AzNetworkSecurityGroup


$NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrWindowsInBound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 445,3389
$NSG2 | Set-AzNetworkSecurityGroup




                    $vnet = @{
                        Name = $VNETName
                        ResourceGroupName = $RGName
                        Location = $Location
                        AddressPrefix = $pfbaddspace 
                        DNSServer = "10.98.8.4","10.98.8.5"
                          
                    }
                    $virtualNetwork = New-AzVirtualNetwork @vnet 
                   
                    $subnet = @{
                        Name = $pfbweb.snetname
                        AddressPrefix = $pfbweb.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT1
                        NetworkSecurityGroup = $NSG1
                                             
                    }
                    
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet  
                    
                   $subnet = @{
                        Name = $pfbapp.snetname
                        AddressPrefix = $pfbapp.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT2
                        NetworkSecurityGroup = $NSG2

                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet  
                    
                    $subnet = @{
                        Name = $pfbdatabase.snetname
                        AddressPrefix = $pfbdatabase.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT3
                        NetworkSecurityGroup = $NSG3
                                             
                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet  
                    
                   $subnet = @{
                        Name = $f5mgmt.snetname
                        AddressPrefix = $f5mgmt.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT4
                        NetworkSecurityGroup = $NSG4

                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet  
                    
                    

                    $subnet = @{
                        Name = $f5bcked_web.snetname
                        AddressPrefix = $f5bcked_web.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT5
                        NetworkSecurityGroup = $NSG5

                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet  
                   

                    $subnet = @{
                        Name = $f5bcked_app.snetname
                        AddressPrefix = $f5bcked_app.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT6
                        NetworkSecurityGroup = $NSG6
                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet  
                    

                   $subnet = @{
                        Name = $f5externalvirtualsvrs.snetname
                        AddressPrefix = $f5externalvirtualsvrs.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT7
                        NetworkSecurityGroup = $NSG7

                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet 
                   

                    $subnet = @{
                        Name = $f5internalvirtualsvrs.snetname
                        AddressPrefix = $f5internalvirtualsvrs.CIDR
                        VirtualNetwork = $virtualNetwork
                        RouteTable = $RTs.RT8
                        NetworkSecurityGroup = $NSG8

                    }
                    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet 
                    $virtualNetwork | Set-AzVirtualNetwork

                    
##Create Vnet peerings
Select-AzSubscription -SubscriptionName "NINP-Connectivity"
$HUBVNET    = Get-AzVirtualNetwork -Name "vnet-npp-con-hub-aue-001" -ResourceGroupName "rg-npp-con-networkhub-aue" 
Select-AzSubscription -SubscriptionName "NINP-Management"
$NetappVnet = Get-AzVirtualNetwork -Name "vnet-npp-mgt-aue-002" -ResourceGroupName "rg-npp-mgt-network-aue-001"



Write-Host "Peering Started"
Select-AzSubscription -SubscriptionName "NINP-PERF2"
Add-AzVirtualNetworkPeering `
  -Name spoke-to-$($HubVNET.Name.ToString()) `
  -VirtualNetwork $virtualNetwork `
  -RemoteVirtualNetworkId $HUBVNET.Id | Out-Null

  Select-AzSubscription -SubscriptionName "NINP-Connectivity"
Add-AzVirtualNetworkPeering `
  -Name Hub-to-$VNETName `
  -VirtualNetwork $HUBVNET `
  -RemoteVirtualNetworkId $virtualNetwork.Id 
  


  Write-Host "Peering Between Hub completed"

  Select-AzSubscription -SubscriptionName "NINP-PERF2"
Add-AzVirtualNetworkPeering `
  -Name peer-to-$($NetappVnet.Name.ToString()) `
  -VirtualNetwork $virtualNetwork `
  -RemoteVirtualNetworkId $NetappVnet.Id | Out-Null

  Select-AzSubscription -SubscriptionName "NINP-Management"
Add-AzVirtualNetworkPeering `
  -Name peer-to-$VNETName `
  -VirtualNetwork $NetappVnet `
  -RemoteVirtualNetworkId $virtualNetwork.Id | Out-Null
  Write-Host "Peering Between Netapp Vnet completed"
Write-Host "Peering Completed"



Select-AzSubscription -SubscriptionName "NINP-PERF2"

Write-Host "#####################################################################################################################################################"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                   CREATE MANAGE SERVICES VNET IN PERF2!                                                           #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#####################################################################################################################################################"


$asefahb = [PSCustomObject]@{
    snetname = "sn-pf2-ase-fa-hb"
    rtname   = "rt-sn-pf2-ase-fa-hb"
    nsgname  = "nsg-sn-pf2-ase-fa-hb"
    CIDR     = "10.99.7.64/28"
}

$asefametrics = [PSCustomObject]@{
    snetname = "sn-pf2-ase-fa-matrics"
    rtname   = "rt-sn-pf2-ase-fa-matrics"
    nsgname  = "nsg-sn-pf2-ase-fa-matrics"
    CIDR     = "10.99.7.80/28"
}

$asefasnow = [PSCustomObject]@{
    snetname = "sn-pf2-ase-fa-snow"
    rtname   = "rt-sn-pf2-ase-fa-snow"
    nsgname  = "nsg-sn-pf2-ase-fa-snow"
    CIDR     = "10.99.7.96/28"
}


$chkRG = Get-AzResourceGroup -ResourceGroupName $MGTRGName  -ErrorVariable notP -ErrorAction SilentlyContinue 


if($notP)
{
    Write-Host "Resource Group $MGTRGName  is creating...." -ForegroundColor Red 
    New-AzResourceGroup -Name $MGTRGName  -Location $mgtlocation
    Write-Host "Resource Group $MGTRGName  is created...." -ForegroundColor Green
}
else 
{
    Write-Host "Resource Group $MGTRGName  is available" 
    $chkRG | Out-Null
}

Write-Host "Creating Routetables!!" 
$MGTRTs = [PSCustomObject]@{

    RT1 = New-AzRouteTable -Name $asefahb.rtname  -ResourceGroupName $MGTRGName -Location $mgtlocation
    RT2 = New-AzRouteTable -Name $asefametrics.rtname  -ResourceGroupName $MGTRGName -Location $mgtlocation
    RT3 = New-AzRouteTable -Name $asefasnow.rtname  -ResourceGroupName $MGTRGName -Location $mgtlocation
}

Write-Host "Creating NSGs!!"
 $ASENSG1 = New-AzNetworkSecurityGroup -Name $asefahb.nsgname -ResourceGroupName $MGTRGName -Location  $mgtlocation
 $ASENSG2 = New-AzNetworkSecurityGroup -Name $asefametrics.nsgname -ResourceGroupName $MGTRGName -Location  $mgtlocation
 $ASENSG3 = New-AzNetworkSecurityGroup -Name $asefasnow.nsgname -ResourceGroupName $MGTRGName -Location  $mgtlocation


 $mgtvnet = @{
    Name = $MGTVNETName
    ResourceGroupName = $MGTRGName 
    Location = $mgtlocation
    AddressPrefix = $mgtaddspace
          
}
$mgtvirtualNetwork = New-AzVirtualNetwork @mgtvnet
$mgtvirtualNetwork | Out-Null

$subnet = @{
    Name = $asefahb.snetname
    AddressPrefix = $asefahb.CIDR
    VirtualNetwork = $mgtvirtualNetwork
    RouteTable = $MGTRTs.RT1
    NetworkSecurityGroup = $ASENSG1

}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet | Out-Null


$subnet = @{
    Name = $asefametrics.snetname
    AddressPrefix = $asefametrics.CIDR
    VirtualNetwork = $mgtvirtualNetwork
    RouteTable = $MGTRTs.RT2
    NetworkSecurityGroup = $ASENSG2

}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet | Out-Null


$subnet = @{
    Name = $asefasnow.snetname
    AddressPrefix = $asefasnow.CIDR
    VirtualNetwork = $mgtvirtualNetwork
    RouteTable = $MGTRTs.RT3
    NetworkSecurityGroup = $ASENSG3

}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet | Out-Null
$mgtvirtualNetwork | Set-AzVirtualNetwork
Write-Host $stopwatch.Elapsed