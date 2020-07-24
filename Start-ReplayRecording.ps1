[CmdletBinding()]
param (
    [switch]
    $DisableBackgroundMusic,
    # Parameter help description
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    $ReplayFilePath

)
    
begin {
    #external .Net libraries and classes
    . $PSScriptRoot\Import-AudioClass.ps1 #Needs to be brought into current scope '.' because it adds a new object type to the session
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") #Needs to be brought in for to send the recording keyboard shortcut

    #constants
    $RecordingStartKeyboardShortCut = '%{F9}' #[System.Windows.Forms.SendKeys] ALT-F9 for Gefore Experincce 
    $recordingFileFolder = join-path -Path $env:USERPROFILE -ChildPath "\Videos\World of Warships\"    
    [decimal]$systemAudioPlaybackVolume = 1.00 #0.00 == 0% 1.00 == 100%

    #audio volume
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
    Rename-Item -Force -path $latestRecordingFileObject.FullName -NewName $replayRecordingFilename
}
end {
    [audio]::volume = $systemAudioVolumeBeforePlayback  
}