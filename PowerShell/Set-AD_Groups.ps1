$shared = Get-Content -Path C:\sharedmbx.txt # list of shared mailboxes email addresses

ForEach ($s in $shared) { 

    Get-Mailbox $s

    $lString = '(&(objectclass=user)(SamAccountName=' + $s.SamAccountName + '))'
    $id = (Get-ADUser -LDAPFilter $lString).samaccountname

    Add-ADGroupMember -Identity group_name -Members $id 
}



$ads=@()
ForEach ($m in $mbxes) { 

    $lString = '(&(objectclass=user)(SamAccountName=' + $m.SamAccountName + '))'
    $id = (Get-ADUser -LDAPFilter $lString).samaccountname

    $ads += $id
}


ForEach ($ad in $ads) { 

    Add-ADGroupMember -Identitygroupname -Members $ad
}
