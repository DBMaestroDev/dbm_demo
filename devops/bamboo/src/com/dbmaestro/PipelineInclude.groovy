/*
 Deployment Pipeline Include
This file is called by the stub and can be centralized for all pipelines
7/6/18 BJB - DBmaestro
*/
package src.com.dbmaestro

import groovy.json.*
import src.com.dbmaestro.Utils as Utils


def get_settings(content, landscape, flavor = 0) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	def pipe = [:]
	def credential = "-AuthType DBmaestroAccount -UserName _USER_ -Password \"_PASS_\""
	settings = jsonSlurper.parseText(content)
	pipe["server"] = settings["general"]["server"]
	pipe["java_cmd"] = settings["general"]["java_cmd"]
	pipe["staging_dir"] = settings["general"]["staging_path"]
	pipe["base_path"] = settings["general"]["base_path"]
	pipe["source_control"] = settings["general"]["source_control"]["type"]
	pipe["remote_git"] = settings["general"]["source_control"]["remote"]
	println "Landscape: ${landscape}, flavor: ${flavor}"
	// note key off of landscape variable
	pipe["base_schema"] = settings["branch_map"][landscape][flavor]["base_schema"]
	pipe["base_env"] = settings["branch_map"][landscape][flavor]["base_env"]
	pipe["pipeline"] = settings["branch_map"][landscape][flavor]["pipeline"]
	pipe["environments"] = settings["branch_map"][landscape][flavor]["environments"]
	pipe["approvers"] = settings["branch_map"][landscape][flavor]["approvers"]
	pipe["source_dir"] = settings["branch_map"][landscape][flavor]["source_dir"]
	credential = credential.replaceFirst("_USER_", settings["general"]["username"])
	pipe["credential"] = credential.replaceFirst("_PASS_", settings["general"]["token"])
	
	println "Pipe: ${pipe["environments"]}"
	return pipe
}
 
def failTheBuild(String message) {

	ut.message_box(message, "title")
	error(message)
	System.exit(1)
}

def run(pipe, env_num){
	try {
		self.execute(pipe, env_num)
	} catch (err) {
		// unfortunately, err.message is not whitelisted by script security
		//failTheBuild(err.message)
		failTheBuild("Build failed")
	}
}

def execute(settings = [:]) {
	ut = new Utils()
	def automationPath = "C:\\automation\\dbm_demo\\devops"
	def settingsFile = ""
	def dbmNode = "master"
	// Get these from Bamboo
	def branchName = "develop" //rootJobName.replaceFirst('.*/.*/', '')
	//def fullBranchName = rootJobName.replaceFirst('.*/','')
	//def branchName = fullBranchName.replaceFirst('%2F', '/')
	//def landscape = branchName.replaceFirst('/.*', '')
	def landscape = settings["landscape"]
	def pipeline = [:]
	def settings_content = ""
	//if(arg_)
	println "branch: ${landscape}"
	if( settings.containsKey("settings_file")) { 
		settingsFile = settings["settings_file"] 
	}		
	println "JSON Settings Document: ${settingsFile}"
	println "Job: ${System.getenv("JOB_NAME")}"
	def hnd = new File(settingsFile)
	settings_content = hnd.text
	
	pipeline = this.get_settings(settings_content, landscape)
	pipeline["branch_name"] = branchName
	pipeline["branch_type"] = landscape
	pipeline["dbm_node"] = dbmNode
	pipeline["staging_dir"] = "${pipeline["staging_dir"]}${sep()}${pipeline["pipeline"]}${sep()}${pipeline["base_schema"]}"
	pipeline["spool_path"] = "${pipeline["staging_dir"]}${sep()}${pipeline["pipeline"]}${sep()}reports"
	settings.each {k,v ->
		pipeline[k] = v
	}
	if( !pipeline["arg_map"].containsKey("environment") ){
		failTheBuild("Must send argument \"environment\"")
	}
	// Here we loop through the environments from the settings file to perform the deployment
	def environment	 = pipeline["arg_map"]["environment"]
	def env_num = pipeline["environments"].findIndexOf{ env -> env == environment}
	ut.message_box("Pipeline Deployment Using ${landscape} Process", "title")
	println "#=> Deploy to Environment: ${environment}"
	println "#=> Working with: Branch: ${landscape} V- ${branchName}\n	 Pipe: ${pipeline["pipeline"]}\n - Schema: ${pipeline["base_schema"]}"
	def tasks = this.get_tasks(pipeline)
	pipeline["tasks"] = tasks
	def version = this.get_version(pipeline)
	pipeline["version"] = version
	println "Executing Environment ${environment}"
	new DeployOperation().execute(pipeline, env_num)
	if (landscape == "master") {
			println "Branch specific work"
	}
}

def get_tasks(pipe_info){
	// message looks like this "Adding new tables [Version: V2.3.4] "
	def reg = ~/.*\[Tasks: (.*)\].*/
	def gitMessage = ""
	def versionResult = ""
	def branch_name = pipe_info["branch_name"]
	def base_path = pipe_info["base_path"]
	def dbm_node = pipe_info["dbm_node"]
	def remote = pipe_info["remote_git"] != "false"
	def scm = pipe_info["source_control"]
	def pull_stg = remote ? " && git pull origin ${branch_name}" : ""
	
	// ------------- Update Local Git -----------------------
	ut.message_box('GitParams', "title")
	println "# Read latest commit..."
	def result = ut.shell_command("git --version")
	//result = ut.shell_command("@cd ${base_path} && git remote update && git checkout ${branch_name}${pull_stg}")
	result = ut.shell_command("@cd ${base_path} && @git log -1 HEAD --pretty=format:%s")
	gitMessage = result["stdout"]  //.trim()
	println "# From Git: ${gitMessage}"
	taskResult = gitMessage.replaceFirst(reg, '$1')
	// Both branch version and git version git wins as override!
	if (gitMessage.length() != taskResult.length()){
		println "# SNOW Tasks from git:" + taskResult
	}else{
		println "# No SNOW Tasks found"
		failTheBuild("Git message not formatted properly")
		return
	}
	return taskResult
}

def get_version(pipe_info){
	// message looks like this "Adding new tables [Version: V2.3.4] "
	if ( pipe_info["arg_map"].containsKey("version") && pipe_info["arg_map"]["version"] != "V0.0.0"){
		println "#------- Version environment variable set: ${pipe_info["arg_map"]["version"]} - using that ---------#\r\n#-------- Ignoring git version ----"
		return pipe_info["arg_map"]["version"]
	}
	if ( System.getenv("Version") != null && System.getenv("Version").length() > 1 && System.getenv("Version") != "V0.0.0"){
		println "#------- Version environment variable set: ${System.getenv("Version")} - using that ---------#\r\n#-------- Ignoring git version ----"
		return System.getenv("Version")
	}
	def reg = ~/.*\[Version: (.*)\].*/
	def gitMessage = ""
	def versionResult = ""
	def branch_name = pipe_info["branch_name"]
	def base_path = pipe_info["base_path"]
	def dbm_node = pipe_info["dbm_node"]
	def remote = pipe_info["remote_git"] != "false"
	def scm = pipe_info["source_control"]
	def pull_stg = remote ? " && git pull origin ${branch_name}" : ""
	
	// ------------- Update Local Git -----------------------
	ut.message_box('GitParams', "title")
	println "# Read latest commit..."
	ut.shell_command( "git --version")
	ut.shell_command("git remote update && git checkout ${branch_name}${pull_stg}")
	gitMessage = ut.shell_command("@cd ${base_path} && @git log -1 HEAD --pretty=format:%s").trim()

	println "# From Git: ${gitMessage}"
	versionResult = gitMessage.replaceFirst(reg, '$1')
	// Both branch version and git version git wins as override!
	if (gitMessage.length() != versionResult.length()){
		println "# VERSION/FOLDER from git:" + versionResult
	}else{
		println "# No VERSION/FOLDER found"
		currentBuild.result = "UNSTABLE"
		return
	}
	return versionResult
}


// GetNextEnv
def shouldDeploy(cur_env) {
	if (cur_env.contains("FIT")) {
		println System.getenv("Optional_Environment_Deploy")
		println cur_env
		if (cur_env.contains(System.getenv("Optional_Environment_Deploy")) || System.getenv("Optional_Environment_Deploy") == "BOTH") {
				do_it = true
		} else {
				do_it = false
		}
	} else if (cur_env == "DryRun") {
		if (System.getenv("Optional_DryRun_Deploy") == "Yes") {
				do_it = true
		} else {
				do_it = false
		}
	} else {
		do_it = true;
	}
	return do_it
}

def sep() {
	return "\\"
}