$inFile1 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\rawin RPC.csv"
$inFile2 = Import-Csv "C:\Users\pherathmudiy\OneDrive - DXC Production\ADHA\Change Requests\Modify NSG rules prod management\AUE\rawinudp.csv"



        $destinationport = $inFile1.DestPort_d
        $Udestinationport = $inFile2.DestPort_d

        Write-Host "$destinationport END           "
        Write-Host $Udestinationport