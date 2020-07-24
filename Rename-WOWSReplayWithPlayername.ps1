[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    $WOWSReplayFilePath
)
    
begin {
        
}
    
process {
    $replayFileObject = Get-item $WOWSReplayFilePath
    $arenaInfoObject = & $PSScriptRoot\Get-ArenaInfoFromWOWSREPLAY.ps1 $WOWSReplayFilePath
    if ($arenaInfoObject) {
        $playerNameComparisionString = '*' + $arenaInfoObject.playerName + '*'
        if ($replayFileObject.Name -notlike $playerNameComparisionString) {
            $replayFileNameWithPlayername = $arenaInfoObject.playerName + "_" + $replayFileObject.Name
            Rename-item -path $WOWSReplayFilePath -NewName $replayFileNameWithPlayername
        }
    }
    else {
        Write-Error "$WOWSReplayFilePath doesn't appear a valid WOWS replay file (missing ArenaInfoJSON)"
    }
        
}
    
end {
        
}
