import groovy.json.*
import java.util.zip.*
 
// DBmaestro Jenkins Groovy Deployment Pipeline
// Set this variable to force it to pick the pipeline
// If it is set to job, then it will match the name of your jenkins job to the key in the branch map in the local_settings.json file.
def landscape = "job"
//def base_path = new File(getClass().protectionDomain.codeSource.location.path).parent
// Set this variable to point to the folder where your local_settings.json folder
def base_path = "C:\\Automation\\dbm_demo\\devops"
// Change this if you want to point to a different local settings file
def settings_file = "local_settings.json"
 
// #------------------- Change anything below at your own risk -------------------#
// #---- (but please take the time to understand what is going on in the code here ;-> ) ---#
def live = false // FIXME just for demo
def flavor = 0
sep = "\\" //FIXME Reset for unix if necessary
 
rootJobName = "$env.JOB_NAME";
if(landscape == "job"){ landscape = rootJobName.toLowerCase() }
//FIXME branchName = rootJobName.replaceFirst('.*/.*/','')
branchName = "master"
branchVersion = ""
// Outboard Local Settings
if(landscape == "job"){ landscape = rootJobName.toLowerCase() }
def local_settings = [:]
// Settings
def git_message = ""
// message looks like this "Adding new tables [Version: V2.3.4] "
def reg = ~/.*\[Version: (.*)\].*/
def environment = ""
def environments = []
def approver = ""
def result = ""
def dbcr_result = ""
def pipeline = ""
def staging_dir = ""
source_dir = ""
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
    choice(name: 'Skip_Packaging', description: "Yes/No to skip packaging step", choices: 'No\nYes')
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
def file_strategy = local_settings["branch_map"][landscape][flavor]["file_strategy"]
credential = credential.replaceFirst("_USER_", local_settings["general"]["username"])
credential = credential.replaceFirst("_PASS_", local_settings["general"]["token"])
source_dir = local_settings["branch_map"][landscape][flavor]["source_dir"]
local_settings = null
 
if( file_strategy != "version"){
  // Reset regex to filter files based on a version
  reg = ~/.*\[Version: (.*)\].*\[DBCR: (.*)\].*/
}
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
    echo "# Looking for a commit message structure like this:"
    echo "#  ${reg}"
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
 
if( !version.startsWith("V")) { version = "V" + result }
if (dbcr_result != ""){
                version = version + "__" + dbcr_result
}
 
echo message_box("${pipeline} Deployment", "title")
echo "# FINAL PACKAGE VERSION: ${version}"
environment = environments[0]
stage(environment) {
  node (dbmNode) {
    //Copy from source to version folder
  if(!env.Skip_Packaging || env.Skip_Packaging == "No"){
    echo "#------------------- Copying files for ${version} ---------#"
      echo "# Cleaning Directory"
      bat "if exist ${staging_dir} del /q ${staging_dir}${sep}*"
      bat "FOR /D %%p IN (\"${staging_dir}${sep}*.*\") DO rmdir \"%%p\" /s /q"
      echo "# Copying using file strategy: ${file_strategy}"
      if(file_strategy == "version"){
      // This is for copying a whole directory
      bat "xcopy /s /y /i \"${source_dir}${sep}${result}\" \"${staging_dir}${sep}${version}\""
    }else{
      // This is for when files are prefixed with <task>
      tasks.split(",").each {item->
        bat "copy \"${source_dir}${sep}${item.trim()}*.sql\" \"${staging_dir}${sep}${version}\""
      }
    }
    echo "#----------------- Packaging Files for ${version} -------#"
    bat "${java_cmd} -Package -ProjectName ${pipeline} -Server ${server} ${credential}"
    // version = adhoc_package(version)
  }else{
    echo "#-------------- Skipping packaging step (parameter set) ---------#"
  }
}
}
 
stage("Nexus push"){
  node(dbmNode){
    echo "Push artifacts to Nexus"
    echo "Creating Zip"
    def zipfile = createZip(version)
    echo "Push to Nexus"
    def curl = "C:\\Automation\\dbm_demo\\devops\\lib\\curl.exe"
    def nexus_token = "secret"
    def nexus_url = "https://nexusdev.test.fyiblue.com/repository"
    def nexus_path = "releases/com/hcsc/sample/sample-app"
    def nexus_version = "${version}/${version}.zip"
    def cmd = "${curl} -k -v -H \"Accept:application/json\" -H \"Authentication:Basic ${nexus_token}\" ${nexus_url}/${nexus_path}/${nexus_version} --upload-file ${zipfile} ${nexus_url}"
    bat cmd
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
def createZip(version){
  stripVer = ""
  if( !version.startsWith("V")) { stripVer = version[1..-1] }
  String zipFileName = "${version}.zip"
  def zipPath = "${source_dir}\\${zipFileName}"
  String inputDir = "${source_dir}\\${stripVer}"
  println "Building: ${zipPath}"
  def outputDir = "${source_dir}" 
  ZipOutputStream zipFile = new ZipOutputStream(new FileOutputStream(zipPath)) 
  new File(inputDir).eachFile() { file ->
    //check if file
    if (file.isFile()){
      zipFile.putNextEntry(new ZipEntry(file.name))
      def buffer = new byte[file.size()] 
      file.withInputStream {
        zipFile.write(buffer, 0, it.read(buffer)) 
      } 
    zipFile.closeEntry()
    }
  } 
  zipFile.close()
  return(zipPath)
}
 
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
 
def execute_prerun_script(source, pipeline, environment) {
  def prerun_script = "prerun.bat"
  fil = new File("${source}${sep}ENV${sep}${prerun_script}")
  if( fil.exists() ) {
    println "> Found Pre-Deploy Script - running..."
    bat "${source}${sep}ENV${sep}${prerun_script} pipeline=${pipeline} environment=${environment}"
  }
  return "ok"
}