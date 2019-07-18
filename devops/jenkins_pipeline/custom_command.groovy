/*
####### Custom Commands ################
#
# Processes Basic API commands with rich arguments
=> BJB 6/15/19
*/
import java.io.File
import java.text.SimpleDateFormat
sep = "\\" //FIXME Reset for windows
def this_path = new File(getClass().protectionDomain.codeSource.location.path).parent
log_file = "${this_path}${sep}dbm_log.txt"
silent_log = false
// #---- Localize Your paths and settings" ------#
settings = [
	"base_path" : "C:\\Automation\\local",
	"default_branch" : "master",
	"java_cmd" : "java -jar \"C:\\Program Files (x86)\\DBmaestro\\TeamWork\\TeamWorkOracleServer\\Automation\\DBmaestroAgent.jar\"",
	"staging_path" : "C:\\scripts\\scenarios",
	"server" : "localhost",
	"username" : "automation@dbmaestro.com",
	"token" : "8Nfdszu5MJfzYOPJGp3cABczsmEPlxLK"
	]

command = this.args[0]
init_log()
message_box("Processing ${command}from Jenkins","title")
switch (command.toLowerCase()) {
	case "custom_build":
		custom_build()
		break
}


def custom_build() {
		def src_arg = System.getenv("SourceEnvironment").trim()
		def tgt_arg = System.getenv("TargetEnvironment").trim()
		def environment = src_arg.split("\\|")[1]
		def pipeline = src_arg.split("\\|")[0]
		def target = tgt_arg.split("\\|")[1]
		def target_pipeline = tgt_arg.split("\\|")[0]
		def baseline_version = System.getenv("BaselineVersion").trim()
		logit "Pipeline: ${pipeline}, SourceEnvironment: ${environment}, TargetEnvironment: ${target}, BaselineVersion: ${baseline_version}"
		def cmd = "${settings["java_cmd"]} -CustomBuild"
		cmd += " -SourceProjectName ${pipeline} -SourceEnvName ${environment} -TargetProjectName ${target_pipeline} -TargetEnvName ${target} -SourceVersionType \"Latest Checkin\" -TargetVersionType Live -BaselineOrigin Source -BaselineLabelName ${baseline_version} -OutputPath ${settings["base_path"]}"
		cmd += " -Server ${settings["server"]} -AuthType DBmaestroAccount -UserName ${settings["username"]} -Password \"${settings["token"]}\""
		def result = shell_execute(cmd)
		display_result(cmd, result)


}


def parse_arguments(args){
  for (arg in args) {
    //logit arg
    pair = arg.split("=")
    if(pair.size() == 2) {
      arg_map[pair[0].trim()] = pair[1].trim()
    }else{
      arg_map[arg] = ""
    }
  }

}

/*
####  Utility Routines
*/

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
  logit res
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  logit "#${dashy}#"
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

def shell_execute(cmd, path = "none"){
  def pth = ""
  if(path != "none") { pth = "cd ${path} && " }
	def command = sep == "/" ? ["/bin/bash", "-c"] : ["cmd", "/c"]
	command << cmd
  def sout = new StringBuffer(), serr = new StringBuffer()
	def proc = command.execute()
	proc.consumeProcessOutput(sout, serr)
	proc.waitForOrKill(1000)
  def outtxt = ["stdout" : sout, "stderr" : serr]
  return outtxt
}

def display_result(command, result){
	separator()
	logit "Running: ${command}"
	logit "out> " + result["stdout"]
	logit "err> " + result["stderr"]
}

def init_log(){
	logit("#------------- New Run ---------------#")
	//logit("# ARGS:")
	//logit(arg_map.toString())
}

def logit(String message, log_type = "INFO", log_only = false){
	def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
	def cur_date = new Date()
	def hnd = new File(log_file)
	if( !hnd.exists() ){
		hnd.createNewFile()
	}
  def stamp = "${sdf.format(cur_date)}|${log_type}> "
  message.eachLine { line->
		if(!silent_log && !log_only){
			println "${stamp}${line.trim()}"
		}
		hnd.append("\r\n${stamp}${line}")
	}
}
