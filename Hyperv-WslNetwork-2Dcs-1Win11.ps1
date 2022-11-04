# Sets up two domain controllers and a single win 11 client
# runs a post install script to setup a ton of user accounts

$networkName = "WSL"
$currentPath = Get-Location
$DependencyFolder = "$currentPath\PostInstallScripts"

$postInstallActivity = @()
$postInstallActivity += Get-LabPostInstallationActivity -ScriptFileName 'Add-Users.ps1' -DependencyFolder $DependencyFolder

$dc1Parameters = @{
    Name                     = 'DC1'
    OperatingSystem          = 'Windows Server 2022 Standard Evaluation (Desktop Experience)'
    Network                  = $networkName
    Roles                    = 'RootDC'
    DomainName               = 'TestLab.local'
    PostInstallationActivity = $postInstallActivity
}

$dc2Parameters = @{
    Name            = 'DC2'
    OperatingSystem = 'Windows Server 2022 Standard Evaluation (Desktop Experience)'
    Network         = $networkName
    Roles           = 'DC'
    DomainName      = 'TestLab.local'
}

$ws1Parameters = @{
    Name            = 'WS1'
    OperatingSystem = 'Windows 11 Enterprise Evaluation'
    Network         = $networkName
    DomainName      = 'TestLab.local'
}

New-LabDefinition -Name $networkName -DefaultVirtualizationEngine HyperV

Set-LabInstallationCredential -Username 'adminaccount' -Password 'P@ssword123!'
Add-LabDomainDefinition -Name TestLab.local -AdminUser 'adminaccount' -AdminPassword 'P@ssword123!'
Add-LabVirtualNetworkDefinition -Name $networkName -HyperVProperties @{ SwitchType = 'Internal' }

Add-LabMachineDefinition @dc1Parameters
Add-LabMachineDefinition @dc2Parameters
Add-LabMachineDefinition @ws1Parameters

Install-Lab

Show-LabDeploymentSummary -Detailed