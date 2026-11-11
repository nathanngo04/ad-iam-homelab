# mover.ps1
# Moves an employee to a new role at Sonder Energy Services

# --- Section 1: Update title, description, department, and manager ---
Set-ADUser -Identity "marcus.reed" -Title "Operations Analyst" -Description "Operations Analyst" -Department "Operations" -Manager "jordan.hayes"

# --- Section 2: Move to the Operations OU ---
Get-ADUser -Identity "marcus.reed" | Move-ADObject -TargetPath "OU=Operations,OU=Users,OU=SonderEnergy,DC=sonderenergy,DC=internal"

# --- Section 3: Add new role access, remove old role access ---
Add-ADGroupMember -Identity "SG-Operations" -Members "marcus.reed"
Remove-ADGroupMember -Identity "SG-Finance" -Members "marcus.reed" -Confirm:$false

# --- Section 4: Verify ---
Get-ADUser -Identity "marcus.reed" -Properties Title, Department, Manager, MemberOf | Select-Object Name, Title, Department, Manager, MemberOf, DistinguishedName