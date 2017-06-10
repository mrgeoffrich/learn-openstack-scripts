Write-Host "Please ensure you have configured an External switch, and in ubuntu1604.json you have"
Write-Host "replaced the hyperv_switch variable value with the name of this switch."
packer build --only=hyperv-iso ubuntu1604base.json