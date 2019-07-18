/*
####### SQL Revision Parser ################
#  
# Parses object revisions from dbm or platform dumpfiles into object ddl and pushes into git
=> BJB 9/18/18
*/
import java.sql.Connection
import groovy.sql.Sql
import groovy.json.*
import java.io.File
import java.text.SimpleDateFormat
sep = "\\" //FIXME Reset for windows
def this_path = new File(getClass().protectionDomain.codeSource.location.path).parent
def settings_file = "${this_path}${sep}parser_input.json"
log_file = "${this_path}${sep}dbm_log.txt"
silent_log = false
// #---- Localize Your paths and settings" ------#
settings = [
	"base_path" : "C:\\Automation\\",
	"repository_name" : "REPO",
	"default_branch" : "master",
	"another" : ""
	]
	
input_file = this.args[0]
init_log()
message_box("Processing Hook for git Sync","title")
logit "InputFile: ${input_file}"
params = [:]
params = get_settings(input_file)
process_hook()


def process_hook() {
		def pipeline = params["FlowDetails"]["FlowName"]
		def environment = params["Environment"]["name"]
		def version = params["Version"]["versionString"]
		def db_type = params["FlowDetails"]["DBTypeId"]
		logit "Job initiated by: ${params["User"]["Name"]} on ${params["Job"]["CreatetionTime"]}"
		logit "Pipeline: ${pipeline}, Environment: ${environment}, Version: ${version}"
		logit "#=> Scripts:"
		logit "${"Name".padRight(25)}| ${"Schema".padRight(15)}"
		params["Scripts"].each{ script -> 
			logit "${script["name"].padRight(25)}| ${script["schemaName"].padRight(15)}"  
		}
		def platform = "oracle"
		msg = "DBm Hook update - ${pipeline} => ${environment} for version: ${version}"
		switch (db_type) {
			case 3:
				platform = "oracle"
				break
			case 1:
				platform = "postgres"
				break
		}
		process_db_changes(pipeline,environment,version,platform)
		update_git(msg)
				
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
//  Oracle Methods
// REPO/ORACLE/SCHEMA
def process_db_changes(pipeline,environment,version, dbType){
	base_path = "${settings["base_path"]}${sep}${settings["repository_name"]}${sep}oracle${sep}${params["FlowDetails"]["FlowName"]}"
	def schema_name = params["Schemas"][0]["name"]
	def path = ''
	def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
	def content = ""
	message_box("${dbType.capitalize()} - DDL Processor", "title")
	logit "=> Processes DBmaestro revisions to files."
	params["ChangedObjects"].each{ schema ->
		schema_name = schema["SchemaName"]
		logit "  Database: ${schema_name}"
		schema["Objects"].each { dbobj ->
			path = "${base_path}${sep}${schema_name}${sep}${type_lookup(dbobj["Type"])}"
			ensure_dir(path)
			content = dbobj["TargetCreationScript"]
			name = "${dbobj["Name"]}.sql"    
			def hnd = new File("${path}${sep}${name}")
			logit "Saving: ${path}${sep}${name}", "DEBUG", true
			hnd.write content	
		}
    }
	separator(100)
}

/*
####  Utility Routines
*/
def update_git(commit_msg = ""){
	/*
	Check if git repo
	add objects
	
	*/
	def now = new Date()
	def base_path = "${settings["base_path"]}${sep}${settings["repository_name"]}"
	def branch = settings["default_branch"]
	def cmd = "cd ${base_path} && git status"
	def pipeline = params["FlowDetails"]["FlowName"]
	def environment = params["Environment"]["name"]
	def version = params["Version"]["versionString"]
	def db_type = params["FlowDetails"]["DBTypeId"]
	logit "Job initiated by: ${params["User"]["Name"]} on ${params["Job"]["CreatetionTime"]}"
	logit "Pipeline: ${pipeline}, Environment: ${environment}, Version: ${version}"
	def commit_txt = commit_msg //System.getenv("COMMIT_TEXT")
	message_box("Update Git Repository", "title")
	logit "Repository Path: ${base_path}"
	logit "Using Branch: ${branch}"
	def result = shell_execute(cmd)
	logit "out> " + result["stdout"]
	logit "err> " + result["stderr"]
	if(result["stderr"].indexOf("fatal:") > -1){
	  message_box("ERROR: Not a git repository - please initialize", "title")
	  System.exit(1)
	}
	if(commit_msg == ""){
		commit_txt = "Adding repository changes from automation - Pipeline: ${pipeline}, Environment: ${environment}, Job initiated by: ${params["User"]["Name"]} on ${params["Job"]["CreationTime"]}"
	}
	cmd = "cd ${base_path} && git status"
	result = shell_execute(cmd)
	display_result(cmd, result)
	cmd = "cd ${base_path} && git add *"
	result = shell_execute(cmd)
	display_result(cmd, result)
	cmd = "cd ${base_path} && git read-tree --reset HEAD"
	result = shell_execute(cmd)
	display_result(cmd, result)
	cmd = "cd ${base_path} && git commit -a -m \"${commit_txt}\""
	result = shell_execute(cmd)
	display_result(cmd, result)	
	cmd = "cd ${base_path} && git push origin ${branch}"
	result = shell_execute(cmd)
	display_result(cmd, result)	
}

def get_settings(file_path) {
	def jsonSlurper = new JsonSlurper()
	def cur_settings = [:]
	logit "JSON Settings Document: ${file_path}"
	def json_file_obj = new File( file_path )
	if (json_file_obj.exists() ) {
	  cur_settings = jsonSlurper.parseText(json_file_obj.text)  
	}
	return cur_settings
}

def type_lookup(typeNo){
	// FIXME - Need to add the type id lookup
	switch (typeNo) {
	case 0:
		"TABLE"
		break
	case 1:
		"VIEW"
		break
  case 2:
  	"PROCEDURE"
  	break
	default:
		"UNDEFINED"
		break	
	}
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

def sql_connection(conn_type) {
  def user = ""
  def password = ""
  def conn = ""
  user = settings["connections"][conn_type]["user"]
  password = settings["connections"][conn_type]["password"]
  conn = settings["connections"][conn_type]["connect"]
  platform = settings["connections"][conn_type]["platform"]
  if (platform == "oracle") {
	  // Assign local settings
	  logit "Querying oracle ${conn_type} Db: ${conn}"
	  return Sql.newInstance("jdbc:oracle:thin:@${conn}", user, password)
	}else{
	  dbDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
	  logit "Querying MSSQL ${conn_type} Db: ${conn}"
	  return Sql.newInstance("jdbc:sqlserver://${conn}", user, password, dbDriver)		
	}
}

def result_query(query, grab = []){
  message_box("Results")
  def header = ""
  def result = [:]
  def conn = sql_connection("repo")
	grab.each {item ->
		result[item] = []
	}

  query["output"].each{arr ->
    header += "| ${arr[0].padRight(arr[2])}"
  }
  logit header
  separator(100)
  conn.eachRow(query["query"])
  { row ->
    query["output"].each{arr ->
      def val = row.getAt(arr[1])
      print "| ${val.toString().trim().padRight(arr[2])}"
    }
	grab.each {item ->
		result[item].add(row.getAt(item))
	}
    logit " "
  }
  separator(100)
  logit ""
  conn.close()
  return result
}

def help(){
	message_box("Command Usage Help", "title")
	help_items = [
		["title" : "Oracle Processing",
		"body" : ["Pulls DDL data from an oracle database, either from a DBmaestro label or directly",
				"Examples:",
				"> dbm_revisions.bat action=process_oracle connection=<name from input.json> oracle_source=repo",
				"> dbm_revisions.bat action=process_oracle connection=<name from input.json> oracle_source=raw"
				]
		],
		["title" : "MSSQL Processing",
		"body" : ["Pulls DDL data from a MSSQL DACPAC package, the package must be exploded to have the sql file",
				"Examples:",
				"> dbm_revisions.bat action=process_mssql connection=<name from input.json> file=<path-to-sql-file>"
				]
		],
		["title" : "PostgreSQL Processing",
		"body" : ["Pulls DDL data from a postgres database using the pg_dump utility",
				"You can pull directly or specify and existing dumpfile.",
				"Note - dump structure only, no data.",
				"Examples:",
				"> dbm_revisions.bat action=process_postgres connection=<name from input.json>",
				"> dbm_revisions.bat action=process_postgres connection=<name from input.json> file=<path-to-dumpfile>"
				]
		]
	]
	help_items.each{ item ->
		println "#----------------------------------------------#"
		println "=> ${item["title"]}"
		println "Description: ${item["body"].join("\r\n")}"
	}
}


def password_decrypt(stg) {
	//logit("Decrypting")
	def salt = "sakjkj509gkj31jkb0#kfkf397"
	//logit("Start: ${stg}")
	def res = new String(stg.decodeBase64())
	def mix = res.reverse()
	def result = mix.replaceAll(salt, "")
	//logit("Finish: ${result}")
	return(result)
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
