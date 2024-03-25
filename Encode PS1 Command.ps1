$Name = "My Script Name"

$Command = @'
#Your script starts here
function Import-SyncroModule {
    param (
        #Defaults to the UUID of local system but you can provide the UUID of Any other Syncro Asset instead.
        $UUID
    )

    # Set up $env: vars for Syncro Module
    if($env:SyncroModule -match '^\s*$'){
        $SyncroRegKey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\RepairTech\Syncro' -Name uuid, shop_subdomain
        $env:RepairTechFilePusherPath  = 'C:\ProgramData\Syncro\bin\FilePusher.exe'
        $env:RepairTechKabutoApiUrl    = 'https://rmm.syncromsp.com'
        $env:RepairTechSyncroApiUrl    = 'https://{subdomain}.syncroapi.com'
        $env:RepairTechSyncroSubDomain = $SyncroRegKey.shop_subdomain
        $env:RepairTechUUID            = if($UUID -match '^\s*$'){ $SyncroRegKey.uuid } else {$UUID}
        $env:SyncroModule              = "$env:ProgramData\Syncro\bin\module.psm1"
    }
    if ((Test-Path -Path $env:SyncroModule) -and ($PSVersionTable.PSVersion -ge [system.version]'4.0')) {
        Import-Module -Name $env:SyncroModule -WarningAction SilentlyContinue
    } else {
        if ($PSVersionTable.PSVersion -lt [system.version]'4.0'){Write-Warning "$($PSVersionTable.PSVersion) is not compatible with SyncroModule"}
        [Environment]::SetEnvironmentVariable('SyncroModule',$null)
    }
}

Import-SyncroModule
New-BurntToastNotification -AppLogo "C:\ProgramData\MyCompany\NotificationLogoS.png" -Text 'Your Computer Name Is:',"$env:ComputerName"
Rmm-Alert -Category 'USS - Test Connectivity' -Body 'USS - Test Connectivity Requested'
#Your script ends here
'@

$EncodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Command))

$outcommand = "powershell.exe -EncodedCommand " + $EncodedCommand

Out-File -FilePath "C:\Temp\$Name.ps1" -Force -InputObject $command
Out-File -FilePath "C:\Temp\$Name-Encoded.txt" -Force -InputObject $outcommand


