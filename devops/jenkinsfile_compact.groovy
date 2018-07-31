import groovy.json.*

// Add a properties for Platform and Skip_Packaging  
properties([
	parameters([
		//choice(name: 'Landscape', description: "Develop/Release to specify deployment target", choices: 'MP_Dev\nMP_Dev2,MP_Release'),
		choice(name: 'Skip_Packaging', description: "Yes/No to skip packaging step", choices: 'No\nYes')
	])
])

/*
Jenkinsfile for all in one operation

Fill in Settings array to personalize for this installation
*/
local_settings = [
    "general" : [
      "base_path" : "C:\\Automation\\dbm_demo",
      "java_cmd" : "java -jar \"C:\\Program Files (x86)\\DBmaestro\\TeamWork\\TeamWorkOracleServer\\Automation\\DBmaestroAgent.jar\"",
      "staging_path" : "C:\\pipelinescript",
      "server" : "dbmtemplate",
  	  "username" : "dbmguest@dbmaestro.com",
  	  "token" : "2BqDtNyL7gQjp6J0Kp7HNHbB5P0WayH0"
    ],
    "connections" : [
    "repository" : [
      "user" : "twmanagedb",
      "password" : "manage#2009",
      "connect" : "dbmtemplate:1521/orcl"
    ],
    "remote" : [
      "user" : "dbmaestro_teamwork",
      "password" : "Remote#2009",
      "connect" : "dbmtemplate:1521/orcl"
			]
  ],
	"branch_map" : [
		"release" : [
		[
		  "pipeline" : "HumanResources",
		  "base_env" : "DIT",
		  "base_schema" : "HR_DEV",
  	  "source_dir" : "C:\\Automation\\dbm_demo\\hr_demo\\versions",
		  "environments" : [
			 "DIT",
			 "QA1,QA2",
			 "STAGE",
			 "PROD"
		   ],
 		  "approvers" : [
 			 "teamwork",
 			 "teamwork",
 			 "teamwork",
 			 "teamwork"
 		   ]
		  ]
		],
		"hrm" : [
		[
		  "pipeline" : "HRMADM",
		  "base_env" : "Day0",
		  "base_schema" : "AH3111ODZ_DEVOPS",
		  "source_dir" : "C:\\Automation\\dbm_demo\\hrm_demo\\3.11.2\\db_request\\SQLSRV",
		  "environments" : [
			 "Day0",
			 "SHK",
			 "ST",
			 "QA"
		   ],
		  "approvers" : [
			 "teamwork",
			 "teamwork",
			 "teamwork",
			 "teamwork"
		   ]
		 ]
		]
	]
]

/*
Jenkinsfile Code
*/

def landscape = "develop"
def live = false // FIXME just for demo
def flavor = 0
sep = "\\"
rootJobName = "$env.JOB_NAME";
//FIXME branchName = rootJobName.replaceFirst('.*/.*/','')
branchName = "master"
branchVersion = ""
// Settings
def git_message = ""
// message looks like this "Adding new tables [Version: V2.3.4] "
//def reg = ~/.*\[Version: (.*)\].*\[DBCR: (.*)\].*/
def reg = ~/.*\[Version: (.*)\].*/
def buildNumber = "$env.BUILD_NUMBER"
def credential = "-AuthType DBmaestroAccount -UserName _USER_ -Password \"_PASS_\""
def server = local_settings["general"]["server"]
def java_cmd = local_settings["general"]["java_cmd"]
def dbmNode = ""
def staging_path = local_settings["general"]["staging_path"]
// note key off of landscape variable
def base_schema = local_settings["branch_map"][landscape][flavor]["base_schema"]
def base_env = local_settings["branch_map"][landscape][flavor]["base_env"]
def pipeline = local_settings["branch_map"][landscape][flavor]["pipeline"]
environments = local_settings["branch_map"][landscape][flavor]["environments"]
def approvers = local_settings["branch_map"][landscape][flavor]["approvers"]
credential = credential.replaceFirst("_USER_", local_settings["general"]["username"])
credential = credential.replaceFirst("_PASS_", local_settings["general"]["token"])
def source_dir = local_settings["branch_map"][landscape][flavor]["source_dir"]
local_settings = null

 echo "Working with: ${rootJobName}\n - Branch: ${branchName}\n - Pipe: ${pipeline}\n - Env: ${base_env}\n - Schema: ${base_schema}"
staging_dir = "${staging_path}${sep}${pipeline}${sep}${base_schema}"

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
        echo "# Read latest commit..."
        bat "git --version"
        git_message = bat(
          script: "@cd ${source_dir} && @git log -1 HEAD --pretty=format:%%s",
          returnStdout: true
        ).trim()

    //git_message = "This is git message. [VERSION: 2.5.0]"
    echo "# From Git: ${git_message}"
    result = git_message.replaceFirst(reg, '$1')
	//  dbcr_result = git_message.replaceFirst(reg, '$2')
	//git_message = "[Version: 3.11.2.1] using [DBCR: ADVTA00292]"
	//result = "3.11.2.1"
  }
}

if(! branchVersion.equals("")){
	// Both branch version and git version git wins as override!
	if (git_message.length() != result.length()){
		echo "# VERSION from git:" + result
		echo "# VERSION from branch:" + branchVersion
		echo "# git version overrides branch version!"
	}else{
		echo "# VERSION from branch:" + branchVersion
		result = branchVersion
	}
}else if (git_message.length() == result.length()){
	echo "No VERSION found\nResult: ${result}\nGit: ${git_message}"
	currentBuild.result = "UNSTABLE"
	return
}else{
	echo "# VERSION from git:" + result
}

version = "V" + result // + "__" + dbcr_result
if (dbcr_result == "" && env.Skip_Packaging != "No"){
	version = "V" + result
}

echo message_box("${pipeline} Deployment", "title")
echo "# FINAL PACKAGE VERSION: ${version}"
environment = environments[0]
stage(environment) {
  node (dbmNode) {
    //Copy from source to version folder
  if(!env.Skip_Packaging || env.Skip_Packaging == "No"){
    echo "#------------------- Copying files for ${version} ---------#"
    bat "if exist ${staging_dir} del /q ${staging_dir}\\*"
    // This is for when files are prefixed with <dbcr_result>
    //bat "if not exist \"${staging_dir}${sep}${version}\" mkdir \"${staging_dir}${sep}${version}\""
    //bat "copy \"${source_dir}${sep}${dbcr_result}*.sql\" \"${staging_dir}${sep}${version}\""
    // This is for copying a whole directory
    bat "xcopy /s /y /i \"${source_dir}${sep}${result}\" \"${staging_dir}${sep}${version}\""
    // trigger packaging
    echo "#----------------- Packaging Files for ${version} -------#"
    bat "${java_cmd} -Package -ProjectName ${pipeline} -Server ${server} ${credential}"
    // version = adhoc_package(version)
  }else{
	  echo "#-------------- Skipping packaging step (parameter set) ---------#"
  }
    // Deploy to Dev
    echo "#------------------- Performing Deploy on ${environment} -------------#"
    try {
      bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server}"
		} catch (Exception e) {
			echo e.getMessage();
		}
    
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
		bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${pair[0]} -PackageName ${version} -Server ${server}"
		if (do_pair) {
			bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${pair[1]} -PackageName ${version} -Server ${server}"
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
		bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server}"
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
		bat "${java_cmd} -Upgrade -ProjectName ${pipeline} -EnvName ${environment} -PackageName ${version} -Server ${server}"
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

@NonCPS
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

