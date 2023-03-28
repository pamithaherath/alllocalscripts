

$mntnames = Get-AzNetAppFilesvolume -ResourceGroupName "rg-npp-mgt-anf-aue-001" -AccountName "anf-npp-mgt-aue-001" -PoolName "anfcp-ultra-mgt-aue-001"
$InputFile = "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Testing GSUPOC\ADHA-Application-Build-Specification-PF2 v1.2 - Copy.xlsx"


$mountPointPath = @{}

foreach ($nfsMountInfo in $mntnames) {
  $pathName = $nfsMountInfo.CreationToken
  $ipAddress = $nfsMountInfo.MountTargets.IpAddress
  Write-Host $pathName
  $mountPointPath.Add($pathName,$ipAddress)
}

$ExcelObj = New-Object -comobject Excel.Application
$ExcelWorkBook = $ExcelObj.Workbooks.Open($InputFile)
$ExcelWorkSheet = $ExcelWorkBook.Sheets.Item("NfsExports")
$usedrange = $ExcelWorkSheet.UsedRange.Rows.count



for ($i = 2; $i -le $usedrange ; $i++) {
  $poolname=$ExcelWorkSheet.Columns.Item(2).Rows.Item($i).Text #need to fix (2)
  $NfsVolumeName = $ExcelWorkSheet.Columns.Item(5).Rows.Item($i).Text #need to fix (5)
  $NfsMountPointEstimate = $ExcelWorkSheet.Columns.Item(6).Rows.Item($i).Text #need to fix (6)
  
  
  if($poolname -eq "anfcp-ultra-mgt-aue-001") {
    $nfsMountPathSummary = "$($mountPointPath[$NfsVolumeName]):/$NfsVolumeName $NfsMountPointEstimate"
    write-host $nfsMountPathSummary
    $ExcelWorkSheet.Columns.Item(21).Rows.Item($i) = $nfsMountPathSummary
  }
}

$ExcelWorkBook.Save()
$ExcelWorkBook.close($true)