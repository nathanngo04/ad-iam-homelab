# create-groups.ps1
# Creates security groups for Sonder Energy Services and adds members

# --- Section 1: Settings ---
$groupsOU = "OU=Groups,OU=SonderEnergy,DC=sonderenergy,DC=internal"
$usersOU = "OU=Users,OU=SonderEnergy,DC=sonderenergy,DC=internal"

# --- Section 2: Create department groups and add members by Department ---
foreach ($dept in "Engineering","Finance","HR","Operations") {
    New-ADGroup -Name "SG-$dept" `
    -GroupScope Global `
    -GroupCategory Security `
    -Path $groupsOU `
    -Description "All $dept department staff"

    $members = Get-ADUser -Filter "Department -eq '$dept'" -SearchBase $usersOU
    Add-ADGroupMember -Identity "SG-$dept" -Members $members
}

# --- Section 3: Create role groups ---
New-ADGroup -Name "SG-Managers" -GroupScope Global -GroupCategory Security -Path $groupsOU -Description "All department managers and leads"
New-ADGroup -Name "SG-IT-HelpDesk" -GroupScope Global -GroupCategory Security -Path $groupsOU -Description "IT help desk staff with delegated password reset"

# Managers: anyone with direct reports
$leads = Get-ADUser -Filter * -SearchBase $usersOU -Properties DirectReports | Where-Object { $_.DirectReports }
Add-ADGroupMember -Identity "SG-Managers" -Members $leads

#Help desk: assigned by name
Add-ADGroupMember -Identity "SG-IT-HelpDesk" -Members "maria.lopez"