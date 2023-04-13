$qqq = Read-Host "enter the email address to be migrated"

do{
$stats = Get-MoverequestStatistics $qqq

send-mailmessage -From x@xyz.com -To x@xyz.com -Subject "$($user) $($stats.PercentComplete) % ExO move status" -SmtpServer 'smtp.xyz.com'

  start-sleep -Seconds 200

}until ($($stats.PercentComplete) -eq 100)

