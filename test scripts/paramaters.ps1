function Install-Office {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Version
    )
    Write-Host "I installed Office $Version. Yippee!"
}