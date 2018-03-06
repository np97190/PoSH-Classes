try
{
    $result = @()
    $filecontent = Get-Content C:\Users\gpkpa\Desktop\Scripts\testing.txt

    foreach($line in $filecontent)
    {
        $data = $line -split ","
        $record = [PSCustomObject]@{
            ID = $data[0]
            Name = $data[1]
            Age = $data[2]
        }

        $result += $record
    }
}
catch
{
    $record = [PSCustomObject]@{
            ID = "Undefined"
            Name = "Undefined"
            Age = "Undefined"
        }

        $result += $record
}
finally
{
    $result
}
