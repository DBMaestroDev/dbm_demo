// Deployment Pipeline
//
import groovy.json.*
//
// Add a properties for Platform and Skip_Packaging
properties([
	parameters([
		choice(name: 'Skip_Packaging', description: "Yes/No to skip packaging step", choices: 'No\nYes'),
		choice(name: 'Optional_Environment_Deploy', description: "Deploy to DryRun", choices: 'FIT1\nFIT2BOTH\n'),
		choice(name: 'Optional_DryRun_Deploy', description: "Deploy to DryRun", choices: 'No\nYes'),
		choice(name: 'Release_Type', description: "Major or Minor", choices: 'Minor\nMajor')
	])
])

sep = "\\"
// This is the Jenkins alias for the dbmaestro server
def dbmNode = ""
// Set this for automatic versioning
def assignVersion = true

// This is the pattern for pulling info from git commit message
def reg = ~/.*\[Version: (.*)\].*/
automationPath = "C:\\automation\\dbm_demo\\devops"
def flavor = 0
def gitMessage = ""
def versionResult = ""
def buildNumber = "$env.BUILD_NUMBER"

// ------------- Git Branch -----------------------
def rootJobName = "$env.JOB_NAME";
def branchName = rootJobName.replaceFirst('.*/','')
branchName = branchName.replaceFirst('%2F','/')
def branchType = branchName.replaceFirst('/.*','')
def developBranch = "develop"
def landscape = branchType

// ------------- Update Local Git -----------------------
stage('GitParams') {
	node (dbmNode) {
		def local_path = "C:\\ProgramData\\Oracle\\Java\\javapath;D:\\oracle\\product\\12.2.0\\client_1\\bin;C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Program Files\\Git\\cmd"
		withEnv(["PATH=${local_path}"]) {
			echo "# Read latest commit..."
			dir([path:"${automationPath}"]){
				bat "git --version"
				bat ([script: "git remote update && git checkout ${branchName} && git pull origin ${branchName}"])
				gitMessage = bat(
				  script: "@cd ${automationPath} && @git log -1 HEAD --pretty=format:%%s",
				  returnStdout: true
				).trim()
      }
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

// ------------- OUTBOARD SETTINGS FILE -----------------------
pipeline = [:]
def settingsFile = "local_settings.json"
node (dbmNode){
	adHocDeploy = (env.JOB_NAME).toLowerCase().contains("dml")
	def file_path = "${automationPath}${sep}${settingsFile}"
	println "JSON Settings Document: ${file_path}"
	settings_content = readFile(file_path).trim()
}
pipeline = get_settings(settings_content, landscape)

if (adHocDeploy) { landscape = "ddu" }
echo message_box("Pipeline Deployment Using ${landscape} Process", "title")
println "=> Inputs: ${rootJobName}, branch: ${branchType}, name: ${branchName}"

if (landscape == "hotfix") {
	// Hotfix will start in develop
	pipeline = get_settings(settings_content, developBranch)
}

echo "=> Working with: Pipe: ${pipeline["pipeline"]}\n - Env: ${pipeline["baseEnv"]}\n - Schema: ${pipeline["baseSchema"]}"
def stagingDir = "${pipeline["stagingDir"]}${sep}${pipeline["pipeline"]}${sep}${pipeline["baseSchema"]}"
def spoolPath = "${stagingDir}${sep}${pipeline["pipeline"]}${sep}reports"
// Add new ddu/ddl subdir to repo
sourceDir = "${pipeline["sourceDir"]}${sep}${ adHocDeploy ? "ddu" : "ddl" }"
if (assignVersion) {
  node (dbmNode){
  	def versionContents = readFile(pipeline["general"]["version_file"]).trim()
  	println "currentVersion Document: ${pipeline["general"]["version_file"]}"
    
  }
}
version = "V" + versionResult
echo message_box("# FINAL VERSION: ${version}", "title")

/*
#-----------------------------------------------#
#	 Stages
*/


if( ["hotfix","ddu","develop"].contains(landscape)) {
	stage('Packaging') {
		node (dbmNode) {
			//Copy from source to version folder
			if( !env.Skip_Packaging || env.Skip_Packaging == "No"){
				echo message_box("Cleaning Directory")
				bat "del /q \"${stagingDir}\\*\""
				bat "FOR /D %%p IN (\"${stagingDir}\\*.*\") DO rmdir \"%%p\" /s /q"
				echo message_box("Copying files for ${version}")
				bat "xcopy /y /s /i \"${sourceDir}\\${versionResult}\" \"${stagingDir}\\${version}\""
				// trigger packaging
				echo message_box("Packaging Files for ${version}")
				bat "${pipeline["javaCmd"]} -Package -ProjectName ${pipeline["pipeline"]} -Server ${pipeline["server"]}"
				if (landscape == "ddu") {
					version = adhoc_package(version)
				}
			}
		}
	}
}

// Hotfix and Development start in the DEV landscape
if( ["hotfix","develop"].contains(landscape)) {
	environment = pipeline["environments"][0]
	approver = pipeline["approvers"][0]
	stage("${landscape}_DIT"){
			//FIXME checkpoint('Rerun DIT')
			node (dbmNode) {
				//	Deploy to DIT
				dbmaestro_deploy(environment, option)
			}
	}
	environment = pipeline["environments"][1]
	approver = pipeline["approvers"][1]
	stage("${landscape}_FIT"){
			//FIXME checkpoint('Rerun FIT')
			input message: "Deploy to FIT?", submitter: approver
			node (dbmNode) {
				//	Deploy to FIT
				dbmaestro_deploy(environment, option)
		 }
		// }
	}
}

// Hotfix runs all environments, thus packages need to be transferred between pipelines
// Must reset the pipeline map for the Release landscape
if( landscape == "hotfix") {
	//Reset variables for next pipeline
	altPipeline = pipeline["pipeline"]
	pipeline = get_settings(settings_content, landscape)
}

if( ["hotfix","release","ddu"].contains(landscape)) {
	environment = pipeline["environments"][0]
	approver = pipeline["approvers"][0]
	stage("${landscape}_SIT"){
			//FIXME checkpoint('Rerun SIT')
			input message: "Deploy to SIT?", submitter: approver
			node (dbmNode) {
				if( landscape == "hotfix" ) {
					// Hotfix needs package transfer on the fly
          echo message_box("Switching to Release pipeline")
					transfer_packages(altPipeline, pipeline["pipeline"], [version])
				}
				//	Deploy to SIT
				dbmaestro_deploy(environment, option)
			}
	}

	environment = pipeline["environments"][1]
	approver = pipeline["approvers"][1]
	stage("${landscape}_Staging"){
		//FIXME checkpoint('Rerun Staging')
		input message: "Deploy to Staging?", submitter: approver
			node (dbmNode) {
				//	Deploy to Staging
				dbmaestro_deploy(environment, option)
			}
	}

	environment = pipeline["environments"][2]
	approver = pipeline["approvers"][2]
	stage("${landscape}_PROD"){
		//FIXME checkpoint('Rerun Prod')
		input message: "Deploy to Prod?", submitter: approver
		node (dbmNode) {
			//	Deploy to PROD
			dbmaestro_deploy(environment, option)
		}
	}
}
if (landscape == "ddu"){
	node (dbmNode) {
		echo message_box("Copying Spool files")
		echo "From: ${spool_path}${sep}ddu_${version}*"
		echo "To: ${env.WORKSPACE}"
		bat "xcopy /y /s /i \"${spool_path}${sep}ddu_${version}*.txt\" \"${env.WORKSPACE}\""
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

@NonCPS
def adhoc_package(full_package_name){
	echo message_box("Converting to AD-HOC package")
	def parts = full_package_name.split("__")
	def package_name = parts.length == 2 ? parts[1] : full_package_name
	def version = parts[0]
	def dbm_cmd = "cd ${automationPath} && dbm_api.bat action=adhoc_package"
	bat "${dbm_cmd} ARG1=${full_package_name}"
	return package_name
}

@NonCPS
def get_settings(content, landscape, flavor = 0) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	def pipe = [:]
	settings = jsonSlurper.parseText(content)
	pipe["server"] = settings["general"]["server"]
	pipe["javaCmd"] = settings["general"]["java_cmd"]
	pipe["stagingDir"] = settings["general"]["staging_path"]
	echo "Landscape: ${landscape}, f: ${flavor}"
	// note key off of landscape variable
	pipe["baseSchema"] = settings["branch_map"][landscape][flavor]["base_schema"]
	pipe["baseEnv"] = settings["branch_map"][landscape][flavor]["base_env"]
	pipe["pipeline"] = settings["branch_map"][landscape][flavor]["pipeline"]
	pipe["environments"] = settings["branch_map"][landscape][flavor]["environments"]
	pipe["approvers"] = settings["branch_map"][landscape][flavor]["approvers"]
	pipe["sourceDir"] = settings["branch_map"][landscape][flavor]["source_dir"]
		
	return pipe
}

// Run inside a Node block
@NonCPS
def dbmaestro_deploy(environment_map, option = 0) {
	def result = []
	def cnt = 0
	def pair = environment_map.split(",")
	def do_it = true
	pair.each { cur_env ->
		if (cur_env.contains("FIT")) {
			if(env.Optional_Environment_Deploy == cur_env || env.Optional_Environment_Deploy == "BOTH") {
				do_it = true
			}else{
				do_it = false
			}
		}else if(cur_env == "DryRun"){
			if(env.Optional_DryRun_Deploy == "Yes") {
				do_it = true
			}else{
				do_it = false
			}
		}
		if (do_it) {
			echo message_box("Performing Deploy on ${cur_env}", "title")
			bat "${pipeline["javaCmd"]} -Upgrade -ProjectName ${pipeline["pipeline"]} -EnvName ${cur_env} -PackageName ${version} -Server ${pipeline["server"]}"
			emailext( body: "See ${env.BUILD_URL}", subject: "${cur_env} Deployment Successful", to: "suppotr@dbmaestro.com" )
		}
				cnt += 1
	}
}

@NonCPS
def transfer_packages(source_pipe, target_pipe, packages){
	bat "set SOURCE_PIPELINE=${source_pipe} && set TARGET_PIPELINE=${target_pipe} && set EXPORT_PACKAGES=${packages.join(",")} && ${automationPath}${sep}dbm_api.bat action=packages ARG1=${source_pipe} && ${automationPath}${sep}dbm_api.bat action=export_packages ARG1=${source_pipe} "
	echo message_box("Packaging Files for ${packages.join(",")}")
	bat "${javaCmd} -Package -ProjectName ${pipeline["pipeline"]} -Server ${server}"
	
}

@NonCPS
def message_box(msg, def mtype = "sep") {
  def tot = 100
  def start = ""
  def res = ""
  msg = (msg.size() > 85) ? msg[0..84] : msg
  def ilen = tot - msg.size()
  if (mtype == "sep"){
    start = "#${"-" * (ilen/2).toInteger()} ${msg} "
    res = "${start}${"-" * (tot - start.size() + 1)}#"
  }else{
    res = "#${"-" * tot}#\r\n"
    start = "#${" " * (ilen/2).toInteger()} ${msg} "
    res += "${start}${" " * (tot - start.size() + 1)}#\r\n"
    res += "#${"-" * tot}#\r\n"   
  }
  //println res
  return res
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
def getNextVersion(optionType, contents){
  //Get version from currentVersion.txt file D:\\repo\\N8
  // looks like this:
  // develop=1.10.01
  // release=1.9.03
  def newVersion = ""
  def curVersion = [:]
  for (cur in contents.split("\r\n") { 
    def pair = cur.split("=")
    curVersion[pair[0].trim()] = pair[1].trim()
  }
  switch (optionType.toLowerCase()) {
    case "develop":
      curVersion["develop"] = incrementVersion(curVersion["develop"])
      break
    case "hotfix":
      curVersion["develop"] = incrementVersion(curVersion["develop"])
      break
  }
  return curVersion
}

@NonCPS
def incrementVersion(ver){
  // ver = 1.9.04
  def process = env.Release_Type == "Major" ? "normal" : "other"
  def new_ver = ver
  def parts = ver.split('\\.')
  if(process == "normal"){
      parts[2] = (parts[2].toInteger() + 1).toString()
      new_ver = parts[0] + "." + parts[1] + "." + parts[2]
  }else{
      if(parts.size() > 3){
          parts[3] = (parts[3].toInteger() + 1).toString()
      }else{
          parts = parts + '1'
      }
      new_ver = parts[0] + "." + parts[1] + "." + parts[2] "." + parts[3]
  }
  return new_ver
}