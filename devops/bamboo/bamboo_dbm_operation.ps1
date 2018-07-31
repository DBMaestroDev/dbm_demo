#  Copy files and validate
# Must run as administrator
Enable-PsRemoting -Force
write-Host "DBmaestro Deploy"

# Build a credential - you can do this in another file for security
$server = "$env:bamboo_dbm_server"
$domain = "DBMTemplate"
$domain_user = "$domain\someuser"
$domain_pwd = "somepwd"
$username = "$env:bamboo_dbm_username"
$password = "$env:bamboo_dbm_password"
$pipeline = "$env:bamboo_dbm_pipeline"
$auto_path = "$env:bamboo_dbm_base_path\$pipeline"
$base_schema = "$env:bamboo_dbm_base_schema"
$java_cmd = "$env:bamboo_dbm_java_cmd"
$dbm_task = "Package"
$version = "$env:bamboo_dbm_version"
$env = "$env:bamboo_dbm_environment"
$action = "$env:bamboo_dbm_action"


function Dbm_action {
	Param ( $action )
	$env_param = ""
	$credential = '-AuthType DBmaestroAccount -UserName _USER_ -Password "_PASS_"'
	$credential = ($credential -replace "_USER_", $username) -replace "_PASS_", $password
	write-Host "Performing: $action"
	if($action -eq "package"){
	# Get from git in packaging phase
		$version = Git_params
	}
	if($action -eq "deploy"){
	# Should be set as and env variable in deploy phase
		$version = $env:bamboo_dbm_version
		$env_param = "-EnvName $env -PackageName V$version "
	}
	$domain_cred = New-Object System.Management.Automation.PSCredential -ArgumentList @($domain_user,(ConvertTo-SecureString -String $domain_pwd -AsPlainText -Force))
	# Now run the automation command
	# Build with here string
	# java -jar DBmaestroAgent.jar -Validate  -ProjectName human_resources -EnvName integration -Server 10.1.0.15 -PackageName V1.0.1
	[String]$dbm_cmd = @"
C:;
cd "$auto_path" 
$java_cmd -$action -ProjectName $pipeline $($env_param)-Server $server $($credential)
"@
	
	# invoke
	write-Host "#=> Running: $dbm_cmd"
	[ScriptBlock]$script = [ScriptBlock]::Create($dbm_cmd)
	Invoke-Command -ComputerName $server -Credential $domain_cred -ScriptBlock $script -ErrorVariable errmsg
	return $xml
}

function Git_params {
	$base_path = "$env:bamboo_dbm_base_path"
	$regex = '.*\[Version: (.*)\].*'
	$file_name = "version_properties.txt"
	$cur_date = Get-Date -format "MM-dd-yy"
	$dbm_cmd = @"
C:;
cd $base_path; 
git log -1 HEAD --pretty=format:%s"
"@
	# invoke
	#$script = [scriptblock]::Create("$cmd")
	#$res = Invoke-Command -Script $script -ErrorVariable errmsg
	$res = $(C: ; cd $base_path ; git log -1 HEAD --pretty=format:%s)
	write-Host "#=> Git Output:"
	write-Host $res
	$matches = @()
	$res | Select-String $regex -AllMatches | Foreach-Object {$_.Matches} | Foreach-Object { 
  	$matches += $_	
  }
	$found_ver = $matches[0].groups[1]
	write-Host "Derived Version: $found_ver"
	# Update the Version File
	Write-Host "Replacing: $base_path\devops\bamboo\$file_name with current version"
	$content = @"
# Derived version - $cur_date 
version=$found_ver
"@

	$content | Set-Content $base_path\devops\bamboo\$file_name
	return $found_ver
}

function Stage_files {
	$version = "$env:bamboo_dbm_version"
	if ( $version.length -lt 2 ) {
	    write-Host "Failure - no version detected"
	    exit(1)
	}
	$source_path = "$env:bamboo_dbm_source_path"
	$base_schema = "$env:bamboo_dbm_base_schema"
	$target_path = "$env:bamboo_dbm_staging_path\$pipeline"
	write-host "#=> Copying $source_path\$version to $target_path\$base_schema\V$version"
	Copy-Item "$source_path\$version" -Destination $target_path\$base_schema\V$version -force
	
}

write-Host "#-------------------- DBmaestro PS Actions Library ---------------------------#"
write-host "#=> Invoking remote session on $server as $username"
# invoke
if($action -eq "Deploy"){
	Dbm_action($action)
} elseif ($action -eq "Package"){
	Dbm_action($action)
} elseif ($action -eq "Git_params"){
	Git_params
} elseif ($action -eq "Stage_Files"){
	Stage_Files
}else {
	write-Host "ERROR command $action not found"
	exit(1)
}



