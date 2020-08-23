
[CmdletBinding()]

param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    $WOWSReplayFilePath
)

    
begin {
        
}
    
process {
        $replayFileObject = get-item $WOWSReplayFilePath
        $replayFolderPath = $replayFileObject.Directory.FullName
        $replayDetailsJSON = & $PSScriptRoot\Get-DetailsFromReplayFile.ps1 $WOWSReplayFilePath |ConvertTo-Json
        $replayDetailsJSONFileName= "replay_details_" + $replayFileObject.BaseName + ".json"
        $replayDetailsJSON |Out-File -Force -FilePath $(Join-Path -Path $replayFolderPath -ChildPath $replayDetailsJSONFileName)

}
    
end {
        
}
