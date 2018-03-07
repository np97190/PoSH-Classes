param(
    [string[]]$ComputerName = ("myserver","myserver","myserver","myserver")
)

$ScriptBlock_Memory = {

    $OS = Get-WmiObject -Class win32_operatingsystem
    $TotalMemorySize = $OS.TotalVisibleMemorySize
    $freeMemorySize = $OS.FreePhysicalMemory
    [Math]::Round(($TotalMemorySize - $freeMemorySize) / 1mb,2)
}

$ScriptBlock_Disk = {
    $Disk = Get-WmiObject -Class win32_logicaldisk -Filter "DeviceID='c:'"
    $freeDiskSpace = $Disk.FreeSpace
    [Math]::Round(($freeDiskSpace /1GB),2)
}

$ScriptBlock_Network = {

    gwmi Win32_NetworkAdapterConfiguration|?{$_.IPAddress}|select @{n='IPAddress';e={$_.ipaddress[0]}},Description
}

$ScriptBlock_arch = {

        $OS = Get-WmiObject -Class win32_operatingsystem
        $OS.OSArchitecture
}


try
{

    $report = @()
    $SecPass = "Pass@word1"|ConvertTo-SecureString -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential -ArgumentList "administrator",$SecPass
    

    foreach($comp in $ComputerName)
    {
         
        try{
                $session = New-PSSession -ComputerName $comp -Credential $Cred
                $memory = Invoke-Command -Session $session -ScriptBlock $ScriptBlock_Memory
                $disk = Invoke-Command -Session $session -ScriptBlock $ScriptBlock_Disk
                $network = Invoke-Command -Session $session -ScriptBlock $ScriptBlock_Network
                $arch = Invoke-Command -Session $session -ScriptBlock $ScriptBlock_arch
                Remove-PSSession $session

                $output =[PSCustomObject] @{
                    Computer = $comp
                    Memory = $memory
                    Disk = $disk
                    Arch = $arch 
                    Network = $null      
                }

                $networkhash = @()
                if($network)
                {
                    
                    $network|%{
                        $networkhash += [pscustomobject]@{
                                Description = $_.Description
                                IPAddress = $_.IPAddress
                        }
                    }
                    $output.Network = $networkhash
                }
                else{
                    $output.Network = $null
                }

                $report += $output
            }
            catch
            {
                $output =[PSCustomObject] @{
                    computer = $comp
                    Memory = "Undefined"
                    Disk = "Undefined"
                    Arch = "Undefined" 
                    Network = "Undefined"      
                }
                $report += $output
            }

    }
}
catch
{
    $output =[PSCustomObject] @{
                
                    Memory = "ERROR"
                    Disk = "ERROR"
                    Arch = "ERROR" 
                    Network = "ERROR"
                    Error = "$($_.Exception.Message)"      
                }
    $report += $output
    
}
finally{
    $report|select computer,Memory,disk,Arch,@{n='Network';e={$_.Network.Description + "=" + $_.network.IPAddress} }|Export-Csv C:\Users\gpkpa\Desktop\Scripts\ServerHealthReport.csv -NoTypeInformation
    $emailcred =  New-Object System.Management.Automation.PSCredential -ArgumentList "user@gmail.com",$("somepasswrod"|ConvertTo-SecureString -AsPlainText -Force)

    $mail = @{
        SmtpServer = "smtp.gmail.com"
        from = "user@gmail.com"
        to = "user@gmail.com"
        Credential = $emailcred
        port = 587
        subject = "hello"
        Attachments = "C:\Users\gpkpa\Desktop\Scripts\ServerHealthReport.csv"
        Body = "Hi,Please refer to the attachment for server health check"
    }

    Send-MailMessage @mail -UseSsl
}
