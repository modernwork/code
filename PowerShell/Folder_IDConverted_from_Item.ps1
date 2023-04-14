#convert the folder ID into a format usable by eDiscovery

Function Process-Stats {

    param (

        $stats,
        $val
    )

    foreach ($mbxa in $stats) {

        $this = (Compare-Object $paths.FolderPath $mbxa.FolderPath -IncludeEqual | ? {$_.SideIndicator -eq "=="}).inputobject

        if ($this) {

            Add-Member -InputObject $mbxa -MemberType NoteProperty -Name "Location" -Value "$val"
            $mbxa
        }
    }
}

$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Collecting User input

$mbx = Read-Host "Enter email address"
$FolderPaths = Read-Host "Enter the location of the CSV for the FolderPaths"

# Processing Mailbox Folder Stats

Write-Host "Collecting all Primary Mailbox Folder Statistics..." -ForegroundColor Yellow
$mbxStatistics = Get-MailboxFolderStatistics -Identity $mbx 

Write-Host "Collecting all Archive Mailbox Folder Statistics..." -ForegroundColor Yellow
$mbxStatistics2 = Get-MailboxFolderStatistics -Identity $mbx -Archive 

# Import pre-defined list of FolderPaths

$paths = Import-Csv -Path $FolderPaths

# Comparing Input CSV to Mailbox Folder Stats

Write-Host "Processing Data..." -ForegroundColor Yellow

$found = @()
$found += Process-Stats -stats $mbxStatistics -val "Mailbox"
$found += Process-Stats -stats $mbxStatistics2 -val "Archive"


$folderQueries2 = @()

foreach ($stat in $found) {

    $encoding = [System.Text.Encoding]::GetEncoding("us-ascii")
    $nibbler = $encoding.GetBytes("0123456789ABCDEF");
    $indexIdBytes = New-Object byte[] 48;
    $folderIdBytes = [Convert]::FromBase64String($stat.FolderId)
    $indexIdIdx = 0
    $folderIdBytes | select -Skip 23 -First 24 | %{$indexIdBytes[$indexIdIdx++] = $nibbler[$_ -shr 4]; $indexIdBytes[$indexIdIdx++] = $nibbler[$_ -band 0xF]}
    $folderIdConverted = $($encoding.GetString($indexIdBytes))


    $folderDetails = New-Object PSObject

    Add-Member -InputObject $folderDetails -MemberType NoteProperty -Name FolderPath -Value $stat.FolderPath
    Add-Member -InputObject $folderDetails -MemberType NoteProperty -Name Location -Value $stat.Location
    Add-Member -InputObject $folderDetails -MemberType NoteProperty -Name ItemsinFolder -Value $stat.ItemsInFolder
    Add-Member -InputObject $folderDetails -MemberType NoteProperty -Name FolderIdOld -Value $stat.folderid
    Add-Member -InputObject $folderDetails -MemberType NoteProperty -Name FolderIdNew -Value $folderIdConverted
    
    $folderQueries2 += $folderDetails
}

$folderqueries = $folderQueries2 | select folderpath, location, itemsinfolder, folderidold, @{name="Folderidnew";Expression={$('folderid="' + $_.FolderIdNew + '"')}}


$date = Get-Date -Format "yyyy-mm-dd_HH-mm-ss"
$name = $($date + "_" + $mbx.split("@")[0].Replace(".","") + ".csv")

$NewPath = $FolderPaths.replace("\","\`n")
$NewPath = $NewPath.split("`n")
$del = $NewPath | select -Last 1
$NewPath = $NewPath | ? {$_ -notmatch $del}
[string]$NewPath = $NewPath -join ''
$NewPath = $($NewPath + $name)

$folderqueries | export-csv -path $NewPath -NoTypeInformation


$folderqueries

<#
    $encoding = [System.Text.Encoding]::GetEncoding("us-ascii")
    $nibbler = $encoding.GetBytes("0123456789ABCDEF");
    $indexIdBytes = New-Object byte[] 48;
    $folderIdBytes = [Convert]::FromBase64String($FolderId)
    $indexIdIdx = 0
    $folderIdBytes | select -Skip 23 -First 24 | %{$indexIdBytes[$indexIdIdx++] = $nibbler[$_ -shr 4]; $indexIdBytes[$indexIdIdx++] = $nibbler[$_ -band 0xF]}
    $folderIdConverted = $($encoding.GetString($indexIdBytes))
#>
