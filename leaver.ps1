# leaver.ps1
# Offboards a departing employee at Sonder Energy Services

$user = "carlos.rivera"

# --- Section 1: Disable the account ---
Disable-ADAccount -Identity $user

# --- Section 2: Note why and when ---
Set-ADUser -Identity $user -Description "Disabled $(Get-Date -Format 'MM/dd/yyyy') - left company"

# --- Section 3: Remove all group memberships ---
$groups = (Get-ADUser -Identity $user -Properties MemberOf).MemberOf
foreach ($g in $groups) {
    Remove-ADGroupMember -Identity $g -Members $user -Confirm:$false
}

# --- Section 4: Move to DisabledUsers ---
Get-ADUser -Identity $user | Move-ADObject -TargetPath "OU=DisabledUsers,OU=SonderEnergy,DC=sonderenergy,DC=internal"

# --- Section 5: Verify ---
Get-ADUser -Identity $user -Properties Description, MemberOf | Select-Object Name, Enabled, Description, MemberOf, DistinguishedName