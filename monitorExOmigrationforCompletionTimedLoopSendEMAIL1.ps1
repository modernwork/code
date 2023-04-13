$user = Read-Host "please enter the email address of the mailbox being migrated" 
$mail = send-mailmessage -From x@xyz.com -To x@xyz.com -Subject '$user ExO Migration Completed' -Body 'body' -SmtpServer 'smtp.xyz.com' 


$i = 0

Do {

$percent = (Get-MoveRequestStatistics $user).PercentComplete

$percent

Start-Sleep 5

$i++

}

until ($percent -eq 100 -or $i -eq 5)

If ($percent -eq 100)
    {$mail}

