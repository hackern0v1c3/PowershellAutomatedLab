# PowershellAutomatedLab
Scripts to setup lab environments with [Automated Lab](https://automatedlab.org/en/latest/)

## Requirements
Automated Lab must be installed.  ISO files must be downloaded into the LabSources\ISOs folder.
List available ISOs with `Get-LabAvailableOperatingSystem`

## Useful Commands
`Import-Lab {Lab Name}` Import the lab into the current powershell session so it can be queried and interacted with

`Get-LabVMStatus` Get list of lab machines and their status

`Enter-LabPSSession {Vm Name}` Enter a powershell session for the lab machine

`Connect-LabVM {Vm Name}` RDP to a lab machine

## Cleanup
To delete the lab use `Remove-Lab` or `Remove-Lab -Name {Lab Name}`