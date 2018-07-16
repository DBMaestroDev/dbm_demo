/*
 Deployment Pipeline Include
This file is called by the stub and can be centralized for all pipelines
7/6/18 BJB - DBmaestro
*/
package org.dbmaestro;

import groovy.json.*

@NonCPS
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
	echo "Landscape: ${landscape}, flavor: ${flavor}"
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
 
def prepare() {
    node {
        //checkout(scm)
        println "Checkout from git"
    }
}

def failTheBuild(String message) {

    currentBuild.result = "FAILURE"    
    def messageColor = "\u001B[32m" 
    def messageColorReset = "\u001B[0m"
    echo messageColor + message + messageColorReset
    error(message)
}

def run(Object step, pipe, env_num){
    try {
        step.execute(pipe, env_num)
    } catch (err) {
        // unfortunately, err.message is not whitelisted by script security
        //failTheBuild(err.message)
        failTheBuild("Build failed")
    }
}

def execute() {
  def buildNumber = "$env.BUILD_NUMBER"
	def dbmNode = "master"
	def rootJobName = "$env.JOB_NAME";
	//def branchName = rootJobName.replaceFirst('.*/.*/', '')
	def fullBranchName = rootJobName.replaceFirst('.*/','')
	def branchName = fullBranchName.replaceFirst('%2F', '/')
	def branchType = branchName.replaceFirst('/.*', '')
  def branchVersion = ""
	def landscape = branchType
	if (landscape.equals("release") || landscape.equals("hotfix")) {
		branchVersion = branchName.replaceFirst('.*/', '')
	}
	echo "Inputs: ${rootJobName}, branch: ${branchType}, name: ${branchName}"
	//def automationPath = "C:\\automation\\dbm_demo\\devops"
	def automationPath = "D:\\dbmautomation\\devops_shared"
  def settingsFile = "local_settings_${branchType}.json"
	def pipeline = [:]
	def settings_content = ""
	//def sourceDir = "C:\\automation\\jenkins_pipe"
	def sourceDir = "D:\\dbmautomation\\deploy\\devops"
  this.prepare()
	node(dbmNode) {
		def file_path = "${automationPath}${sep()}settings${sep()}${settingsFile}"
		println "JSON Settings Document: ${file_path}"
		println "Job: ${env.JOB_NAME}"
		def hnd = new File(file_path.trim())
		settings_content = hnd.text
	}
	pipeline = this.get_settings(settings_content, landscape)
	pipeline["branch_name"] = branchName
	pipeline["branch_type"] = branchType
	pipeline["dbm_node"] = dbmNode
  pipeline["staging_dir"] = "${pipeline["staging_dir"]}${sep()}${pipeline["pipeline"]}${sep()}${pipeline["base_schema"]}"
  pipeline["spool_path"] = "${pipeline["staging_dir"]}${sep()}${pipeline["pipeline"]}${sep()}reports"
  
  echo message_box("Pipeline Deployment Using ${landscape} Process", "title")
  echo "Working with: ${rootJobName}\n - Branch: ${landscape} V- ${branchName}\n - Pipe: ${pipeline["pipeline"]}\n - Env: ${pipeline["base_env"]}\n - Schema: ${pipeline["base_schema"]}"
	def version = this.get_version(pipeline)
  pipeline["version"] = version
  // Here we loop through the environments from the settings file to perform the deployment
  def env_num = 0
  pipeline["environments"].each { env ->
    echo "Executing Environment ${env}"
    this.run(new DeployOperation(), pipeline, env_num)
    if (branchType == "master") {
        println "Branch specific work"
    }
    env_num += 1
  }
}

return this;


def get_version(pipe_info){
	// message looks like this "Adding new tables [Version: V2.3.4] "
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
  stage('GitParams') {
  	node (dbm_node) {
  			echo "# Read latest commit..."
  			dir([path:"${base_path}"]){
  				bat "git --version"
				bat ([script: "git remote update && git checkout ${branch_name}${pull_stg}"])
  				gitMessage = bat(
  				  script: "@cd ${base_path} && @git log -1 HEAD --pretty=format:%%s",
  				  returnStdout: true
  				).trim()
  		}
  		echo "# From Git: ${gitMessage}"
  		versionResult = gitMessage.replaceFirst(reg, '$1')
  	}
  }
  // Both branch version and git version git wins as override!
  if (gitMessage.length() != versionResult.length()){
  	echo "# VERSION/FOLDER from git:" + versionResult
  }else{
    echo "# No VERSION/FOLDER found"
    currentBuild.result = "UNSTABLE"
    return
  }
	return versionResult
}

// Run inside a Node block
@NonCPS
def dbmaestro_deploy(environment_map, option = 0) {
    def result = []
    def cnt = 0
    def pair = environment_map.split(",")
    if (pair.size() < 2) {
        return true
    }
    def do_it = true
    pair.each { cur_env ->
        if (cur_env.contains("FIT")) {
            echo env.Optional_Environment_Deploy
            echo cur_env
            if (cur_env.contains(env.Optional_Environment_Deploy) || env.Optional_Environment_Deploy == "BOTH") {
                do_it = true
            } else {
                do_it = false
            }
        } else if (cur_env == "DryRun") {
            if (env.Optional_DryRun_Deploy == "Yes") {
                do_it = true
            } else {
                do_it = false
            }
        }
        cnt += 1
    }
}

@NonCPS
def message_box(msg, def mtype = "sep") {
    def tot = 100
    def start = ""
    def res = ""
    res = "#--------------------------- ${msg} ---------------------------#"
    return res
    msg = (msg.size() > 85) ? msg[0..84] : msg
    def ilen = tot - msg.size()
    if (mtype == "sep") {
        start = "#${"-" * (ilen / 2).toInteger()} ${msg} "
        res = "${start}${"-" * (tot - start.size() + 1)}#"
    } else {
        res = "#${"-" * tot}#\r\n"
        start = "#${" " * (ilen / 2).toInteger()} ${msg} "
        res += "${start}${" " * (tot - start.size() + 1)}#\r\n"
        res += "#${"-" * tot}#\r\n"
    }
    //println res
    return res
}

@NonCPS
def callPreProcess(cur_env) {
    try {
        echo "Running pre processing"
        bat "${pipeline["javaCmd"]} -Upgrade -ProjectName ${pipeline["pipeline"]} -EnvName ${cur_env} -PackageName ${preProcess} -Server ${pipeline["server"]}"
    } catch (Exception e) {
        echo e.getMessage();
    }
}

@NonCPS
def callPostProcess(cur_env) {
    try {
        echo "Running post processing"
        bat "${pipeline["javaCmd"]} -Upgrade -ProjectName ${pipeline["pipeline"]} -EnvName ${cur_env} -PackageName ${postProcess} -Server ${pipeline["server"]}"
    } catch (Exception e) {
        echo e.getMessage();
    }
}

@NonCPS

// GetNextEnv
def shouldDeploy(cur_env) {
    if (cur_env.contains("FIT")) {
        echo env.Optional_Environment_Deploy
        echo cur_env
        if (cur_env.contains(env.Optional_Environment_Deploy) || env.Optional_Environment_Deploy == "BOTH") {
            do_it = true
        } else {
            do_it = false
        }
    } else if (cur_env == "DryRun") {
        if (env.Optional_DryRun_Deploy == "Yes") {
            do_it = true
        } else {
            do_it = false
        }
    } else {
        do_it = true;
    }
    return do_it
}

@NonCPS
def getNextVersion(optionType){
  //Get version from currentVersion.txt file D:\\repo\\N8
  // looks like this:
  // develop=1.10.01
  // release=1.9.03
  def newVersion = ""
  def curVersion = [:]
  def versionFile = "D:\\n8dml\\N8\\currentVersion.txt"
  def contents = readFile(versionFile)
  contents.split("\r\n").each{ -> cur
    def pair = cur.split("=")
    curVersion[pair[0].trim()] = pair[1].trim()
  }
  
  switch (optionType.toLowerCase()) {
    case "develop":
      curVersion["develop"] = newVersion = incrementVersion(curVersion["develop"])
      break
    case "hotfix":
      curVersion["develop"] = newVersion = incrementVersion(curVersion["develop"], "other")
      break
    case "cross_over":
      curVersion["release"] = newVersion = incrementVersion(curVersion["release"])
      break
    case "dml":
      curVersion["release"] = newVersion = incrementVersion(curVersion["release"], "other")
      break
  }
  stg = "develop=${curVersion["develop"]}\r\n"
  stg += "release=${curVersion["release"]}"
  fil.write(stg)
  fil.close()
  return newVersion
}

@NonCPS
def incrementVersion(ver, process = "normal"){
  // ver = 1.9.04
  def new_ver = ver
  def parts = ver.split('\\.')
  if(process == "normal"){
      parts[2] = (parts[2].toInteger() + 1).toString()
      new_ver = parts[0..2].join(".")
  }else{
      if(parts.size() > 3){
          parts[3] = (parts[3].toInteger() + 1).toString()
      }else{
          parts = parts + '1'
      }
      new_ver = parts[0..3].join(".")
  }
  return "V" + new_ver
}
