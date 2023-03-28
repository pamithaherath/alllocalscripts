#This script will create fresh vnets on NINP-CTV subscription

Select-AzSubscription -SubscriptionName "NINP-CTV"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "Starting..............." 
Write-Host "#####################################################################################################################################################"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                   CREATE NINP-CTV NETWORK RESOURCES IN AUEAST and AU SOUTH EAST                                   #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#####################################################################################################################################################"
Write-Host "`n"
Write-Host "`n"

 #Define Variables******"
$AUEVNETName        = "vnet-ctb-workload-aue-001"
$ASEVNETName        = "vnet-cta-workload-ase-001"
$MGTVNETName        = "vnet-ctv-managed-service-ase-001"
$AUELocation        = "australiaeast"
$ASELocation        = "australiasoutheast"
$MGTlocation        = "australiasoutheast"
$AUERGName          = "rg-ctb-network-aue-001"
$ASERGName          = "rg-cta-network-ase-001"
$MGTRGName          = "rg-npp-ctv-managed-service-ase"
$ctbaddspace        = "10.98.80.0/21"
$ctaaddspace        = "10.99.80.0/21"
$mgtaddspace        = "10.99.6.64/26"
$ewfwip             = "10.98.0.14"
$nsfwip             = "10.98.0.38"
$webports = 7,22,80,81,82,389,443,444,636,639,686,1521,1527,3060,3131,3872,3873,3874,4443,4444,4445,4446,4447,4448,4848,4899,4900,4901,5162,5556,5557,5575,5800,6700,6701,6707,7000,7001,7006,7008,7009,7012,7013,7101,7102,7103,7104,7199,7201,7270,7272,7273,7450,7499,7500,7501,7777,7778,7890,8001,8002,8044,8080,8090,8101,8102,8180,8181,8280,8281,8282,8443,8444,8834,9000,9100,9160,9703,9704,9804,11211,14000,14001,14100,14101,14942,14943,18089,19000,19013,19043,19080,19999,28002,30000,30100,35080,61616
$appports = 7,22,80,81,82,389,443,444,636,639,686,1521,1527,3060,3131,3872,3873,3874,4443,4444,4445,4446,4447,4448,4848,4899,4900,4901,5162,5556,5557,5575,5800,6700,6701,6707,7000,7001,7006,7008,7009,7012,7013,7101,7102,7103,7104,7199,7201,7270,7272,7273,7450,7499,7500,7501,7777,7778,7890,8001,8002,8044,8080,8090,8101,8102,8180,8181,8280,8281,8282,8443,8444,8834,9000,9100,9160,9703,9704,9804,11211,14000,14001,14100,14101,14942,14943,18089,19000,19013,19043,19080,19999,28002,30000,30100,35080,61616

#Creating CTA subnet objects in AU East

$ctbweb = [PSCustomObject]@{
    snetname = "sn-ctb-aue-ctv-web"
    rtname   = "rt-sn-ctb-aue-ctv-web"
    nsgname  = "nsg-sn-ctb-aue-ctv-web"
    CIDR     = "10.98.80.0/24"
}

$ctbapp = [PSCustomObject]@{
    snetname = "sn-ctb-aue-ctv-app"
    rtname   = "rt-sn-ctb-aue-ctv-app"
    nsgname  = "nsg-sn-ctb-aue-ctv-app"
    CIDR     = "10.98.81.0/24"
}

$ctbdatabase = [PSCustomObject]@{
    snetname = "sn-ctb-aue-ctv-database"
    rtname   = "rt-sn-ctb-aue-ctv-database"
    nsgname  = "nsg-sn-ctb-aue-ctv-database"
    CIDR     = "10.98.82.0/26"
}

$ctbf5mgmt = [PSCustomObject]@{
    snetname = "sn-ctb-aue-f5-mgmt"
    rtname   = "rt-sn-ctb-aue-f5-mgmt"
    nsgname  = "nsg-sn-ctb-aue-f5-mgmt"
    CIDR     = "10.98.82.128/28"
}

$ctbf5bcked_web = [PSCustomObject]@{
    snetname ="sn-ctb-aue-lb-backend_web"
    rtname   = "rt-sn-ctb-aue-lb-backend_web"
    nsgname  = "nsg-sn-ctb-aue-lb-backend_web"
    CIDR     = "10.98.82.144/28"
    
}

$ctbf5bcked_app = [PSCustomObject]@{
    snetname = "sn-ctb-aue-lb-backend_app"
    rtname   = "rt-sn-ctb-aue-lb-backend_app"
    nsgname  = "nsg-sn-ctb-aue-lb-backend_app"
    CIDR     = "10.98.82.160/28"
    
}

$ctbf5ha = [PSCustomObject]@{
    snetname = "sn-ctb-aue-f5-ha"
    rtname   = "rt-sn-ctb-aue-f5-ha"
    nsgname  = "nsg-sn-ctb-aue-f5-ha"
    CIDR     = "10.98.82.176/28"
}

$ctbf5externalvirtualsvrs = [PSCustomObject]@{
    snetname = "sn-ctb-aue-lb-external"
    rtname   = "rt-sn-ctb-aue-lb-external"
    nsgname  = "nsg-sn-ctb-aue-lb-external"
    CIDR     = "10.98.83.0/25"
}

$ctbf5internalvirtualsvrs = [PSCustomObject]@{
    snetname = "sn-ctb-aue-lb-internal"
    rtname   = "rt-sn-ctb-aue-lb-internal"
    nsgname  = "nsg-sn-ctb-aue-lb-internal"
    CIDR     = "10.98.84.0/24"
  
}


#Creating CTB subnet objects in AU South East

$ctaweb = [PSCustomObject]@{
    snetname = "sn-cta-ase-ctv-web"
    rtname   = "rt-sn-cta-ase-ctv-web"
    nsgname  = "nsg-sn-cta-ase-ctv-web"
    CIDR     = "10.99.80.0/24"
}

$ctaapp = [PSCustomObject]@{
    snetname = "sn-cta-ase-ctv-app"
    rtname   = "rt-sn-cta-ase-ctv-app"
    nsgname  = "nsg-sn-cta-ase-ctv-app"
    CIDR     = "10.99.81.0/24"
}

$ctadatabase = [PSCustomObject]@{
    snetname = "sn-cta-ase-ctv-database"
    rtname   = "rt-sn-cta-ase-ctv-database"
    nsgname  = "nsg-sn-cta-ase-ctv-database"
    CIDR     = "10.99.82.0/26"
}

$ctaf5mgmt = [PSCustomObject]@{
    snetname = "sn-cta-ase-f5-mgmt"
    rtname   = "rt-sn-cta-ase-f5-mgmt"
    nsgname  = "nsg-sn-cta-ase-f5-mgmt"
    CIDR     = "10.99.82.128/28"
}

$ctaf5bcked_web = [PSCustomObject]@{
    snetname ="sn-cta-ase-lb-backend_web"
    rtname   = "rt-sn-cta-ase-lb-backend_web"
    nsgname  = "nsg-sn-cta-ase-lb-backend_web"
    CIDR     = "10.99.82.144/28"
    
}

$ctaf5bcked_app = [PSCustomObject]@{
    snetname = "sn-cta-ase-lb-backend_app"
    rtname   = "rt-sn-cta-ase-lb-backend_app"
    nsgname  = "nsg-sn-cta-ase-lb-backend_app"
    CIDR     = "10.99.82.160/28"
    
}

$ctaf5ha = [PSCustomObject]@{
    snetname = "sn-cta-ase-f5-ha"
    rtname   = "rt-sn-cta-ase-f5-ha"
    nsgname  = "nsg-sn-cta-ase-f5-ha"
    CIDR     = "10.99.82.176/28"
}

$ctaf5externalvirtualsvrs = [PSCustomObject]@{
    snetname = "sn-cta-ase-lb-external"
    rtname   = "rt-sn-cta-ase-lb-external"
    nsgname  = "nsg-sn-cta-ase-lb-external"
    CIDR     = "10.99.83.0/25"
}

$ctaf5internalvirtualsvrs = [PSCustomObject]@{
    snetname = "sn-cta-ase-lb-internal"
    rtname   = "rt-sn-cta-ase-lb-internal"
    nsgname  = "nsg-sn-cta-ase-lb-internal"
    CIDR     = "10.99.84.0/24"
  
}

#Create UDRs in AU East

Write-Host "Creating CTB AUE UDRs...."

$ctbwebudrs = [PSCustomObject]@{

    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbf5bcked_app.snetname)" -AddressPrefix $ctbf5bcked_app.CIDR -NextHopType "VnetLocal"  
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctbf5bcked_web.snetname)" -AddressPrefix $ctbf5bcked_web.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$($ctbf5internalvirtualsvrs.snetname)" -AddressPrefix $ctbf5internalvirtualsvrs.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.135"
    UDR4 = New-AzRouteConfig -Name "route-to-$($ctbapp.snetname)" -AddressPrefix $ctbapp.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.135"
    UDR5 = New-AzRouteConfig -Name "route-to-$($ctbweb.snetname)" -AddressPrefix $ctbweb.CIDR -NextHopType "VnetLocal"
    UDR6 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR7 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR8 = New-AzRouteConfig -Name "route-via-f5-appliance" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress "10.98.26.149"
}

$ctbappudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbf5bcked_app.snetname)" -AddressPrefix $ctbf5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctbf5internalvirtualsvrs.snetname)" -AddressPrefix $ctbf5internalvirtualsvrs.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.151"
    UDR3 = New-AzRouteConfig -Name "route-to-$($ctbapp.snetname)" -AddressPrefix $ctbapp.CIDR -NextHopType "VnetLocal"
    UDR4 = New-AzRouteConfig -Name "route-to-$($ctbdatabase.snetname)" -AddressPrefix $ctbdatabase.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.151"
    UDR5 = New-AzRouteConfig -Name "route-to-$($ctbweb.snetname)" -AddressPrefix $ctbweb.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.155"
    UDR6 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR7 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR8 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctbdatabaseudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbapp.snetname)" -AddressPrefix $ctbapp.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.167"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctbdatabase.snetname)" -AddressPrefix $ctbdatabase.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR5 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctbf5mgmtudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbf5mgmt.snetname)" -AddressPrefix $ctbf5mgmt.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctbf5bcked_webudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbweb.snetname)" -AddressPrefix $ctbweb.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}
$ctbf5bcked_appudrs = [PSCustomObject]@{

    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbweb.snetname)" -AddressPrefix $ctbweb.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctbf5bcked_app.snetname)" -AddressPrefix $ctbf5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctbf5externalvirtualsvrsudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR2 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctbf5internalvirtualsvrsudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctbweb.snetname)" -AddressPrefix $ctbweb.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.98.0.135"
    UDR2 = New-AzRouteConfig -Name "route-to-$AUEVNETName" -AddressPrefix $ctbaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-to-null" -AddressPrefix "0.0.0.0/0" -NextHopType "None"
}

$ctbf5haudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-null" -AddressPrefix "0.0.0.0/0" -NextHopType "None"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctbf5ha.snetname)" -AddressPrefix $ctbf5ha.CIDR -NextHopType "VnetLocal"
}

#Create UDRs in AU South East
Write-Host "`n"
Write-Host "`n"
Write-Host "Creating CTA ASE UDRs...."

$ctawebudrs = [PSCustomObject]@{

    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaf5bcked_app.snetname)" -AddressPrefix $ctaf5bcked_app.CIDR -NextHopType "VnetLocal"  
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctaf5bcked_web.snetname)" -AddressPrefix $ctaf5bcked_web.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$($ctaf5internalvirtualsvrs.snetname)" -AddressPrefix $ctaf5internalvirtualsvrs.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.135"
    UDR4 = New-AzRouteConfig -Name "route-to-$($ctaapp.snetname)" -AddressPrefix $ctaapp.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.135"
    UDR5 = New-AzRouteConfig -Name "route-to-$($ctaweb.snetname)" -AddressPrefix $ctaweb.CIDR -NextHopType "VnetLocal"
    UDR6 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR7 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR8 = New-AzRouteConfig -Name "route-via-f5-appliance" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress "10.99.26.149"
}

$ctaappudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaf5bcked_app.snetname)" -AddressPrefix $ctaf5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctaf5internalvirtualsvrs.snetname)" -AddressPrefix $ctaf5internalvirtualsvrs.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.151"
    UDR3 = New-AzRouteConfig -Name "route-to-$($ctaapp.snetname)" -AddressPrefix $ctaapp.CIDR -NextHopType "VnetLocal"
    UDR4 = New-AzRouteConfig -Name "route-to-$($ctadatabase.snetname)" -AddressPrefix $ctadatabase.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.151"
    UDR5 = New-AzRouteConfig -Name "route-to-$($ctaweb.snetname)" -AddressPrefix $ctaweb.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.155"
    UDR6 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR7 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR8 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctadatabaseudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaapp.snetname)" -AddressPrefix $ctaapp.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.167"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctadatabase.snetname)" -AddressPrefix $ctadatabase.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR5 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctaf5mgmtudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaf5mgmt.snetname)" -AddressPrefix $ctaf5mgmt.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctaf5bcked_webudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaweb.snetname)" -AddressPrefix $ctaweb.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}
$ctaf5bcked_appudrs = [PSCustomObject]@{

    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaweb.snetname)" -AddressPrefix $ctaweb.CIDR -NextHopType "VnetLocal"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctaf5bcked_app.snetname)" -AddressPrefix $ctaf5bcked_app.CIDR -NextHopType "VnetLocal"
    UDR3 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctaf5externalvirtualsvrsudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR2 = New-AzRouteConfig -Name "route-via-ns-firewall" -AddressPrefix "0.0.0.0/0" -NextHopType VirtualAppliance -NextHopIpAddress $nsfwip
}

$ctaf5internalvirtualsvrsudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-$($ctaweb.snetname)" -AddressPrefix $ctaweb.CIDR -NextHopType VirtualAppliance -NextHopIpAddress "10.99.0.135"
    UDR2 = New-AzRouteConfig -Name "route-to-$ASEVNETName" -AddressPrefix $ctaaddspace -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR3 = New-AzRouteConfig -Name "route-via-ew-firewall" -AddressPrefix "10.0.0.0/8" -NextHopType VirtualAppliance -NextHopIpAddress $ewfwip
    UDR4 = New-AzRouteConfig -Name "route-to-null" -AddressPrefix "0.0.0.0/0" -NextHopType "None"
}

$ctaf5haudrs = [PSCustomObject]@{
    UDR1 = New-AzRouteConfig -Name "route-to-null" -AddressPrefix "0.0.0.0/0" -NextHopType "None"
    UDR2 = New-AzRouteConfig -Name "route-to-$($ctaf5ha.snetname)" -AddressPrefix $ctaf5ha.CIDR -NextHopType "VnetLocal"
}


$AUEchkRG = Get-AzResourceGroup -ResourceGroupName $AUERGName -ErrorVariable notP -ErrorAction SilentlyContinue 
$ASEchkRG = Get-AzResourceGroup -ResourceGroupName $ASERGName -ErrorVariable notP1 -ErrorAction SilentlyContinue 

#Create AUE network Resource Group

if($notP)
{
    Write-Host "Resource Group $AUERGName is creating...." -ForegroundColor Red 
    New-AzResourceGroup -Name $AUERGName -Location $AUELocation 
    Write-Host "Resource Group $AUERGName is created...." -ForegroundColor Green
}
else 
{
    Write-Host "Resource Group $AUERGName is available" 
    $AUEchkRG | Out-Null
}

#Create ASE network Resource Group

if($notP1)
{
    Write-Host "Resource Group $ASERGName is creating...." -ForegroundColor Red 
    New-AzResourceGroup -Name $ASERGName -Location $ASELocation 
    Write-Host "Resource Group $ASERGName is created...." -ForegroundColor Green
}
else 
{
    Write-Host "Resource Group $ASERGName is available" 
    $ASEchkRG | Out-Null
}

#Create AUE Route tables
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "Creating AUE Routetables!!" 
Write-Host "`n"
Write-Host "`n"

$AUERTs = [PSCustomObject]@{

   
    RT1 = New-AzRouteTable -Name $ctbweb.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbwebudrs.UDR1, $ctbwebudrs.UDR2, $ctbwebudrs.UDR3, $ctbwebudrs.UDR4, $ctbwebudrs.UDR5, $ctbwebudrs.UDR6, $ctbwebudrs.UDR7, $ctbwebudrs.UDR8
    RT2 = New-AzRouteTable -Name $ctbapp.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbappudrs.UDR1, $ctbappudrs.UDR2, $ctbappudrs.UDR3, $ctbappudrs.UDR4, $ctbappudrs.UDR5, $ctbappudrs.UDR6, $ctbappudrs.UDR7, $ctbappudrs.UDR8
    RT3 = New-AzRouteTable -Name $ctbdatabase.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbdatabaseudrs.UDR1, $ctbdatabaseudrs.UDR2, $ctbdatabaseudrs.UDR3, $ctbdatabaseudrs.UDR4, $ctbdatabaseudrs.UDR5
    RT4 = New-AzRouteTable -Name $ctbf5mgmt.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbf5mgmtudrs.UDR1, $ctbf5mgmtudrs.UDR2, $ctbf5mgmtudrs.UDR3, $ctbf5mgmtudrs.UDR4
    RT5 = New-AzRouteTable -Name $ctbf5bcked_web.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbf5bcked_webudrs.UDR1, $ctbf5bcked_webudrs.UDR2, $ctbf5bcked_webudrs.UDR3
    RT6 = New-AzRouteTable -Name $ctbf5bcked_app.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbf5bcked_appudrs.UDR1, $ctbf5bcked_appudrs.UDR2, $ctbf5bcked_appudrs.UDR3, $ctbf5bcked_appudrs.UDR4
    RT7 = New-AzRouteTable -Name $ctbf5externalvirtualsvrs.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbf5externalvirtualsvrsudrs.UDR1, $ctbf5externalvirtualsvrsudrs.UDR2   
    RT8 = New-AzRouteTable -Name $ctbf5internalvirtualsvrs.rtname  -ResourceGroupName $AUERGName -Location $AUELocation -Route  $ctbf5internalvirtualsvrsudrs.UDR1, $ctbf5internalvirtualsvrsudrs.UDR2, $ctbf5internalvirtualsvrsudrs.UDR3, $ctbf5internalvirtualsvrsudrs.UDR4
    RT9 = New-AzRouteTable -Name $ctbf5ha.rtname -ResourceGroupName $AUERGName -Location $AUELocation -Route $ctbf5haudrs.UDR1, $ctbf5haudrs.UDR2
}
#Create ASE Route tables
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "Creating ASE Routetables!!" 
Write-Host "`n"
Write-Host "`n"

$ASERTs = [PSCustomObject]@{

    RT1 = New-AzRouteTable -Name $ctaweb.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctawebudrs.UDR1, $ctawebudrs.UDR2, $ctawebudrs.UDR3, $ctawebudrs.UDR4, $ctawebudrs.UDR5, $ctawebudrs.UDR6, $ctawebudrs.UDR7, $ctawebudrs.UDR8
    RT2 = New-AzRouteTable -Name $ctaapp.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctaappudrs.UDR1, $ctaappudrs.UDR2, $ctaappudrs.UDR3, $ctaappudrs.UDR4, $ctaappudrs.UDR5, $ctaappudrs.UDR6, $ctaappudrs.UDR7, $ctaappudrs.UDR8
    RT3 = New-AzRouteTable -Name $ctadatabase.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctadatabaseudrs.UDR1, $ctadatabaseudrs.UDR2, $ctadatabaseudrs.UDR3, $ctadatabaseudrs.UDR4, $ctadatabaseudrs.UDR5
    RT4 = New-AzRouteTable -Name $ctaf5mgmt.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctaf5mgmtudrs.UDR1, $ctaf5mgmtudrs.UDR2, $ctaf5mgmtudrs.UDR3, $ctaf5mgmtudrs.UDR4
    RT5 = New-AzRouteTable -Name $ctaf5bcked_web.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctaf5bcked_webudrs.UDR1, $ctaf5bcked_webudrs.UDR2, $ctaf5bcked_webudrs.UDR3
    RT6 = New-AzRouteTable -Name $ctaf5bcked_app.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctaf5bcked_appudrs.UDR1, $ctaf5bcked_appudrs.UDR2, $ctaf5bcked_appudrs.UDR3, $ctaf5bcked_appudrs.UDR4
    RT7 = New-AzRouteTable -Name $ctaf5externalvirtualsvrs.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctaf5externalvirtualsvrsudrs.UDR1, $ctaf5externalvirtualsvrsudrs.UDR2
    RT8 = New-AzRouteTable -Name $ctaf5internalvirtualsvrs.rtname  -ResourceGroupName $ASERGName -Location $ASELocation -Route  $ctaf5internalvirtualsvrsudrs.UDR1, $ctaf5internalvirtualsvrsudrs.UDR2, $ctaf5internalvirtualsvrsudrs.UDR3, $ctaf5internalvirtualsvrsudrs.UDR4
    RT9 = New-AzRouteTable -Name $ctaf5ha.rtname -ResourceGroupName $ASERGName -Location $ASELocation -Route $ctaf5haudrs.UDR1, $ctaf5haudrs.UDR2
}
#Create AUE NSGs
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "Creating AUE NSGs!!" 
Write-Host "`n"
Write-Host "`n"


$AUENSGs = [PSCustomObject]@{
    NSG1 = New-AzNetworkSecurityGroup -Name $ctbweb.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG2 = New-AzNetworkSecurityGroup -Name $ctbapp.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG3 = New-AzNetworkSecurityGroup -Name $ctbdatabase.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG4 = New-AzNetworkSecurityGroup -Name $ctbf5mgmt.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG5 = New-AzNetworkSecurityGroup -Name $ctbf5bcked_web.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG6 = New-AzNetworkSecurityGroup -Name $ctbf5bcked_app.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG7 = New-AzNetworkSecurityGroup -Name $ctbf5externalvirtualsvrs.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG8 = New-AzNetworkSecurityGroup -Name $ctbf5internalvirtualsvrs.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
    NSG9 = New-AzNetworkSecurityGroup -Name $ctbf5ha.nsgname -ResourceGroupName $AUERGName -Location  $AUELocation
}

#Create ASE NSGs
Write-Host "`n"
Write-Host "`n"
Write-Host "`n"
Write-Host "Creating ASE NSGs!!" 
Write-Host "`n"
Write-Host "`n"

$ASENSGs = [PSCustomObject]@{
    NSG1 = New-AzNetworkSecurityGroup -Name $ctaweb.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG2 = New-AzNetworkSecurityGroup -Name $ctaapp.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG3 = New-AzNetworkSecurityGroup -Name $ctadatabase.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG4 = New-AzNetworkSecurityGroup -Name $ctaf5mgmt.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG5 = New-AzNetworkSecurityGroup -Name $ctaf5bcked_web.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG6 = New-AzNetworkSecurityGroup -Name $ctaf5bcked_app.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG7 = New-AzNetworkSecurityGroup -Name $ctaf5externalvirtualsvrs.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG8 = New-AzNetworkSecurityGroup -Name $ctaf5internalvirtualsvrs.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
    NSG9 = New-AzNetworkSecurityGroup -Name $ctaf5ha.nsgname -ResourceGroupName $ASERGName -Location  $ASELocation
   }

#Configure CTB WEB NSG rules

$AUENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
-Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$AUENSGs.NSG1 | Set-AzNetworkSecurityGroup


$AUENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $webports
$AUENSGs.NSG1 | Set-AzNetworkSecurityGroup


$AUENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix $ctbweb.CIDR -SourcePortRange * `
-DestinationAddressPrefix $ctbweb.CIDR -DestinationPortRange *
$AUENSGs.NSG1 | Set-AzNetworkSecurityGroup


$AUENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$AUENSGs.NSG1| Set-AzNetworkSecurityGroup

#Configure CTB APP NSG rules

$AUENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
-Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$AUENSGs.NSG2 | Set-AzNetworkSecurityGroup


$AUENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $appports
$AUENSGs.NSG2 | Set-AzNetworkSecurityGroup


$AUENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix $ctbapp.CIDR -SourcePortRange * `
-DestinationAddressPrefix $ctbapp.CIDR -DestinationPortRange *
$AUENSGs.NSG2 | Set-AzNetworkSecurityGroup


$AUENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$AUENSGs.NSG2| Set-AzNetworkSecurityGroup

#************************************************
#************************************************

#Configure CTA WEB NSG rules

$ASENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
-Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$ASENSGs.NSG1 | Set-AzNetworkSecurityGroup


$ASENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $webports
$ASENSGs.NSG1 | Set-AzNetworkSecurityGroup


$ASENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix $ctaweb.CIDR -SourcePortRange * `
-DestinationAddressPrefix $ctaweb.CIDR -DestinationPortRange *
$ASENSGs.NSG1 | Set-AzNetworkSecurityGroup


$ASENSGs.NSG1 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$ASENSGs.NSG1| Set-AzNetworkSecurityGroup

#Configure CTA APP NSG rules

$ASENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppIcmpDefaultInBound" -Access Allow `
-Protocol "ICMP" -Direction Inbound -Priority 1000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$ASENSGs.NSG2 | Set-AzNetworkSecurityGroup


$ASENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppTcpDefaultInBound" -Access Allow `
-Protocol "TCP" -Direction Inbound -Priority 1001 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange $appports
$ASENSGs.NSG2 | Set-AzNetworkSecurityGroup


$ASENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "AllowMhrAppWithinSubnetDefaultInbound" -Access Allow `
-Protocol * -Direction Inbound -Priority 1002 -SourceAddressPrefix $ctaapp.CIDR -SourcePortRange * `
-DestinationAddressPrefix $ctaapp.CIDR -DestinationPortRange *
$ASENSGs.NSG2 | Set-AzNetworkSecurityGroup


$ASENSGs.NSG2 | Add-AzNetworkSecurityRuleConfig -Name "DenyMhrAppDefaultInBound" -Access Deny `
-Protocol * -Direction Inbound -Priority 4000 -SourceAddressPrefix "VirtualNetwork" -SourcePortRange * `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange *
$ASENSGs.NSG2| Set-AzNetworkSecurityGroup

#Create AUE Vnet

$vnet = @{
    Name = $AUEVNETName
    ResourceGroupName = $AUERGName
    Location = $AUELocation
    AddressPrefix = $ctbaddspace 
    DNSServer = "10.98.8.4","10.98.8.5"
      
}
$auevirtualNetwork = New-AzVirtualNetwork @vnet 

$subnet = @{
    Name = $ctbweb.snetname
    AddressPrefix = $ctbweb.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT1
    NetworkSecurityGroup = $AUENSGs.NSG1
                         
}

Add-AzVirtualNetworkSubnetConfig @subnet  

$subnet = @{
    Name = $ctbapp.snetname
    AddressPrefix = $ctbapp.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT2
    NetworkSecurityGroup = $AUENSGs.NSG2

}
Add-AzVirtualNetworkSubnetConfig @subnet  

$subnet = @{
    Name = $ctbdatabase.snetname
    AddressPrefix = $ctbdatabase.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT3
    NetworkSecurityGroup = $AUENSGs.NSG3
                         
}
Add-AzVirtualNetworkSubnetConfig @subnet  

$subnet = @{
    Name = $ctbf5mgmt.snetname
    AddressPrefix = $ctbf5mgmt.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT4
    NetworkSecurityGroup = $AUENSGs.NSG4

}
Add-AzVirtualNetworkSubnetConfig @subnet  



$subnet = @{
    Name = $ctbf5bcked_web.snetname
    AddressPrefix = $ctbf5bcked_web.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT5
    NetworkSecurityGroup = $AUENSGs.NSG5

}
Add-AzVirtualNetworkSubnetConfig @subnet  


$subnet = @{
    Name = $ctbf5bcked_app.snetname
    AddressPrefix = $ctbf5bcked_app.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT6
    NetworkSecurityGroup = $AUENSGs.NSG6
}
Add-AzVirtualNetworkSubnetConfig @subnet  


$subnet = @{
    Name = $ctbf5externalvirtualsvrs.snetname
    AddressPrefix = $ctbf5externalvirtualsvrs.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT7
    NetworkSecurityGroup = $AUENSGs.NSG7

}
Add-AzVirtualNetworkSubnetConfig @subnet 


$subnet = @{
    Name = $ctbf5internalvirtualsvrs.snetname
    AddressPrefix = $ctbf5internalvirtualsvrs.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT8
    NetworkSecurityGroup = $AUENSGs.NSG8
}
Add-AzVirtualNetworkSubnetConfig @subnet 

$subnet = @{
    Name = $ctbf5ha.snetname
    AddressPrefix = $ctbf5ha.CIDR
    VirtualNetwork = $auevirtualNetwork
    RouteTable = $AUERTs.RT9
    NetworkSecurityGroup = $AUENSGs.NSG9
}
Add-AzVirtualNetworkSubnetConfig @subnet 
$auevirtualNetwork | Set-AzVirtualNetwork

#Create ASE Vnet

$vnet = @{
    Name = $ASEVNETName
    ResourceGroupName = $ASERGName
    Location = $ASELocation
    AddressPrefix = $ctaaddspace 
    DNSServer = "10.98.8.4","10.98.8.5"
      
}
$asevirtualNetwork = New-AzVirtualNetwork @vnet 

$subnet = @{
    Name = $ctaweb.snetname
    AddressPrefix = $ctaweb.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT1
    NetworkSecurityGroup = $ASENSGs.NSG1
                         
}

Add-AzVirtualNetworkSubnetConfig @subnet  

$subnet = @{
    Name = $ctaapp.snetname
    AddressPrefix = $ctaapp.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT2
    NetworkSecurityGroup = $ASENSGs.NSG2

}
Add-AzVirtualNetworkSubnetConfig @subnet  

$subnet = @{
    Name = $ctadatabase.snetname
    AddressPrefix = $ctadatabase.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT3
    NetworkSecurityGroup = $ASENSGs.NSG3
                         
}
Add-AzVirtualNetworkSubnetConfig @subnet  

$subnet = @{
    Name = $ctaf5mgmt.snetname
    AddressPrefix = $ctaf5mgmt.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT4
    NetworkSecurityGroup = $ASENSGs.NSG4

}
Add-AzVirtualNetworkSubnetConfig @subnet  



$subnet = @{
    Name = $ctaf5bcked_web.snetname
    AddressPrefix = $ctaf5bcked_web.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT5
    NetworkSecurityGroup = $ASENSGs.NSG5

}
Add-AzVirtualNetworkSubnetConfig @subnet  


$subnet = @{
    Name = $ctaf5bcked_app.snetname
    AddressPrefix = $ctaf5bcked_app.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT6
    NetworkSecurityGroup = $ASENSGs.NSG6
}
Add-AzVirtualNetworkSubnetConfig @subnet  


$subnet = @{
    Name = $ctaf5externalvirtualsvrs.snetname
    AddressPrefix = $ctaf5externalvirtualsvrs.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT7
    NetworkSecurityGroup = $ASENSGs.NSG7

}
Add-AzVirtualNetworkSubnetConfig @subnet 


$subnet = @{
    Name = $ctaf5internalvirtualsvrs.snetname
    AddressPrefix = $ctaf5internalvirtualsvrs.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT8
    NetworkSecurityGroup = $ASENSGs.NSG8
}
Add-AzVirtualNetworkSubnetConfig @subnet 

$subnet = @{
    Name = $ctaf5ha.snetname
    AddressPrefix = $ctaf5ha.CIDR
    VirtualNetwork = $asevirtualNetwork
    RouteTable = $ASERTs.RT9
    NetworkSecurityGroup = $ASENSGs.NSG9
}
Add-AzVirtualNetworkSubnetConfig @subnet 


$asevirtualNetwork | Set-AzVirtualNetwork

#CTB Vnet peering with AUE HUB

Select-AzSubscription -SubscriptionName "NINP-Connectivity"
$AUEHUBVNET    = Get-AzVirtualNetwork -Name "vnet-npp-con-hub-aue-001" -ResourceGroupName "rg-npp-con-networkhub-aue"
$ASEHUBVNET    = Get-AzVirtualNetwork -Name "vnet-npp-con-hub-ase-001" -ResourceGroupName "rg-npp-con-networkhub-ase"

Select-AzSubscription -SubscriptionName "NINP-Management"
$AUENetappVnet = Get-AzVirtualNetwork -Name "vnet-npp-mgt-aue-002" -ResourceGroupName "rg-npp-mgt-network-aue-001"
$ASENetappVnet = Get-AzVirtualNetwork -Name "vnet-npp-mgt-ase-002" -ResourceGroupName "rg-npp-mgt-network-ase-001"

Write-Host "Peering Started"

#Peering between CTB and AUE hub
Select-AzSubscription -SubscriptionName "NINP-CTV"
Add-AzVirtualNetworkPeering `
  -Name spoke-to-$($AUEHUBVNET.Name.ToString()) `
  -VirtualNetwork $auevirtualNetwork `
  -RemoteVirtualNetworkId $AUEHUBVNET.Id | Out-Null
  
  
$peer1 = Get-AzVirtualNetworkPeering -VirtualNetworkName $auevirtualNetwork.Name.ToString() -ResourceGroupName $auevirtualNetwork.ResourceGroupName.ToString() -Name "spoke-to-$($AUEHUBVNET.Name.ToString())"
$peer1.AllowForwardedTraffic = $true
Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer1

Select-AzSubscription -SubscriptionName "NINP-Connectivity"
Add-AzVirtualNetworkPeering `
  -Name Hub-to-$AUEVNETName `
  -VirtualNetwork $AUEHUBVNET `
  -RemoteVirtualNetworkId $auevirtualNetwork.Id   
  $peer2 = Get-AzVirtualNetworkPeering -VirtualNetworkName $AUEHUBVNET.Name.ToString() -ResourceGroupName $AUEHUBVNET.ResourceGroupName.ToString() -Name "Hub-to-$AUEVNETName"
  $peer2.AllowForwardedTraffic = $true
  $peer2.AllowGatewayTransit   = $true
  Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer2
  Write-Host "Peering Between AUE Hub and CTB completed"




  #peering between CTB and AUE Netapp
Select-AzSubscription -SubscriptionName "NINP-CTV"
  Add-AzVirtualNetworkPeering `
    -Name peer-to-$($AUENetappVnet.Name.ToString()) `
    -VirtualNetwork $auevirtualNetwork `
    -RemoteVirtualNetworkId $AUENetappVnet.Id | Out-Null
    $peer3 = Get-AzVirtualNetworkPeering -VirtualNetworkName $auevirtualNetwork.Name.ToString() -ResourceGroupName $auevirtualNetwork.ResourceGroupName.ToString() -Name "peer-to-$($AUENetappVnet.Name.ToString())"
    $peer3.AllowForwardedTraffic = $true
    Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer3
  
    Select-AzSubscription -SubscriptionName "NINP-Management"
  Add-AzVirtualNetworkPeering `
    -Name peer-to-$AUEVNETName `
    -VirtualNetwork $AUENetappVnet  `
    -RemoteVirtualNetworkId $auevirtualNetwork.Id | Out-Null
    $peer4 = Get-AzVirtualNetworkPeering -VirtualNetworkName $AUENetappVnet.Name.ToString() -ResourceGroupName $AUENetappVnet.ResourceGroupName.ToString() -Name "peer-to-$AUEVNETName"
    $peer4.AllowForwardedTraffic = $true
    Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer4
    Write-Host "Peering Between Netapp Vnet and CTB Vnet completed"


#CTA Vnet peering with ASE HUB
    Select-AzSubscription -SubscriptionName "NINP-CTV"
    Add-AzVirtualNetworkPeering `
    -Name spoke-to-$($ASEHUBVNET.Name.ToString()) `
    -VirtualNetwork $asevirtualNetwork `
    -RemoteVirtualNetworkId $ASEHUBVNET.Id | Out-Null
    $peer5 = Get-AzVirtualNetworkPeering -VirtualNetworkName $asevirtualNetwork.Name.ToString() -ResourceGroupName $asevirtualNetwork.ResourceGroupName.ToString() -Name "spoke-to-$($ASEHUBVNET.Name.ToString())"
    $peer5.AllowForwardedTraffic = $true
    Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer5
    
    Select-AzSubscription -SubscriptionName "NINP-Connectivity"
    Add-AzVirtualNetworkPeering `
      -Name Hub-to-$ASEVNETName `
      -VirtualNetwork $ASEHUBVNET `
      -RemoteVirtualNetworkId $asevirtualNetwork.Id 
     $peer6 = Get-AzVirtualNetworkPeering -VirtualNetworkName $ASEHUBVNET.Name.ToString() -ResourceGroupName $ASEHUBVNET.ResourceGroupName.ToString() -Name "Hub-to-$ASEVNETName"
     $peer6.AllowForwardedTraffic = $true
     Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer6
      Write-Host "Peering Between AUE Hub and CTB completed"
    



#Peering between CTA and AUE hub
Select-AzSubscription -SubscriptionName "NINP-CTV"
Add-AzVirtualNetworkPeering `
  -Name spoke-to-$($AUEHUBVNET.Name.ToString()) `
  -VirtualNetwork $asevirtualNetwork `
  -RemoteVirtualNetworkId $AUEHUBVNET.Id | Out-Null
  $peer7 = Get-AzVirtualNetworkPeering -VirtualNetworkName $asevirtualNetwork.Name.ToString() -ResourceGroupName $asevirtualNetwork.ResourceGroupName.ToString() -Name "spoke-to-$($ASEHUBVNET.Name.ToString())"
     $peer7.AllowForwardedTraffic = $true
     Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer7
      

Select-AzSubscription -SubscriptionName "NINP-Connectivity"
Add-AzVirtualNetworkPeering `
  -Name Hub-to-$AUEVNETName `
  -VirtualNetwork $ASEHUBVNET `
  -RemoteVirtualNetworkId $asevirtualNetwork.Id 
  $peer8 = Get-AzVirtualNetworkPeering -VirtualNetworkName $ASEHUBVNET.Name.ToString() -ResourceGroupName $ASEHUBVNET.ResourceGroupName.ToString() -Name "Hub-to-$ASEVNETName"
     $peer8.AllowForwardedTraffic = $true
     Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer8
  Write-Host "Peering Between AUE Hub and CTA completed"
  


       #CTA peering with AUE Netapp 
       Select-AzSubscription -SubscriptionName "NINP-CTV"
       Add-AzVirtualNetworkPeering `
         -Name peer-to-$($AUENetappVnet.Name.ToString()) `
         -VirtualNetwork $asevirtualNetwork `
         -RemoteVirtualNetworkId $AUENetappVnet.id | Out-Null
         $peer9 = Get-AzVirtualNetworkPeering -VirtualNetworkName $asevirtualNetwork.Name.ToString() -ResourceGroupName $asevirtualNetwork.ResourceGroupName.ToString() -Name "peer-to-$($AUENetappVnet.Name.ToString())"
         $peer9.AllowForwardedTraffic = $true
         Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer9
       
         Select-AzSubscription -SubscriptionName "NINP-Management"
         Add-AzVirtualNetworkPeering `
         -Name peer-to-$ASEVNETName `
         -VirtualNetwork $AUENetappVnet  `
         -RemoteVirtualNetworkId $asevirtualNetwork.Id | Out-Null
         $peer10 = Get-AzVirtualNetworkPeering -VirtualNetworkName $AUENetappVnet.Name.ToString() -ResourceGroupName $AUENetappVnet.ResourceGroupName.ToString() -Name "peer-to-$AUEVNETName"
         $peer10.AllowForwardedTraffic = $true
         Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer10
         Write-Host "Peering Between Netapp Vnet and CTB Vnet completed"
 
  
     #CTA peering with ASE Netapp 
        Select-AzSubscription -SubscriptionName "NINP-CTV"
        Add-AzVirtualNetworkPeering `
        -Name peer-to-$($ASENetappVnet.Name.ToString()) `
        -VirtualNetwork $asevirtualNetwork `
        -RemoteVirtualNetworkId $ASENetappVnet.id | Out-Null
        $peer11 = Get-AzVirtualNetworkPeering -VirtualNetworkName $asevirtualNetwork.Name.ToString() -ResourceGroupName $asevirtualNetwork.ResourceGroupName.ToString() -Name "peer-to-$($ASENetappVnet.Name.ToString())"
         $peer11.AllowForwardedTraffic = $true
         Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer11
      
        Select-AzSubscription -SubscriptionName "NINP-Management"
        Add-AzVirtualNetworkPeering `
        -Name peer-to-$ASEVNETName `
        -VirtualNetwork $ASENetappVnet  `
        -RemoteVirtualNetworkId $asevirtualNetwork.Id | Out-Null
        $peer12 = Get-AzVirtualNetworkPeering -VirtualNetworkName $ASENetappVnet.Name.ToString() -ResourceGroupName $ASENetappVnet.ResourceGroupName.ToString() -Name "peer-to-$ASEVNETName"
        $peer12.AllowForwardedTraffic = $true
         Set-AzVirtualNetworkPeering -VirtualNetworkPeering $peer12
        Write-Host "Peering Between Netapp Vnet and CTB Vnet completed"




  Write-Host "Peering Completed"
  Select-AzSubscription -SubscriptionName "NINP-CTV"


Write-Host "#####################################################################################################################################################"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#                                                   CREATE MANAGE SERVICES VNET IN NINP-CTV!                                                        #"
Write-Host "#                                                                                                                                                   #"
Write-Host "#####################################################################################################################################################"


$asefahb = [PSCustomObject]@{
    snetname = "sn-ctv-ase-fa-hb"
    rtname   = "rt-sn-ctv-ase-fa-hb"
    nsgname  = "nsg-sn-ctv-ase-fa-hb"
    CIDR     = "10.99.6.64/28"
}

$asefametrics = [PSCustomObject]@{
    snetname = "sn-ctv-ase-fa-matrics"
    rtname   = "rt-sn-ctv-ase-fa-matrics"
    nsgname  = "nsg-sn-ctv-ase-fa-matrics"
    CIDR     = "10.99.6.80/28"
}

$asefasnow = [PSCustomObject]@{
    snetname = "sn-ctv-ase-fa-snow"
    rtname   = "rt-sn-ctv-ase-fa-snow"
    nsgname  = "nsg-sn-ctv-ase-fa-snow"
    CIDR     = "10.99.6.96/28"
}


$AUEchkRG = Get-AzResourceGroup -ResourceGroupName $MGTRGName  -ErrorVariable notP -ErrorAction SilentlyContinue 


if($notP)
{
    Write-Host "Resource Group $MGTRGName  is creating...." -ForegroundColor Red 
    New-AzResourceGroup -Name $MGTRGName  -Location $MGTlocation
    Write-Host "Resource Group $MGTRGName  is created...." -ForegroundColor Green
}
else 
{
    Write-Host "Resource Group $MGTRGName  is available" 
    $AUEchkRG | Out-Null
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
Add-AzVirtualNetworkSubnetConfig @subnet | Out-Null


$subnet = @{
    Name = $asefametrics.snetname
    AddressPrefix = $asefametrics.CIDR
    VirtualNetwork = $mgtvirtualNetwork
    RouteTable = $MGTRTs.RT2
    NetworkSecurityGroup = $ASENSG2

}
Add-AzVirtualNetworkSubnetConfig @subnet | Out-Null


$subnet = @{
    Name = $asefasnow.snetname
    AddressPrefix = $asefasnow.CIDR
    VirtualNetwork = $mgtvirtualNetwork
    RouteTable = $MGTRTs.RT3
    NetworkSecurityGroup = $ASENSG3

}
Add-AzVirtualNetworkSubnetConfig @subnet | Out-Null
$mgtvirtualNetwork | Set-AzVirtualNetwork