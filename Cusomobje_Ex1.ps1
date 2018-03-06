try
{
   $ErrorActionPreference = "stop"
    #Memory Usages
   $OS = Get-WmiObject -Class win32_operatingsystem
   $TotalMemorySize = $OS.TotalVisibleMemorySize
   $freeMemorySize = $OS.FreePhysicalMemory
   
   #Cdrive uses
   $Disk = Get-WmiObject -Class win32_logicaldisk -Filter "DeviceID='c:'"
   $DIskSize      = $Disk.Size
   $freeDiskSpace = $Disk.FreeSpace

   #CPU Load
   $Cpu = Get-WmiObject -Class win32_processor
   $load = $Cpu.LoadPercentage

   #OS Arch
   $arch = $OS.OSArchitecture

   $result = [PSCustomObject]@{
   
        Host = $env:COMPUTERNAME
        MemoryUsages = [Math]::Round((($TotalMemorySize - $freeMemorySize)/1mb),2)
        OSDriveUsages = [Math]::Round(($freeDiskSpace /1GB),2)
        OSArchitecture = $arch
   }
}
catch
{
    $result = [PSCustomObject]@{
   
        Host = $env:COMPUTERNAME
        MemoryUsages = "Undefined"
        OSDriveUsages = "Undefined"
        OSArchitecture = "Undefined"
   }
}
finally
{
    Write-Output $result
}
