/*
-- Package Scripts Order
select v.name, ss.script_id, s.name as script, ss.excution_order FROM twmanagedb.TBL_SMG_VERSION v 
JOIN TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR ss ON ss.VERSION_ID = v.ID
JOIN TWMANAGEDB.TBL_SMG_MANAGED_DYNAMIC_SCR s ON s.SCRIPT_ID = ss.SCRIPT_ID
WHERE v.NAME = 'V0.0.3';

-- update scripts order
update TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR set excution_order = __VAL__

*/

// Read file

/*
 #-------- SQL Oracle with Groovy -------------#
 - Setup: Put the oracle ojdbc6.jar in the same folder as this script
 - Update path in script here for the jenkins groovy jar
 - Here is the invocation on the command line
 java -cp ".;ojdbc6.jar;C:\Program Files (x86)\Jenkins\war\WEB-INF\lib\groovy-all-2.4.7.jar" groovy.ui.GroovyMain c:\automation\source\groovy\db_connect.groovy
*/
// @ExecutionModes({ON_SINGLE_NODE})

import java.sql.Connection
import groovy.sql.Sql
//import oracle.jdbc.pool.OracleDataSource
import groovy.json.*
import java.io.File
import java.text.SimpleDateFormat
base_path = new File(getClass().protectionDomain.codeSource.location.path).parent
def jsonSlurper = new JsonSlurper()
arg_map = [:]
file_contents = [:]
contents = [:]
local_settings = [:]
sep = "/" //FIXME Reset for windows
log_file = "${base_path}${sep}dbm_log.txt"
silent_log = true
for (arg in this.args) {
  //logit arg
  pair = arg.split("=")
  if(pair.size() == 2) {
    arg_map[pair[0].trim()] = pair[1].trim()
  }else{
    arg_map[arg] = ""
  }
}
separator()
// ========================== INPUT PARAMS ========================
local_settings = [
	"general" : [
		"platform" : "oracle"
	],
	"connections" : [
		"repository" : [
			"user" : "twmanagedb",
			"password" : "manage#2009",
			"connect" : "dbmjohnhancock:1521/orcl"
		]
	]
]

// ========================== INPUT PARAMS ========================




init_log()

if (arg_map.containsKey("action")) {
  switch (arg_map["action"].toLowerCase()) {
    case "update_script_order":
      update_script_order()
      break     
    case "initialize_pipelines":
      init_pipelines()
      break     
    default:
      println "Action argument not found"
      break
  }
}else{
	logit
}

// #--------- TEAMWORK EXPORT ROUTINES ------------#

def update_script_order(){
  message_box("Update Script Order in Package", "title")
  def date = new Date()
  def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
  def db_platform = local_settings["general"]["platform"]
  if (!arg_map.containsKey("order_file")) {
    println "Send pipeline= and order_file= arguments"
    System.exit(1)
  }
  def order_file = arg_map["order_file"]
	def version = arg_map["version"]
  def pipeline = arg_map["pipeline"]
	def hnd = new File(order_file)
	if(!hnd.exists()) {
    println "order_file: ${filename} does not exist"
    System.exit(1)
  }
	logit "Working with: Pipeline: ${pipeline} and Version: ${version}"
	def script_order = [:]
	def id_buff = 100
	def new_order = 0
	hnd.text.eachLine{ line, cnt ->
		script_order[line.trim()] = cnt
	}
	def res = ""
  def conn = sql_connection("repository")
	def update_query = "update TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR set EXCUTION_ORDER = __NEW__ WHERE SCRIPT_ID = __ID__"
  def order_query = "select  p.FLOWNAME, v.name, ss.script_id, s.name as script, ss.excution_order as pos FROM twmanagedb.TBL_SMG_VERSION v JOIN TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR ss ON ss.VERSION_ID = v.ID JOIN TWMANAGEDB.TBL_FLOW p ON p.FLOWID = v.PIPELINE_ID JOIN TWMANAGEDB.TBL_SMG_MANAGED_DYNAMIC_SCR s ON s.SCRIPT_ID = ss.SCRIPT_ID WHERE p.FLOWNAME = '__PIPELINE__' AND v.NAME = '__VERSION__'"
	def query = order_query.replaceAll("__PIPELINE__", pipeline)
	query = query.replaceAll("__VERSION__", version)
	logit "Scripts Order File:"
	logit script_order.toString()
	logit "| Script             | Orig | New  |"
	def result = ""; def qry = "";
  conn.eachRow(query){ rec ->
		if(script_order.containsKey(rec.script)){
			result += "Found - ${rec.script}\r\n"
			new_order = script_order[rec.script] + id_buff
		}else{
			result += "NOT - Found - ${rec.script}\r\n"
			new_order = rec.pos + 1000
		}
		qry = update_query.replaceAll("__NEW__", new_order.toString())
		qry = qry.replaceAll("__ID__", rec.SCRIPT_ID.toString())
		logit "Updating: ${qry}"
		res = conn.execute(qry)
	logit "|${rec.script.padRight(21)}|${rec.pos.toString().padRight(6)}|${new_order.toString().padRight(6)}|"
  }
  logit result, "INFO", true
}

def sql_connection(conn_type) {
  def user = ""
  def password = ""
  def conn = ""
  if (conn_type == "repo" || conn_type == "repository" || conn_type == "repo_mssql") {
    user = local_settings["connections"][conn_type]["user"]
    if (local_settings["connections"][conn_type].containsKey("password_enc")) {
      password = password_decrypt(local_settings["connections"][conn_type]["password_enc"])
    }else{
      password = local_settings["connections"][conn_type]["password"]
    }
    conn = local_settings["connections"][conn_type]["connect"]
  }
  if (local_settings["general"]["platform"] == "oracle") {
	  // Assign local settings
	  logit "Querying oracle ${conn_type} Db: ${conn}"
	  return Sql.newInstance("jdbc:oracle:thin:@${conn}", user, password)
	}else{
	  dbDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
	  logit "Querying MSSQL ${conn_type} Db: ${conn}"
	  return Sql.newInstance("jdbc:sqlserver://${conn}", user, password, dbDriver)		
	}
}

// #--------- UTILITY ROUTINES ------------#

def add_query_arguments(query){
  def result_stg = query
  if (query.contains("ARG1")){
    if (arg_map.containsKey("ARG1")){
      (0..10).each {
        def cur_key = "ARG${it}".toString()
        if(arg_map.containsKey(cur_key)){
          //logit "Find: ${cur_key} => ${arg_map[cur_key]}"
          result_stg = result_stg.replaceAll(cur_key, arg_map[cur_key])
        }else{
          //logit "Find: ${cur_key} => %"
          result_stg = result_stg.replaceAll(cur_key, '%')
        }
      }
    }else{
        logit "ERROR - query requires ARG values"
        System.exit(1)
    }
  }
  return result_stg
}

def map_has_key(find_map, match_regex){
  def result = "false"
  for (skey in find_map.ketSet()) {
    if (skey.matches(match_key)) {
      result = skey
    }
  }
  return result
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
  if(silent_log){ println res }
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  logit "#${dashy}#"
}

def ensure_dir(pth) {
  folder = new File(pth)
  if ( !folder.exists() ) {
  logit "Creating folder: ${pth}"
  folder.mkdirs() }
  return pth
}

def dir_exists(pth) {
  folder = new File(pth)
  return folder.exists()
}

def create_file(pth, name, content){
  def fil = new File(pth,name)
  fil.withWriter('utf-8') { writer ->
      writer << content
  }
  return "${pth}${sep}${name}"
}

def read_file(pth, name){
  def fil = new File(pth,name)
  return fil.text
}

def sortable(inum){
  ans = "00"
  def icnt = inum.toInteger()
  //incoming int
  def seq = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9']
  def iter = (icnt/36).toInteger()
  def remain = icnt % 36
  return "${seq.get(iter)}${seq.get(remain)}"
}

def read_csv_file(filepath){
	def fil = new File(filepath)
	def result = []
	def parts = []
	def hsh = [:]
	def header = []
	def cnt = 0
	lines = fil.readLines()
	lines.each{ line -> 
		//logit "Process Line: ${line}"
		if( cnt == 0) { 
			header = line.split(",")
		}else{
			parts = line.split(",")
			hsh = [:]
			k = 0
			header.each{ col -> 
				if(parts.size() > k ){
					hsh[col] = parts[k]
				}else{
					hsh[col] = ""
				}
				k += 1
			}
			result << hsh
		}
		cnt += 1
	}
	return result
}

def read_json_file(filepath){
  def jsonSlurper = new JsonSlurper()
  def contents = [:]
  logit "JSON file: ${filepath}"
  def json_file_obj = new File( filepath )
  if (json_file_obj.exists() ) {
    contents = jsonSlurper.parseText(json_file_obj.text)
  }
  return contents
}

def create_json_file(filepath, contents){
  def jsonSlurper = new JsonSlurper()
  logit "Creating JSON file: ${filepath}"
  val_file = new File(filepath)
  val_file.withWriter('utf-8') { writer -> 
    writer << JsonOutput.prettyPrint(JsonOutput.toJson(contents))
  } 
  
}

def shell_execute(cmd, path = "none"){
  def pth = ""
  if(path != "none") { pth = "cd ${path} && " }
  def outtxt = "cmd /c ${pth}${cmd} 2>&1".execute().text 
  //def outtxt = ""
  //logit "cmd /c ${pth}${cmd} 2>&1"
  return outtxt
}

def init_log(){
	logit("#------------- New Run ---------------#")
	logit("# ARGS:")
	logit(arg_map.toString())
}

def logit(message, log_type = "INFO", force = false){
	def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
	def cur_date = new Date()
	def hnd = new File(log_file)
	if( !hnd.exists() ){
		hnd.createNewFile()
	}
  def stamp = "${sdf.format(cur_date)}|${log_type}> "
  message.eachLine { line->
		if(!silent_log || force){
			println "${stamp}${line.trim()}"
		}
		hnd.append("\r\n${stamp}${line}")
	}
}
