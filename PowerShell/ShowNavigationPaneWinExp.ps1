$regPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer'
# if that registry path does not already exist, create it here
$null = New-Item -Path $regPath -Force

$values = [byte[]](0xa0, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x56, 0x05, 0x00, 0x00)
Set-ItemProperty -Path $regPath -Name 'PageSpaceControlSizer' -Value $values -Type Binary -Force