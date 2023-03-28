Select-AzSubscription -SubscriptionName "NINP-PERF"
 $azNsgs = Get-AzNetworkSecurityGroup


foreach ($azNsg in $azNsgs) {
    Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg | `
    Select-Object @{label = 'NSG Name'; expression = { $azNsg.Name } }, `
    @{label = 'NSG Location'; expression = { $azNsg.Location } }, `
    @{label = 'Rule Name'; expression = { $_.Name } }, `
    @{label = 'Source'; expression = { $_.SourceAddressPrefix } }, `
    @{label = 'Source Application Security Group'; expression = { $_.SourceApplicationSecurityGroups.id.Split('/')[-1] } },
    @{label = 'Source Port Range'; expression = { $_.SourcePortRange } }, Access, Priority, Direction, `
    @{label = 'Destination'; expression = { $_.DestinationAddressPrefix } }, `
    @{label = 'Destination Application Security Group'; expression = { $_.DestinationApplicationSecurityGroups.id.Split('/')[-1] } }, `
    @{label = 'Destination Port Range'; expression = { $_.DestinationPortRange } }, `
    @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } } | `
    Export-Csv -Path "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\nsg-rules.csv" -NoTypeInformation -Append -force
}