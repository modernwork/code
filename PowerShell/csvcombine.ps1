$users = Import-Csv -Path 'C:\temp4\CSV\AADall.csv'
$report = Import-Csv -Path 'C:\temp4\CSV\intuneonlyphones.csv'

$mailInBoth = Compare-Object -ReferenceObject $users.mail -DifferenceObject $report.mail -IncludeEqual | #Posh v3
Where-Object {$_.SideIndicator -eq "=="} |
Select-Object -ExpandProperty InputObject 

$results = ForEach($mail in $mailInBoth) {
    $u = $users | Where-Object {$_.mail -eq $mail}
    $r = $report | Where-Object {$_.mail -eq $mail}
    New-Object -TypeName psobject -Property @{
        "mail" = $mail
        "officeLocation" = $u.officeLocation
      #  "Data2" = $u.data2
        "Model" = $r.Model
        "Primaryuserdisplayname" = $r.Primaryuserdisplayname
      #  "Phonenumber" = $r.Phonenumber
    }
}

$results | Export-CSV -NoTypeInformation -Path 'C:\temp4\CSV\result.csv'