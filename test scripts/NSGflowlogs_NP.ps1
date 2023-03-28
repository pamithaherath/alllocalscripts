# Get Current path and reset location for execution of all scripts.
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $executingScriptDirectory

$Tenant = "44fd5bf5-900a-45b8-8d9a-4fc1d9953452"
$MasterNSGSubName = "NINP-Management"

Set-AzContext -Tenant $Tenant -Subscription $MasterNSGSubName

$scopedSubscriptions = "NINP-AppTools","NINP-DEV","NINP-Identity","NINP-Sandbox","NINP-PERF","NINP-Connectivity","NINP-SIT","NINP-SVT","NINP-Management"
$managedServicesRG = "rg-npp-mgt-managed-service-ase"


#Traffic Analytics Parameters for Australia East

$workspaceResourceId = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-managed-service-ase/providers/Microsoft.OperationalInsights/workspaces/log-npp-mgt-ninp-network-aue"
$workspaceGUID = "156033e1-0ca5-400f-b697-a452976ddb0b"
$workspaceLocation = "australiaeast"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $managedServicesRG -Name dxcmgtauenwlog10052022sa
ForEach ($subName in $scopedSubscriptions)
{
        Set-AzContext -Tenant $Tenant -Subscription $SubName

        ## Register provider

        Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
        $NW = Get-AzNetworkWatcher -ResourceGroupName NetworkWatcherRG -Name NetworkWatcher_australiaeast

        $NSGList = Get-AzNetworkSecurityGroup| Select-Object -Property Name, ResourceGroupname, @{label='Location';expression={$_.Location}}

        ForEach ($NSG in $NSGList)
        {
            If ( $NSG.Location -eq "australiaeast")
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


#Traffic Analytics Parameters for Australia Central 

$workspaceResourceId = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourcegroups/rg-npp-mgt-managed-service-ase/providers/microsoft.operationalinsights/workspaces/log-npp-mgt-ninp-network-auc1"
$workspaceGUID = "744d515c-6499-4fc1-9ff7-3609311ad564"
$workspaceLocation = "australiacentral"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $managedServicesRG -Name dxcmgtauc1nwlogsa

ForEach ($subName in $scopedSubscriptions)
{
        Set-AzContext -Tenant $Tenant -Subscription $SubName

        ## Register provider

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


