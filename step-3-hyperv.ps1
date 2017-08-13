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

Write-Host "Please ensure you have configured an External switch, and in the packer config you have"
Write-Host "replaced the hyperv_switch variable value with the name of this switch."

$multinodeFile = "multinode-vars.json"

packer build --only=hyperv-iso -var-file="$multinodeFile" .\multinode-deploy-hyperv.json
packer build --only=hyperv-iso -var-file="$multinodeFile" .\multinode-compute-hyperv.json
packer build --only=hyperv-iso -var-file="$multinodeFile" .\multinode-controller-hyperv.json
packer build --only=hyperv-iso -var-file="$multinodeFile" .\multinode-infrastructure-hyperv.json
packer build --only=hyperv-iso -var-file="$multinodeFile" .\multinode-network-hyperv.json
packer build --only=hyperv-iso -var-file="$multinodeFile" .\multinode-storage-hyperv.json

Import-Packer-VM '.\hyperv\os-deploy\Virtual Machines'
Import-Packer-VM '.\hyperv\os-compute\Virtual Machines'
Import-Packer-VM '.\hyperv\os-controller\Virtual Machines'
Import-Packer-VM '.\hyperv\os-infrastructure\Virtual Machines'
Import-Packer-VM '.\hyperv\os-network\Virtual Machines'
Import-Packer-VM '.\hyperv\os-storage\Virtual Machines'

# Turn on nested virtualisation
Set-VMProcessor -VMName os-deploy -ExposeVirtualizationExtensions $true
Set-VMProcessor -VMName os-compute -ExposeVirtualizationExtensions $true
Set-VMProcessor -VMName os-controller -ExposeVirtualizationExtensions $true
Set-VMProcessor -VMName os-infrastructure -ExposeVirtualizationExtensions $true
Set-VMProcessor -VMName os-network -ExposeVirtualizationExtensions $true
Set-VMProcessor -VMName os-storage -ExposeVirtualizationExtensions $true
