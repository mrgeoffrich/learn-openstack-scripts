Write-Host "Please ensure you have configured an External switch, and in allinoneserverhyperv.json you have"
Write-Host "replaced the hyperv_switch variable value with the name of this switch."
packer build --only=hyperv-iso .\allinoneserverhyperv.json

$vmpath = '.\hyperv\allinone-server\Virtual Machines'

$files = Get-ChildItem -Path $vmpath -Filter '*.vmcx'
$vmcxFilePath = $vmpath + '\' + $files[0].Name
Import-VM $vmcxFilePath  -Copy -GenerateNewId

Start-VM -Name "allinone-server"