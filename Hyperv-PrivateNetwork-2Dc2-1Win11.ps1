$networkName = "LabDomain"

$dc1Parameters = @{
    Name            = 'DC1'
    OperatingSystem = 'Windows Server 2022 Standard Evaluation (Desktop Experience)'
    Network         = $networkName
    IpAddress       = '192.168.55.200'
    DnsServer1      = '192.168.55.200'
    DnsServer2      = '192.168.55.201'
    Gateway         = '192.168.55.1'
    Roles           = 'RootDC'
    DomainName      = 'TestLab.local'
}

$dc2Parameters = @{
    Name            = 'DC2'
    OperatingSystem = 'Windows Server 2022 Standard Evaluation (Desktop Experience)'
    Network         = $networkName
    IpAddress       = '192.168.55.201'
    DnsServer1      = '192.168.55.201'
    DnsServer2      = '192.168.55.200'
    Gateway         = '192.168.55.1'
    Roles           = 'DC'
    DomainName      = 'TestLab.local'
}

$ws1Parameters = @{
    Name            = 'WS1'
    OperatingSystem = 'Windows 11 Enterprise Evaluation'
    Network         = $networkName
    IpAddress       = '192.168.55.100'
    DnsServer1      = '192.168.55.200'
    DnsServer2      = '192.168.55.201'
    Gateway         = '192.168.55.1'
    DomainName      = 'TestLab.local'
}

New-LabDefinition -Name $networkName -DefaultVirtualizationEngine HyperV

Set-LabInstallationCredential -Username 'adminaccount' -Password 'P@ssword123!'
Add-LabDomainDefinition -Name TestLab.local -AdminUser 'adminaccount' -AdminPassword 'P@ssword123!'
Add-LabVirtualNetworkDefinition -Name $networkName -AddressSpace '192.168.55.0/24' -HyperVProperties @{ SwitchType = 'Internal' }

Add-LabMachineDefinition @dc1Parameters
Add-LabMachineDefinition @dc2Parameters
Add-LabMachineDefinition @ws1Parameters

Install-Lab

Show-LabDeploymentSummary -Detailed