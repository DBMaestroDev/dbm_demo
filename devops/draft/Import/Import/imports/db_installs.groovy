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
this_path = new File(getClass().protectionDomain.codeSource.location.path).parent
def settings_file = "${this_path}${sep}db_installs_input.json"
log_file = "${this_path}${sep}dbm_log.txt"
silent_log = false
settings = [:]
settings = get_settings(settings_file)
arg_map = [:]
parse_arguments(this.args)

if (arg_map.containsKey("action")) {
	//if (!arg_map.containsKey("connection")){
	//  message_box("ERROR: No connection argument given", "title")
	//  System.exit(1)
	//}
	init_log()
  switch (arg_map["action"].toLowerCase()) {
    case "import_db_users":
      create_db_users()
      break
    case "import_dbs":
      import_dbs()
      break
    case "add_schemas_to_source_control":
      add_schemas_to_source_control()
      break
    default:
		logit "No acceptable argument given - e.g. action=process_dump"
	break
	}
}else{
	message_box("ERROR: enter an action argument", "title")
	help()
}

def create_db_users(){
	def serv = settings["general"]["dbm_server"]
	def envs = settings["provisioning"]["environments"]
	def prefix = settings["provisioning"]["prefix"]
	def tablespace = settings["provisioning"]["tablespace"]
	def conn = settings["provisioning"]["connection"]
	def base_sql = settings["provisioning"]["templates"]["user_creation"]	
	def user = ""; def pwd = ""; def sql = "";
	message_box("Creating Database Users", "title")
	logit "=> building users from input file" 
	envs.each{ env ->
		settings["provisioning"]["schemas"].each{ schema, pth -> 
			user = "${prefix}_${schema}_${env}"
			pwd = user.toLowerCase()
			sql = base_sql.replaceAll("__USER__", user)
			sql = sql.replaceAll("__PASSWORD__", pwd)
			sql = sql.replaceAll("__TABLESPACE__", tablespace)
			logit "SQL: ${sql}"
			res = execute_sql_script(conn, sql)
		}
	}
}

def execute_sql_script(connection, sql){
	def file_path = "${this_path}${sep}dbm_tmp.sql"
	def hnd = new File(file_path)
	hnd.write(sql + "\r\nexit;")
	cmd = "sqlplus ${connection} @${file_path}"
	def result = shell_execute(cmd)
	display_result(cmd, result)
}

def import_dbs(){
	def envs = settings["provisioning"]["environments"]
	def prefix = settings["provisioning"]["prefix"]
	def conn = settings["provisioning"]["connection"]
	def file_path = ""; def content = ""; def sql = ""; def user = "";
	message_box("Creating Databases Users", "title")
	logit "=> building database from sql file" 
			//user = "TSD_ODS_DEV"
			//file_path = "${this_path}${sep}scripts\\ODS_DV1.sql"
			//content = new File(file_path).getText()
			//sql = content.replaceAll("__SCHEMA__", user)
			//res = execute_sql_script(conn, sql)
	envs.each{ env ->
		settings["provisioning"]["schemas"].each{ schema, pth -> 
			user = "${prefix}_${schema}_${env}"
			file_path = "${this_path}${sep}${pth}"
			content = new File(file_path).getText()
			sql = content.replaceAll("__SCHEMA__", user)
			res = execute_sql_script(conn, sql)
		}	
	} 
}

def add_schemas_to_source_control() {
	message_box("Adding schemas to source control", "title")
	def prefix = settings["provisioning"]["prefix"]
	def java_cmd = settings["general"]["java_cmd"]
	def port = "1521"
	def instance = "orcl"
	def server = settings["general"]["dbm_server"]
	def credential = "-AuthType DBmaestroAccount -UserName ${settings["general"]["dbm_user"]} -Password \"${settings["general"]["dbm_token"]}\""
	def sys_cred = "-SysUser \"${settings["provisioning"]["sys_user"]}\" -SysPassword \"${settings["provisioning"]["sys_password"]}\" -Tablespace \"Users\""
	def sid_ident = "SID"
	def result = ""; def user = ""; def pwd = "";
	def envs = settings["provisioning"]["environments"]
	for(env in envs){
		if(["DEV","TI","PSE"].contains(env)){
			settings["provisioning"]["schemas"].each{ schema, pth -> 
				user = "${prefix}_${schema}_${env}"
				pwd = user.toLowerCase()	
				logit "Environment: ${env} => ${user}"
				dbm_cmd = "${java_cmd} -AddSchema -DisplayName ${user} -Host ${server} -Port ${port} -ServerInstance ${instance} -ServiceInstanceIdentification \"${sid_ident}\" -DBUser \"${user}\" -DBPassword \"${pwd}\" ${sys_cred} -Server ${server} ${credential}"
				result = shell_execute(dbm_cmd)
				display_result(dbm_cmd, result)
			}
		}
	}
}


//#------------------------------------------------------------------#
//#------------------------------------------------------------------#

 
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
def update_git(){
	/*
	Check if git repo
	add objects
	
	*/
	def now = new Date()
	def base_path = "${settings["general"]["base_path"]}${sep}${settings["general"]["repository_name"]}"
	def branch = settings["general"]["default_branch"]
	def cmd = "cd ${base_path} && git status"
	def build_no = System.getenv("BUILD_NUMBER")
	def commit_txt = System.getenv("COMMIT_TEXT")
	def result = shell_execute(cmd)
	logit "out> " + result["stdout"]
	logit "err> " + result["stderr"]
	if(result["stderr"].indexOf("fatal:") > -1){
	  message_box("ERROR: Not a git repository - please initialize", "title")
	  System.exit(1)
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
	cmd = "cd ${base_path} && git commit -a -m \"Adding repository changes from automation - ${arg_map["connection"]} v${build_no} ${commit_txt}\""
	result = shell_execute(cmd)
	display_result(cmd, result)	
	cmd = "cd ${base_path} && git push origin ${branch}"
	result = shell_execute(cmd)
	display_result(cmd, result)	
}

def get_settings(file_path) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	logit "JSON Settings Document: ${file_path}"
	def json_file_obj = new File( file_path )
	if (json_file_obj.exists() ) {
	  settings = jsonSlurper.parseText(json_file_obj.text)  
	}else{
		println "ERROR - cannot find ${file_path}"
	}
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
	logit("# ARGS:")
	logit(arg_map.toString())
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