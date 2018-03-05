Function New-LogFile
{
    #Code to create new log file with new-folder created everyday
    param(
        [String]$Path,
        [String]$FileName
    )

    $LogDirectory = Get-Date -Format "dd_MM_yyyy"
    $logroot = Join-Path $Path -ChildPath $LogDirectory

    $Global:LogFile = Join-Path $logroot -ChildPath $FileName
    
    if(-not (Test-Path $Global:LogFile))
    {
        New-Item -Path $Global:LogFile -Force|Out-Null
    }
}

Function Write-Log
{
    #Code to write log in file
    [CmdletBinding()]
    param(
            [parameter()]
            [ValidateSet(0,1,2)]
            [String]$Type,

            [String]$Message
        )

$code = switch($Type)
        {
            0 {"ERROR"}
            1 {"INFO"}
            2 {"WARN"}
            default {"UNKNOWN"}
        }

      "$(Get-Date)`t`t$code`t`t$Message" |Out-File $Global:LogFile -Append

}

Export-ModuleMember -Function *
