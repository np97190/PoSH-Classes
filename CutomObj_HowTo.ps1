#example 1
$a = New-Object -TypeName psobject
$a|Add-Member -MemberType NoteProperty -Name "FreeMemory" -Value "10GB"
$a|Add-Member -MemberType NoteProperty -Name "ARCH" -Value "64bit"


#example 2
$b = ""|select FreeMemory,Arch
$b.FreeMemory = "10gb"
$b.Arch = "64bit"


#example3
$objects = @()

for($i = 0;$i -lt 5;$i++)
{
    $hash = @{
        FreeMemory = "10GB"
        Arch = "64bit"
    }

$c = New-Object PSCustomObject -Property $hash
$objects += $c

}


#example4
$d =[PSCustomObject] @{
        FreeMemory = "10GB"
        Arch = "64bit"
}
