# Run for specific group

# Connect and change schema 
Connect-MSGraph -ForceInteractive
Update-MSGraphEnvironment -SchemaVersion beta
Connect-MSGraph
 
# Which AAD group do we want to check against
$groupName = "intune"
 
#$Groups = Get-AADGroup | Get-MSGraphAllPages
$Group = Get-AADGroup -Filter "displayname eq '$GroupName'"
 
#### Config Don't change
 
Write-host "AAD Group Name: $($Group.displayName)" -ForegroundColor Green
 
# Apps
#$AllAssignedApps = Get-IntuneMobileApp -Filter "isAssigned eq true" -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
$AllAssignedApps = Get-IntuneMobileApp -Expand assignments | Select id, displayName, lastModifiedDateTime, assignments | Where-Object {$_.assignments -match $Group.id}

Write-host "Number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan

Foreach ($Config in $AllAssignedApps) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
 
# Device Compliance
$AllDeviceCompliance = Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" -ForegroundColor cyan

Foreach ($Config in $AllDeviceCompliance) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
 
# Device Configuration
$AllDeviceConfig = Get-IntuneDeviceConfigurationPolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" -ForegroundColor cyan

Foreach ($Config in $AllDeviceConfig) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
# Device Configuration Powershell Scripts 
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfigScripts = $DMS.value | Where-Object {$_.groupAssignments -match $Group.id}
Write-host "Number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" -ForegroundColor cyan
 
Foreach ($Config in $AllDeviceConfigScripts) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
 
 
# Administrative templates
$Resource = "deviceManagement/groupPolicyConfigurations"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=Assignments"
$ADMT = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllADMT = $ADMT.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" -ForegroundColor cyan

Foreach ($Config in $AllADMT) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}

























# Running the sample script on all AAD groups

# Connect and change schema 
Connect-MSGraph -ForceInteractive
Update-MSGraphEnvironment -SchemaVersion beta
Connect-MSGraph
 
$Groups = Get-AADGroup | Get-MSGraphAllPages
$Groups = $Groups | sort-object displayname

$AllAssignedApps = Get-IntuneMobileApp -Expand assignments | Select id, displayName, lastModifiedDateTime, assignments
$AllDeviceCompliance = Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments
$AllDeviceConfig = Get-IntuneDeviceConfigurationPolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments

# Device Configuration Powershell Scripts 
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfigScripts = $DMS.value 

# Administrative templates
$Resource = "deviceManagement/groupPolicyConfigurations"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=Assignments"
$ADMT = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllADMT = $ADMT.value


Write-host "Total number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan
Write-host "Total number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" -ForegroundColor cyan
Write-host "Total number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" -ForegroundColor cyan
Write-host "Total number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" -ForegroundColor cyan
Write-host "Total number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" -ForegroundColor cyan
Write-host ""
Write-host ""
Write-host ""




#### Config 
Foreach ($Group in $Groups) {
Write-host "AAD Group Name: $($Group.displayName)" -ForegroundColor Green
 
	# Apps
	#$AllAssignedApps = Get-IntuneMobileApp -Filter "isAssigned eq true" -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
	#$AllAssignedApps = Get-IntuneMobileApp -Expand assignments | Select id, displayName, lastModifiedDateTime, assignments | Where-Object {$_.assignments -match $Group.id}

	$AssignedApps = $AllAssignedApps | Where-Object {$_.assignments.id -match $Group.id}
	$DeviceCompliance = $AllDeviceCompliance | Where-Object {$_.assignments.id -match $Group.id}
	$DeviceConfig = $AllDeviceConfig | Where-Object {$_.assignments.id -match $Group.id}
	$DeviceConfigScripts = $AllDeviceConfigScripts | Where-Object {$_.groupAssignments.id -match $Group.id}
	$ADMT = $AllADMT | Where-Object {$_.assignments.id -match $Group.id}
	
	Write-host "Number of Apps found: $($AssignedApps.DisplayName.Count)" -ForegroundColor magenta
	
	#Write-host "Number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan
	Foreach ($Config in $AssignedApps) {
	 
		Write-host $Config.displayName -ForegroundColor Yellow
	 
	}
	 
	
	# Device Compliance
	Write-host "Number of Device Compliance policies found: $($DeviceCompliance.DisplayName.Count)" -ForegroundColor magenta	
	#$AllDeviceCompliance = Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
	#Write-host "Number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" -ForegroundColor cyan
	Foreach ($Config in $DeviceCompliance) {
	 
		Write-host $Config.displayName -ForegroundColor Yellow
	 
	}
	 
	
	# Device Configuration
	Write-host "Number of Device Configurations found: $($DeviceConfig.DisplayName.Count)" -ForegroundColor magenta
	#$AllDeviceConfig = Get-IntuneDeviceConfigurationPolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
	#Write-host "Number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" -ForegroundColor cyan
	Foreach ($Config in $DeviceConfig) {
	 
		Write-host $Config.displayName -ForegroundColor Yellow
	 
	}
	 
	# Device Configuration Powershell Scripts 
	Write-host "Number of Device Configurations Powershell Scripts found: $($DeviceConfigScripts.DisplayName.Count)" -ForegroundColor magenta
	 
	Foreach ($Config in $DeviceConfigScripts) {
	 
		Write-host $Config.displayName -ForegroundColor Yellow
	 
	}
	 
	
	# Administrative templates
	Write-host "Number of Device Administrative Templates found: $($ADMT.DisplayName.Count)" -ForegroundColor magenta
	
	Foreach ($Config in $ADMT) {
	 
		Write-host $Config.displayName -ForegroundColor Yellow
	 
	}
	
	Write-host ""
	Write-host ""
	Write-host ""	
 
}


#shorter version with output file 

# Run for specific group

# Connect and change schema 
Connect-MSGraph 
 
# Which AAD group do we want to check against
$groupName = "U-WW-S-EXOMigratedMailboxes"
 
#$Groups = Get-AADGroup | Get-MSGraphAllPages
$Group = Get-AADGroup -Filter "displayname eq '$GroupName'"
 
#### Config Don't change
 
Write-host "AAD Group Name: $($Group.displayName)" -ForegroundColor Green
"AAD Group Name: $($Group.displayName)" | Out-File -FilePath C:\group3.csv -Append -NoClobber
 
# Apps
#$AllAssignedApps = Get-IntuneMobileApp -Filter "isAssigned eq true" -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
$AllAssignedApps = Get-IntuneMobileApp -Expand assignments | Select id, displayName, lastModifiedDateTime, assignments | Where-Object {$_.assignments -match $Group.id}

Write-host "Number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan
"Number of Apps found: $($AllAssignedApps.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Foreach ($Config in $AllAssignedApps) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
 
# Device Compliance
$AllDeviceCompliance = Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" -ForegroundColor cyan
"Number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Foreach ($Config in $AllDeviceCompliance) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
 
# Device Configuration
$AllDeviceConfig = Get-IntuneDeviceConfigurationPolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" -ForegroundColor cyan
"Number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber


Foreach ($Config in $AllDeviceConfig) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
$Config.displayName | Out-File -FilePath C:\group3.csv -Append -NoClobber
 
}
 
# Device Configuration Powershell Scripts 
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfigScripts = $DMS.value | Where-Object {$_.groupAssignments -match $Group.id}
Write-host "Number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" -ForegroundColor cyan
"Number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Foreach ($Config in $AllDeviceConfigScripts) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}
 
 
 
# Administrative templates
$Resource = "deviceManagement/groupPolicyConfigurations"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=Assignments"
$ADMT = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllADMT = $ADMT.value | Where-Object {$_.assignments -match $Group.id}
Write-host "Number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" -ForegroundColor cyan
"Number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Foreach ($Config in $AllADMT) {
 
	Write-host $Config.displayName -ForegroundColor Yellow
 
}



# Running the sample script on all AAD groups

# Connect and change schema 
Connect-MSGraph
Update-MSGraphEnvironment -SchemaVersion beta
Connect-MSGraph
 
$Groups = Get-AADGroup | Get-MSGraphAllPages
$Groups = $Groups | sort-object displayname

$AllAssignedApps = Get-IntuneMobileApp -Expand assignments | Select id, displayName, lastModifiedDateTime, assignments
$AllDeviceCompliance = Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments
$AllDeviceConfig = Get-IntuneDeviceConfigurationPolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments

# Device Configuration Powershell Scripts 
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfigScripts = $DMS.value 

# Administrative templates
$Resource = "deviceManagement/groupPolicyConfigurations"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=Assignments"
$ADMT = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllADMT = $ADMT.value


Write-host "Total number of Apps found: $($AllAssignedApps.DisplayName.Count)" -ForegroundColor cyan
"Total number of Apps found: $($AllAssignedApps.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Write-host "Total number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" -ForegroundColor cyan
"Total number of Device Compliance policies found: $($AllDeviceCompliance.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Write-host "Total number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" -ForegroundColor cyan
"Total number of Device Configurations found: $($AllDeviceConfig.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Write-host "Total number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" -ForegroundColor cyan
"Total number of Device Configurations Powershell Scripts found: $($AllDeviceConfigScripts.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber

Write-host "Total number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" -ForegroundColor cyan
"Total number of Device Administrative Templates found: $($AllADMT.DisplayName.Count)" | Out-File -FilePath C:\group3.csv -Append -NoClobber
