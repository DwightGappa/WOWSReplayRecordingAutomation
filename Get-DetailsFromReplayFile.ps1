
[CmdletBinding()]

param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    $WOWSReplayFilePath
)

    
begin {
    $CultureRussianRussia = [CultureInfo]::CreateSpecificCulture("ru-RU")
}
    
process {
    $replayFileObject = get-item $WOWSReplayFilePath
    $arenaInfo = & $PSScriptRoot\Get-ArenaInfoFromWOWSREPLAY.ps1 $WOWSReplayFilePath
    $replayDetails = $arenaInfo | Select-Object playerName, dateTime, playerVehicle, clientVersionFromExe
    $replayDetails.clientVersionFromExe = $replayDetails.clientVersionFromExe -replace ",", "."
    $replayDetails.dateTime = [datetime]::Parse($replayDetails.dateTime, $CultureRussianRussia) #Using Russian Russia culture because dateTime is formated dd.mm.yyyy HH:mm:ss i.e. Russian date format
    $replayDetails | Add-Member -NotePropertyName "title" -NotePropertyValue $replayFileObject.BaseName
    $replayDetails | Add-Member -NotePropertyName date -NotePropertyValue $replayDetails.dateTime.ToString("yyyy-MM-dd", [CultureInfo]::InvariantCulture)
    $replayDetails | Add-Member -NotePropertyName "ReplayFileName" -NotePropertyValue $replayFileObject.name
    $replayDetails | Select-Object title, playerName, date, playerVehicle, clientVersionFromExe, dateTime, ReplayFileName
        
}
    
end {
        
}
