Select-AzSubscription -SubscriptionName 'NINP-Management'
$mntnames = Get-AzNetAppFilesvolume -ResourceGroupName "rg-npp-mgt-anf-aue-001" -AccountName "anf-npp-mgt-aue-001" -PoolName "anfcp-ultra-mgt-aue-001"
$InputFile = "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Testing GSUPOC\ADHA-Application-Build-Specification-PF2 v1.2 - Copy (3).xlsx"



$fullnamearray = @{}
$j=0
$anffullpath2ndhalf = ""
$anffullpathip = ""
$nametodelete = ""

foreach ($mntname in $mntnames) 
{
  
  $ip = $mntname.MountTargets.IpAddress
  $name  = $mntname.Name.Split("/",3)[2]
  $furthername = $name.Split("_",3)[0]
  
  $fullname = "$ip/$furthername"
  $fullnamearray[$j] = $fullname
  $j++
  
}


$ExcelObj = New-Object -comobject Excel.Application
$ExcelWorkBook = $ExcelObj.Workbooks.Open($InputFile)
$ExcelWorkSheet = $ExcelWorkBook.Sheets.Item("NfsExports")
$usedrange = $ExcelWorkSheet.UsedRange.Rows.count


    for ($i = 2; $i -le $usedrange ; $i++) {
      $poolname=$ExcelWorkSheet.Columns.Item(2).Rows.Item($i).Text
      $Fullpath=$ExcelWorkSheet.Columns.Item(21).Rows.Item($i).Text
      
      if($poolname -eq "anfcp-ultra-mgt-aue-001")
      {

        $currentfulpath =  $Fullpath.Split("/",3)[1]
        $currentfulpathwithoutip =  $Fullpath.Split("/",2)[1]
        
       #Write-Host $currentfulpath
        for ($k = 0; $k -lt $fullnamearray.Count; $k++) 
        {
          #write-host  $fullnamearray[$i].Split("/",2)[0]
        
            $anffullpath2ndhalf = $fullnamearray[$k].Split("/",2)[1]
            $anffullpathip = $fullnamearray[$k].Split("/",2)[0]
            $nametodelete = "$anffullpathip/$anffullpath2ndhalf"

            
            if($currentfulpath -eq "$anffullpath2ndhalf-apps-pcehr ")
            {
              
              Write-Host "$anffullpathip/$currentfulpathwithoutip"
              $ExcelWorkSheet.Columns.Item(21).Rows.Item($i) = "$anffullpathip/$currentfulpathwithoutip"
              
              #$fullnamearray.Remove($nametodelete)

            }
            elseif ($currentfulpath -eq "$anffullpath2ndhalf ") {
              Write-Host "Updating Column U with $anffullpathip/$currentfulpathwithoutip" -ForegroundColor DarkGreen
              $ExcelWorkSheet.Columns.Item(21).Rows.Item($i) = "$anffullpathip/$currentfulpathwithoutip"
              
              #$fullnamearray.Remove($nametodelete)
            }
            elseif ($currentfulpath -eq "$anffullpath2ndhalf-templatepackage ") {
              Write-Host "Updating Column U with $anffullpathip/$currentfulpathwithoutip" -ForegroundColor DarkGreen
              $ExcelWorkSheet.Columns.Item(21).Rows.Item($i) = "$anffullpathip/$currentfulpathwithoutip"
              $fullnamearray.Remove("$anffullpathip/$anffullpath2ndhalf")
              
              #$fullnamearray.Remove($nametodelete)
            }
            elseif ($currentfulpath -eq "$anffullpath2ndhalf-opt ") {
              Write-Host "Updating Column U with $anffullpathip/$currentfulpathwithoutip" -ForegroundColor DarkGreen
              $ExcelWorkSheet.Columns.Item(21).Rows.Item($i) = "$anffullpathip/$currentfulpathwithoutip"
              $fullnamearray.Remove("$anffullpathip/$anffullpath2ndhalf")
              $fullnamearray.Remove($nametodelete)
            }
            #else {
             # Write-Host "Updating task has been complted or no any further matching vols"
            #}
        }
       
        
      }
      $fullnamearray.Remove($nametodelete)
    }
   Write-Host $fullnamearray.Count
    $ExcelWorkBook.Save()
    $ExcelWorkBook.close($true)










