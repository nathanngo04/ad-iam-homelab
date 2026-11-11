# create-shares.ps1
# Creates department file shares restricted to each department's security group

# --- Section 1: Create folders, set NTFS permissions, and share them ---
$depts = "Engineering","Finance","HR","IT","Operations"
New-Item -Path "C:\Shares" -ItemType Directory -Force | Out-Null

foreach ($d in $depts) {
    $path = "C:\Shares\$d"
    New-Item -Path $path -ItemType Directory -Force | Out-Null

    # NTFS: remove inherited access, then grant only admins, SYSTEM, and the department group
    icacls $path /inheritance:r /grant:r "SONDERENERGY\Domain Admins:(OI)(CI)F" "NT AUTHORITY\SYSTEM:(OI)(CI)F" "SONDERENERGY\SG-$($d):(OI)(CI)M" | Out-Null

    # Share: only admins and the department group
    New-SmbShare -Name $d -Path $path -FullAccess "SONDERENERGY\Domain Admins" -ChangeAccess "SONDERENERGY\SG-$d" | Out-Null
}

# --- Section 2: Add a test file to the Finance share ---
Set-Content -Path "C:\Shares\Finance\vendor-pricing.txt" -Value "CONFIDENTIAL - Sonder Energy vendor pricing (lab test file)"

# --- Section 3: Verify ---
Get-SmbShare | Where-Object Path -like "C:\Shares\*" | Select-Object Name, Path
icacls "C:\Shares\Finance"