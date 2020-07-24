[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    $WOWSReplayFilePath
)
    
begin {
        $ArenaInfoJSONREGEX = '({.*\d0})'
}
    
process {
        $stringContainingPossibleArenaInfoJSON = Get-Content $WOWSReplayFilePath |Select-String -Pattern $ArenaInfoJSONREGEX |Select-Object -First 1
        if ($stringContainingPossibleArenaInfoJSON -match $ArenaInfoJSONREGEX){
            try{
                $Matches[0] | ConvertFrom-Json
            }
            catch{
                
            }
        }
}
    
end {
        
}