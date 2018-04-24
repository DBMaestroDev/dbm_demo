// N8 Error Cleanup
//
import groovy.json.*
import java.sql.Connection
//
// Add a properties for Platform and Skip_Packaging
properties([
	parameters([
		string(name: 'Version', description: "Last successful version", default: 'V1.0.0.0'),
		string(name: 'Failed_Version', description: "Version of this attempt", default: 'V1.0.0.0'),
		choice(name: 'Execute_Rollback', description: "Execute a Rollback", choices: 'No\nYes')
	])
])

// This is the Jenkins alias for the dbmaestro server
def dbmNode = "" //"dbmaestro"
rootJobName = "$env.JOB_NAME";
automationPath = "D:\\automation\\git\\com.adp.avs.dbmaestro.n8.ddu\\dbmaestroGroovyFiles"
automationPath = "C:\\Automation\\jenkins_pipe"
libPath = "C:\\Automation\\dbm_demo\\devops"
settingsFile = "local_settings.json"
pipeline = [:]
sep = "\\"
def stagingDir = ""
def version = ""
def buildNumber = "$env.BUILD_NUMBER"
def flavor = 0
def environment = ""
def approver = ""

// ------------- OUTBOARD SETTINGS FILE -----------------------
node (dbmNode){
	file_path = "${automationPath}${sep}${settingsFile}"
	println "JSON Settings Document: ${file_path}"
	settings_content = readFile(file_path).trim()
  version = env.Version
}

pipeline = get_settings(settings_content, "develop", flavor)

echo "Repairing: ${env.Version}\n - Pipe: ${pipeline["pipeline"]}\n - Env: ${pipeline["baseEnv"]}\n - Schema: ${pipeline["baseSchema"]}"
stagingDir = "${stagingDir}${sep}${pipeline["pipeline"]}${sep}${pipeline["baseSchema"]}"

/*
#-----------------------------------------------#
#  Stages
*/

echo "# FINAL VERSION: ${version}"
environment = pipeline["environments"][0]
approver = pipeline["approvers"][0]

stage('Exit Integration') {
  node (dbmNode) {
    echo "#--- Exit Integration state and checkin changed objects ---#"
    dbmaestro_cli("exit_integration", ["environment" : environment])
    dbmaestro_cli("checkin", ["environment" : environment])
  }
}

environment = pipeline["environments"][0]
approver = pipeline["approvers"][0]
if (env.Failed_Version != "V1.0.0.0"){
  stage("Empty Package"){
      echo "#--- Removing failed script from ${env.Failed_Version} ---#"
      node (dbmNode) {
        dbm_connect("empty_package", ['ARG1' : pipeline["pipeline"], 'ARG2' : env.Failed_Version])
     }
  }
}

if (env.Execute_Rollback == "Yes" && version != "V1.0.0.0"){
  stage("Rollback DIT"){
    echo "#--- Rolling back to ${version} ---#"
    input message: "Rollback DIT?", submitter: approver
    node (dbmNode) {
        //  Deploy to FIT
        dbmaestro_cli("rollback", ["environment" : environment, "version" : version])
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

def adhoc_package(full_package_name){
	echo "Converting to AD-HOC package"
	def parts = full_package_name.split("__")
	def package_name = parts.length == 2 ? parts[1] : full_package_name
	def version = parts[0]
	def dbm_cmd = "cd ${automationPath} && dbm_api.bat action=adhoc_package"
	bat "${dbm_cmd} ARG1=${full_package_name}"
	return package_name
}


def get_settings(content, landscape, flavor = 0) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
  jsonsettings = jsonSlurper.parseText(content)
  settings["server"] = jsonsettings["general"]["server"]
  settings["javaCmd"] = jsonsettings["general"]["java_cmd"]
  settings["stagingDir"] = jsonsettings["general"]["staging_path"]
  // note key off of landscape variable
  settings["baseSchema"] = jsonsettings["branch_map"][landscape][flavor]["base_schema"]
  settings["baseEnv"] = jsonsettings["branch_map"][landscape][flavor]["base_env"]
  settings["pipeline"] = jsonsettings["branch_map"][landscape][flavor]["pipeline"]
  settings["environments"] = jsonsettings["branch_map"][landscape][flavor]["environments"]
  settings["approvers"] = jsonsettings["branch_map"][landscape][flavor]["approvers"]
  settings["sourceDir"] = jsonsettings["branch_map"][landscape][flavor]["source_dir"]
  settings["repository"] = jsonsettings["connections"]["repository"]["connect"]
  // null the variable - not serializable
  jsonsettings = null
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
		if (cur_env.contains("FIT")) {
			if(env.Optional_Environment_Deploy == cur_env) {
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
			echo "#------- Performing Deploy on ${cur_env} -------#"
			bat "${javaCmd} -Upgrade -ProjectName ${pipeline} -EnvName ${cur_env} -PackageName ${version} -Server ${server}"
			emailext( body: "See ${env.BUILD_URL}", subject: "${cur_env} Deployment Successful", to: "AVS_DEVOPS_RELEASE_ENGINEERING@ADP.com,CAPS_Open_Systems_DBA@ADP.com" )
		}
		do_it = true
    cnt += 1
  } // pair
}

def dbmaestro_cli(task, options = [:]) {
	def result = []
  args = ""
  dbm_task = ""
  switch (task.toLowerCase()) {
    case "exit_integration":
      args = "-IntegrationState Exit "
	  dbm_task = "SetIntegrationState"
      break
    case "checkin":
      args = "-comment \"Script ended in error\" "
      dbm_task = "Checkin"
      break
    case "rollback":
      args = "-packageName ${options["version"]} "
      dbm_task = "Rollback"
      break
    case "empty_package":
      args = ""
      break
  }
	echo "#------- Performing ${task} on ${options["pipeline"]} -------#"
	bat "${pipeline["javaCmd"]} -${dbm_task} -ProjectName ${pipeline["pipeline"]} -EnvName ${options["environment"]} ${args} -Server ${pipeline["server"]}"
	
}

def dbm_connect(action, args = [:]){
  def cli = "${libPath}${sep}dbm_api.bat"
  def argstg = ""
  args.each {cur -> 
    argstg += "${cur}=${arg[cur]} "
  }
  echo "Executing: dbm_api.bat action=${action} ${argstg}"
  bat "${cli} action=${action} ${arg_stg}"
}