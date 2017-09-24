function Import-Packer-VM
{
    Param(
        [parameter(Mandatory=$true)]
        [string]
        $VMPath
        )
    
    $files = Get-ChildItem -Path $VMPath -Filter '*.vmcx'
    $vmcxFilePath = $VMPath + '\' + $files[0].Name
    Import-VM $vmcxFilePath  -Copy -GenerateNewId
}

$serverNames = @('compute','deploy','infrastructure','storage')
$storageServer = 'os-storage'
$mainSwitchName = 'Main External'
$multinodeFile = ".\multinode-vars.json"
$secondHddPath = 'F:\VMs\CinderStoreage.vhdx'

Write-Host "Please ensure you have configured an External switch, and in the packer config you have"
Write-Host "replaced the hyperv_switch variable value with the name of this switch."

for ($i=0; $i -lt $serverNames.Length; $i++) {
    Write-Host 'Building', $serverNames[$i]
    $packerBuildFile = '.\multinode-' + $serverNames[$i] + '-hyperv.json'
    $vmFolder = '.\hyperv\os-' + $serverNames[$i] + '\Virtual Machines'
    $vmName = 'os-' + $serverNames[$i]
    packer build --only=hyperv-iso --force -var-file="$multinodeFile" $packerBuildFile
    Import-Packer-VM $vmFolder
    Set-VMProcessor -VMName $vmName -ExposeVirtualizationExtensions $true
    Set-VMNetworkAdapterVlan -VMName $vmName -Trunk -AllowedVlanIdList 0-1000 -NativeVlanId 0
}

# Assuming the external switch all the VMs are connected to is called "Main External"
# This allows promiscuous mode
Import-Module .\VMSwitchPortMonitorMode.psm1
Set-VMSwitchPortMonitorMode -SwitchName $mainSwitchName -MonitorMode Source

# Add a second drive to os-storage now
if (-not (Test-Path $secondHddPath)) {
    New-VHD -Path $secondHddPath -SizeBytes 100GB -Dynamic
    Add-VMHardDiskDrive -VMName $storageServer -ControllerType SCSI -Path $secondHddPath
}
