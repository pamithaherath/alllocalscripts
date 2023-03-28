<#
.SYNOPSIS
    Creates ANF volumes based on a build sheet

.DESCRIPTION
	Creates ANF volumes with the values specified in a build spreadsheet. Note that the module ImportExcel is a pre-requisite for this to operate. Note also that this 
	script is NOT particularly user-friendly.

.PARAMETER InputFile
    Parameter to specify the input file. Note this file must be a spreadsheet, and it must contain an NfsExports tab with appropriate column names. The spreadsheet must be closed.

.PARAMETER DryRun
    Optional parameter to disable the script's default "dry-run" mode of operation. This must be set to $false for throughputs to be updated

.PARAMETER AppendExportClients
	Optional parameter so that for existing volumes, the export client list in the spreadsheet is appended to the list already attached to the volume. This parameter defaults to $true.

.PARAMETER SetDefaultThroughputs
	Optional parameter so that for existing volumes, the throughput is set to the default value. This setting defaults to $false, meaning that existing volumes will have their throughputs remain as-is (except if ProcessThroughputOverrides is set)

.PARAMETER ProcessThroughputOverrides
	Optional parameter so that for all volumes, the throughput will be set to reflect any overrides specified in the spreadsheet. This parameter defaults to $true.

.INPUTS
    None; cannot be used on the pipeline.

.OUTPUTS
    Volume creations will be shown on screen.

.EXAMPLE
    To create volumes based on a biuld sheet, disabling the default dry-run functionality
        .\8705-AnfCreateVolumes.ps1 -InputFile "SomeInputFile.xlsx" -DryRun $false

#>



Param($InputFile = "C:\Users\pherathmudiy\OneDrive - DXC Production\All downloads\ADHA-Application-Build-Specification-SDC v1.2 (1).xlsx",
#Param($InputFile = "C:\Users\cmurch\GSUPoC\DHAgencySP POC - General\07 Environment\Build Sheets\ADHA-Application-Build-Specifications-NPP OEM Accenture v0.3.xlsx",
		$DryRun = $true,
		$AppendExportClients = $true,
		$SetDefaultThroughputs = $false,
		$ProcessThroughputOverrides = $true)

if ($SetDefaultThroughputs -and $ProcessThroughputOverrides) {
	write-host -ForegroundColor Red "SetDefaultThroughputs and ProcessThroughputOverrides were both set to true. This is ambiguous. Please specify one or the other."
	exit
}

$dxcMonitoredTag = @{"dxcMonitored"="True"}

if ($DryRun) {
    write-host "Note: Running in dry-run mode only. No volumes will be created."
}

Write-Host -ForegroundColor Green "Loading VM build sheet $InputFile for ANF data"
try {
  $buildSheetExcel = Import-Excel -Path $InputFile -WorksheetName "NfsExports"
} catch {
  write-host -ForegroundColor Red "Unable to load $InputFile. Please make sure it isn't open in Excel."
  exit
}

$volumeFile = @{}
foreach ($buildSheetRow in $buildSheetExcel) {
    $volName = $buildSheetRow."FMO Volume Name"
    $netApp = $buildSheetRow."ANF Name"
    if ($volName) {
		#We only take action when a row status is "Not created" or "Not updated". Any other status means we skip the row.
		if ($buildSheetRow.Status -ne "Not created" -and $buildSheetRow.Status -ne "Not updated") {
			continue
		}
		$volumeFile.Add("$netapp-$volName",$buildSheetRow)
	}
}


write-host -ForegroundColor Green "`tProcessing..."
#Main loop
foreach ($volumeFileKey in $volumeFile.Keys) {
	$volumeRow = $volumeFile[$volumeFileKey]
	$volumeSize = [int]($volumeRow."Configured Quota (GB)")
	$volumeSize = $volumeSize*1024*1024*1024

	#region Calculate platform variables
	$anfEnvironmentShort = $volumeRow."ANF Name".Substring(4,3) #something like "npp" or "prd"
	$anfLocationShort = $volumeRow."ANF Name".Substring(12,4) #something like "auc1"
	$anfLocationShort = $anfLocationShort.Replace("-","")
	$anfServiceLevel = "Premium"

	if ($volumeRow.'Capacity Pool' -match "standard") {
		$anfServiceLevel = "Standard"
		$defaultThroughput = ($volumeSize / 1024 / 1024 / 1024) / 1000.0 * 16.0
	} elseif ($volumeRow.'Capacity Pool' -match "premium") {
		$anfServiceLevel = "Premium"
		$defaultThroughput = ($volumeSize / 1024 / 1024 / 1024) / 1000.0 * 64.0
	} elseif ($volumeRow.'Capacity Pool' -match "ultra") {
		$anfServiceLevel = "Ultra"
		$defaultThroughput = ($volumeSize / 1024 / 1024 / 1024) / 1000.0 * 128.0
	} else {
		write-host -ForegroundColor Red "`tUnable to find a service level match for capacity pool $($volumeRow.'Capacity Pool'). Skipping."
		continue
	}
	if ($anfEnvironmentShort -eq "npp" -and $anfLocationShort -eq "auc1") {
        
		$anfSubnetId = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-network-auc1-001/providers/Microsoft.Network/virtualNetworks/vnet-npp-mgt-auc1-002/subnets/sn-npp-auc1-mgt-netapp"
		$anfResourceGroupName = "rg-npp-mgt-anf-auc1-001"
		$anfStandardSnapshotPolicy = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-anf-auc1-001/providers/Microsoft.NetApp/netAppAccounts/anf-npp-mgt-auc1-001/snapshotPolicies/snpol-standard"
		$anfResourceGroupName = "rg-npp-mgt-anf-auc1-001"
	} elseif ($anfEnvironmentShort -eq "npp" -and $anfLocationShort -eq "aue") {
		$anfSubnetId = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-network-aue-001/providers/Microsoft.Network/virtualNetworks/vnet-npp-mgt-aue-002/subnets/sn-npp-aue-mgt-anf"
		$anfResourceGroupName = "rg-npp-mgt-anf-aue-001"
		$anfStandardSnapshotPolicy = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-anf-aue-001/providers/Microsoft.NetApp/netAppAccounts/anf-npp-mgt-aue-001/snapshotPolicies/snpol-standard"
	} elseif ($anfEnvironmentShort -eq "npp" -and $anfLocationShort -eq "ase") {
		$anfSubnetId = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-network-ase-001/providers/Microsoft.Network/virtualNetworks/vnet-npp-mgt-ase-002/subnets/sn-npp-ase-mgt-anf"
		$anfResourceGroupName = "rg-npp-mgt-anf-ase-001"
		$anfStandardSnapshotPolicy = "/subscriptions/19a2b5f5-6c86-4cb3-befd-170ead3c865a/resourceGroups/rg-npp-mgt-anf-ase-001/providers/Microsoft.NetApp/netAppAccounts/anf-npp-mgt-ase-001/snapshotPolicies/snpol-standard"
	} elseif ($anfEnvironmentShort -eq "prd" -and $anfLocationShort -eq "aue") {
		$anfSubnetId = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-netapp-aue/providers/Microsoft.Network/virtualNetworks/vnet-prd-mgt-netapp-aue/subnets/sn-prd-aue-mgt-netapp"
		$anfResourceGroupName = "rg-prd-mgt-anf-aue-001"
		$anfStandardSnapshotPolicy = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-anf-aue-001/providers/Microsoft.NetApp/netAppAccounts/anf-prd-mgt-aue-001/snapshotPolicies/snpol-standard"
	} elseif ($anfEnvironmentShort -eq "prd" -and $anfLocationShort -eq "ase") {
		$anfSubnetId = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-netapp-ase/providers/Microsoft.Network/virtualNetworks/vnet-prd-mgt-netapp-ase/subnets/sn-prd-ase-mgt-netapp"
		$anfResourceGroupName = "rg-prd-mgt-anf-ase-001"
		$anfStandardSnapshotPolicy = "/subscriptions/1f0a12a1-e38b-4feb-8b94-5928640bcd23/resourceGroups/rg-prd-mgt-anf-ase-001/providers/Microsoft.NetApp/netAppAccounts/anf-prd-mgt-ase-001/snapshotPolicies/snpol-standard"
	} else {
		write-host -ForegroundColor Red "Unable to find an appropriate subnet for environment '$anfEnvironmentShort' at location '$anfLocationShort'. Perhaps this combination was not planned."
		exit
	}

	if ($anfLocationShort -eq "auc1") {
		$anfLocation = "australiacentral"
	} elseif ($anfLocationShort -eq "auc2") {
		$anfLocation = "australiacentral2"
	} elseif ($anfLocationShort -eq "aue") {
		$anfLocation = "australiaeast"
	} elseif ($anfLocationShort -eq "ase") {
		$anfLocation = "australiasoutheast"
	}
	#endregion

	#If we don't have a reasonable list of export clients, we cannot proceed, so we skip instead.
	if ($volumeRow."FMO Export Clients Calculated" -match "10.") {
		write-host "$($volumerow."FMO Volume Name")"

		$throughput = $defaultThroughput

		$creationToken = $volumerow."FMO File Path"
		$futureAllowedClientsString = $($volumeRow.'FMO Export Clients Calculated')
		$futureAllowedClientsArray = $futureAllowedClientsString.Split(",")
		$currentAllowedClientsString = ""
		$existingVolume = $null
		try {
			$existingVolume = Get-AzNetAppFilesVolume -ResourceGroupName $anfResourceGroupName -AccountName $volumeRow."ANF Name" -PoolName $volumeRow."Capacity Pool" -Name $volumeRow."FMO Volume Name" -ErrorAction Silentlycontinue
		} catch {
			#existing share didn't exist so nothing to do here
		}
		if ($null -ne $existingVolume) { #found an existing share
			if ($SetDefaultThroughputs -eq $false) {
				$throughput = $existingVolume.ThroughputMibps
			}
			$currentAllowedClientsString = $existingVolume.ExportPolicy.Rules.AllowedClients #get current export policy

			if ($currentAllowedClientsString -ne $futureAllowedClientsString) { #old export policy does not align with new
				write-host "`tExport list doesn't align: $($volumeRow.'FMO Volume Name') -- Old: $currentAllowedClientsString, New: $futureAllowedClientsString"
				$currentAllowedClientsArray = $currentAllowedClientsString.Split(",")
				if ($AppendExportClients) { #we've been told to be additive - so we add the client lists together rather than simply blat the new over the old
					foreach ($currentClient in $currentAllowedClientsArray) {
						if (!$futureAllowedClientsArray.Contains($currentClient)) {
							write-host "`tAdded $currentClient to new list."
							$futureAllowedClientsArray += $currentClient
						}
					}
					$futureAllowedClientsString = $futureAllowedClientsArray -join ","
					write-host "`tNew list is $futureAllowedClientsString"
				}
			}
		}
		if ($ProcessThroughputOverrides -eq $true) {
			if ($volumeRow."ThroughputMibps Override") {
				if ($volumeRow."ThroughputMibps Override" -ne "") {
					$throughput = $volumeRow."ThroughputMibps Override"
					write-host "`tOverriding default throughput for $($volumeRow.'FMO Volume Name') to $($throughput)MiB/s"
				}
			}
		}

	   	$rule1 = @{
			RuleIndex = 1
			UnixReadWrite = $true
			UnixReadOnly = $false
			Kerberos5ReadOnly = $false
			Kerberos5ReadWrite = $false
			Kerberos5pReadOnly = $false
			Kerberos5pReadWrite = $false
			Kerberos5iReadOnly = $false
			Kerberos5iReadWrite = $false
			hasRootAccess = $true
			Cifs = $false
			Nfsv3 = $false
			Nfsv41 = $true
			AllowedClients = $futureAllowedClientsString
		}

		$volumeExportPolicy = @{ 
			Rules = ($rule1)
		}

		$snapshotPolicy = $anfStandardSnapshotPolicy

		if ($volumeRow.DisableSnapshots) {
			if ($volumeRow.DisableSnapshots -eq "yes") {
				write-host "`tDisabling snapshot for $($volumeRow.'FMO Volume Name')"
				$snapshotPolicy = $null
			}
		}
		$newVolume = $null
		write-host "`tCreating/Updating $($volumeRow."FMO Volume Name") with size $($volumeSize/1024/1024/1024)GB and throughput $($throughput)MiB/s."
		if (!$DryRun) {
			if ($null -ne $snapshotPolicy) {
				$newVolume = New-AzNetAppFilesVolume -ResourceGroupName $anfResourceGroupName -AccountName $volumeRow."ANF Name" -PoolName $volumeRow."Capacity Pool" -Name $volumeRow."FMO Volume Name" -CreationToken $creationToken -location $anfLocation -SubnetId $anfSubnetId -UsageThreshold $volumeSize -ExportPolicy $volumeExportPolicy -ProtocolType "NFSv4.1" -SnapshotPolicyId $snapshotPolicy -ThroughputMibps $throughput -ServiceLevel $anfServiceLevel
			} else {
				$newVolume = New-AzNetAppFilesVolume -ResourceGroupName $anfResourceGroupName -AccountName $volumeRow."ANF Name" -PoolName $volumeRow."Capacity Pool" -Name $volumeRow."FMO Volume Name" -CreationToken $creationToken -location $anfLocation -SubnetId $anfSubnetId -UsageThreshold $volumeSize -ExportPolicy $volumeExportPolicy -ProtocolType "NFSv4.1" -ThroughputMibps $throughput -ServiceLevel $anfServiceLevel			
			}
			if ($null -ne $newVolume) {
				#Set dxcMonitored tag on all volumes..
				$newTag = Update-AzTag  -ResourceId $newVolume.Id -Tag $dxcMonitoredTag -operation Merge
				write-host "`tCreated. NFS server IP address was $($newVolume.MountTargets.IpAddress)"
			} else {
				write-host -ForegroundColor Red "`tError creating volume $($volumeRow."FMO Volume Name"). Please review the running NetApp - there may be a defunct volume which needs to be removed, and the capacity pool may need to be expanded."
				exit
			}
		}
	}
}