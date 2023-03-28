#Requires -PSEdition Core
#Requires -Version 7.0
#Requires -Modules @{ ModuleName="Az.Resources"; ModuleVersion="5.1.0" }
#Requires -Modules @{ ModuleName = 'Az.ManagementPartner'; ModuleVersion = '0.7.2' }
<#=====================================================================================================================
Required - Powershell Version 7.0, Az.ManagementPartner Powershell module 
=======================================================================================================================
DATE          VERSION    AUTHOR                         DETAILS         
=======================================================================================================================
12/16/2019    1.0        Hung Trinh                     Initial Release
01/27/2020    2.0        Santanu Sengupta               Rectified Logical error, restructured the script
06/10/2020    3.0        David Williams 
02/09/2021    3.1        Thomas Richards                Added Function 'ConnectToAzure'
                                                        Updated keyvault key commands
                                                        Updated Get-AzKeyVaultSecret to use .NET
03/02/2021    3.2        Thomas Richards                Set Palapp secret expiry dates
07/09/2021    3.3        Thomas Richards                Add support for Service Principals to be usable across multiple subscriptions
07/23/2021    4.0        Thomas Richards                Adding Lighthouse deployment support
01/18/2022    4.1        Thomas Richards                Update to Az.Resources 5.1.0
23/11/2022    4.2        Pamitha Herath                 Modified to create seperate SPN for each subsciption
                                                        and commented line 276 as it tries to add contributor RBAC to subscription for already created SPN 
=======================================================================================================================
.SYNOPSIS
    Allows customer assigned admin user to get, add, change, or delete MPN ID from / to tenant subscription         
#>

[CmdletBinding(SupportsShouldProcess=$true)]
Param
    (
    [Parameter(Mandatory=$true)]  [String]$dxcTenantID,        #Specifies the tenant ID 
    [Parameter(Mandatory=$true)]  [String]$dxcSubscriptionID,        #Specifies the subscription ID 
    [Parameter(Mandatory=$false)]  [String]$dxcKeyVault,              #Specifies the DXC Key Vault for the app key
    [Parameter(Mandatory=$true)]  [int]$dxcMPNId,              #Specifies the Microsoft MPN Id
    [Parameter(Mandatory=$true)]  [ValidateSet("Get","Add","Change","Delete")] [String]$dxcOperation, #Specifies action that you want to perform.
    [Parameter(ParameterSetName="Lighthouse")]  [switch]$Lighthouse,                        #Switch to run Lighthouse deployment. This will not store SPN Key in key vault.
    [Parameter(ParameterSetName="Lighthouse", Mandatory=$false)]  $dxcSPNSecretValue        #For Lighthouse use only. Input the Service Principal secret if SPN already exists.
    )
#======================================================================================================================
# CHECK VARIABLES
#======================================================================================================================
If (($Lighthouse -eq $False) -and (-Not $dxcKeyVault)){
    Write-host "`nERROR: Key Vault was not specified. Please try again with parameter 'dxcKeyVault'. `nExiting..." -ForegroundColor Red
    exit
}
if ($Lighthouse -eq $True){
    Write-Host "`nWARNING: You have opted for Lighthouse deployment. This does not use a key vault. You must manually add the SPN key to the dxc key vault on creation of SPN. For post-creation operations, you must input this secret in as parameter 'dxcSPNSecretValue'." -ForegroundColor Yellow
}

#======================================================================================================================
# CHECK ENVIRONMENT FOR NECESSARY MODULES
#======================================================================================================================
$ModuleURL = "https://dxcazuretools.blob.core.windows.net/installers/DXCPowershellModules/DXCEnvCheck.psm1"
$LocalModule = $PSScriptRoot + "\DXCEnvCheck.psm1"
(New-Object System.Net.WebClient).DownloadFile($ModuleURL, $LocalModule)
Import-Module $LocalModule -WA 0
Remove-Item -Path $LocalModule

Check-AzureCLIVersion -dxcAZRequiredVersion 2.0.74  
    
#=====================================================================================================================
# LOGIN SECTION
#=====================================================================================================================
Write-Host "WARNING:     You need the following permissions to run this script." -ForegroundColor Yellow 
Write-Host "APPLICATION ADMINISTRATOR "  -ForegroundColor Red -NoNewLine
Write-Host "permissions in the AD TENANT where the Service Principal will be created." -ForegroundColor Blue 
Write-Host "OWNER "   -ForegroundColor Red -NoNewLine
Write-Host "privileges in the SUBSCRIPTION in order to grant Contributor access to the subscription." -ForegroundColor Blue

$InputFile = "C:\Users\pherathmudiy\OneDrive - DXC Production\All downloads\PAL.xlsx" 
$buildSheetExcel = Import-Excel -Path $InputFile -WorksheetName "PAL"
$volumeFile = @{}
foreach ($buildSheetRow in $buildSheetExcel) {
    $tenantid = $buildSheetRow."Tenant ID"
    $netApp = $buildSheetRow."Subscription ID"
    if ($tenantid) {
		#We only take action when a row status is "Not created" or "Not updated". Any other status means we skip the row.
		if ($buildSheetRow.Status -ne "Not created" -and $buildSheetRow.Status -ne "Not updated") {
			continue
		}
		$volumeFile.Add("$netapp-$volName",$buildSheetRow)
	}
}

function ConnectToAzure($tenant, $subname)
{
    write-host "Switching to $subname in $tenant."
    # Now Switch Subscription, and login if required.
    Try {
        $found = $false
        foreach ($cntxt in Get-AzContext -ListAvailable) {
            if ($cntxt.Tenant.ID -eq $tenant -and $cntxt.Subscription.Name -eq $subName) {
                $selectedcntxt = Select-AzContext -name $cntxt.name
                Write-Host "`n $($cntxt.name) selected"
                $found = $true
                break
            }
        }
        if (-not $found) {
            Connect-AzAccount -Tenant $tenant -SubscriptionName $subName
            $selectedcntxt = Set-AzContext -Tenant $tenant -SubscriptionName $subName
        }
    } 
    Catch {
        $error.clear()
        Connect-AzAccount -Tenant $tenant -SubscriptionName $subName
        $selectedcntxt = Set-AzContext -Tenant $tenant -SubscriptionName $subName
    }
    return $selectedcntxt
}
        
Write-Host "`nINFORMATION: Please login to Azure." -ForegroundColor Green
    
$error.Clear()
if (!(ConnectToAzure -tenant $dxcTenantID -subname $dxcSubscriptionID)) { 
    Write-Host "`nWARNING:     Unable to connect to Azure. Check your internet connection and verify authentication details." -ForegroundColor Yellow
    exit 
}
Write-Host "`nINFORMATION: Connected to Azure with provided authentication." -ForegroundColor Green 
    
#=====================================================================================================================
# Get the Object ID of the current user so access can be granted to the Key Vault if needed
#=====================================================================================================================
    
Write-Host "`nINFORMATION: Obtaining the Object ID of the current user so temporary access can be granted to the Key Vault if needed.`n" -ForegroundColor Green -NoNewLine 
    
#Get objectID of logged in user
$usertype = (get-azcontext).Account.Type
if($usertype -eq 'ServicePrincipal'){
    #get object id of spn
    $currentUserObjectID = (Get-AzADServicePrincipal -ServicePrincipalName ((Get-AzContext).Account.id)).id
    $addomain = (Get-AzAdServicePrincipal -ServicePrincipalName (Get-AzContext).Account.id).ServicePrincipalNames[0].split("/")[2]
}
elseif($usertype -eq 'User'){
    #get object of user
    $account = (Get-AzContext).account
    $currentUserObject = (get-azaduser -UserPrincipalName $account)
    $addomain = $account.Id.Split("@")[1]

    #if no user found, possibly guest/b2b account access, try getting object ID via Azure CLI commands instead
    If(!($currentuserobject)){
        Write-Host "User not matched on login name, connecting to AZ Cli to object ID"
        try{
            #try to run az commands to clear any connections
            az account clear
            #prompt to log in 
            if(!($tenantid)){
                $tenantid = Read-Host -Prompt "`nWARNING: you must provide the Tenant ID for the Azure AD that manages this subscription."
            }
            $result = (az login --tenant $tenantid)
            # get current user's object ID for granting access to keyvault
            $currentUserObjectID = (az ad signed-in-user show | ConvertFrom-Json).objectid
            $addomain =  (az ad signed-in-user show | ConvertFrom-Json).userPrincipalName.split("@")[1]
            $currentUserObject = "Object found"
        }
        catch{
            #If az commands fail, let user know to install az cli
            Write-Host "Azure CLI tools are required to run this script with CSP/Guest Logins to be able to find user's Object IDs to grant them permissions to add Keyvault Secrets, please install Azure CLI and retry"
            Write-Host "You can install it by running the following command as admin"
            Write-Host "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'"
        }
    }
    If(!($currentUserObject)){
        Write-Host "User object ID/GUID not found, please check your account, Exiting..." -ForegroundColor Red
        Exit
    }
    If(!($currentUserObjectID)){
        #If ObjectID not already retrieved then set it now.
        $currentUserObjectID = $currentUserObject[0].id
    }
}
    
    
#=====================================================================================================================
# GATHER VARIABLES / SET THE CONTEXT / CHECK THE KEYVAULT EXISTS
#=====================================================================================================================

Set-AzContext $dxcSubscriptionID
if ($error) { 
    Write-Host "WARNING:     Invalid Subscription ID. Please make sure you have sufficient access to this Azure Subscription." -ForegroundColor Yellow 
    Write-Host "             Run the Powershell Command: " -ForegroundColor Yellow -NoNewLine 
    Write-Host "Login-AzAccount " -NoNewLine
    Write-Host "and login with your authentication details." -ForegroundColor Yellow
    Write-Host "             If you get error, you have access issues with the subscription." -ForegroundColor Yellow
    exit 
}
    
# Check the Key Vault exists
if ($Lighthouse -eq $False){
    $kvexists = Get-AzKeyVault -VaultName $dxcKeyVault
    if($null -eq $kvexists){ 
        Write-Host "WARNING: Invalid Key Vault Name, please check the Key Vault " -ForegroundColor Yellow -NoNewline
        Write-Host $dxcKeyVault  -ForegroundColor Red  -NoNewline
        Write-Host " exists in the subscription "  -ForegroundColor Yellow  -NoNewline
        Write-Host $dxcSubscriptionID  -ForegroundColor Red  -NoNewline
        Write-Host " and rerun the script."  -ForegroundColor Yellow
        exit 
    }
}

#=====================================================================================================================
# SERVICE PRINCIPLE CHECK & CREATION / ADDITION OF ROLE DEFINITION IN THE SUBSCRIPTION
#=====================================================================================================================
$PalAppID = "palapp$($dxcSubscriptionID.Substring(0,4))"
$PalAppSecretName = $palAppID + "key"
    
Write-Host "`nINFORMATION: There should only be one App registration per subscription. " -ForegroundColor Green
Write-Host "If the App Registration already exists it will be given the required access to the subscription." -ForegroundColor Green
Write-Host "The name for the App Registration/Service Principal in this AD Tenant is " -NoNewline -ForegroundColor Green
Write-Host $PalAppID"." -ForegroundColor Red
    
# Check whether the App Registration Exists
$AppRegExists = Get-AzADServicePrincipal -DisplayName $PalAppID
if (!$AppRegExists) { 
    Write-Host "`nINFORMATION: App Registration $PalAppID doesn't exist, creating it now..." -ForegroundColor Green
    # Create the App registration and Generate the Key
            
    # Constants
    $appURL = "http://" + $addomain + "/" + $PalAppID
    
    # Key start date
    $startDate = Get-Date
    
    # Key end date
    $endDate = (Get-Date).AddYears(1)
    
    # The Microsoft recommended method for creating a Service Principle authenticated by a PSADCredential is to first create the application without credentials, 
    # then use the cmdlet New-AzADAppCredential to create the credential and attach it to the App
    Write-Host "`nINFORMATION: Creating the new AD Application - $PalAppID" -ForegroundColor Green
    $psadCredential = New-AzADApplication -DisplayName $PalAppID -HomePage "http://localhost" -IdentifierUri $appURL | New-AzADAppCredential -StartDate $startDate -EndDate $endDate
    $app = Get-AzADApplication -DisplayName $PalAppId
    if ($error) { 
        Write-Host "`nWARNING: Creation of the AD Application failed.  Check you have sufficient permissions in the AD Tenant."  -ForegroundColor Yellow
        exit 
    }
    Write-Host "`nINFORMATION: The AD Application was created successfully." -ForegroundColor Green 
        
    # Creating the Service Principal, this will assign the Conotributor and assign the scope as this subscription
    Write-Host "`nINFORMATION: Creating the Service Principal, this will assign the Contributor role and assign the scope as this subscription." -ForegroundColor Green
    $ApplicationID = $app.AppId
    New-AzADServicePrincipal -ApplicationId $ApplicationID -Role Contributor
    if ($error) { 
        Write-Host "`nWARNING:Creation of the Service Principal failed.  Check you have sufficient permissions in the AD Tenant."  -ForegroundColor Yellow
        exit 
    }
    Write-Host "`nINFORMATION: The Service Principal was created successfully." -ForegroundColor Green 
    if ($Lighthouse -eq $False){
    # Write the AD Application secret to the Key Vault
    $error.Clear()
    Write-Host "`nINFORMATION: Adding the App registration key secret $PalAppSecretName to the Key Vault $KeyVaultName" -ForegroundColor Green
    $secureString = convertto-securestring $psadCredential.SecretText -asplaintext -force
    $result = Set-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName -SecretValue $secureString -Expires $endDate
    $secretvalue = Get-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName
    $keyValue = ([System.Net.NetworkCredential]::new("", $secretvalue.SecretValue).Password)
    $result
    if ($error) { 
        Write-Host "`nINFORMATION: Insufficient rights to write to the key vault, will provide temporary rights."  -ForegroundColor Green
               
        # Add current context user to keyvault access policy temporarily
        Set-AzKeyVaultAccessPolicy -VaultName $dxcKeyVault -ObjectId $currentUserObjectID -PermissionsToSecrets get, set, list
        Write-Host "`nINFORMATION: Added" (Get-AzContext).Account "to" $dxcKeyVault "Access Policy Temporarily" -ForegroundColor Green 
               
        # Write the AD Application secret to the Key Vault
        Write-Host "`nINFORMATION: Adding the App registration key secret $PalAppSecretName to the Key Vault $KeyVaultName" -ForegroundColor Green
        $secureString = convertto-securestring $psadCredential.SecretText -asplaintext -force
        $result = Set-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName -SecretValue $secureString -Expires $endDate
        $secretvalue = Get-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName
        $keyValue = ([System.Net.NetworkCredential]::new("", $secretvalue.SecretValue).Password)
        $result
               
        Write-Host "`nINFORMATION: Do you want to remove the access to the Vault named" $dxcKeyVault -ForegroundColor Yellow  
        $RemovePrivs = (Read-Host -Prompt "(Y/N)?").ToUpper()
        if($RemovePrivs -eq 'Y'){
            #Remove current context user from keyvault access policy
            Write-Host "`nINFORMATION: Removed" (Get-AzContext).Account "rights from" $dxcKeyVault "Access Policy " -ForegroundColor Green           
            Remove-AzKeyVaultAccessPolicy -VaultName $dxcKeyVault -ObjectId $currentUserObjectID
        }
        else {
            Write-Host "`nINFORMATION: Left" (Get-AzContext).Account "temporary rights on" $dxcKeyVault "Access Policy " -ForegroundColor Green          
        }
    }
    }
    else{
        Write-Host "INFORMARION: Skipping Key Vault secret creation." -ForegroundColor Green
        Write-Host "`n`nIMPORTANT: Service Principal key is: $keyValue " -Backgroundcolor Red
        Write-Host "IMPORTANT: This key needs to be manually saved in the DXC Key Vault under the name: dxcPALAppSPNkey " -Backgroundcolor Red
    }
}
Else {
    Write-Host "`nINFORMATION: The App Registration $PalAppID already exists, attempting to assign Contributor permissions to existing App Registration ..." -ForegroundColor Green
    $app = Get-AzADApplication -DisplayName $PalAppID
    #New-AzRoleAssignment -ApplicationId $app.AppId -RoleDefinitionName Contributor
    if ($error) { 
        Write-Host "`nINFORMATION:The App Registration $PalAppID already has Contributor access to the subscription, script will continue."  -ForegroundColor Green
    }
    $ApplicationID = $app.AppId
    Write-Host "App ID:" $ApplicationID
    
    if ($Lighthouse -eq $False){
        # Obtain the secret from the Key Vault
        $error.Clear()
        $PalAppSecretName = $palAppID + "key"
        $secretvalue = Get-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName -ErrorAction Stop
        $keyValue = ([System.Net.NetworkCredential]::new("", $secretvalue.SecretValue).Password)

        if ($error) { 
            Write-Host "`nINFORMATION: Insufficient rights to read the key vault, will provide temporary rights."  -ForegroundColor Green
            # Add current context user to keyvault access policy temporarily
            Set-AzKeyVaultAccessPolicy -VaultName $dxcKeyVault -ObjectId $currentUserObjectID -PermissionsToSecrets get, set, list
            Write-Host "`nINFORMATION: Added" (Get-AzContext).Account "to" $dxcKeyVault "Access Policy Temporarily" -ForegroundColor Green 
            $secretvalue = Get-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName
            $keyValue = ([System.Net.NetworkCredential]::new("", $secretvalue.SecretValue).Password)
            Write-Host "`nINFORMATION: Do you want to remove the access to the Vault named" $dxcKeyVault -ForegroundColor Yellow  
            $RemovePrivs = (Read-Host -Prompt "(Y/N)?").ToUpper()
            if($RemovePrivs -eq 'Y'){
                #Remove current context user from keyvault access policy
                Write-Host "`nINFORMATION: Removed" (Get-AzContext).Account "rights from" $dxcKeyVault "Access Policy " -ForegroundColor Green           
                Remove-AzKeyVaultAccessPolicy -VaultName $dxcKeyVault -ObjectId $currentUserObjectID
            }
            else {
                Write-Host "`nINFORMATION: Left" (Get-AzContext).Account "temporary rights on" $dxcKeyVault "Access Policy " -ForegroundColor Green          
            }
        }
    }
    else{
        $keyValue = $dxcSPNSecretValue
    }
}
#======================================================================================================================
# COMPLETE THE REQUIRED PAL ACTIVITY
#======================================================================================================================
    
# Switch the variables
$dxcAppID = $ApplicationID
$PalAppSecretName = $palAppID + "key"
if ((!($keyValue)) -and ($Lighthouse -eq $False)){ 
    $secretValue = Get-AzKeyVaultSecret -VaultName $dxcKeyVault -Name $PalAppSecretName
    $keyValue = ([System.Net.NetworkCredential]::new("", $secretValue.SecretValue).Password)
}
elseif ((!($keyValue)) -and ($Lighthouse -eq $True)){
    Write-Host "ERROR: PAL App secret not found. If the '$PalAppID' service principal already exists you must input the secret as parameter 'dxcSPNSecretValue'.`nExiting... " -ForegroundColor Red
    exit
}

Write-Host "`nINFORMATION: Connecting to Azure using the Service Principal"  -ForegroundColor Green
$error.Clear()
Write-Host "Logging in using ID:$dxcAppID"
If ($dxcAppID -and $keyValue)  {  
    $Error.Clear()
    Start-Sleep -Seconds 5
    $dxcCred = New-Object System.Management.Automation.PSCredential ($dxcAppID, (ConvertTo-SecureString $keyValue -AsPlainText -Force))
    Connect-AzAccount -Subscription $dxcSubscriptionID -Environment (Get-AzEnvironment 'AzureCloud') -Tenant $dxcTenantID -Credential $dxcCred -ServicePrincipal -erroraction SilentlyContinue
    while( ($Error -ne $null) -and ($rep -le 3) ){
        try{
            Write-Host "Retrying Connection to Service Principal..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
            $Error.Clear()
            Connect-AzAccount -Subscription $dxcSubscriptionID -Environment (Get-AzEnvironment 'AzureCloud') -Tenant $dxcTenantID -Credential $dxcCred -ServicePrincipal -erroraction SilentlyContinue
            }
        catch{
        $rep += 1
            }
        }
}

Else {
    Write-Host "Unable to connect to Azure with the App ID and Key pair, script will exit."
    Exit
}
$dxcOutput = Get-AzManagementPartner -ErrorAction silentlyContinue
if ($dxcOutput){   
    If ($dxcOutput.PartnerId -eq $dxcMPNId){ 
        $dxcMPNStatus = $dxcOperation + "-Same" 
    }
    else { 
        $dxcMPNStatus = $dxcOperation + "-Different" 
    }
}
else {
    $dxcMPNStatus = $dxcOperation + "-None" 
}
    
$error.Clear()
Write-Host "`nINFORMATION: Performing the required PAL action.`n"  -ForegroundColor Green
switch($dxcMPNStatus) {
    "Get-Same"         { Write-Host "`nINFORMATION: The account is already associated with the mentioned MPN ID." -ForegroundColor Green ; Exit }
    "Get-Different"    { Write-Host "`nWARNING:     The account is not associated with the mentioned MPN ID. The current MPN ID is:" $dxcOutput.PartnerId "-" $dxcOutput.PartnerName -ForegroundColor Yellow ; Exit }
    "Get-None"         { Write-Host "`nWARNING:     The account is not associated with any MPN ID." -ForegroundColor Yellow ; Exit }
        
    "Add-Same"         { Write-Host "`nINFORMATION: The account is already associated with the mentioned MPN ID." -ForegroundColor Green ; Exit }
    "Add-Different"    { Write-Host "`nWARNING:     The account is already associated with another MPN ID:" $dxcOutput.PartnerId "-" $dxcOutput.PartnerName ". Please use 'Change' operation if you want to change the MPN ID to:" $dxcMPNId -ForegroundColor Yellow ; Exit } 
    "Add-None"         { 

        $Error.Clear()
        Start-Sleep -Seconds 5
        New-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue
        while( ($Error -ne $null) -and ($rep -le 3) ){
            try{
                Write-Host "Retrying PAL action..." -ForegroundColor Yellow
                Start-Sleep -Seconds 5
                $Error.Clear()
                New-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue
            }
            catch{
            $rep += 1
            }
        }
        Break 
    }
        
    "Delete-Different" { Write-Host "`nCannot perform Delete operation, the account is associated with a diferent MPN ID:" $dxcOutput.PartnerId "-" $dxcOutput.PartnerName -ForegroundColor Yellow ; Exit }
    "Delete-None"      { Write-Host "`nWARNING:     Unable to perform Delete operation, the account is not associated with any MPN ID." -ForegroundColor Yellow ; Exit }
    "Delete-Same"      {
                        $Error.Clear()
                        Start-Sleep -Seconds 5
                        Remove-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue
                        while( ($Error -ne $null) -and ($rep -le 3) ){
                            try{
                                Write-Host "Retrying PAL action..." -ForegroundColor Yellow
                                Start-Sleep -Seconds 5
                                $Error.Clear()
                                Remove-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue -erroraction SilentlyContinue
                            }
                            catch{
                            $rep += 1
                            }
                        }
                        Break
                    } 
        
    "Change-Same"      { Write-Host "`nINFORMATION: The account is already associated with the mentioned MPN ID. No change is required." -ForegroundColor Green ; Exit }
    "Change-Different" { 
                        $Error.Clear()
                        Start-Sleep -Seconds 5
                        Update-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue
                        while( ($Error -ne $null) -and ($rep -le 3) ){
                            try{
                                Write-Host "Retrying PAL action..." -ForegroundColor Yellow
                                Start-Sleep -Seconds 5
                                $Error.Clear()
                                Update-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue -erroraction SilentlyContinue
                            }
                            catch{
                            $rep += 1
                            }
                        }
                        Break 
                    }
    "Change-None"      { Write-Host "`nINFORMATION: The account is not associated with any MPN ID. Adding the MPN ID:" $dxcMPNId -ForegroundColor Green
                        New-AzManagementPartner -PartnerId $dxcMPNId
                    
                        $Error.Clear()
                        Start-Sleep -Seconds 5
                        New-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue
                        while( ($Error -ne $null) -and ($rep -le 3) ){
                            try{
                                Write-Host "Retrying PAL action..." -ForegroundColor Yellow
                                Start-Sleep -Seconds 5
                                $Error.Clear()
                                New-AzManagementPartner -PartnerId $dxcMPNId -ErrorAction SilentlyContinue
                            }
                            catch{
                            $rep += 1
                            }
                        }
                        Break 
                    }
                }
If ($error.Count -eq 0) { Write-Host "`nINFORMATION: " $dxcOperation "operation completed successfully."  -ForegroundColor Green }
else                    { Write-Host "`nWARNING:     Failed to perform" $dxcOperation "operation."  -ForegroundColor yellow }
Get-Variable -Name dxc* | Remove-Variable
Disconnect-AzAccount
Write-Host "`nINFORMATION: Script complete." -ForegroundColor Green


