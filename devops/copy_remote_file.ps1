Import-Module bitstransfer
#$cred = Get-Credential
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList @($username,(ConvertTo-SecureString -String $password -AsPlainText -Force))
$sourcePath = "C:\Automation\dbm_demo\devops\HumanReources_properties.txt"
$destPath = "\\10.0.0.12\Automation\"
Start-BitsTransfer -Source $sourcePath -Destination $destPath -Credential $cred