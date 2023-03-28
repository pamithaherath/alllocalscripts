
<#
    Convert the XLS Build Sheet into a JSON file that can be consumed by the Azure Devops Pipeline
#>

Param($InputFile = "C:\Users\pherathmudiy\OneDrive - DXC Production\All downloads\ADHA-Application-Build-Specification-PTE v1.0.xlsx",
      $OutputFile = "C:\Users\pherathmudiy\OneDrive - DXC Production\Desktop\GenerationTest.json",
      $SubnetFilter = "app",
      $ResourceGroup = "rg-itoh",
      $OU = "OU=DEV,OU=Servers,OU=abc,DC=mycompany,DC=gov,DC=au",
      $LifeCycleTag = "ABC",
      $BootDiagnostics = "stbootdiag001",
      $Location = "australiaeast",
      $EnvironmentTag = "Test",
      $Domain = "abc.mycompany.gov.au",
      $DCSManagementServer = "VMDCS01",
      $DCSAltManagementServer = "VDCS02",
      $SplunkAgentDeploymentServer = "99.99.99.99",
      $KeyVaultId = "/subscriptions/Subscription-GUID/resourceGroups/rg-itohs/providers/Microsoft.KeyVault/vaults/kv-itoh",
      $PipelineName = "testPipeline.yaml",
      $accountPrefix = "ABC",
      $domainControllerIP1 = "99.99.99.99",
      $domainControllerIP2 = "99.99.99.99",
      $BackupTag = "False"

)

# Use these below and uncomment further down if you have a Compute Gallery for Custom Images
# $customImageIdOel610 = "/subscriptions/Subscription-GUID/resourceGroups/rg-name/providers/Microsoft.Compute/galleries/gallery-name/images/image-name/versions/9.9.9"
# $customImageIdOel79 = "/subscriptions/Subscription-GUID/resourceGroups/rg-name/providers/Microsoft.Compute/galleries/gallery-name/images/image-name/versions/9.9.9"
# $customImageIdWin2016 = "/subscriptions/Subscription-GUID/resourceGroups/rg-name/providers/Microsoft.Compute/galleries/gallery-name/images/image-name/versions/9.9.9"
# $customImageIdWin2019 = "/subscriptions/Subscription-GUID/resourceGroups/rg-name/providers/Microsoft.Compute/galleries/gallery-name/images/image-name/versions/9.9.9"

try {
    Import-Module ImportExcel
} catch {throw ; return}

#region LoadAndParse
#Load core info from starting sheet
Write-Host -ForegroundColor Green "Loading BuildSheet $InputFile"
$vmSpecSheet = Import-Excel -Path $InputFile -WorksheetName "VM Specs"
$vmInfo = @{}
$skipCount = 0
foreach ($buildSheetRow in $vmSpecSheet) {
    $vmName = $buildSheetRow."VM Name"
    if ($vmName) {
        #if we've got a subnetfilter, we should skip VMs which don't match
        if ($SubnetFilter -ne "") {
            if ($buildSheetRow.subnet -notmatch $SubnetFilter) {
                $skipCount += 1
                continue
            }
        }
        $vmInfo.Add($vmName,$buildSheetRow)
    }
}

$jsonObject = [pscustomobject]@{
    "`$schema" = "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#"
    "contentVersion" = "1.0.0.0"
}

Write-Host -ForegroundColor Green "`tCreating initial parameter section"
#region parameters section - initial part
$parametersObject = [pscustomobject]@{
    "adminUser" = [pscustomobject]@{
        "reference" = [pscustomobject]@{
            "keyVault" = [pscustomobject]@{
                "id" = $keyVaultId
            }
            "secretName" = "$($accountPrefix.ToLower())-localadmin-user"
        }
    }
    "adminPassword" = [pscustomobject]@{
        "reference" = [pscustomobject]@{
            "keyVault" = [pscustomobject]@{
                "id" = $keyVaultId
            }
            "secretName" = "$($accountPrefix.ToLower())-localadmin-password"
        }
    }
}
#endregion

#region
Write-Host -ForegroundColor Green "`tPopulating globals"
$resourceGroupsObject = @()

$resourceGroupsObject += [pscustomobject]@{
    "name" = $resourceGroup
    "location" = $location
}

$joinDomainObject = @()

$joinDomainObject = [pscustomobject]@{
    "domain" = $domain
    "ouPath" = $ou
}

$globalsValue = [pscustomobject]@{
    "bootDiagnosticsStorageAccount" = $bootDiagnostics
    "resourceGroups" = $resourceGroupsObject
    "dcsManagementServer" = $dcsManagementServer
    "dcsAltManagementServer" = $dcsAltManagementServer
    "splunkAgentDeploymentServer" = $splunkAgentDeploymentServer
    "domainControllerIP1" = $domainControllerIP1
    "domainControllerIP2" = $domainControllerIP2
    "joinDomain" = $joinDomainObject
}

$globalsObject = [pscustomobject]@{
    "value" = $globalsValue
}

#endregion

#region tags
Write-Host -ForegroundColor Green "`tPopulating tags"
$baseTagValue = [pscustomobject]@{
    "Owner" = "Test Team"
    "Environment" = $environmentTag
    "Business Criticality" = "High"
    "Application Management team" = "Test Team"
    "Platform Management team" = "DXC"
    "Created By" = "DXC"
    "Lifecycle" = $lifecycleTag
    "AzDoRepo" = "Test Repo"
    "AzDoPipeline" = $PipelineName
}

$tagObject = [pscustomobject]@{
    "value" = $baseTagValue
}
#endregion

#region availabilitySets
Write-Host -ForegroundColor Green "`tPopulating availabilitySets"
$availabilitySetList = @{}
$availabilitySetObject = [pscustomobject]@{}
$availabilitySetValues = @()
foreach ($vmKey in $vmInfo.Keys) {
    $vm = $vmInfo[$vmKey]
    $availabilitySet = $vm."Availability Set Name"


    $vmName = $vm."VM Name"
    if (!$availabilitySetList.ContainsKey($availabilitySet)) {
        $availabilitySetValues += [pscustomObject]@{
            "asName" = $availabilitySet
            "location" = $location
            "skuName" = "Aligned"
            "platformFaultDomainCount" = 2
            "platformUpdateDomainCount" = 5
        }
        $availabilitySetList.Add($availabilitySet,$availabilitySet)
    }
}
#endregion

#region VMs
Write-Host -ForegroundColor Green "`tPopulating virtualMachines"
$vmSetObjectLinux = [pscustomobject]@{}
$vmSetValuesLinux = @()
$vmSetObjectWindows = [pscustomobject]@{}
$vmSetValuesWindows = @()

$vmCount = 0

foreach ($vmKey in $vmInfo.Keys) {
    $vm = $vmInfo[$vmKey]
    $vmName = $vm."VM Name"

    # This only works if column naming is consistent, any issues check column headings
    $dataDiskValues = @()
    for ($i=1; $i -le 5; $i++)
    {
        if ($vm."Data Disk$i Size") {
            $storageType = "unknown"
            if ($vm."Data Disk$i Type" -match "Premium") {
                $storageType = "Premium_LRS"
            } elseif ($vm."Data Disk$i Type" -match "Standard") {
                $storageType = "StandardSSD_LRS"
            } else {
                $storageType = "unknown"
                write-host -ForegroundColor Yellow "`t`tUnknown storage type specified on $($vm."VM Name"), disk $i. Value found was [$($vm."Data Disk$i Type")]. Please check the source data."
            }

            $dataDiskValues += [pscustomobject]@{
                "dataDiskName" = $vm."Data Disk$i Name"
                "dataDiskSizeGB" = $vm."Data Disk$i Size".ToString().TrimEnd("TtGgMmBb")
                "dataLun" = ($i-1).ToString()
                "dataDiskcreateOption" = "Empty"
                "dataDiskmanagedDiskStorageAccountType" = $storageType
            }
        }
    }

    $appTierTag = "NA"
    if ($vm.subnet -match "-web") {
        $appTierTag = "WS"
    } elseif ($vm.subnet -match "-database") {
        $appTierTag = "DB"
    } elseif ($vm.subnet -match "-app") {
        $appTierTag = "AS"
    }
    $tagValues = [pscustomobject]@{
        "Application Name" = $vm."Server Role"
        "Application Service" = $vm.service.ToUpper()
        "AppTier" = $appTierTag
        "DXCManagedBackup" = $BackupTag
        "PatchTier" = "NA"
    }

    $osVersion = ($vm."OS Version").ToString().ToUpper()

    if (($osVersion -eq "OEL7.9") -or ($osVersion -eq "OEL 7.9") -or ($osVersion -eq "Linux 7") -or ($osVersion -eq "7.9")) {
        $imageReferencePublisher = "Oracle"
        $imageReferenceOffer = "Oracle-Linux"
        $imageReferenceSku = "79-gen2"
        $imageReferenceVersion = "latest"
#        $customImageId = $customImageIdOel79
        $osDiskType = "Linux"
    } elseif ($osVersion -eq "OEL6.10") {
        $imageReferencePublisher = ""
        $imageReferenceOffer = "Oracle-Linux"
        $imageReferenceSku = "6.10"
        $imageReferenceVersion = "6.10.00"
#        $customImageId = $customImageIdOel610
        $osDiskType = "Linux"
    } elseif (($osVersion -eq "Windows 2016 STD 64-Bit") -or ($osVersion -eq "Windows Server 2016 Datacenter") -or ($osVersion -eq "2016") -or ($osVersion -eq "Windows 2016 Custom SOE") -or ($osVersion -eq "Server 2016")){
        $imageReferencePublisher = "MicrosoftWindowsServer"
        $imageReferenceOffer = "WindowsServer"
        $imageReferenceSku = "2016-Datacenter"
        $imageReferenceVersion = "latest"
#        $customImageId = $customImageIdWin2016
        $osDiskType = "Windows"
    } elseif (($osVersion -eq "Windows 2019 STD 64-Bit")  -or ($osVersion -eq "Server 2019")){
        $imageReferencePublisher = "MicrosoftWindowsServer"
        $imageReferenceOffer = "WindowsServer"
        $imageReferenceSku = "2019-Datacenter"
        $imageReferenceVersion = "latest"
#        $customImageId = $customImageIdWin2019
        $osDiskType = "Windows"
    } else {
        write-host -ForegroundColor Yellow "`t`tUnknown OS version specified on $($vm."VM Name"). Value found was [$($vm."OS Version")]. Please check the source data."
    }

    $osStorageType = "unknown"
    if ($vm."OS Disk Type (Standard SSD etc)" -match "Premium") {
        $osStorageType = "Premium_LRS"
    } elseif ($vm."OS Disk Type (Standard SSD etc)" -match "Standard") {
        $osStorageType = "StandardSSD_LRS"
    } else {
        $osStorageType = "unknown"
        write-host -ForegroundColor Yellow "`t`tUnknown storage type specified on $($vm."VM Name"), OS disk. Value found was [$($vm."OS Disk Type (Standard SSD etc)")]. Please check the source data."
    }
    try {
        if ($vm."Operating System" -eq "Linux")
        {
            $vmSetValuesLinux += [pscustomObject]@{
                "name" = $vm."VM Name"
                "vnetResourceGroupName" = $vm."Virtual Network Resource Group"
                "vnetName" = $vm."Virtual Network"
                "subnetName" = $vm.subnet
                "nicName" = $vm."NIC Name"
                "enableAcceleratedNetworking" = $false
                "region" = $location
                "availabilitySetName" = $vm."Availability Set Name"
                "staticIP" = $vm.IP.Replace("Dynamic","")
                "bootDiagnosticsEnabled" = "true"
                "vmSize" = $vm."Instance size"

                "imageReferencePublisher" = $imageReferencePublisher
                "imageReferenceOffer" = $imageReferenceOffer
                "imageReferenceSku" = $imageReferenceSku
                "imageReferenceVersion" = $imageReferenceVersion
#                "customImageId" = $customImageId

                "osDiskName" = $vm."OS Disk Name".Replace("`r`n","") #not sure why people have done this
                "osDiskSizeGB" = $vm."OS Disk Size".ToString().TrimEnd("TtGgBb")
                "osDiskType" = $osDiskType
                "osDiskcaching" = "ReadWrite"
                "osDiskcreateOption" = "FromImage"
                "osDiskmanagedDiskStorageAccountType" = $osStorageType

                "dataDisks" = $dataDiskValues
                "tags" = $tagValues
            }
        }

        if ($vm."Operating System" -eq "Windows")
        {
            $vmSetValuesWindows += [pscustomObject]@{
                "name" = $vm."VM Name"
                "vnetResourceGroupName" = $vm."Virtual Network Resource Group"
                "vnetName" = $vm."Virtual Network"
                "subnetName" = $vm.subnet
                "nicName" = $vm."NIC Name"
                "enableAcceleratedNetworking" = $false
                "region" = $location
                "availabilitySetName" = $vm."Availability Set Name"
                "staticIP" = $vm.IP.Replace("Dynamic","")
                "bootDiagnosticsEnabled" = "true"
                "vmSize" = $vm."Instance size"

                "imageReferencePublisher" = $imageReferencePublisher
                "imageReferenceOffer" = $imageReferenceOffer
                "imageReferenceSku" = $imageReferenceSku
                "imageReferenceVersion" = $imageReferenceVersion
#                "customImageId" = $customImageId

                "osDiskName" = $vm."OS Disk Name".Replace("`r`n","") #not sure why people have done this
                "osDiskSizeGB" = $vm."OS Disk Size".ToString().TrimEnd("TtGgBb")
                "osDiskType" = $osDiskType
                "osDiskcaching" = "ReadWrite"
                "osDiskcreateOption" = "FromImage"
                "osDiskmanagedDiskStorageAccountType" = $osStorageType

                "dataDisks" = $dataDiskValues
                "tags" = $tagValues
            }
        }

        $vmCount += 1

    } catch {
        write-host -ForegroundColor Yellow "`t`tError trying to parse row for $($vm."VM Name"). Please check the source data."
    }
}
Write-Host -ForegroundColor Green "`t`tPopulated $vmCount virtual machines; skipped $skipCount due to filter"
#endregion

Write-Host -ForegroundColor Green "`tMerging sections"
$parametersObject | Add-Member -MemberType NoteProperty -name "globals" -Value $globalsObject
$parametersObject | Add-Member -MemberType NoteProperty -name "tags" -Value $tagObject

$availabilitySetObject | Add-Member -MemberType NoteProperty -name "value" -Value $availabilitySetValues
$parametersObject | Add-Member -MemberType NoteProperty -name "availabilitySets" -Value $availabilitySetObject

$vmSetObjectLinux | Add-Member -MemberType NoteProperty -name "value" -Value $vmSetValuesLinux
$parametersObject | Add-Member -MemberType NoteProperty -name "virtualMachinesLinux" -Value $vmSetObjectLinux

$vmSetObjectWindows | Add-Member -MemberType NoteProperty -name "value" -Value $vmSetValuesWindows
$parametersObject | Add-Member -MemberType NoteProperty -name "virtualMachinesWindows" -Value $vmSetObjectWindows


$jsonObject | Add-Member -MemberType NoteProperty -Name "parameters" -Value $parametersObject

Write-Host -ForegroundColor Green "`tWriting output file $outputFile"
$jsonObject | ConvertTo-Json -Depth 50 | out-file $outputFile -Force
<#DXC

    DXC DXC

    © 2022 GitHub, Inc.

    Help
    Support
    API
    Training
    Blog
    About

GitHub Enterprise Server 3.5.7#>
