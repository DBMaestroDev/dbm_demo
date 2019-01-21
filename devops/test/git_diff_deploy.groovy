/*
####### Pluck Files by git-diff ################
#  
# Parses object revisions from dbm or platform dumpfiles into object ddl and pushes into git
=> BJB 1/16/19
*/
import java.sql.Connection
import groovy.sql.Sql
import groovy.json.*
import java.io.File
import java.text.SimpleDateFormat
sep = "\\" //FIXME Reset for windows
def this_path = new File(getClass().protectionDomain.codeSource.location.path).parent
log_file = "${this_path}${sep}dbm_log.txt"
silent_log = false
// #---- Localize Your paths and settings" ------#
settings = [
	"base_path" : "/Users/bbyrd/Documents/DbMaestro/dev/dbm_demo",
	"repository_name" : "REPO",
	"default_branch" : "master",
	"another" : ""
	]
	
commit_id = this.args[0]
init_log()
message_box("Processing Diff for Deployment Files","title")
logit "Commit: ${commit_id}"
params = [:]
process_git_files(commit_id)

// #------------------------------------------#
def process_git_files(commit_id){
	def base_path = setting["base_path"]
	cmd = "cd ${base_path} && git status"
	result = shell_execute(cmd)
	display_result(cmd, result)
	cmd = "cd ${base_path} && git status"
	result = shell_execute(cmd)
	display_result(cmd, result)
	
}


/*
#=>  Utility Routines
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
