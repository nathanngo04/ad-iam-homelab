# create-users.ps1
# Creates employee accounts for Sonder Energy Services (sonderenergy.internal)

# --- Section 1: Settings ---
$domain = "sonderenergy.internal"
$usersOU = "OU=Users,OU=SonderEnergy,DC=sonderenergy,DC=internal"
$tempPassword = Read-Host "Enter a temporary password for new users" -AsSecureString

# --- Section 2: Create the IT Manager ---
New-ADUser -Name "Daniel Kim" `
    -GivenName "Daniel" `
    -Surname "Kim" `
    -DisplayName "Daniel Kim" `
    -SamAccountName "daniel.kim" `
    -UserPrincipalName "daniel.kim@$domain" `
    -EmailAddress "daniel.kim@$domain" `
    -Title "IT Manager" `
    -Description "IT Manager" `
    -Department "IT" `
    -Company "Sonder Energy Services" `
    -Office "Houston" `
    -Path "OU=IT,$usersOU" `
    -AccountPassword $tempPassword `
    -ChangePasswordAtLogon $true `
    -Enabled $true

# Make Daniel Maria's manager
Set-ADUser -Identity "maria.lopez" -Manager "daniel.kim"

# Section 3: Create the remaining employees ---
$employees = @(
    @{ First="Aisha";  Last="Patel";  Username="aisha.patel";   Dept="HR";          Title="HR Manager" },
    @{ First="Ryan";   Last="Brooks"; Username="ryan.brooks";   Dept="HR";          Title="HR Generalist" },
    @{ First="Laura";  Last="Chen";   Username="laura.chen";    Dept="Finance";     Title="Finance Manager" },
    @{ First="Marcus"; Last="Reed";   Username="marcus.reed";   Dept="Finance";     Title="Procurement Analyst" },
    @{ First="Priya";  Last="Nair";   Username="priya.nair";    Dept="Engineering"; Title="Senior Engineer" },
    @{ First="Tyler";  Last="Grant";  Username="tyler.grant";   Dept="Engineering"; Title="Field Engineer" },
    @{ First="Jordan"; Last="Hayes";  Username="jordan.hayes";  Dept="Operations";  Title="Operations Manager" },
    @{ First="Carlos"; Last="Rivera"; Username="carlos.rivera"; Dept="Operations";  Title="Field Technician" }
)

foreach ($emp in $employees) {
    New-ADUser -Name "$($emp.First) $($emp.Last)" `
    -GivenName $emp.First `
    -Surname $emp.Last `
    -DisplayName "$($emp.First) $($emp.Last)" `
    -SamAccountName $emp.Username `
    -UserPrincipalName "$($emp.Username)@$domain" `
    -EmailAddress "$($emp.Username)@$domain" `
    -Title $emp.Title `
    -Description $emp.Title `
    -Department $emp.Dept `
    -Company "Sonder Energy Services" `
    -Office "Houston" `
    -Path "OU=$($emp.Dept),$usersOU" `
    -AccountPassword $tempPassword `
    -ChangePasswordAtLogon $true `
    -Enabled $true
}

# --- Section 4: Link staff to their managers ---
$managers = @{
    "ryan.brooks" = "aisha.patel"
    "marcus.reed" = "laura.chen"
    "tyler.grant" = "priya.nair"
    "carlos.rivera" = "jordan.hayes"
}

foreach($staff in $managers.Keys) {
    Set-ADUser -Identity $staff -Manager $managers[$staff]
}