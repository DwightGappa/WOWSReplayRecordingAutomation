[CmdletBinding()]
param (
    [switch]
    $DisableBackgroundMusic,
    # Parameter help description
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    $ReplayFilePath

)
    
begin {
    . $PSScriptRoot\Import-AudioClass.ps1 #Needs to be brought into current scope '.' because it adds a new object type to the session
    $RecordingStartKeyboardShortCut = '%{F9}' #ALT-F9 for Gefore Experincce [System.Windows.Forms.SendKeys]
    $recordingFileFolder = join-path -Path $env:USERPROFILE -ChildPath "\Videos\World of Warships\"    
    [decimal]$systemAudioPlaybackVolume = 1.00 #0.00 == 0% 1.00 == 100%
    [decimal]$systemAudioVolumeBeforePlayback = [audio]::volume
    [audio]::volume = $systemAudioPlaybackVolume
    
    
}
    
process {
    $replayFileObject = Get-Item $ReplayFilePath
    Write-Output $replayFileObject.BaseName
    $WOWSProcess = Start-Process -PassThru -Filepath $ReplayFilePath
    Start-sleep 10
    [System.Windows.Forms.SendKeys]::SendWait($RecordingStartKeyboardShortCut)
    $WOWSProcess = get-process | where-object name -like "WorldOfWarships*"
    Wait-Process -InputObject $WOWSProcess
    Start-Process $recordingFileFolder
    Start-Sleep 45 #Allows enough time for Geforce Experince to finish writing .mp4 file
    $latestRecordingFileObject = Get-ChildItem $recordingFileFolder -Filter "World of Warships*.mp4" | Sort-Object -Property LastWriteTime -Descending | Select-object -First 1
    $replayRecordingFilename = $replayFileObject.BaseName + $latestRecordingFileObject.Extension
    move-item -Force $latestRecordingFileObject.FullName $(join-path -path $recordingFileFolder -ChildPath $replayRecordingFilename)
}
end {
    [audio]::volume = $systemAudioVolumeBeforePlayback  
}