Import-Module C:\Users\gpkpa\Desktop\Scripts\Logger.psm1 -DisableNameChecking

New-LogFile -Path C:\Users\gpkpa\Desktop\Logs -FileName "classes.txt"

Write-Log -Type 1 -Message "===========Starting Logging for the run===================="

try
{
    $ErrorActionPreference = "stop"
    if(Test-Connection localhost -Count 1)
    {
        Write-Host "Rerachable"
        Write-Log -Type 1 -Message "Server 'localhost' is reachable'"
    }
    else
    {
        Write-Host "Not reachable"
        Write-Log -Type 2 -Message "Server 'localhost' could not be reached. terminating program"
    }
    
    # random code to generate error.
    asdfasdfas
 }
 catch
 {
    Write-Host $_
    Write-Log -Type 0 -Message $_.Exception.Message
 }
finally{
    Write-Log -Type 0 "===========ENding log for the run=============="
 }
