/*
####### SQL Revision Parser ################
#
# Parses object revisions from dbm or platform dumpfiles into object ddl and pushes into git
=> BJB 9/18/18, 5/14/19
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
settings = [:]
settings = get_settings(settings_file)
arg_map = [:]
parse_arguments(this.args)

if (arg_map.containsKey("action")) {
	if (!arg_map.containsKey("connection")){
	  message_box("ERROR: No connection argument given", "title")
	  System.exit(1)
	}
	init_log()
  switch (arg_map["action"].toLowerCase()) {
    case "process_mssql":
      process_mssql()
      break
    case "process_oracle":
      process_oracle()
      break
	case "process_postgres":
		process_postgres()
    	break
	case "update_git":
    	update_git()
	    break
	case "postgres_all":
    	postgres_all()
	    break
    case "generate_pg_dump":
      generate_pg_dump()
      break
    default:
		logit "No acceptable argument given - e.g. action=process_dump"
	break
	}
}else{
	message_box("ERROR: enter an action argument", "title")
	help()
}

def process_mssql(){
	def connection = arg_map["connection"]
	def base_path = settings["general"]["base_path"]
	def delim = settings["connections"][connection]["code_separator"]
	def obj_dll = ""
	if (!arg_map.containsKey("dacpac_file")){
	  logit message_box("ERROR: No dacpac_file argument given", "title")
	  System.exit(1)
	}
	message_box("MSSQL - DACPAC Processor", "title")
	logit "=> Processes an exploded DACPAC file (the sql file) into individual object revisions."
	logit "Using Connection: ${connection}"
	logit "  Platform: ${settings["connections"][connection]["platform"]}"
	logit "  Database: ${settings["connections"][connection]["connect"]}"
	def file_name = arg_map["dacpac_file"]
	logit "  DACPAC: ${file_name}"
	file_path = "${base_path}${sep}${file_name}"
	// FIXME - build routine to unpack the dacpac file
	// "C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin\DacUnpack.exe" "%1"
	// unpack_file(file_name)
	def icnt = 0
	def last_line = "ZZZ___"
	def hand = new File(file_path).eachLine {line ->
	  if(line.length() < 1){ // || icnt > 3000){
	    //skip it
	  }else if(line == delim && last_line == ""){
	    obj_dll += "\n" + line + "\n"
	    save_object(obj_dll)
	    obj_dll = ""
	    rpt = true
	  }else{
	    obj_dll += line + "\n"
	    logit "accumulate ${icnt}", "DEBUG", true
	    rpt = false
	  }
	  //logit "#=> Line: ${line}"
	  last_line = line
	  icnt += 1
	}
}
// FIXME - now add all the files to git and commit
// update_scm


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

// ### Postgres Processing
def process_postgres(){
	def connection = arg_map["connection"]
	def base_path = settings["general"]["base_path"]
	def delim = settings["connections"][connection]["code_separator"]
	def file_path = ""
	def obj_dll = ""
	def database = settings["connections"][connection]["database"]
	message_box("PostgreSQL - Dump Processor", "title")
	logit "=> Processes a structure dump file into individual object revisions."
	logit "Using Connection: ${connection}"
	logit "  Platform: ${settings["connections"][connection]["platform"]}"
	logit "  Database: ${database}"
	def dump_path = "${base_path}${sep}DUMP"
	file_path = "${dump_path}${sep}${database}.sql"
	logit "# File: ${file_path}"
	def icnt = 0
	def last_line = "--"
	def dec_line = "-- Name: unknown; Type: COMMENT; Schema: -; Owner: \n"
	obj_ddl = dec_line
	def hand = new File(file_path).eachLine {line ->
	  if(line.length() < 1 ){ // || icnt > 3000){
	    //skip it
	  }else if(line.startsWith(delim) && last_line == "--"){
	    pg_save_object(obj_dll, dec_line)
	    dec_line = line
	    obj_dll = "${line}\n"
	    rpt = true
	  }else{
	    obj_dll += line + "\n"
	    logit "lines: ${icnt}", "DEBUG", true
	    rpt = false
	  }
	  //logit "#=> Line: ${line}"
	  last_line = line
	  icnt += 1
	}
}

def generate_pg_dump(){
	def connection = arg_map["connection"]
	message_box("Generate PG Dump: ${connection}", "title")
	def base_path = settings["general"]["base_path"]
	def pass = ""
	def pwd = ""
	def database = settings["connections"][connection]["database"]
	def pg_dump = "${settings["general"]["postgres_path"]}${sep}pg_dump"
	def dump_path = "${base_path}${sep}DUMP"
	ensure_dir(dump_path)
	def user = settings["connections"][connection]["username"]
	if (settings["connections"][connection].containsKey("password_enc")) {
      pwd = password_decrypt(settings["connections"][connection]["password_enc"])
    }else{
      pwd = settings["connections"][connection]["password"]
    }
	def host = settings["connections"][connection]["host"]
	def output_file = "${dump_path}${sep}${database}.sql"
	def cmd = "-s -U ${user} -f ${output_file} -h ${host} ${database}"
	if(sep == "/"){
		pass = "PGPASSWORD=\"${pwd}\" "
		cmd = "${pass}${pg_dump} ${cmd}"

	}else{
		pass = "set \"PGPASSWORD=${pwd}\" && "
		cmd = "${pass}\"${pg_dump}\" ${cmd}"
	}
	logit "Updating structure dump"
	def result = shell_execute(cmd)
	display_result(cmd.replaceAll(pwd, "*******"), result)

}

def postgres_all(){
		generate_pg_dump()
		process_postgres()
		update_git()
}
//  Oracle Methods
// REPO/ORACLE/SCHEMA
def process_oracle(){
	def connection = arg_map["connection"].toLowerCase()
	def base_path = settings["general"]["base_path"]
	def delim = settings["connections"][connection]["code_separator"]
	def schema_name = settings["connections"][connection]["user"]
	def branch = settings["general"]["default_branch"]
	if(settings["connections"][connection]["branch"]){ branch = settings["connections"][connection]["branch"] }
	def app_name = schema_name
	if(settings["connections"][connection]["app_name"]){ app_name = settings["connections"][connection]["app_name"] }
	def oracle_src = "repo"
	def label_name = ""
	base_path = "${settings["general"]["base_path"]}${sep}${settings["general"]["repository_name"]}${sep}oracle"
	if (arg_map.containsKey("oracle_source")){
	  oracle_src = arg_map["oracle_source"]
	}
	if (oracle_src == "repo"){
		if(arg_map.containsKey("labelname")){
			label_name = arg_map["labelname"]
		}else{
			logit message_box("ERROR: No labelname argument given", "title")
			System.exit(1)
		}
	}
	def cmd = "cd ${base_path} && git status"
	def result = shell_execute(cmd)
	logit "out> " + result["stdout"]
	logit "err> " + result["stderr"]
	if(result["stderr"].indexOf("fatal:") > -1){
	  message_box("ERROR: Not a git repository - please initialize", "title")
	  System.exit(1)
	}
	display_result(cmd, result)
	if(branch != "master"){
		cmd = "cd ${base_path} && git checkout ${branch}"
		result = shell_execute(cmd)
		display_result(cmd, result)
	}
	def sql = oracle_object_ddl_query(oracle_src)
	def path = ''; def hdr = ''
	def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
	def content = ""
	def reg = /\"${schema_name}\"\./
	java.sql.Clob clob = null
	message_box("Oracle - DDL Processor", "title")
	logit "=> Processes either raw ddl or DBmaestro revisions to files."
	logit "Using Connection: ${connection}"
	logit "  Platform: ${settings["connections"][connection]["platform"]}"
	logit "  Database: ${schema_name}"
	def conn = sql_connection(connection)
	sql = sql.replaceAll("__LABELNAME__", label_name)
	sql = sql.replaceAll("__SCHEMA_NAME__", schema_name)
	sql = sql.replaceAll("__PIPELINE__", arg_map["connection"])
	logit "  Query: ${sql}"
	logit "  Pushing to path: ${base_path}${sep}${app_name}"
	def icnt = 0
	conn.eachRow(sql){ row ->
		if(app_name == "none"){ app_name = row.SCHEMANAME}
		cur_date = new Date()
		hdr = ""
		path = "${base_path}${sep}${app_name}${sep}${row.OBJECT_TYPE}"
		ensure_dir(path)
		clob = (java.sql.Clob) row.DDL
	    content = clob.getAsciiStream().getText()
		icnt += 1
		content = hdr + content.replaceAll(reg,"") //"<SCHEMANAME>")
		name = "${row.OBJECT_NAME}.sql"
		def hnd = new File("${path}${sep}${name}")
		logit "Saving: ${path}${sep}${name}", "DEBUG", true
		hnd.write content
	}

	logit "  Processed: ${icnt} objects"
	separator(100)
}

def oracle_object_ddl_query(src = "repo") {
	def sql = "SELECT p.FLOWNAME, l.name, oh.SCHEMANAME, oh.OBJECT_NAME, oh.OBJECT_TYPE,oh.OBJECTVERSION, oh.OBJECTREVISION, oh.objectcreationscript as DDL FROM twmanagedb.view_ctrl_objshistory_script oh INNER JOIN twmanagedb.tblcontrollerobjectactionlog al ON al.objectversion = oh.objectversion and al.objectrevision = oh.objectrevision and al.EntityRepositoryId = oh.EntityRepositoryId INNER JOIN twmanagedb.twlabels_checkins lc ON al.ID = lc.action_log_id INNER JOIN twmanagedb.twlabels l on lc.label_id = l.id INNER JOIN twmanagedb.TBL_SMG_VERSION v ON l.id = v.POST_LABEL_ID INNER JOIN twmanagedb.TBL_FLOW p ON p.FLOWID = v.PIPELINE_ID AND p.FLOWDBTYPEID = 3 where l.name = '__LABELNAME__' AND p.FLOWNAME = '__PIPELINE__' AND oh.objectcreationscript is NOT null"
	if(src == "raw"){
		sql = "select u.OBJECT_TYPE, u.OBJECT_NAME, u.LAST_DDL_TIME, '__SCHEMA_NAME__' as SCHEMANAME, DBMS_METADATA.GET_DDL(u.OBJECT_TYPE, u.OBJECT_NAME) as DDL FROM all_objects u where owner = '__SCHEMA_NAME__'"
	}
	return sql
}

//Postgres Save
def pg_save_object(content, declaration){
  def parts = declaration.replaceAll(/\-\-\s/,"").split(";")
  def connection = arg_map["connection"]
	def app = arg_map["application"]
	def info = [:]
	def base_path = "${settings["general"]["base_path"]}${sep}${settings["general"]["repository_name"]}${sep}postgres"

	logit "Parts: ${parts}", "DEBUG", true
  parts.each{ item->
		pair = item.split(": ")
		//logit "Got: ${item}"
		def val = pair.size() > 1 ? pair[1] : ""
		info[pair[0].trim()] = val.trim()
	}
	logit "Info: ${info}", "DEBUG", true
  def prefix = ""
  obj_schema = info["Schema"]
  obj_name = info["Name"]
	obj_type = info["Type"]
  def path = "${base_path}${sep}${connection}${sep}${obj_type}"
  ensure_dir(path)
  def name = obj_name.replaceAll(/\;/,"").trim()
  name = "${prefix}${name}.sql"
  def hnd = new File("${path}${sep}${name}")
  logit "Saving: ${path}${sep}${name}", "DEBUG", true
  hnd.write content

}

// MSSQL Parsing
def save_object(content){
	def connection = arg_map["connection"]
	def base_path = "${settings["general"]["base_path"]}${sep}${settings["general"]["repository_name"]}${sep}mssql${sep}${connection}"
	ensure_dir(base_path)
	def pri_reg = /^.*\s?\[(.*)\]\.\[(.*)\].*/
  def pri_reg2 = /^.*\s?\[(.*)\].*/
  def sub_reg = /^\s+ADD\s\w+\s\[(.+?)\].*/
  def mod_reg = /^.*?CONSTRAINT\s\[(.+?)\].*/
  def obj_type = "not found"
  def obj_name = "not found"
  def lines = content.readLines()
  def cur_line = ""
  def dec_line = ""
  def icnt = 0
  for(ln in lines){
    logit "#=> Line: ${ln}", "DEBUG", true
    if(icnt < 4){
      obj_type = has_declaration(ln)
      if(obj_type != "not found"){
        cur_line = ln
        logit "Found: ${cur_line}", "DEBUG", true
        break
      }
    }else{
      logit "Did not find declaration in first 4 lines"
      break
    }
    icnt += 1
  }
  if(obj_type != "not found"){
    def prefix = ""
    obj_schema = cur_line.replaceFirst(pri_reg, '$1')
    obj_name = cur_line.replaceFirst(pri_reg, '$2')
    if(obj_schema == cur_line){
      obj_schema = ""
      obj_name = cur_line.replaceFirst(pri_reg2, '$1')
    }
    def mod_type = has_declaration(cur_line, "sub_modifiers")
    if(mod_type == "not found"){
      dec_line = lines[icnt + 1]
      def subobj_type = has_declaration(dec_line, "sub_objects")
      if(subobj_type != "not found"){
        prefix = settings["mssql_map"]["sub_objects"]["prefix"]
        obj_type = subobj_type
        obj_name = dec_line.replaceFirst(sub_reg, '$1')
        logit "SUB: ${obj_type}: ${obj_name}", "DEBUG", true
      }else{
        logit "PRIMARY: ${obj_type}: ${obj_name}", "DEBUG", true
      }
    }else{
      prefix = settings["mssql_map"]["sub_modifiers"]["prefix"]
      obj_type = mod_type
      obj_name = cur_line.replaceFirst(mod_reg, '$1')
      logit "MOD: ${obj_type}: ${obj_name}", "DEBUG", true
    }
    def path = "${base_path}${sep}${obj_type}"
    ensure_dir(path)
    def name = obj_name.replaceAll(/\;/,"").trim()
    name = "${prefix}${name}.sql"
    def hnd = new File("${path}${sep}${name}")
    logit "Saving: ${path}${sep}${name}", "DEBUG", true
    hnd.write content
  }
}

def has_declaration(line, p_type = "objects"){
  def obj_type = "not found"
  if(line == null || line.length() < 2){
    return obj_type
  }
  logit "Type: ${p_type}\r\n${settings["objects"]}", "DEBUG", true
  def declarations = settings["mssql_map"][p_type]
  for(term in declarations.keySet()) {
    if(line.indexOf(term) > -1){
        obj_type = declarations[term]
        logit "Found declaration: ${term}", "DEBUG", true
        break
     }
   }
  return obj_type
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
	def connection = arg_map["connection"]
	if(settings["connections"][connection]["branch"]){ branch = settings["connections"][connection]["branch"] }
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
	//cmd = "cd ${base_path} && git read-tree --reset HEAD"
	//result = shell_execute(cmd)
	//display_result(cmd, result)
	if(branch != "master"){
		cmd = "cd ${base_path} && git checkout ${branch}"
		result = shell_execute(cmd)
		display_result(cmd, result)
	}
	cmd = "cd ${base_path} && git add *"
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
