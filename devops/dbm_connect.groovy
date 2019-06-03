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
//import DbmSecure

sep = "\\" //FIXME Reset for windows
base_path = new File(getClass().protectionDomain.codeSource.location.path).parent
//evaluate(new File("${base_path}\\DbmSecure.groovy"))
log_file = "${base_path}${sep}dbm_log.txt"
silent_log = false
def jsonSlurper = new JsonSlurper()
def json_file = "dbm_queries.json"
def settings_file = "local_settings.json"
arg_map = [:]
file_contents = [:]
contents = [:]
local_settings = [:]

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
logit "loading..."
logit "JSON Settings Document: ${base_path}${sep}${settings_file}"
def json_file_obj = new File( base_path, settings_file )
if (json_file_obj.exists() ) {
  local_settings = jsonSlurper.parseText(json_file_obj.text)
}else{
  logit "Cannot find settings file"
}

logit "JSON Config Document: ${base_path}${sep}${json_file}"
json_file_obj = new File( base_path, json_file )
if (json_file_obj.exists() ) {
  file_contents = jsonSlurper.parseText(json_file_obj.text)
}else{
    logit "Cannot find queries file"
}
logit "... done"

if (arg_map.containsKey("action")) {
  switch (arg_map["action"].toLowerCase()) {
    case "dbm_package":
      dbm_package
      break
    case "adhoc_package":
      adhocify_package()
      break
    case "disable_package":
      disable_package()
      break
    case "empty_package":
      empty_package()
      break
    case "transfer_packages":
      transfer_packages()
      break
    case "environment_report":
      environment_report()
      break
    case "encrypt":
      password_encrypt()
      break
    case "schema_objects":
      show_schema_objects()
      break
    case "exclusion_list":
      exclusion_list()
      break
    default:
      perform_query()
      break
  }
}else{
  if (arg_map.containsKey("help")) {
    message_box("dbm_api HELP", "title")
    file_contents.each { k,v ->
      logit "${k}: ${v["name"]}"
      logit "\tUsage: ${v["usage"]}"
      logit " --------- "
    }
  }else{
    logit "Error: specify action=<action> as argument"
    System.exit(1)

  }
}

def perform_query() {
  if (!file_contents.containsKey(arg_map["action"])) {
    logit "Error: Action: ${arg_map["action"]} - not found!"
    logit "Available: ${file_contents.keySet()}"
    System.exit(1)
  }
  contents = file_contents[arg_map["action"]]
  message_box("Task: ${arg_map["action"]}")
  println " Description: ${contents["name"]}"
  for (query in contents["queries"]) {
    def post_results = ""
    separator()
    def conn = sql_connection(query["connection"].toLowerCase())
    //logit "Raw Query: ${query["query"]}"
    def query_stg = add_query_arguments(query["query"])
    logit "Processed Query: ${query_stg}"
    message_box("Results")
    def header = ""
    query["output"].each{arr ->
      header += "| ${arr[0].padRight(arr[2])}"
      }
    println header
    separator(100)
    conn.eachRow(query_stg)
    { row ->
      query["output"].each{arr ->
        def val = row.getAt(arr[1])
        print "| ${val.toString().trim().padRight(arr[2])}"
      }
      println " "
    }
    separator(100)
    println ""
    if (query.containsKey("post_process")) {
      post_process(query["post_process"], query_stg, conn)
    }
    conn.close()

  }
}


def post_process(option, query_string, connection){
  //logit "Option: ${option}"
  def result = ""
  //logit "Running post-processing: ${option}"
  switch (option.toLowerCase()) {
    case "export_packages":
      export_packages(query_string, connection)
      break
    case "create_control_json":
      //create_control_json(query_string, connection)
      break
    case "show_object_ddl":
      show_object_ddl(query_string, connection)
      break
  }
  return result
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
  println header
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
    println " "
  }
  separator(100)
  println ""
  conn.close()
  return result
}

def export_packages(query_string, conn){
  def jsonSlurper = new JsonSlurper()
  def date = new Date()
  def seed_list = [:]
  def contents = [:]
  sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
  def src = ""
  def cur_ver = ""
  def p_list = ""
  def source_pipeline = ""
  def target_pipeline = System.getenv("TARGET_PIPELINE").trim()
  if(! target_pipeline){
    logit "Error: Set TARGET_PIPELINE environment variable or pass path to control.json as 2nd argument"
    System.exit(1)
  }
  if ( System.getenv("EXPORT_PACKAGES") == null ) {
    logit "Error: Set EXPORT_PACKAGES environment variable to specify which packages move forward"
    System.exit(1)
  }else{ 
    p_list = System.getenv("EXPORT_PACKAGES") 
  }
  def consolidate_version = System.getenv("CONSOLIDATE_VERSION").trim()
  if(consolidate_version != "none"){
    logit "Consolidating packages to version: ${consolidate_version}"
  }
  def target_schema = get_target_schema(target_pipeline)

  message_box("Exporting Versions")
  if( p_list && p_list != "" ){
    p_list.split(",").each{
      if (it.contains("=>")) {
        def parts = it.split("=>")
        seed_list[parts[0].trim()] = parts[1].trim()
      }else{
        seed_list[it.trim()] = ""
      }
    }
    //logit seed_list
  }
  logit "Target Pipeline: ${target_pipeline}, schema: ${target_schema}"
  logit "Packages: ${p_list}"
  def result = ""
  def tmp_path = "${local_settings["general"]["staging_path"]}${sep}${target_pipeline}${sep}${target_schema}"
  def target_path = tmp_path
  def fil_name = ""
  def hdr = ""
  def do_save = false
  def counter = 0
  // Redo query and loop through records
  hdr += "-- Exported from pipeline: ${target_pipeline} on ${sdf.format(date)}\n"
  conn.eachRow(query_string)
  { rec ->
    cur_ver = "${rec.version}".toString()
	  target_ver = cur_ver
    result = cur_ver
    do_save = false
    hdr += "-- Version - ${cur_ver}, created: ${rec.created_at}\n"
    if (seed_list.containsKey(cur_ver) && rec.script.endsWith(".sql") ) {
      if(consolidate_version != "none"){
        target_ver = consolidate_version
      }
      if(seed_list[cur_ver] != ""){
        target_ver = seed_list[cur_ver]
      }
      src = new File(rec.script_sorce_data_reference).text
      tmp_path = "${target_path}${sep}${target_ver}"
      ensure_dir(tmp_path)
      fil_name = "${sortable(counter)}_${rec.script}"
      src = hdr + src
      //logit src
      logit "Exporting Script: ${rec.script}, Target: ${target_path}"
      create_file(tmp_path, fil_name, src)
      result += " - Transfer Version (${target_ver})"
    }else{
      result += " - Skip Version"
    }
    counter += 1
    logit result
  }
}

def dbm_package() {
  def java_cmd = local_settings["general"]["java_cmd"]
  def server = local_settings["general"]["server"]
  def target_pipeline = System.getenv("TARGET_PIPELINE")
  def base_path = local_settings["general"]["staging_path"]
  def base_schema = get_target_schema(target_pipeline)
  logit "#-------- Performing DBmPackage command ----------#"
  logit "# Cmd: ${java_cmd} -Package -ProjectName ${target_pipeline} -Server ${server}"
  def results = "${java_cmd} -Package -ProjectName ${target_pipeline} -Server ${server} ".execute().text
}

def adhocify_package() {
  def package_name = arg_map["ARG1"]
  separator()
  def parts = package_name.split("__")
  def new_name = parts.length == 2 ? parts[1] : package_name
  def query = "update twmanagedb.TBL_SMG_VERSION set NAME = 'ARG_NAME', UNIQ_NAME = 'ARG_NAME', TYPE_ID = 2 where NAME = 'ARG_FULL_NAME'"
  def conn = sql_connection("repository")
  //logit "Raw Query: ${query["query"]}"
  def query_stg = query.replaceAll("ARG_FULL_NAME", package_name)
  query_stg = query_stg.replaceAll("ARG_NAME", new_name)
  logit "Processed Query: ${query_stg}"
  message_box("Results")
  def res = conn.execute(query_stg)
  logit res
  separator()
  conn.close()
}

def disable_package() {
  def package_name = arg_map["ARG1"]
  separator()
  def query = "update twmanagedb.TBL_SMG_VERSION set IS_ENABLED = 0 where NAME = 'ARG_FULL_NAME'"
  def conn = sql_connection("repository")
  //logit "Raw Query: ${query["query"]}"
  def query_stg = query.replaceAll("ARG_FULL_NAME", package_name)
  logit "Processed Query: ${query_stg}"
  message_box("Results")
  def res = conn.execute(query_stg)
  logit res
  separator()
  conn.close()
}

def empty_package(){
  def contents = file_contents["package_content"]
  def version = arg_map["ARG2"]
  def pipeline = arg_map["ARG1"]
  def cnt = 0
  message_box("Task: Empty Package - ")
  logit " Description: ${contents["name"]}\nARGS: ${arg_map}"
  def query = contents["queries"][0]
  ver_query = query["query"]
  ver_query = ver_query.replaceAll('ARG1', pipeline)
  ver_query = ver_query.replaceAll('ARG2', version)
  query["query"] = ver_query
  def results = result_query(query, ["SCRIPT_ID","script","SCRIPT_SORCE_DATA_REFERENCE"])
  logit " Processed Query: ${query["query"]}"
  def conn = sql_connection("repo")
  results["SCRIPT_ID"].each {script_id -> 
    logit "Removing script_id = ${script_id}"
    conn.call("{call PKG_RM.DELETE_SCRIPT(?,?)}", [script_id, Sql.VARCHAR]) { was_deleted ->
		if (was_deleted == 'TRUE') {logit "Deleted Successfully (${was_deleted})"}
	}
    logit "Remove from file system: ${results["SCRIPT_SORCE_DATA_REFERENCE"][cnt]}"
	def fil = new File(results["SCRIPT_SORCE_DATA_REFERENCE"][cnt])
	fil.delete()
	cnt += 1
  }
  conn.close()
}

def changeStagingDir() {
  // Change the product staging directory
  if (!arg_map.containsKey("pipeline")) {
    logit "Send pipeline= and path= arguments"
    System.exit(1)
  }
  def flowid = 0
  def old_path = ""
  def pipeline = arg_map["pipeline"]
  def query = "select s.flowid, s.SCRIPTOUTPUTFOLDER from TWMANAGEDB.TBL_FLOW_SETTINGS s INNER JOIN TBL_FLOW f on f.FLOWID = s.FLOWID WHERE FLOWNAME = '${pipeline}'"
  logit message_box("Change Staging Folder", "title")
  def new_path = arg_map["path"]
  logit "Pipeline: ${pipeline}"
  def conn = sql_connection("repo")
  conn.eachRow(query) { rec ->
    old_path = rec["SCRIPTOUTPUTFOLDER"]
    logit "Existing: ${old_path}"
    flowid = rec["FLOWID"]
  }
  ensure_dir()
  logit "New: ${new_path}"
  logit ""
  logit "=> Update Flow Record"
  query = "update TWMANAGEDB.TBL_FLOW_SETTINGS set SCRIPTOUTPUTFOLDER = '${new_path}' where FLOWID = ${flowid}"
  conn.execute(query)
  logit "=> Update Script Import Records"
  query = "update TWMANAGEDB.TBL_SMG_MANAGED_DYNAMIC_SCR set SCRIPT_SORCE_DATA_REFERENCE = REPLACE(SCRIPT_SORCE_DATA_REFERENCE, '${old_path}', '${new_path}') where SCRIPT_ID IN (SELECT SCRIPT_ID from TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR s INNER JOIN TWMANAGEDB.TBL_VERSION v ON v.ID = s.VERSION_ID WHERE v.FLOW_ID = '${flowid}' )"
  conn.execute(query)
  logit "=> Update Script Import Records"
  query = "update TWMANAGEDB.TBL_SMG_BRANCH set DATA_SOURCE_PATH = REPLACE(DATA_SOURCE_PATH, '${old_path}', '${new_path}') where SCRIPT_ID IN (SELECT SCRIPT_ID from TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR s INNER JOIN TWMANAGEDB.TBL_VERSION v ON v.ID = s.VERSION_ID WHERE v.FLOW_ID = '${flowid}' )"
  conn.execute(query)
}

def environment_report(){
	// Reports on environments versions and tags
  if (!arg_map.containsKey("pipeline")) {
    logit "Send pipeline= and path= arguments"
    System.exit(1)
  }
  def html = ""
  def grid = [:]
  def tmp_html = ""
  def contents = file_contents["environment_tags"]
  def pipeline = arg_map["pipeline"]
  def output_path = base_path
  def template_path = base_path + sep + "env_report_template.html"
  if (arg_map.containsKey("path")) {
	output_path = arg_map["path"]
  }
  def cnt = 0
  message_box("Task: Environment Report")
  logit "Args: ${arg_map}"
  html = read_file(base_path,"env_report_template.html" )
  def query = contents["queries"][0]
  ver_query = query["query"]
  ver_query = ver_query.replaceAll('ARG1', pipeline)
  def conn = sql_connection("repo")
  def ipos = 0
  sdf = new SimpleDateFormat("MM/dd/yyyy")
  sdft = new SimpleDateFormat("HH:mm:ss")
  html = html.replaceAll('__PIPELINE__', pipeline)
  def package_list = get_packages(pipeline, conn)
  def script_tags = get_script_tags(pipeline, conn)
  def environments = get_environments(pipeline, conn)
  // Build master dictionary
  package_list.keySet().each{ ver ->
	stf = [:]
	stf["tags"] = ""
	environments.each{ env,v -> 
		stf[env] = ""
	}
	logit "Ver: ${ver}"
	grid[ver] = stf
	
  }
  // Now loop through deployment data
  // pipeline, environment, VERSION, TAG_VALUE
  conn.eachRow(ver_query){ row ->
	ver = row["VERSION"]
	if(grid.containsKey(ver)){
		tag = row["TAG_VALUE"] == null ? "" : row["TAG_VALUE"]
		String dep_at = row["FINISH"]
		grid[ver]["tags"] = tag
		grid[ver][row["environment"]] = "${dep_at.split(" ")[0]}<br>${dep_at.split(" ")[1]}"
	}
  }
  
  
	tmp_html += "<tr>\n"
	tmp_html += "<th>Version</th>\n"
	tmp_html += "<th>Tags</th>\n"
	
	environments.each{ env,v -> 
		tmp_html += "<th>${env}</th>\n"	
	}
  tmp_html += "</tr>\n"
  html = html.replaceAll('__HEADER__', tmp_html)
  tmp_html = ""
  // pipeline, environment, VERSION, TAG_VALUE
	grid.each{ ver,vals ->
		tag = vals["tags"]
		tmp_html += "<tr>\n"
		tmp_html += "<td>${ver}</td>\n"
		if(script_tags.containsKey(ver)){
			logit "Found ver: ${ver}"
			tag == "" ? tag = "${script_tags[ver].join(",")}" : "${tag},${script_tags[ver].join(",")}"
		}

		tmp_html += "<td>${tag}</td>\n"
		environments.each{ env,v -> 
			tmp_html += "<td>${vals[env].toString().trim()}</td>\n"	
		}
    }
	tmp_html += "</tr>\n"
  html = html.replaceAll('__BODY__', tmp_html)
  
  conn.close()
   logit " Processed Query: ${ver_query}"
   logit " Creating: ${output_path}${sep}env_report.html"
   //logit " Content: ${html}"
   create_file(output_path, "env_report.html", html)
}

def get_script_tags(pipeline, cxn){
  def returnVal = [:]
  def contents = file_contents["script_tags"]
  def query = contents["queries"][0]
  def ver_query = query["query"]
  ver_query = ver_query.replaceAll('ARG1', pipeline)
  cxn.eachRow(ver_query)
  { row ->
	//logit "Processing: ${row["version"]}, ${row["script"]}, ${row["TAG_VALUE"]}"
     if(row["TAG_VALUE"] != null){
	  if(!returnVal.containsKey(row["version"])){returnVal[row["version"]] = []}
	  returnVal[row["version"]] << row["TAG_VALUE"]
	 }
  }
  return returnVal
}

def get_packages(pipeline, cxn){
	def sql = "select p.FLOWNAME, v.id, v.name as version, v.IS_ENABLED as enabled from TWMANAGEDB.TBL_SMG_VERSION v INNER JOIN twmanagedb.TBL_FLOW p ON p.flowid = v.pipeline_id where p.FLOWNAME = 'ARG1' AND v.IS_ENABLED = 1 order by v.ID"
	def returnVal = [:]
	def ver_query = sql
	ver_query = ver_query.replaceAll('ARG1', pipeline)
	cxn.eachRow(ver_query)
	{ row ->
		//logit "Processing: ${row["version"]}, ${row["script"]}, ${row["TAG_VALUE"]}"
		returnVal[row["version"]] = ["id" : row["ID"]]
	}
	return returnVal
}

def get_environments(pipeline, cxn){
	def sql = "select p.FLOWNAME, e.LSNAME as environment, e.LSID, e.ENV_TYPE, et.T_ORDER from TWMANAGEDB.TBL_LS e INNER JOIN twmanagedb.TBL_FLOW p ON p.flowid = e.FLOWID INNER JOIN TWMANAGEDB.TBL_SMG_ENV_TYPES et on et.ID = e.ENV_TYPE where p.FLOWNAME = 'ARG1' AND e.ENV_TYPE <> 8 order by et.T_ORDER"
	def returnVal = [:]
	def ver_query = sql
	ver_query = ver_query.replaceAll('ARG1', pipeline)
	cxn.eachRow(ver_query)
	{ row ->
		//logit "Processing: ${row["version"]}, ${row["script"]}, ${row["TAG_VALUE"]}"
		returnVal[row["environment"]] = ["order" : row["T_ORDER"]]
	}
	//logit "Got this: ${returnVal}"
	return returnVal
}

def export_exclusions(fpath, cxn){
	def sql = "select * from TWMANAGEDB.TBL_SMG_EXCLUDE_OBJECTS"
	def returnVal = ""
	def valid_columns = "DBCID, EXCLUDE_TYPE, OBJECT_NAME, EXCLUDE_BUILD, EXCLUDE_VALIDATE, EXCLUDE_ROLLBACK"
		def cur = "${fpath}${sep}exclusion_list_export.csv"
	logit "ALERT - replacing existing data in the exclusion list table"
	logit "old data exported to: ${cur}"
	returnVal += valid_columns + "\n"
	cxn.eachRow(sql)
	{ row ->
		//logit "Processing: ${row["version"]}, ${row["script"]}, ${row["TAG_VALUE"]}"
		returnVal += "${row["DBCID"]},${row["EXCLUDE_TYPE"]},${row["OBJECT_NAME"]},${row["EXCLUDE_BUILD"]},${row["EXCLUDE_VALIDATE"]},${row["EXCLUDE_ROLLBACK"]}\n"
	}
	//logit "Got this: ${returnVal}"
	create_file(fpath, "exclusion_list_export.csv", returnVal)
}

def exclusion_list() {
	// dbm_api.bat action=exclusion_list file_path=c:\automation\multi_tsk_exclusion.csv
	// Imports a csv file (Create and export from excel)
	// Schema, EXCLUDE_TYPE, OBJECT_NAME
	// HR				2							TMP_TABLE
	// HR				1							SYNONYM
	// Take input of SchemaName and object name
	def valid_columns = "DBCID, EXCLUDE_TYPE, OBJECT_NAME, EXCLUDE_BUILD, EXCLUDE_VALIDATE, EXCLUDE_ROLLBACK"
	def replace_data = false
	def last_schema = "ZZZZZZ"
	if (!arg_map.containsKey("file_path")) {
		logit "Send file_path= arguments"
		System.exit(1)
	}else{
		filepath = arg_map["file_path"]
		
	}
	def filepath_path = new File(filepath).getParent()
	if (arg_map.containsKey("replace")) {
		if( arg_map["replace"] == 'true') { 
			replace_data = true
		}
	}
	message_box("Task: Update Exclusion List")
	logit "Args: ${arg_map}"
	def contents = read_csv_file(filepath)
	def fil = new File(filepath)
	if (contents[0].join(",").replaceAll(" ","") != valid_columns.replaceAll(" ","")) {
		logit "ERROR - invalid format, bad column titles"
		logit "must be:"
		logit valid_columns
		System.exit(1)
	}
	def conn = sql_connection("repo")
	// pipeline, environment, VERSION, TAG_VALUE
	def icnt = 0
	def dbcid = -1
	int icode = 0
	def content = ""
	if(replace_data){
		export_exclusions(filepath_path, conn)
	}
	//sql = "INSERT INTO TBL_SMG_EXCLUDE_OBJECTS (DBCID, EXCLUDE_TYPE, OBJECT_NAME, EXCLUDE_BUILD, EXCLUDE_VALIDATE, EXCLUDE_ROLLBACK) VALUES (147, 2, 'TMP_DONORS', 1, 1, 1)"
	//sql = "select * from TWMANAGEDB.TBL_SMG_EXCLUDE_OBJECTS"
	//res = conn.execute(sql)
	contents.each{ row ->
		if( icnt > 0 ){
			if( row[0] != last_schema) { dbcid = get_dbcid(row[0], conn) }
			sql = "INSERT INTO TWMANAGEDB.TBL_SMG_EXCLUDE_OBJECTS (${valid_columns}) VALUES (${dbcid}, ${row[1]}, '${row[2]}', ${row[3]}, ${row[4]}, ${row[5]});"
			//logit sql
			content += sql + "\n"
		}
		icnt += 1
	}
	content += "commit;\n"
	content += "exit;\n"
	def sqlfile = new File(fil.getParent(), "exclusion_inserts.sql")
	logit "Creating: ${sqlfile.getPath()}"
	def credential = "${local_settings["connections"]["repository"]["user"]}/${local_settings["connections"]["repository"]["password"]}@${local_settings["connections"]["repository"]["connect"]}"
	sqlfile.write content
	def cmd = "sqlplus ${credential} @${sqlfile.getPath()}"
	def result = shell_execute(cmd)
	logit "out> " + result["stdout"]
	logit "err> " + result["stderr"]

	conn.close()
}

def show_schema_objects() {
	// dbm_api.bat action=schema_objects schema_name=multi_tsk output_path=c:\automation
	// Builds a csv file of database objects in a schema
	// #NOTE - may need to grant: grant select on DBA_OBJECTS to twmanagedb; for this to work
	// #NOTE - for schema on other instances include a connection="scott/tiger@myserver.com:1521/orcl" argument
	if (!arg_map.containsKey("schema_name")) {
		logit "ERROR: Send schema_name= and output_path= arguments"
		System.exit(1)
	}
	if (!arg_map.containsKey("output_path")) {
		logit "ERROR: Send output_path= arguments"
		System.exit(1)
	}
	message_box("Task: Schema Objects")
	logit "Args: ${arg_map}"
	def conn = null
	if (arg_map.containsKey("connection")) {
		conn = sql_connection("custom", arg_map["connection"])
	}else{
		conn = sql_connection("repo")
	}
	def res = "SCHEMA_NAME, OBJECT_NAME, OBJECT_TYPE\n"
	def arow = []
	def schema = arg_map["schema_name"]
	def icnt = 0
	def sql = "SELECT OBJECT_NAME, OBJECT_TYPE, OWNER FROM DBA_OBJECTS where owner = '__SCHEMA__' AND SUBOBJECT_NAME IS NULL ORDER BY OBJECT_TYPE, OBJECT_NAME"
	def ver_query = sql.replaceAll('__SCHEMA__', schema.toUpperCase())
	// OBJECT_NAME, OBJECT_TYPE, OWNER
	conn.eachRow(ver_query){ row ->
		arow = []
		arow << schema
		arow << row["OBJECT_NAME"]
		arow << row["OBJECT_TYPE"]
		res += arow.join(",")
		res += "\n"
		icnt += 1
	}
	logit "Processed: ${icnt} objects"
	conn.close()
	logit "Creating file: ${arg_map["output_path"]}"
	create_file(arg_map["output_path"], "object_list.csv", res)
}

// #---------------------------- UTILITY ROUTINES ----------------------------#

def get_dbcid(schema_name, conn) {
	def res = "ERROR - No Data Returned"
	def sql = "SELECT DBCID FROM TWMANAGEDB.TBL_DBC WHERE DBCNAME = '__SCHEMA__'"
  def ver_query = sql.replaceAll('__SCHEMA__', schema_name.toUpperCase())
	conn.eachRow(ver_query){ row ->
		res = row["DBCID"]
	}
	res
}

def show_object_ddl(query_string, conn) {
  // Redo query and loop through records
  conn.eachRow(query_string)
  { rec ->
    message_box("Object DDL Rev: ${rec.COUNTEDREVISION} of ${rec.OBJECT_NAME}")
    java.sql.Clob clob = (java.sql.Clob) rec.OBJECTCREATIONSCRIPT
    bodyText = clob.getAsciiStream().getText()
    logit bodyText
  }
}

def sql_connection(conn_type, connection="") {
  def user = ""
  def password = ""
  def conn = ""
  if (conn_type == "repo" || conn_type == "repository") {
    user = local_settings["connections"]["repository"]["user"]
    if (local_settings["connections"]["repository"].containsKey("password_enc")) {
      //password = password_decrypt(local_settings["connections"]["repository"]["password_enc"])
    }else{
      password = local_settings["connections"]["repository"]["password"]
    }
    conn = local_settings["connections"]["repository"]["connect"]
  }else if (conn_type == "remote") {
    // FIXME find instance for named environment and build it
    user = local_settings["connections"]["remote"]["user"]
    if (local_settings["remote"].containsKey("password_enc")) {
     // password = password_decrypt(local_settings["connections"]["remote"]["password_enc"])
    }else{
      password = local_settings["connections"]["remote"]["password"]
    }
    conn = local_settings["connections"]["remote"]["connect"]
	}else if (conn_type == "custom") {
		if(connection == ""){
			logit "ERROR: Must pass a connection string for custom database connection.  e.g. scott/tiger@myserver.com:1521/orcl"
			System.exit(1)
		}
    // A passed connection
		parts = connection.split("@")
		items = parts[0].split("/")
		user = items[0]
		password = items[1]
    conn = parts[1]
  }
  // Assign local settings
  logit "Querying ${conn_type} Db: ${conn}"
  return Sql.newInstance("jdbc:oracle:thin:@${conn}", user, password)
}

def get_export_json_file(target, path_only = false){
  def jsonSlurper = new JsonSlurper()
  def contents = [:]
  def export_path_temp = "${local_settings["general"]["staging_path"]}${sep}${target}${sep}export_control.json"
  logit "JSON Export config: ${export_path_temp}"
  if(path_only){
    return export_path_temp
  }
  def json_file_obj = new File( export_path_temp )
  if (json_file_obj.exists() ) {
    contents = jsonSlurper.parseText(json_file_obj.text)
  }
  return contents
}

def get_target_schema(cur_pipeline){
  def target_schema = ""
  local_settings["branch_map"].each { k,v ->
    def cur_branch = k
    v.each { pipe -> if (pipe["pipeline"] == cur_pipeline){ target_schema = pipe["base_schema"] } }
  }
  return target_schema
}

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
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  println "#${dashy}#"
}

def sql_file_list(dir_txt) {
  // Returns files in ascending date order
  def files=[]
  def src = new File(dir_txt)
  src.eachFile groovy.io.FileType.FILES, { file ->
    if (file.name.contains(".sql")) {
      files << file
    }
  }
  return files.sort{ a,b -> a.lastModified() <=> b.lastModified() }
}

def path_from_pipeline(pipe_name){
  def query_stg = "select f.FLOWID, f.FLOWNAME, s.SCRIPTOUTPUTFOLDER from TWMANAGEDB.TBL_FLOW f INNER JOIN TWMANAGEDB.TBL_FLOW_SETTINGS s ON f.FLOWID = s.FLOWID WHERE f.FLOWNAME = 'ARG1'"
  def result = ""
  sql.eachRow(query_stg.replaceAll("ARG1", pipe_name))
  { row ->
    result = row.SCRIPTOUTPUTFOLDER
  }
  return result
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

def read_csv_file(pth) {
	def result = []
	def cnt = 0
	int code = 0
	def txt = read_file(pth)
	txt.split("\n").each { line->
		row = []
		//logit line
		// Fix problem where excel puts a special character in file
		code = (int)line[0]
		//logit line[0] + " ${code}"
		if(code > 200) { line = line[1..-1] }
		line.trim().split(",").each { item-> 
			row << item
		}
		result << row
		cnt += 1
	}
	return result
}

def read_file(pth, name = ""){
	def fil = null
	if(name == "") {
		fil = new File(pth)
	}else{
		fil = new File(pth,name)
	}
  return fil.text
}

def getNextVersion(optionType){
  //Get version from currentVersion.txt file D:\\repo\\N8
  // looks like this:
  // develop=1.10.01
  // release=1.9.03
  def newVersion = ""
  def curVersion = [:]
  def versionFile = "D:\\n8ddu\\N8\\currentVersion.txt"
  def fil = new File(versionFile)
  def contents = fil.readLines
  contents.each{ -> cur
    def pair = cur.split("=")
    curVersion[pair[0].trim()] = pair[1].trim()
  }
  
  switch (optionType.toLowerCase()) {
    case "develop":
      curVersion["develop"] = newVersion = incrementVersion(curVersion["develop"])
      break
    case "hotfix":
      curVersion["develop"] = newVersion = incrementVersion(curVersion["develop"], "other")
      break
    case "cross_over":
      curVersion["release"] = newVersion = incrementVersion(curVersion["release"])
      break
    case "ddu":
      curVersion["release"] = newVersion = incrementVersion(curVersion["release"], "other")
      break
  }
  stg = "develop=${curVersion["develop"]}\r\n"
  stg += "release=${curVersion["release"]}"
  fil.write(stg)
  fil.close()
  return newVersion
}

def incrementVersion(ver, process = "normal"){
  // ver = 1.9.04
  def new_ver = ver
  def parts = ver.split('\\.')
  logit parts
  if(process == "normal"){
      parts[2] = (parts[2].toInteger() + 1).toString()
      new_ver = parts[0..2].join(".")
      logit new_ver
  }else{
      if(parts.size() > 3){
          parts[3] = (parts[3].toInteger() + 1).toString()
      }else{
          parts = parts + '1'
      }
      logit parts[3]
      new_ver = parts[0..3].join(".")
      logit new_ver
  }
}

def sortable(inum){
  ans = "00"
  def icnt = inum.toInteger()
  //incoming int
  def seq = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9']
  def iter = (icnt/36).toInteger()
  def remain = icnt % 36
  return "${seq.get(iter)}${seq.get(remain)}"
}

def transfer_packages(){
  arg_map["action"] = "package_export"
  perform_query()
  
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

def logit(String message, log_type = "INFO", display_only = true){
	def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
	def cur_date = new Date()
	if(!display_only){
		def hnd = new File(log_file)
		if( !hnd.exists() ){
			hnd.createNewFile()
		}
	}
	def stamp = "${sdf.format(cur_date)}|${log_type}> "
	message.eachLine { line->
		if(!silent_log){
			println "${stamp}${line.trim()}"
		}
		if(!display_only){
			hnd.append("\r\n${stamp}${line}")
		}
	}
}

/*
def password_encrypt(pwd_enc = ""){
	def pwdTools = new DbmSecure()
	if(pwd_enc == "") {pwd_enc = arg_map["password"] }
	result = pwdTools.encrypt(["password" : pwd_enc])
	return result
}

def password_decrypt(pwd_enc = ""){
	def pwdTools = new DbmSecure()
	if(pwd_enc == "") {pwd_enc = arg_map["password"] }
	result = pwdTools.decrypt(["password" : pwd_enc])
	return result
}
*/