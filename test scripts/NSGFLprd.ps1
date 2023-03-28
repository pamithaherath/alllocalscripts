# Get Current path and reset location for execution of all scripts.
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $executingScriptDirectory

$Tenant = "b5e01e05-f2ed-4c0a-86b4-b69f83c652ee"
$MasterNSGSubName = "NIPD-Management"

Set-AzContext -Tenant $Tenant -Subscription $MasterNSGSubName

#$scopedSubscriptions = "NIPD-AppTools","NIPD-PDC","NIPD-SDC","NIPD-Identity","NIPD-Connectivity","NIPD-Management"
$scopedSubscriptions = "NIPD-Management"
$managedServicesRG = "rg-prd-mgt-managed-service-ase"


#Traffic Analytics Parameters

$workspaceResourceId = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-managed-service-ase/providers/Microsoft.OperationalInsights/workspaces/log-prd-mgt-nipd-network-aue"
$workspaceGUID = "44d4cf94-b919-4b53-ac66-6f5ea32a6ae0"
$workspaceLocation = "australiaeast"

$storageAccount = Get-AzStorageAccount -ResourceGroupName $managedServicesRG -Name dxcmgtauenwlog09052022sa 

ForEach ($subName in $scopedSubscriptions)
{
        Set-AzContext -Tenant $Tenant -Subscription $SubName

        New-AzNetworkWatcher -Name NetworkWatcher_australiaeast -ResourceGroupName NetworkWatcherRG -Location australiaeast

        ## Register provider

        Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
        $NW = Get-AzNetworkWatcher -ResourceGroupName NetworkWatcherRG -Name NetworkWatcher_australiaeast

        $NSGList = Get-AzNetworkSecurityGroup| Select-Object -Property Name, ResourceGroupname, @{label='Location';expression={$_.Location}}

        ForEach ($NSG in $NSGList)
        {
           
            If ( $NSG.Location -eq 'australiaeast')
            {
                Write-Host "Onboarding NSG....", $NSG.Name ,"in region", $NSG.Location
                $nsg1 = Get-AzNetworkSecurityGroup -ResourceGroupName $NSG.ResourceGroupName -Name $NSG.Name

                #Configure Version 2 FLow Logs with Traffic Analytics Configured
                Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg1.Id -StorageAccountId $storageAccount.Id -EnableFlowLog $true -FormatType Json -FormatVersion 2 -EnableTrafficAnalytics -WorkspaceResourceId $workspaceResourceId -WorkspaceGUID $workspaceGUID -WorkspaceLocation $workspaceLocation -TrafficAnalyticsInterval 10

                #Query Flow Log Status
                #Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg1.Id
                
            }
            else {
                Write-Host "skipping NSG....", $NSG.Name ,"in region", $NSG.Location
            }
        }
}

#Traffic Analytics Parameters for Australia Southeast 

$workspaceResourceId = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-managed-service-ase/providers/Microsoft.OperationalInsights/workspaces/log-prd-mgt-nipd-network-ase"
$workspaceGUID = "b05edc29-d46d-4a09-b591-629d75df088f"
$workspaceLocation = "australiasoutheast"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $managedServicesRG -Name dxcmgtasenwlog09052022sa 

ForEach ($subName in $scopedSubscriptions)
{
        Set-AzContext -Tenant $Tenant -Subscription $SubName

        New-AzNetworkWatcher -Name NetworkWatcher_australiasoutheast -ResourceGroupName NetworkWatcherRG

        ## Register provider

        Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
        $NW = Get-AzNetworkWatcher -ResourceGroupName NetworkWatcherRG -Name NetworkWatcher_australiasoutheast

        $NSGList = Get-AzNetworkSecurityGroup| Select-Object -Property Name, ResourceGroupname, @{label='Location';expression={$_.Location}}

        ForEach ($NSG in $NSGList)
        {

            If ( $NSG.Location -eq "australiasoutheast")
            {
                Write-Host "Onboarding NSG....", $NSG.Name ,"in region", $NSG.Location
                $nsg1 = Get-AzNetworkSecurityGroup -ResourceGroupName $NSG.ResourceGroupName -Name $NSG.Name

                #Configure Version 2 FLow Logs with Traffic Analytics Configured
                Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg1.Id -StorageAccountId $storageAccount.Id -EnableFlowLog $true -FormatType Json -FormatVersion 2 -EnableTrafficAnalytics -WorkspaceResourceId $workspaceResourceId -WorkspaceGUID $workspaceGUID -WorkspaceLocation $workspaceLocation -TrafficAnalyticsInterval 10

                #Query Flow Log Status
                #Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg1.Id
                
            }
            else {
                Write-Host "skipping NSG....", $NSG.Name ,"in region", $NSG.Location
            }
        }
}#>

#Traffic Analytics Parameters for Australia Central

$workspaceResourceId = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-managed-service-ase/providers/Microsoft.OperationalInsights/workspaces/log-prd-mgt-nipd-network-aue"
$workspaceGUID = "44d4cf94-b919-4b53-ac66-6f5ea32a6ae0"
$workspaceLocation = "australiaeast"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $managedServicesRG -Name dxcmgtauc1nwlg04072022sa
ForEach ($subName in $scopedSubscriptions)
{
        Set-AzContext -Tenant $Tenant -Subscription $SubName

        New-AzNetworkWatcher -Name NetworkWatcher_australiacentral -ResourceGroupName NetworkWatcherRG -location "australiacentral"
#Register Provider 
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
$NW = Get-AzNetworkWatcher -ResourceGroupName NetworkWatcherRG -Name NetworkWatcher_australiacentral

$NSGList = Get-AzNetworkSecurityGroup| Select-Object -Property Name, ResourceGroupname, @{label='Location';expression={$_.Location}}  

ForEach ($NSG in $NSGList)
{
If ( $NSG.Location -eq "australiacentral")
{
    Write-Host "Onboarding NSG....", $NSG.Name ,"in region", $NSG.Location
    $nsg1 = Get-AzNetworkSecurityGroup -ResourceGroupName $NSG.ResourceGroupName -Name $NSG.Name

    #Configure Version 2 FLow Logs with Traffic Analytics Configured
    Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg1.Id -StorageAccountId $storageAccount.Id -EnableFlowLog $true -FormatType Json -FormatVersion 2 -EnableTrafficAnalytics -WorkspaceResourceId $workspaceResourceId -WorkspaceGUID $workspaceGUID -WorkspaceLocation $workspaceLocation -TrafficAnalyticsInterval 10

    #Query Flow Log Status
    #Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg1.Id
    
}
else {
    Write-Host "skipping NSG....", $NSG.Name ,"in region", $NSG.Location
}
}
}

#Traffic Analytics Parameters for Australia Central 2

$workspaceResourceId = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-managed-service-ase/providers/Microsoft.OperationalInsights/workspaces/log-prd-mgt-nipd-network-ase"
$workspaceGUID = "b05edc29-d46d-4a09-b591-629d75df088f"
$workspaceLocation = "australiasoutheast"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $managedServicesRG -Name dxcmgtauc2nwlg04072022sa
                                                                                   

ForEach ($subName in $scopedSubscriptions)
{
        Set-AzContext -Tenant $Tenant -Subscription $SubName
        New-AzNetworkWatcher -Name NetworkWatcher_australiacentral2 -ResourceGroupName NetworkWatcherRG -location "australiacentral2"

        ## Register provider

        Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
        $NW = Get-AzNetworkWatcher -ResourceGroupName NetworkWatcherRG -Name NetworkWatcher_australiacentral2

        $NSGList = Get-AzNetworkSecurityGroup| Select-Object -Property Name, ResourceGroupname, @{label='Location';expression={$_.Location}} 

        ForEach ($NSG in $NSGList)
        {
            If ( $NSG.Location -eq "australiacentral2")
            {
                Write-Host "Onboarding NSG....", $NSG.Name ,"in region", $NSG.Location
                $nsg1 = Get-AzNetworkSecurityGroup -ResourceGroupName $NSG.ResourceGroupName -Name $NSG.Name

                #Configure Version 2 FLow Logs with Traffic Analytics Configured
                Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg1.Id -StorageAccountId $storageAccount.Id -EnableFlowLog $true -FormatType Json -FormatVersion 2 -EnableTrafficAnalytics -WorkspaceResourceId $workspaceResourceId -WorkspaceGUID $workspaceGUID -WorkspaceLocation $workspaceLocation -TrafficAnalyticsInterval 10

                #Query Flow Log Status
                #Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg1.Id
                
            }
            else {
                Write-Host "skipping NSG....", $NSG.Name ,"in region", $NSG.Location
            }
        }
       
}    