# Get all users
$users = Get-MgUser -All -Property "UserPrincipalName,DisplayName,AssignedLicenses"

# Filter users who do not have the Intune license assigned
$unlicensedUsers = $users | Where-Object { $_.AssignedLicenses -notcontains "Intune" }

# Display the unlicensed users
$unlicensedUsers | Select-Object UserPrincipalName, DisplayName