#  cURL script to launch Jenkins pipeline build
# BJB - DBmaestro 2018
$arg_map = @{}
$job_params = @{}
foreach ($arg in $args) {
  $pair = $arg.split("=")
  if($pair.length -eq 2) {
    $arg_map[$pair[0].trim()] = $pair[1].trim()
  }
}
if ( $arg_map.ContainsKey("branch")) {
  #"hotfix%252F1.9.0"
  $branch = $arg_map.branch 
}else{
  write-Host "ERROR: specify branch=mybranch (in url compatible My%20Branch)"
  exit(1)
}

# Look up the Token in Jenkins Users
$username = "dbmguest"
$token = "0d543ef790b005778bd91e490a2a8b7c"
# Pipeline info
$cURL = "C:\Automation\dbm_demo\devops\lib\curl.exe"
$serverURL = "http://dbmtemplate:4007"
$job = "Pipetest"
# Parameters for Jenkins Job
foreach ($k in $arg_map.Keys){
  if ( $k -ne "branch"){
    $job_params[$k] = $arg_map[$k]
  }
}

write-Host "#-----------  Get CSRF Crumb ----------#"
write-Host $cmd
$cmd = "$cURL -u `"$($username):$($token)`" `"$($serverURL)/crumbIssuer/api/xml`""
iex "& $cmd" | Out-String -OutVariable raw_output

[String]$output = $raw_output
$output -match "\<crumb\>.*\<\/crumb\>"
$CRUMB = $matches[0].replace("<crumb>","").replace("</crumb>","")
write-Host "CRUMB=$CRUMB"
$parameters = ""
foreach ($k in $job_params.Keys) {
  $parameters += "$($k)=$($job_params[$k])&" 
}
$parameters = $parameters.Substring(0,$parameters.Length-1)
write-Host "#-----------  Start Build on $job ----------#"
$cmd = "$cURL -X POST -u `"$($username):$($token)`" -H `"Jenkins-Crumb:$CRUMB`" `"$($serverURL)/job/$job/job/$branch/buildWithParameters?$($parameters)`""
write-Host $cmd
iex "& $cmd"
