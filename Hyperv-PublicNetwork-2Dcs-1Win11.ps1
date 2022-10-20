# Enter network adapter here
$adapterName = 'Ethernet 2'
$labName = "LabDomain"
$domainName = "TestLab.local"

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace '192.168.20.0/24' -HyperVProperties @{ SwitchType = 'External'; AdapterName = $adapterName }

#and the domain definition with the domain admin account
Add-LabDomainDefinition -Name $domainName -AdminUser 'adminaccount' -AdminPassword 'P@ssword123!'

Set-LabInstallationCredential -Username 'adminaccount' -Password 'P@ssword123!'

# default values for all lab members
$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:Network'    = $labName
    'Add-LabMachineDefinition:DnsServer1' = '192.168.20.145'
    'Add-LabMachineDefinition:DnsServer2' = '192.168.20.146'
    'Add-LabMachineDefinition:Gateway'    = '192.168.20.1'
}

# Adjust VM Properties here
$dc1Parameters = @{
    Name            = 'DC1'
    OperatingSystem = 'Windows Server 2022 Standard Evaluation (Desktop Experience)'
    IpAddress       = '192.168.20.145'
    Gateway         = '192.168.20.1'
    Roles           = 'RootDC'
    DomainName      = $domainName
}

$dc2Parameters = @{
    Name            = 'DC2'
    OperatingSystem = 'Windows Server 2022 Standard Evaluation (Desktop Experience)'
    IpAddress       = '192.168.20.146'
    Roles           = 'DC'
    DomainName      = $domainName
}

$ws1Parameters = @{
    Name            = 'WS1'
    OperatingSystem = 'Windows 11 Enterprise Evaluation'
    IpAddress       = '192.168.20.147'
    DomainName      = $domainName
}

Add-LabMachineDefinition @dc1Parameters
Add-LabMachineDefinition @dc2Parameters
Add-LabMachineDefinition @ws1Parameters

# Requires novalidation switch to skip DNS checking during startup.
Install-Lab -NoValidation

Show-LabDeploymentSummary -Detailed