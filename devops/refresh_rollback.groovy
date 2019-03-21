import groovy.json.*

// N8 Deployment Pipeline
// Set this variable to choose between Dev1 and Dev2 landscape
def landscape = "HR"
def live = false // FIXME just for demo
def flavor = 0
sep = "\\"
def base_path = "C:\\Automation\\local"

rootJobName = "$env.JOB_NAME";
//FIXME branchName = rootJobName.replaceFirst('.*/.*/','')
branchName = "master"
branchVersion = ""
// Outboard Local Settings
def settings_file = "local_settings.json"
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
local_settings = get_settings("${base_path}${sep}${settings_file}")
def server = local_settings["general"]["server"]

// Add a properties for Platform and Skip_Packaging
properties([
	parameters([
		//choice(name: 'Landscape', description: "Develop/Release to specify deployment target", choices: 'MP_Dev\nMP_Dev2,MP_Release'),
		choice(name: 'ReviewRollback', description: "Yes/No to review before execution", choices: 'No\nYes')
	])
])

def java_cmd = local_settings["general"]["java_cmd"]
def dbmNode = ""
def staging_path = local_settings["general"]["staging_path"]
// note key off of landscape variable
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

def refresh_environments = [1,2]
def create_scripts_only = env.ReviewRollback != "yes" ? "true" : "false"
def pkg_file = "${def server = local_settings["general"]["server"]}/packages_exp.json"

/*
#-----------------------------------------------#
#  Stages
*/

echo message_box("Reapply Dev Changes after Delphix Refresh", "title")
stage("DiscoverVersion") {
  node (dbmNode) {
    //Use API to get current DBM version on each environment
	//java -jar DBmaestroAgent.jar -GetEnvPackages -ProjectName HumanResources -EnvName TargetA -FilePath "C:\Automation\pkgs.json" -Server EC2AMAZ-85K316M -AuthType DBmaestroAccount -UserName automation@dbmaestro.com -Password "1dywwlDpsZgp9tVLyX8pG6qUS6ap0eMx"
	
  }
}

environment = environments[refresh_environments[0]
approver = approvers[0]
stage(environment) {
	// FIXME checkpoint('Rerun QA')
	//input message: "Deploy to ${environment}?", submitter: approver
	node (dbmNode) {
		//  Figure out latest version
		echo '#------------------- Determine Version on ${environment} --------------#'
		bat "${java_cmd} -GetEnvPackages -ProjectName ${pipeline} -EnvName ${pair[0]} -FilePath ${pkg_file} -Server ${server} ${credential}"
		echo '#------------------- Building Rollback on ${environment} for ${version} --------------#'
		bat "${java_cmd} -Rollback -ProjectName ${pipeline} -EnvName ${pair[0]} -PackageName ${version} -CreateScriptsOnly ${create_scripts_only} -Server ${server} ${credential}"
		if(env.ReviewRollback != "yes"){
			echo '#------------------- Performing Deploy on ${environment} --------------#'
			bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server} ${credential}"
		}
	}   
} 
if(refresh_environments.size() < 2) {
	currentBuild.result = "SUCCESS"
	return
}
environment = environments[refresh_environments[1]]
approver = approvers[1]
stage(environment) {
	// FIXME checkpoint('Rerun QA')
	//input message: "Deploy to ${environment}?", submitter: approver
	node (dbmNode) {
		//  Deploy to QA
		echo '#------------------- Building Rollback on ${environment} for ${version} --------------#'
		bat "${java_cmd} -Rollback -ProjectName ${pipeline} -EnvName ${pair[0]} -PackageName ${version} -CreateScriptsOnly ${create_scripts_only} -Server ${server} ${credential}"
		if(env.ReviewRollback != "yes"){
			echo '#------------------- Performing Deploy on ${environment} --------------#'
			bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server} ${credential}"
		}
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

def get_settings(file_path) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	println "JSON Settings Document: ${file_path}"
	def json_file_obj = new File( file_path )
	if (json_file_obj.exists() ) {
	  settings = jsonSlurper.parseText(json_file_obj.text)  
	}
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
