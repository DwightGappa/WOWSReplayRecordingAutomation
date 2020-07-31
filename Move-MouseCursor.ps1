[CmdletBinding()]
#Adtapted from http://stackoverflow.com/a/34049937
param (
    [int]
    $NumberOfPixelsToMoveMouse = 1,
    # Moves the mouse 0 pixels when updating postion
    [switch]
    $KeepCurrentMousePostionWhileMovingMouse,
    # Keeps moving mouse until script is stopped
    [switch]
    $MoveMouseUntilStoped,
    # Number seconds between mouse movements when using $MoveMouseUntilStoped
    [int]
    $NumberOfSecondsToWait = 150
)
    
begin {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    if ($KeepCurrentMousePostionWhileMovingMouse) {
        $NumberOfPixelsToMoveMouse = 0
    }
}
    
process {
    

    do {
        $mouseCursorPosition = [System.Windows.Forms.Cursor]::Position  
        $mouseCursorPosition.Offset($NumberOfPixelsToMoveMouse, $NumberOfPixelsToMoveMouse)
        [System.Windows.Forms.Cursor]::Position = $mouseCursorPosition 
        if ($MoveMouseUntilStoped) {
            $currentTime = Get-Date;  
            $shorterTimeString = $currentTime.ToLongTimeString();  
            Write-Host $shorterTimeString "Mouse pointer has been moved $([math]::Abs($NumberOfPixelsToMoveMouse)) pixels"  
            #Set your duration between each mouse move
            Start-Sleep -Seconds $NumberOfSecondsToWait
        }
        
    } while ($MoveMouseUntilStoped)
}
    
end {
        
}

