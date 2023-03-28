$serverList = get-content "C:\Users\pherathmudiy\OneDrive - DXC Production\Desktop\list.txt"
foreach ($row in $serverList) {
    $serverName = $row.Split("`t ")[0] 
    write-host $serverName  

    
}

Convert-ExcelSheetToJson -InputFile "C:\Users\pherathmudiy\OneDrive - DXC Production\All downloads\ADHA-Application-Build-Specification-SVTA-Cutover v1.0.xlsx" -OutputFileName "C:\Users\pherathmudiy\OneDrive - DXC Production\Desktop\list.txt" -SheetName "VM Specs"