// git Hook Receiver
import groovy.json.*
sep = "\\" //FIXME Reset for unix
base_path = new File(getClass().protectionDomain.codeSource.location.path).parent
project = "multibranch"
settings_file = "local_settings.json"
//println "Received githook"

// #--------------------------- MAIN METHODS --------------------------------#

def next_version(proj_json){
	def last_ver = proj_json["version"]
	println "CurVersion: ${last_ver}"
	def parts = last_ver.toString().split("_")
	def the_rest = parts.size() > 1 ? "_" + parts[1..-1].join("_") : ""
	ver_parts = parts[0].split(/\./)
	ver_parts[-1] = (ver_parts[-1].toInteger() + 1)
	def new_ver = ver_parts.join(".") + the_rest
	println "NewVersion: ${new_ver}"
	local_settings["branch_map"][project][0]["version"] = new_ver
	update_settings(local_settings)
	return new_ver	
}

def git_trigger() {
	def workspace = "C:\\Automation\\Multibranch"
	def reg = ~/.*\[DBCR: (.*)\].*/
	def cmd = "git log -1 HEAD" // --pretty=format:%s"
	def res = shell_execute(cmd)
	def raw = ""
	def commit = "dont know yet"
	message_box("Git Trigger")
	println "# Commit: ${res["stdout"]}"
	raw = res["stdout"].toString().trim()
	if(!raw.contains("#DBDEPLOY")){
		println "Commit did not contain #DBDEPLOY"
		System.exit(0)
	}
	def lines = raw.split("\n")
	//println "Git lines: ${lines}"
	lines.each{
		//println "Working: ${it}"
		if(it.startsWith("commit ")){
			commit = it.replaceAll("commit ","").trim()
		}
	}
	println "# Revision: ${commit}"
	//Pick new files in commit
	// git diff-tree --no-commit-id --name-only -r 32b0f0dd6e4bd810f3edc4bcd8a114f8f98a65ea
	cmd = "git diff-tree --no-commit-id --name-only -r ${commit}"
	res = shell_execute(cmd)
	display_result(cmd,res)
	raw = res["stdout"].toString().trim()

	def files = raw.split("\n")
	println "Git new files: ${files}"
	def cur_version = project_settings["version"]
	def copy_files = []
	files.each{ 
		fil = new File("${workspace}${sep}${it}")
		if(fil.getName().endsWith(".sql")) {
			println "Match - ${fil.getName()}"
			copy_files << fil
		}
	}
	if(copy_files.size() > 0){
		def staging_path = local_settings["general"]["staging_path"] + sep + project + sep + project_settings["base_schema"]
		cur_version = next_version(project_settings)
		def target_path = "${staging_path}${sep}${cur_version}"
		cmd = "mkdir ${target_path}"
		res = shell_execute(cmd)
		display_result(cmd,res)
		copy_files.each{
			println "Targ: ${target_path}, ${it.getName()}"
			dest = new File(target_path, it.getName())
			dest << it.text
		}
	}else{
		println "#----- No files for deployment - must have .sql extension"
		System.exit(0)
	}
	// packaging
	dbm_package()
	// upgrade
	dbm_upgrade(cur_version)
}


// #--------------------------- MAIN --------------------------------#

local_settings = get_settings("${base_path}${sep}${settings_file}")
project_settings = local_settings["branch_map"][project][0]
git_trigger()


// #--------------------------- UTILITY METHODS --------------------------------#

def dbm_package() {
  dbm_cli("Package", "-ProjectName ${project}")
}

def dbm_upgrade(version, env = "RS") {
  if(env == "RS"){
	env = local_settings["branch_map"][project][0]["base_env"]
  }
  dbm_cli("Upgrade", "-ProjectName ${project} -EnvName ${env} -PackageName ${version}")
}

def dbm_cli(method, cmd_block){
	def credential = "-AuthType DBmaestroAccount -UserName _USER_ -Password \"_PASS_\""
	credential = credential.replaceFirst("_USER_", local_settings["general"]["username"])
	credential = credential.replaceFirst("_PASS_", local_settings["general"]["token"])
	def java_cmd = local_settings["general"]["java_cmd"]
	def server = local_settings["general"]["server"]
	println "#-------- Performing ${method} command ----------#"
	def cmd = "${java_cmd} -${method} ${cmd_block} -Server ${server} ${credential}"
	println "# Cmd: ${cmd}"
	def res = shell_execute(cmd, "none", 600000)
	display_result(cmd,res)
	if(res["stdout"].contains("SEVERE")){
		println "ERROR in DBm command"
		System.exit(1)
	}
}

def shell_execute(cmd, path = "none", timeout = 100000){
  def pth = ""
  def command = sep == "/" ? ["/bin/bash", "-c"] : ["cmd", "/c"]
  if(path != "none") { 
	pth = "cd ${path} && "
	command << pth
  }
	command << cmd
  def sout = new StringBuffer(), serr = new StringBuffer()
  //println "Running: ${command}"
	def proc = command.execute()
	proc.consumeProcessOutput(sout, serr)
	proc.waitForOrKill(timeout)
  def outtxt = ["stdout" : sout, "stderr" : serr]
  return outtxt
}

def display_result(command, result){
	println "#------------------------------------------------------#"
	println "Running: ${command}"
	println "out> " + result["stdout"]
	println "err> " + result["stderr"]
}

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
    res = "#${"-" * tot}#\n"
    start = "#${" " * (ilen/2).toInteger()} ${msg} "
    res += "${start}${" " * (tot - start.size() + 1)}#\n"
    res += "#${"-" * tot}#\n"
  }
  println res
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  println "#${dashy}#"
}

def get_settings(file_path) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	println "JSON Settings Document: ${file_path}"
	def json_file_obj = new File( file_path )
	if (json_file_obj.exists() ) {
	  settings = jsonSlurper.parseText(json_file_obj.text)  
	}
	println "Project Configurations: ${settings["branch_map"].keySet()}"
	return settings
}

def update_settings(settings_json){
	def fil = new File(base_path, settings_file)
	fil.withWriter('utf-8') { writer -> 
      writer << new JsonBuilder(settings_json).toPrettyString()
	}
	return "${base_path}${sep}${settings_file}"
}
