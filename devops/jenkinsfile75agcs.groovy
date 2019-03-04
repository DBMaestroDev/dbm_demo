import groovy.json.*

// OPKR
def landscape = "job"
def live = false // FIXME just for demo
def flavor = 0
sep = "\\"
// Outboard Local Settings - set this to be able to find the settings file
def settings_file = "local_settings.json"
def base_path = "C:\\AutomationScriptsMaestro\\DEVOPS"

rootJobName = "$env.JOB_NAME";
if (landscape == "job") { landscape = rootJobName.toLowerCase()}
branchName = "master"
branchVersion = ""
def local_settings = [:]
// Settings
def git_message = ""
// message looks like this "Adding new tables [Version: V2.3.4] "
//def reg = ~/.*\[Version: (.*)\].*\[DBCR: (.*)\].*/
def reg = ~/.*\[Version: (.*)\].*/
def environment = ""
def environments = []
def approver = ""
def result = ""
def dbcr_result = ""
def pipeline = ""
def staging_dir = ""
def source_dir = ""
def base_env = "Dev"
def base_schema = ""
def version = "3.11.2.1"
def buildNumber = "$env.BUILD_NUMBER"
def credential = "-AuthType DBmaestroAccount -UserName _USER_ -Password \"_PASS_\""
local_settings = get_settings("${base_path}${sep}${settings_file}", landscape)
def server = local_settings["general"]["server"]

// Add a properties for Platform and Skip_Packaging
properties([
	parameters([
		//choice(name: 'Landscape', description: "Develop/Release to specify deployment target", choices: 'MP_Dev\nMP_Dev2,MP_Release'),
		string(name: 'VersionNumber', description: "Version for package", defaultValue: '1.0.1'),
		string(name: 'ServiceNowID', description: "Service now ticket or enhancement", defaultValue: 'ENH-1111'),
		choice(name: 'Skip_Packaging', description: "Yes/No to skip packaging step", choices: 'No\nYes')
	])
])

def java_cmd = local_settings["general"]["java_cmd"]
def dbmNode = ""
def staging_path = local_settings["general"]["staging_path"]
if ("$env.VersionNumber".length() < 2) {
  println "Error: specify Version for package"
  System.exit(1)
}
if ("$env.ServiceNowID".length() < 2) {
  println "Error: specify service now ticket for package"
  System.exit(1)
}

// note key off of landscape variable
println "Matching: ${landscape} in the ${settings_file} file"
raw_version = "$env.VersionNumber"
snow_id = "$env.ServiceNowID"
base_schema = local_settings["branch_map"][landscape][flavor]["base_schema"]
base_env = local_settings["branch_map"][landscape][flavor]["base_env"]
pipeline = local_settings["branch_map"][landscape][flavor]["pipeline"]
environments = local_settings["branch_map"][landscape][flavor]["environments"]
def approvers = local_settings["branch_map"][landscape][flavor]["approvers"]
credential = credential.replaceFirst("_USER_", local_settings["general"]["username"])
credential = credential.replaceFirst("_PASS_", local_settings["general"]["token"])
source_dir = local_settings["branch_map"][landscape][flavor]["source_dir"]
local_settings = null

 echo "Working with: ${rootJobName}\n - Branch: ${branchName}\n - Pipe: ${pipeline}\n - Env: ${base_env}\n - Schema: ${base_schema}"
staging_dir = "${staging_path}${sep}${pipeline}${sep}${base_schema}"

/*
#-----------------------------------------------#
#  Stages
*/

if (raw_version.startsWith("V")) {
	version = "V" + raw_version 
}else{
	version = raw_version
}
version = version + "__" + snow_id
echo message_box("${pipeline} Deployment", "title")
echo "# FINAL PACKAGE VERSION: ${version}"
environment = environments[0]
stage(environment) {
  node (dbmNode) {
    //Copy from source to version folder
  if(!env.Skip_Packaging || env.Skip_Packaging == "No"){
    echo "#------------------- Copying files for ${version} ---------#"
    bat "if exist ${staging_dir} del /q ${staging_dir}\\*"
    bat "if not exist \"${staging_dir}${sep}${version}\" mkdir \"${staging_dir}${sep}${version}\""
    echo "#------------------- Copying DDL ---------#"
    //bat "copy \"${source_dir}${sep}${snow_id}${sep}ddl${sep}*.sql\" \"${staging_dir}${sep}${version}\""
	def icnt = prefix_files("${source_dir}${sep}${snow_id}${sep}ddl", "${staging_dir}${sep}${version}", 0)
    echo "#------------------- Copying DML ---------#"
	icnt = prefix_files("${source_dir}${sep}${snow_id}${sep}dml", "${staging_dir}${sep}${version}", icnt)
    //bat "copy \"${source_dir}${sep}${snow_id}${sep}dml${sep}*.sql\" \"${staging_dir}${sep}${version}\""
    // trigger packaging
    echo "#----------------- Packaging Files for ${version} -------#"
    bat "${java_cmd} -Package -ProjectName ${pipeline} -Server ${server} ${credential}"
    // version = adhoc_package(version)
  }else{
	  echo "#-------------- Skipping packaging step (parameter set) ---------#"
  }
    // Deploy to Dev
    echo "#------------------- Performing Deploy on ${environment} -------------#"
    //try {
      bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server} ${credential}"
	//	} catch (Exception e) {
	//		echo e.getMessage();
	//	}
    
  }
}
if(environments.size() < 2) {
	currentBuild.result = "SUCCESS"
	return
}
environment = environments[1]
approver = approvers[0]
def pair = environment.split(",")
def do_pair = false
if (pair.size() == 2) {environment = pair[0] }
do_pair = (pair.size() == 2) 
stage(environment) {
	// FIXME checkpoint('Rerun QA')
	input message: "Deploy to ${environment}?", submitter: approver
	node (dbmNode) {
		//  Deploy to QA
		echo '#------------------- Performing Deploy on ${environment} --------------#'
		bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${pair[0]} -PackageName ${version} -Server ${server} ${credential}"
		if (do_pair) {
			bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${pair[1]} -PackageName ${version} -Server ${server} ${credential}"
		}
	}   
} 
if(environments.size() < 3) {
	currentBuild.result = "SUCCESS"
	return
}
environment = environments[2]
approver = approvers[1]
stage(environment) {
	// FIXME checkpoint('Rerun QA')
	input message: "Deploy to ${environment}?", submitter: approver
	node (dbmNode) {
		//  Deploy to QA
		echo '#------------------- Performing Deploy on ${environment} --------------#'
		bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server} ${credential}"
	}   
} 
if(environments.size() < 4) {
	currentBuild.result = "SUCCESS"
	return
}
environment = environments[3]
approver = approvers[2]
stage(environment) {
	// FIXME checkpoint('Rerun QA')
	input message: "Deploy to ${environment}?", submitter: approver
	node (dbmNode) {
		//  Deploy to QA
		echo '#------------------- Performing Deploy on ${environment} --------------#'
		bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server} ${credential}"
	}   
} 

def adhoc_package(full_package_name){
	echo "Converting to AD-HOC package"
	def parts = full_package_name.split("__")
	def package_name = parts.length == 2 ? parts[1] : full_package_name
	def version = parts[0]
	def dbm_cmd = "cd C:\\Automation\\dbm_demo\\devops\r\ndbm_api.bat action=adhoc_package"
	bat "${dbm_cmd} ARG1=${full_package_name}"
	return package_name
}

def prefix_files(path, target, icnt = 0){
	def files = []
	def result = bat(script: "dir /B ${path}${sep}*.sql", returnStdout: true)
	def new_name = ""
	def ilen = 0
	result.eachLine{
		println "Line: ${it}"
		ilen = it.length()
		println "Len: ${ilen}, Cmd: ${it.toLowerCase().contains("dir /b")}"
		if(ilen > 2 && !it.toLowerCase().contains("dir /b")){
			new_name = "${sortable(icnt)}_${ it}"
			bat("copy ${path}${sep}${fil} ${target}${sep}${new_name}")
			icnt += 1
		}
	}
}

@NonCPS
def ensure_dir(pth){
  folder = new File(pth)
  if ( !folder.exists() ){
    if( folder.mkdirs()){
        return true
    }else{
        return false
    }
  }else{
    return true
  }
}

def get_settings(file_path, project = "none") {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	println "JSON Settings Document: ${file_path}"
	println "Project: ${project}"
	def json_file_obj = new File( file_path )
	if (json_file_obj.exists() ) {
	  settings = jsonSlurper.parseText(json_file_obj.text)  
	}
	println "Project Configurations: ${settings["branch_map"].keySet()}"
	return settings
}

def message_box(msg, def mtype = "sep") {
  def tot = 80
  def start = ""
  def res = ""
  msg = (msg.size() > 65) ? msg[0..64] : msg
  def ilen = tot - msg.size()
  if (mtype == "sep"){
    start = "#${"-" * (ilen/2).toInteger()} ${msg} "
    res = "${start}${"-" * (tot - start.size() + 1)}#"
  }else{
    res = "#${"-" * tot}#\n"
    start = "#${" " * (ilen/2).toInteger()} ${msg} "
    res += "${start}${" " * (tot - start.size() + 1)}#\n"
    res += "#${"-" * tot}#\n"   
  }
  //println res
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  //println "#${dashy}#"
}

def sortable(inum){
  ans = "00"
  def icnt = inum.toInteger()
  //incoming int
  def seq = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9']
  def iter = (icnt/36).toInteger()
  def remain = icnt % 36
  return "${seq.get(iter)}${seq.get(remain)}"
}