# create-ous.ps1
# Creates the OU structure for Sonder Energy Services (sonderenergy.internal)

# --- Section 1: Save the base location in a variable ---
$base = "OU=SonderEnergy,DC=sonderenergy,DC=internal"

# --- Section 2: Create the main OUs inside SonderEnergy ---
New-ADOrganizationalUnit -Name "Users" -Path $base
New-ADOrganizationalUnit -Name "Groups" -Path $base
New-ADOrganizationalUnit -Name "Computers" -Path $base
New-ADOrganizationalUnit -Name "ServiceAccounts" -Path $base
New-ADOrganizationalUnit -Name "DisabledUsers" -Path $base

# --- Section 3: Create department OUs inside Users ---
foreach ($dept in "Engineering","Finance","HR","IT","Operations") {
    New-ADOrganizationalUnit -Name $dept -Path "OU=Users,$base"
}

# --- Section 4: Create type OUs inside Computers ---
foreach ($type in "Workstations","Servers") {
    New-ADOrganizationalUnit -Name $type -Path "OU=Computers,$base"
}

# --- Section 5: Verify everything was created ---
Get-ADOrganizationalUnit -Filter * -SearchBase $base | Select-Object Name, DistinguishedName