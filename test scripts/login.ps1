Select-AzSubscription -SubscriptionName 'NINP-Management'
$KeyVault       = "kv-npp-mgt-ase-dxcms-001" 

$cid = Get-AzKeyVaultSecret -VaultName $KeyVault  -Name "spn-ninp-managed-service-deploy-cid" -AsPlainText
$sec = Get-AzKeyVaultSecret -VaultName $KeyVault  -Name "spn-ninp-managed-service-deploy-sec" -AsPlainText
$tid = Get-AzKeyVaultSecret -VaultName $KeyVault  -Name "spn-ninp-managed-service-deploy-tid" -AsPlainText
$sid = Get-AzKeyVaultSecret -VaultName $KeyVault  -Name "spn-ninp-managed-service-deploy-sid" -AsPlainText

$ServiceNowURL                  = Get-AzKeyVaultSecret -VaultName $KeyVault  -Name "ServiceNowServerURL" -AsPlainText
$UpgradeFunctionCodes           = "Yes"
$UpgradeEnvVariables            = "Yes"


$azureAccountName   =   $cid
$azurePassword      =   ConvertTo-SecureString $sec -AsPlainText -Force

$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)

Connect-AzAccount   -Credential $psCred `
                    -Tenant $tid `
                    -SubscriptionId $sid `
                    -ServicePrincipal