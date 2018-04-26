// N8 Deployment Pipeline
//
import groovy.json.*
//
// Add a properties for Platform and Skip_Packaging
properties([
	parameters([
		//choice(name: 'Landscape', description: "Develop/Release to specify deployment target", choices: 'MP_Dev\nMP_Dev2,MP_Release'),
		choice(name: 'Skip_Packaging', description: "Yes/No to skip packaging step", choices: 'No\nYes'),
		choice(name: 'Optional_DryRun_Deploy', description: "Deploy to DryRun", choices: 'No\nYes')
	])
])

// This is the Jenkins alias for the dbmaestro server
def dbmNode = "dbmaestro"
rootJobName = "$env.JOB_NAME";
branchName = rootJobName.replaceFirst('.*/.*/','')
branchName = branchName.replaceFirst('%2F','/')
branchType = branchName.replaceFirst('/.*','')
def landscape = branchType
if(branchType.equals("release") || branchType.equals("hotfix")){
    branchVersion = branchName.replaceFirst('.*/','')
}
automationPath = "D:\\automation\\git\\com.adp.avs.dbmaestro.n8.ddu\\dbmaestroGroovyFiles"
settingsFile = "local_settings.json"
local_settings = [:]
branchVersion = ""
version = ""
def gitMessage = ""
sep = "\\"
// message looks like this "Adding new tables [Version: V2.3.4] "
def reg = ~/.*\[Version: (.*)\].*/
def stagingDir = ""
def baseEnv = "Dev"
def buildNumber = "$env.BUILD_NUMBER"
def ddu_deploy = false
def flavor = 0
def sourceDir = ""
def baseDir = ""
def environment = ""
def approver = ""
def settings_content = ""
def option = 0

// ------------- OUTBOARD SETTINGS FILE -----------------------
node (dbmNode){
	ddu_deploy = (env.JOB_NAME).toLowerCase().contains("ddu")
	file_path = "${automationPath}${sep}${settingsFile}"
	println "JSON Settings Document: ${file_path}"
	settings_content = readFile(file_path).trim()
}

local_settings = get_settings(settings_content)
server = local_settings["general"]["server"]
javaCmd = local_settings["general"]["java_cmd"]
stagingDir = local_settings["general"]["staging_path"]
// note key off of landscape variable
baseSchema = local_settings["branch_map"][landscape][flavor]["base_schema"]
baseEnv = local_settings["branch_map"][landscape][flavor]["base_env"]
pipeline = local_settings["branch_map"][landscape][flavor]["pipeline"]
environments = local_settings["branch_map"][landscape][flavor]["environments"]
def approvers = local_settings["branch_map"][landscape][flavor]["approvers"]
sourceDir = local_settings["branch_map"][landscape][flavor]["source_dir"]
if (branchType == "hotfix" && !ddu_deploy) {
  // Hotfix will switch so need release values saved
  r_baseSchema = baseSchema
  r_baseEnv = baseEnv
  r_pipeline = pipeline
  r_environments = environments
  r_approvers = approvers
  baseSchema = local_settings["branch_map"]["develop"][flavor]["base_schema"]
  baseEnv = local_settings["branch_map"]["develop"][flavor]["base_env"]
  pipeline = local_settings["branch_map"]["develop"][flavor]["pipeline"]
  environments = local_settings["branch_map"]["develop"][flavor]["environments"]
  approvers = local_settings["branch_map"]["develop"][flavor]["approvers"]
}
// null the variable - not serializable
local_settings = null

echo "Working with: ${rootJobName}\n - Branch: ${branchType}\n - Pipe: ${pipeline}\n - Env: ${baseEnv}\n - Schema: ${baseSchema}"
stagingDir = "${stagingDir}${sep}${pipeline}${sep}${baseSchema}"
def spoolPath = "${stagingDir}${sep}${pipeline}${sep}reports"
// Add new ddu/ddl subdir to repo
sourceDir = "${sourceDir}${sep}${ ddu_deploy ? "ddu" : "ddl" }"

/*
#-----------------------------------------------#
#  Stages
*/
stage('GitParams') {
  node (dbmNode) {
    echo '#---------------------- Summary ----------------------#'
    echo "#  Validating Git Commit"
    echo "#------------------------------------------------------#"
    echo "# Update git repo..."
    echo "# Reset local path - original:"
    bat "echo %PATH%"
    def local_path = "C:\\ProgramData\\Oracle\\Java\\javapath;D:\\oracle\\product\\12.2.0\\client_1\\bin;C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Program Files\\Git\\cmd"
    echo "# Now: \n${local_path}"

    withEnv(["PATH=${local_path}"])
    {
        echo "# Read latest commit..."
        dir([path:"${sourceDir}"])
        {
            bat "git --version"
            bat ([script: "git remote update && git checkout ${branchName} && git pull origin ${branchName}"])
            gitMessage = bat(
            script: "@cd ${sourceDir} && @git log -1 HEAD --pretty=format:%%s",
            returnStdout: true
            ).trim()
        }
    }
    //gitMessage = "This is git message. [VERSION: 2.5.0]"
    echo "# From Git: ${gitMessage}"
    result = gitMessage.replaceFirst(reg, '$1')
  }
}

if(! branchVersion.equals("")){
	// Both branch version and git version git wins as override!
	if (gitMessage.length() != result.length()){
		echo "# VERSION from git:" + result
		echo "# VERSION from branch:" + branchVersion
		echo "# git version overrides branch version!"
	}else{
		echo "# VERSION from branch:" + branchVersion
		result = branchVersion
	}
}else if (gitMessage.length() == result.length()){
	echo "No VERSION found"
	currentBuild.result = "UNSTABLE"
	return
}else{
	echo "# VERSION from git:" + result
}

version = "V" + result
echo "# FINAL VERSION: ${version}"

if( branchType == "hotfix" || branchType == "develop") {
  stage('Packaging') {
    node (dbmNode) {
      //Copy from source to version folder
      if( !env.Skip_Packaging || env.Skip_Packaging == "No"){
        echo '#------- Cleaning Directory -------#'
        bat "del /q \"${stagingDir}\\*\""
        bat "FOR /D %%p IN (\"${stagingDir}\\*.*\") DO rmdir \"%%p\" /s /q"
        echo '#------- Copying files for ${version} -------#'
        // trigger packaging
        echo '#------- Packaging Files for ${version} -------#'
        bat "${javaCmd} -Package -ProjectName ${pipeline} -Server ${server}"
		if (ddu_deploy) {
			version = adhoc_package(version)
		}
      }
    }
  }
}
if( branchType == "develop" || (branchType == "hotfix" && !ddu_deploy)) {
  environment = environments[0]
  approver = approvers[0]
  stage("${branchType}_DIT"){
      checkpoint('Rerun DIT')
      node (dbmNode) {
        //  Deploy to DIT
        dbmaestro_deploy(environment, option)
      }
  }
  environment = environments[1]
  approver = approvers[1]
  stage("${branchType}_FIT"){
      checkpoint('Rerun FIT')
      input message: "Deploy to FIT?", submitter: approver
      node (dbmNode) {
        //  Deploy to FIT
        dbmaestro_deploy(environment, option)
     }
    // }
  }
}
//
if( branchType == "hotfix" && !ddu_deploy) {
  //Reset variables for next pipeline
  environments = r_environments
  approvers = r_approvers
}
if( branchType == "release" || branchType == "hotfix") {
  environment = environments[0]
  approver = approvers[0]
  stage("${branchType}_SIT"){
      checkpoint('Rerun SIT')
      input message: "Deploy to SIT?", submitter: approver
      node (dbmNode) {
        if( branchType == "hotfix" && !ddu_deploy) {
          // Hotfix needs package transfer on the fly
          transfer_packages(pipeline, r_pipeline, version)
          pipeline = r_pipeline
        }
        //  Deploy to SIT
        dbmaestro_deploy(environment, option)
	    }
  }

  environment = environments[1]
  approver = approvers[1]
  stage("${branchType}_Staging"){
    checkpoint('Rerun Staging')
    input message: "Deploy to Staging?", submitter: approver
      node (dbmNode) {
		    //  Deploy to Staging
		    dbmaestro_deploy(environment, option)
      }
  }

  environment = environments[2]
  approver = approvers[2]
  stage("${branchType}_PROD"){
    checkpoint('Rerun Prod')
    input message: "Deploy to Prod?", submitter: approver
  	node (dbmNode) {
  	  //  Deploy to PROD
  	  dbmaestro_deploy(environment, option)
    }
  }
}
if (ddu_deploy){
  node (dbmNode) {
    echo '#------- Copying Spool files ---------#'
    echo "From: ${spool_path}${sep}ddu_${version}*"
    echo "To: ${env.WORKSPACE}"
    bat "xcopy /y /s /i \"${spool_path}${sep}ddu_${version}*.txt" \"${env.WORKSPACE}\""
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

def adhoc_package(full_package_name){
	echo "Converting to AD-HOC package"
	def parts = full_package_name.split("__")
	def package_name = parts.length == 2 ? parts[1] : full_package_name
	def version = parts[0]
	def dbm_cmd = "cd ${automationPath} && dbm_api.bat action=adhoc_package"
	bat "${dbm_cmd} ARG1=${full_package_name}"
	return package_name
}


def get_settings(content) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	  settings = jsonSlurper.parseText(content)
	return settings
}

def environment_choice(env, option = 0) {
  def pair = env.split(",")
  if (pair.length < 2) { return pair }
  def do_pair = false
  if (option == 0) {
	  pair = pair - pair[1]
  }else if (option == 1) {
	  pair = pair - pair[0]
  }else{
	  // la di da
  }
  return pair
}

def dbmaestro_deploy(environment_map, option = 0) {
	def result = []
	def cnt = 0
	def pair = environment_map.split(",")
	def do_it = true
	pair.each { cur_env ->
		/*
		if (cur_env.contains("FIT") {
			if(env.Optional_Environment_Deploy == cur_env) {
				skip_it = false
			}else{
		
		}else if(cur_env == 'DryRun' && env.Optional_DryRun_Deploy == "Yes") {do_it = true
		}else if(cnt > 1 && option > 1) {do_it = true
		}else { do_it = true }
		*/
		if (do_it && cnt < 1) {
			echo '#------- Performing Deploy on ${cur_env} -------#'
			bat "${javaCmd} -Upgrade -ProjectName ${pipeline} -EnvName ${cur_env} -PackageName ${version} -Server ${server}"
			emailext( body: "See ${env.BUILD_URL}", subject: "${cur_env} Deployment Successful", to: "AVS_DEVOPS_RELEASE_ENGINEERING@ADP.com,CAPS_Open_Systems_DBA@ADP.com" )
		}
        cnt += 1
	}
}

def transfer_packages(source_pipe, target_pipe, packages){
  bat "set SOURCE_PIPELINE=${source_pipe} && set TARGET_PIPELINE=${target_pipe} && set EXPORT_PACKAGES=${packages} && ${automationPath}${sep}dbm_api.bat action=packages ARG1=${source_pipe} && ${automationPath}${sep}dbm_api.bat action=export_packages ARG1=${source_pipe} "
}
