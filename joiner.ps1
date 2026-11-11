# joiner.ps1
# Onboards a new hire for Sonder Energy Services

# --- Section 1: Create the new hire's account (disabled until start date) ---
$tempPassword = Read-Host "Temporary password" -AsSecureString

New-ADUser -Name "Sofia Martinez" `
    -GivenName "Sofia" `
    -Surname "Martinez" `
    -DisplayName "Sofia Martinez" `
    -SamAccountName "sofia.martinez" `
    -UserPrincipalName "sofia.martinez@sonderenergy.internal" `
    -EmailAddress "sofia.martinez@sonderenergy.internal" `
    -Title "Accounts Payable Specialist" `
    -Description "Accounts Payable Specialist" `
    -Department "Finance" `
    -Company "Sonder Energy Services" `
    -Office "Houston" `
    -Manager "laura.chen" `
    -Path "OU=Finance,OU=Users,OU=SonderEnergy,DC=sonderenergy,DC=internal" `
    -AccountPassword $tempPassword `
    -ChangePasswordAtLogon $true `
    -Enabled $false

# --- Section 2: Add to her department group ---
Add-ADGroupMember -Identity "SG-Finance" -Members "sofia.martinez"

# --- Section 3: Start date - enable the account ---
Enable-ADAccount -Identity "sofia.martinez"

# --- Verify ---
Get-ADUser -Identity "sofia.martinez" -Properties Title, Department, Manager, MemberOf |
    Select-Object Name, Enabled, Title, Department, Manager, MemberOf