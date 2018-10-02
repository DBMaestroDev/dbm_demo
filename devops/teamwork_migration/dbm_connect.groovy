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
def json_file = "dbm_queries.json"
def settings_file = "local_settings_sql.json"
arg_map = [:]
file_contents = [:]
contents = [:]
local_settings = [:]
sep = "/" //FIXME Reset for windows
for (arg in this.args) {
  //println arg
  pair = arg.split("=")
  if(pair.size() == 2) {
    arg_map[pair[0].trim()] = pair[1].trim()
  }else{
    arg_map[arg] = ""
  }
}
separator()
println "loading..."
println "JSON Settings Document: ${base_path}${sep}${settings_file}"
def json_file_obj = new File( base_path, settings_file )
if (json_file_obj.exists() ) {
  local_settings = jsonSlurper.parseText(json_file_obj.text)
}else{
  println "Cannot find settings file"
}

println "JSON Config Document: ${base_path}${sep}${json_file}"
json_file_obj = new File( base_path, json_file )
if (json_file_obj.exists() ) {
  file_contents = jsonSlurper.parseText(json_file_obj.text)
}else{
    println "Cannot find queries file"
}
println "... done"

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
    case "teamwork_export":
      teamwork_export()
      break
    case "build_import_json":
      build_import_json()
      break
    case "add_to_source_control":
      add_schemas_to_source_control()
      break
    case "import_pipelines":
      import_pipelines()
      break     
    case "initialize_pipelines":
      init_pipelines()
      break     
    default:
      perform_query()
      break
  }
}else{
  if (arg_map.containsKey("help")) {
    message_box("dbm_api HELP", "title")
    file_contents.each { k,v ->
      println "${k}: ${v["name"]}"
      println "\tUsage: ${v["usage"]}"
      println " --------- "
    }
  }else{
    println "Error: specify action=<action> as argument"
    System.exit(1)

  }
}

def perform_query() {
  if (!file_contents.containsKey(arg_map["action"])) {
    println "Error: Action: ${arg_map["action"]} - not found!"
    println "Available: ${file_contents.keySet()}"
    System.exit(1)
  }
  contents = file_contents[arg_map["action"]]
  message_box("Task: ${arg_map["action"]}")
  println " Description: ${contents["name"]}"
  for (query in contents["queries"]) {
    def post_results = ""
    separator()
    def conn = sql_connection(query["connection"].toLowerCase())
    //println "Raw Query: ${query["query"]}"
    def query_stg = add_query_arguments(query["query"])
    println "Processed Query: ${query_stg}"
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
  //println "Option: ${option}"
  def result = ""
  //println "Running post-processing: ${option}"
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
  }else if (conn_type == "remote") {
    // FIXME find instance for named environment and build it
    user = local_settings["connections"]["remote"]["user"]
    if (local_settings["remote"].containsKey("password_enc")) {
      password = password_decrypt(local_settings["connections"]["remote"]["password_enc"])
    }else{
      password = local_settings["connections"]["remote"]["password"]
    }
    conn = local_settings["connections"]["remote"]["connect"]
  }
  if (local_settings["general"]["platform"] == "oracle") {
	  // Assign local settings
	  println "Querying oracle ${conn_type} Db: ${conn}"
	  return Sql.newInstance("jdbc:oracle:thin:@${conn}", user, password)
	}else{
	  dbDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
	  println "Querying MSSQL ${conn_type} Db: ${conn}"
	  return Sql.newInstance("jdbc:sqlserver://${conn}", user, password, dbDriver)		
	}
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
    println "Error: Set TARGET_PIPELINE environment variable or pass path to control.json as 2nd argument"
    System.exit(1)
  }
  if ( System.getenv("EXPORT_PACKAGES") == null ) {
    println "Error: Set EXPORT_PACKAGES environment variable to specify which packages move forward"
    System.exit(1)
  }else{ 
    p_list = System.getenv("EXPORT_PACKAGES") 
  }
  def consolidate_version = System.getenv("CONSOLIDATE_VERSION").trim()
  if(consolidate_version != "none"){
    println "Consolidating packages to version: ${consolidate_version}"
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
    //println seed_list
  }
  println "Target Pipeline: ${target_pipeline}, schema: ${target_schema}"
  println "Packages: ${p_list}"
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
      //println src
      println "Exporting Script: ${rec.script}, Target: ${target_path}"
      create_file(tmp_path, fil_name, src)
      result += " - Transfer Version (${target_ver})"
    }else{
      result += " - Skip Version"
    }
    counter += 1
    println result
  }
}

def dbm_package() {
  def java_cmd = local_settings["general"]["java_cmd"]
  def server = local_settings["general"]["server"]
  def target_pipeline = System.getenv("TARGET_PIPELINE")
  def base_path = local_settings["general"]["staging_path"]
  def base_schema = get_target_schema(target_pipeline)
  println "#-------- Performing DBmPackage command ----------#"
  println "# Cmd: ${java_cmd} -Package -ProjectName ${target_pipeline} -Server ${server}"
  def results = "${java_cmd} -Package -ProjectName ${target_pipeline} -Server ${server} ".execute().text
}

def adhocify_package() {
  def package_name = arg_map["ARG1"]
  separator()
  def parts = package_name.split("__")
  def new_name = parts.length == 2 ? parts[1] : package_name
  def query = "update twmanagedb.TBL_SMG_VERSION set NAME = 'ARG_NAME', UNIQ_NAME = 'ARG_NAME', TYPE_ID = 2 where NAME = 'ARG_FULL_NAME'"
  def conn = sql_connection("repository")
  //println "Raw Query: ${query["query"]}"
  def query_stg = query.replaceAll("ARG_FULL_NAME", package_name)
  query_stg = query_stg.replaceAll("ARG_NAME", new_name)
  println "Processed Query: ${query_stg}"
  message_box("Results")
  def res = conn.execute(query_stg)
  println res
  separator()
  conn.close()
}

def disable_package() {
  def package_name = arg_map["ARG1"]
  separator()
  def query = "update twmanagedb.TBL_SMG_VERSION set IS_ENABLED = 0 where NAME = 'ARG_FULL_NAME'"
  def conn = sql_connection("repository")
  //println "Raw Query: ${query["query"]}"
  def query_stg = query.replaceAll("ARG_FULL_NAME", package_name)
  println "Processed Query: ${query_stg}"
  message_box("Results")
  def res = conn.execute(query_stg)
  println res
  separator()
  conn.close()
}

def show_object_ddl(query_string, conn) {
  // Redo query and loop through records
  conn.eachRow(query_string)
  { rec ->
    message_box("Object DDL Rev: ${rec.COUNTEDREVISION} of ${rec.OBJECT_NAME}")
    java.sql.Clob clob = (java.sql.Clob) rec.OBJECTCREATIONSCRIPT
    bodyText = clob.getAsciiStream().getText()
    println bodyText
  }
}

// #--------- UTILITY ROUTINES ------------#

def get_export_json_file(target, path_only = false){
  def jsonSlurper = new JsonSlurper()
  def contents = [:]
  def export_path_temp = "${local_settings["general"]["staging_path"]}${sep}${target}${sep}export_control.json"
  println "JSON Export config: ${export_path_temp}"
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
          //println "Find: ${cur_key} => ${arg_map[cur_key]}"
          result_stg = result_stg.replaceAll(cur_key, arg_map[cur_key])
        }else{
          //println "Find: ${cur_key} => %"
          result_stg = result_stg.replaceAll(cur_key, '%')
        }
      }
    }else{
        println "ERROR - query requires ARG values"
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
  println res
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

def password_decrypt(password_enc){
  def slug = "__sj8kl3LM77g903ugbn_KG="
  def result = ""
  byte[] decoded = password_enc.decodeBase64()
  def res = new String(decoded)
  res = res.replaceAll(slug,"")
  result = new String(res.decodeBase64())
  return result
}

def ensure_dir(pth) {
  folder = new File(pth)
  if ( !folder.exists() ) {
  println "Creating folder: ${pth}"
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

def empty_package(){
  def contents = file_contents["package_content"]
  def version = arg_map["ARG2"]
  def pipeline = arg_map["ARG1"]
  def cnt = 0
  message_box("Task: Empty Package - ")
  println " Description: ${contents["name"]}\nARGS: ${arg_map}"
  def query = contents["queries"][0]
  ver_query = query["query"]
  ver_query = ver_query.replaceAll('ARG1', pipeline)
  ver_query = ver_query.replaceAll('ARG2', version)
  query["query"] = ver_query
  def results = result_query(query, ["SCRIPT_ID","script","SCRIPT_SORCE_DATA_REFERENCE"])
  println " Processed Query: ${query["query"]}"
  def conn = sql_connection("repo")
  results["SCRIPT_ID"].each {script_id -> 
    println "Removing script_id = ${script_id}"
    conn.call("{call PKG_RM.DELETE_SCRIPT(?,?)}", [script_id, Sql.VARCHAR]) { was_deleted ->
		if (was_deleted == 'TRUE') {println "Deleted Successfully (${was_deleted})"}
	}
    println "Remove from file system: ${results["SCRIPT_SORCE_DATA_REFERENCE"][cnt]}"
	def fil = new File(results["SCRIPT_SORCE_DATA_REFERENCE"][cnt])
	fil.delete()
	cnt += 1
  }
  conn.close()
}

def changeStagingDir() {
  // Change the product staging directory
  if (!arg_map.containsKey("pipeline")) {
    println "Send pipeline= and path= arguments"
    System.exit(1)
  }
  def flowid = 0
  def old_path = ""
  def pipeline = arg_map["pipeline"]
  def query = "select s.flowid, s.SCRIPTOUTPUTFOLDER from TWMANAGEDB.TBL_FLOW_SETTINGS s INNER JOIN TBL_FLOW f on f.FLOWID = s.FLOWID WHERE FLOWNAME = '${pipeline}'"
  println message_box("Change Staging Folder", "title")
  def new_path = arg_map["path"]
  println "Pipeline: ${pipeline}"
  def conn = sql_connection("repo")
  conn.eachRow(query) { rec ->
    old_path = rec["SCRIPTOUTPUTFOLDER"]
    println "Existing: ${old_path}"
    flowid = rec["FLOWID"]
  }
  ensure_dir()
  println "New: ${new_path}"
  println ""
  println "=> Update Flow Record"
  query = "update TWMANAGEDB.TBL_FLOW_SETTINGS set SCRIPTOUTPUTFOLDER = '${new_path}' where FLOWID = ${flowid}"
  conn.execute(query)
  println "=> Update Script Import Records"
  query = "update TWMANAGEDB.TBL_SMG_MANAGED_DYNAMIC_SCR set SCRIPT_SORCE_DATA_REFERENCE = REPLACE(SCRIPT_SORCE_DATA_REFERENCE, '${old_path}', '${new_path}') where SCRIPT_ID IN (SELECT SCRIPT_ID from TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR s INNER JOIN TWMANAGEDB.TBL_VERSION v ON v.ID = s.VERSION_ID WHERE v.FLOW_ID = '${flowid}' )"
  conn.execute(query)
  println "=> Update Script Import Records"
  query = "update TWMANAGEDB.TBL_SMG_BRANCH set DATA_SOURCE_PATH = REPLACE(DATA_SOURCE_PATH, '${old_path}', '${new_path}') where SCRIPT_ID IN (SELECT SCRIPT_ID from TWMANAGEDB.TBL_SMG_MANAGED_STATIC_SCR s INNER JOIN TWMANAGEDB.TBL_VERSION v ON v.ID = s.VERSION_ID WHERE v.FLOW_ID = '${flowid}' )"
  conn.execute(query)
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
  println parts
  if(process == "normal"){
      parts[2] = (parts[2].toInteger() + 1).toString()
      new_ver = parts[0..2].join(".")
      println new_ver
  }else{
      if(parts.size() > 3){
          parts[3] = (parts[3].toInteger() + 1).toString()
      }else{
          parts = parts + '1'
      }
      println parts[3]
      new_ver = parts[0..3].join(".")
      println new_ver
  }
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

def transfer_packages(){
  arg_map["action"] = "package_export"
  perform_query()
  
}

// #--------- TEAMWORK EXPORT ROUTINES ------------#

def teamwork_export(){
  def date = new Date()
  def sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
  def db_platform = local_settings["general"]["platform"]
  def filename = "${base_path}${sep}env_${db_platform}_export.csv"
  def pipeline_header = ["ID", "Pipeline", "ProjectGroupID", "ProjectGroup", "RS", "ENV1","ENV2","ENV3","ENV4","ENV5","ENV6","ENV7","ENV8"]
  def env_header = "ID,pipeline,environment,host,service_sid,service_name,port,schema_name,username,password,is_managed,mssql_auth_type"
  env_info = []
  def src = ""
  repo = db_platform == "oracle" ? "repository" : "repo_mssql"
  def conn = sql_connection(repo) 
  def env_query_oracle = "select p.FLOWID, p.FLOWNAME, env.LSNAME, db.DBCNAME, inst.SERVERMACHINENAME, inst.SERVICEINSTANCENAME, inst.SERVERSID, inst.ORACLEDBID from TBL_LS env JOIN TBL_FLOW p ON p.FLOWID = env.FLOWID JOIN TBL_LS_DBC_MAPPING mp ON mp.LSID = env.LSID JOIN TBL_DBC db ON mp.DBCID = db.DBCID LEFT JOIN TBLMONITOREDDATABASES mdb ON mdb.ID = db.MONITOREDDATABASEID LEFT JOIN TBLMONITOREDSERVERINSTANCES inst ON mdb.SERVERINSTANCEID = inst.INSTANCEID ORDER BY FLOWNAME"
  def env_query_mssql = "select p.FLOWID, p.FLOWNAME, env.LSNAME, db.DBCNAME, inst.SERVER_NAME, inst.USER_NAME, inst.PASSWORD, inst.PORT, inst.DB_AUTH_TYPE_ID from TBL_LS env JOIN TBL_FLOW p ON p.FLOWID = env.FLOWID JOIN TBL_LS_DBC_MAPPING mp ON mp.LSID = env.LSID JOIN TBL_DBC db ON mp.DBCID = db.DBCID LEFT JOIN TBLMONITOREDDATABASES mdb ON mdb.ID = db.MONITOREDDATABASEID LEFT JOIN TBLMONITOREDSERVERINSTANCES inst ON mdb.SERVERINSTANCEID = inst.INSTANCEID ORDER BY p.FLOWNAME"
  def last_pipe = ""
  def env_query = local_settings["general"]["platform"] == "oracle" ? env_query_oracle : env_query_mssql
  message_box("Performing pipeline export (${db_platform} platform)","title")
  envs = conn.eachRow(env_query){ rec ->
		if (db_platform == "oracle") {
			env_info << "${rec.FLOWID},${rec.FLOWNAME},${rec.LSNAME},${rec.SERVERMACHINENAME},${rec.SERVERSID},${rec.SERVICEINSTANCENAME},,${rec.DBCNAME},,,${rec.SERVERMACHINENAME != null },"
		}else{
			env_info << "${rec.FLOWID},${rec.FLOWNAME},${rec.LSNAME},${rec.SERVER_NAME},,,${rec.port},${rec.DBCNAME},${rec.USER_NAME},,FALSE,${rec.DB_AUTH_TYPE_ID}"
		}
  }
  def fil = new File(filename)
  fil.append(env_header + "\r\n")
  fil.append(env_info.join("\r\n"))
	
  println "Env Info\r\n${env_info}"
  
  filename = "${base_path}${sep}pipeline_${db_platform}_export.csv"
	def query_string = "select p.FLOWID, p.FLOWNAME, srcenv.LSNAME as source, tgtenv.LSNAME as target from TBL_LS_RELATIONSHIP rel inner join TBL_FLOW p ON p.FLOWID = rel.FLOWID JOIN TBL_LS_DBC_MAPPING src ON src.MAPPINGID = rel.SOURCEMAPPINGID JOIN TBL_LS_DBC_MAPPING tgt ON tgt.MAPPINGID = rel.TARGETMAPPINGID JOIN TBL_LS srcenv ON srcenv.LSID = src.LSID JOIN TBL_LS tgtenv ON tgtenv.LSID = tgt.LSID ORDER BY p.FLOWID"
  last_pipe = ""
  last_id = ""
  def envs = []
  def rows = []
  def row = []
  def val = ""
  def tmp = ""
  conn.eachRow(query_string){ rec ->
		if(last_pipe != rec.FLOWNAME) {
			if(last_pipe != ""){
				println "Processing: ${last_pipe}"
				rows << process_row(last_pipe, last_id, row, envs, env_info)
				envs = []
				row = []
			}
			last_pipe = rec.FLOWNAME
			last_id = rec.FLOWID
		}
		if(envs.contains(rec.source) && envs.contains(rec.target)){
			val = envs.indexOf(rec.target)
			println "double match at ${val}" 
		}else if(!envs.contains(rec.source) && envs.contains(rec.target)){
			val = envs.indexOf(rec.target)
			println "${envs} tgt match at ${val}" 
			tmp = envs[val]
			envs[val] = rec.source
			println envs
			envs.size() > val ? envs = envs.plus(val + 1, tmp) : envs << tmp
			println envs
		}else if(envs.contains(rec.source) && !envs.contains(rec.target)){
			val = envs.indexOf(rec.source)
			println "${envs} src match at ${val}" 
			envs.size() > val ? envs = envs.plus(val + 1, rec.target) : envs << rec.target
	 
		}else{
			envs << rec.source
			envs << rec.target
		}
		println envs
  }
  rows << process_row(last_pipe, last_id, row, envs, env_info)

  fil = new File(filename)
  fil.append(pipeline_header.join(',') + "\r\n")
  rows.each{ item -> 
	fil.append(item.join(',') + "\r\n")
  }
}

def process_row(pipe, pipe_id, record, envs, env_info){
	record << pipe_id
	record << pipe
	envs.each{ env -> 
		println "- ${env}"
		record << env
	}
	return record
}

def build_import_json() {
	env_types = ["Development", "PreRun", "Release Source", "Testing", "Staging", "Production"]
	def pipe = local_settings["import"]
	def db_platform = local_settings["general"]["platform"]
	def project_template = db_platform == "oracle" ? "project_oracle_template.json" : "project_mssql_template.json"
	def env_template = db_platform == "oracle" ? "env_oracle_template.json" : "env_mssql_template.json"
  def p_template = [:]
	def e_template = [:]
	// process import csv file
	//read environment_export.csv
	def envs = read_csv_file("${base_path}\\env_${db_platform}_export.csv")
	println "Environments:\r\n${envs}"
	def cur_env = [:]
	//read pipeline_export.csv
	def pipelines = read_csv_file("${base_path}\\pipeline_${db_platform}_export.csv")
	println "Pipelines:\r\n${pipelines}"
	pipelines.each{ item ->

		p_template = read_json_file("${base_path}\\${project_template}")
		println "Processing: ${item["Pipeline"]}"
		pipe["project_name"] = item["Pipeline"]
		p_template["ProjectName"] = item["Pipeline"]
    p_template["ProjectGroupId"] = item["ProjectGroupID"] //pipe["project_group"]
    p_template["Options"]["ScriptOutputFolder"] = "${pipe["base_path"]}\\${item["ProjectGroup"]}\\${item["Pipeline"]}"
		cnt = 0
		
		item.keySet().each{ env ->
      if( cnt > 3 && item[env].length() > 1 ){
		    println( "Key: ${item[env]}")
		    e_template = read_json_file("${base_path}\\${env_template}")
        e_template["EnvironmentName"] = item[env]
        cur_env = lookup_environment(envs, item["ID"], item[env])
        e_template["Schemas"][0]["Name"] = cur_env["schema_name"]
        e_template["Schemas"][0]["SchemaCredentials"]["Port"] = cur_env["port"]
        e_template["Schemas"][0]["SchemaCredentials"]["Host"] = cur_env["host"] 
        e_template["Schemas"][0]["SchemaCredentials"]["UserName"] = cur_env["username"] 
        e_template["Schemas"][0]["SchemaCredentials"]["Password"] = cur_env["password"] 
         
        if( db_platform == "oracle") {
          e_template["Schemas"][0]["SchemaCredentials"]["IdentifierType"] = cur_env["service_sid"]
          e_template["Schemas"][0]["SchemaCredentials"]["Identifier"] = cur_env["service_name"]
        }else{
          e_template["Schemas"][0]["SchemaCredentials"]["AuthType"] = cur_env["mssql_auth_type"]
          e_template["Schemas"][0]["SchemaCredentials"]["DBName"] = cur_env["schema_name"] 
       }
		    println "cnt: ${cnt}"
        p_template["EnvironmentTypes"][cnt-2]["Environments"] << e_template
      }
		  cnt += 1
		}
		create_json_file("${base_path}\\output_${pipe["project_name"]}.json", p_template)
    
	} 

}

def lookup_environment(env_info, pipe_id, env){
	def result = [:]
	def got_it = false
	for (item in env_info) { 
		if(pipe_id == item["ID"] && env == item["environment"]){
			println "Found ${env}, ${pipe_id}"
			got_it = true
			result = item
			break
		}
	}
	if(!got_it){ println("NOT FOUND: ${env}, ${pipe_id}") }
	return result
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
		//println "Process Line: ${line}"
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
  println "JSON file: ${filepath}"
  def json_file_obj = new File( filepath )
  if (json_file_obj.exists() ) {
    contents = jsonSlurper.parseText(json_file_obj.text)
  }
  return contents
}

def create_json_file(filepath, contents){
  def jsonSlurper = new JsonSlurper()
  println "Creating JSON file: ${filepath}"
  val_file = new File(filepath)
  val_file.withWriter('utf-8') { writer -> 
    writer << JsonOutput.prettyPrint(JsonOutput.toJson(contents))
  } 
  
}

def add_schemas_to_source_control() {
  message_box("Adding schemas to source control", "title")
  def db_platform = local_settings["general"]["platform"]
	def java_cmd = local_settings["general"]["java_cmd"]
	def server = local_settings["general"]["server"]
	def credential = "-AuthType DBmaestroAccount -UserName ${local_settings["general"]["username"]} -Password \"${local_settings["general"]["token"]}\""
	def sys_cred = "-SysUser \"${local_settings["import"]["sys_user"]}\" -SysPassword \"${local_settings["import"]["sys_password"]}\" -Tablespace \"${local_settings["import"]["tablespace"]}\""
  def sid_ident = "SERVICE_NAME"
  def result = ""
  //read environment_export.csv
  def envs = read_csv_file("${base_path}\\env_${db_platform}_export.csv")
  println "EnvironmentsRaw:${envs}"
	for(env in envs){
    println "EnvironmentRaw:${env}"
    sid_ident = "SERVICE_NAME"
	if(env["is_managed"] == "true"){
		separator()
		println "Environment: ${env["environment"]}"
      if(env["service_name"] == env["sid_service"]){
        sid_ident = "SID"
      }
      dbm_cmd = "${java_cmd} -AddSchema -DisplayName ${env["environment"]} -Host ${env["host"]} -Port ${env["port"].length() < 2 ? "1521" : env["port"]} -ServerInstance ${env["service_name"]} -ServiceInstanceIdentification \"${sid_ident}\" -DBUser \"${env["username"]}\" -DBPassword \"${env["password"]}\" ${sys_cred} -Server ${server} ${credential}"
      println "Executing: ${dbm_cmd}"
      result = shell_execute(dbm_cmd)
      println result
    }
  }

def import_projects() {
  message_box("Adding Projects", "title")
  def db_platform = local_settings["general"]["platform"]
	def java_cmd = local_settings["general"]["java_cmd"]
	def server = local_settings["general"]["server"]
	def credential = "-AuthType DBmaestroAccount -UserName ${local_settings["general"]["username"]} -Password \"${local_settings["general"]["token"]}\""
	def result = ""
  def filepath = ""
  //read environment_export.csv
  def projects = read_csv_file("${base_path}\\pipeline_${db_platform}_export.csv")
  for(proj in projects){
    println "Project: ${proj["Pipeline"]}"
    filepath = "${base_path}\\output_${proj["Pipeline"]}.json"
  	separator()
      dbm_cmd = "${java_cmd} -ImportProject -FilePath ${filepath} -Server ${server} ${credential}"
      println "Executing: ${dbm_cmd}"
      result = shell_execute(dbm_cmd)
      println result
    }
  }	

}

def init_pipelines() {
  message_box("Init Projects with dummy package", "title")
  def base_pkg = "V0.0"
  def db_platform = local_settings["general"]["platform"]
	def java_cmd = local_settings["general"]["java_cmd"]
	def server = local_settings["general"]["server"]
	def stage_path = local_settings["import"]["base_path"]
  def credential = "-AuthType DBmaestroAccount -UserName ${local_settings["general"]["username"]} -Password \"${local_settings["general"]["token"]}\""
  def result = ""
  def dbm_cmd = ""
  def content = "-- Dummy Script - no action\r\n"
  file_path = "${base_path}\\dummy.sql"
  val_file = new File(file_path)
  val_file.withWriter('utf-8') { writer -> 
    writer << content
  }

  //read pipeline_export.csv
  def pipelines = read_csv_file("${base_path}\\pipeline_${db_platform}_export.csv")
	//println "Pipelines:\r\n${pipelines}"
  def cnt = 0
  pipelines.each{ pipe ->
    separator()
    println "=> Project: ${pipe["Pipeline"]}"
    println "Packaging: ${dbm_cmd}"   
    staging_path = "${stage_path}\\${pipe["ProjectGroupName"]}\\${pipe["Pipeline"]}\\${pipe["RS"]}"
    dbm_cmd = "mkdir ${staging_path}\\${base_pkg}"
    result = shell_execute(dbm_cmd)
    println result
    dbm_cmd = "copy ${file_path} ${staging_path}\\${base_pkg}\\"
    result = shell_execute(dbm_cmd)
    println result
    dbm_cmd = "${java_cmd} -Package -ProjectName ${pipe["Pipeline"]} -Server ${server} ${credential}"
    result = shell_execute(dbm_cmd)
    println result
    cnt = 0
    pipe.keySet().each{ env ->
      if( cnt > 3 && pipe[env].length() > 1 ){
		    println( "Upgrade Env: ${pipe[env]}")
	      dbm_cmd = "${java_cmd} -Upgrade -ProjectName ${pipe["Pipeline"]} -EnvName ${pipe[env]} -PackageName ${base_pkg} -Server ${server} ${credential}"
        result = shell_execute(dbm_cmd)
        println result
      }
	  cnt += 1
    }
  }
	

}

def shell_execute(cmd, path = "none"){
  def pth = ""
  if(path != "none") { pth = "cd ${path} && " }
  def outtxt = "cmd /c ${pth}${cmd} 2>&1".execute().text 
  //def outtxt = ""
  //println "cmd /c ${pth}${cmd} 2>&1"
  return outtxt
}

def update_exclusion_list(){
	def jsonSlurper = new JsonSlurper()
	def now = new Date()
	def exclusions = [:]
	def src = ""
	def do_it = false
	def cur_ver = ""
	if (!arg_map.containsKey("exclusion_file")){
		println "Error: Give path to discovery_exclusion.json as argument"
		System.exit(1)
	}
	result = "#----- Updating Discovery Exclusion -------#\n"
	println "JSON Exclusion config: ${arg_map["exclusion_file"]}"
	def json_file_obj = new File( arg_map["exclusion_file"] )
	if (json_file_obj.exists() ) {
	  exclusions = jsonSlurper.parseText(json_file_obj.text)  
	}
  def clause = ""
	def base_query = "UPDATE TWMANAGEDB.TBLSETTINGS SET SETTINGVALUE = 'ARG1' WHERE SETTINGNAME = 'DISCOVERY_FILTER'"
  def bcls = "D.OBJECT_NAME NOT LIKE(''ARG2'')"
  /*  Build Query
  Ex:
UPDATE TWMANAGEDB.TBLSETTINGS 
SET SETTINGVALUE = ' D.OBJECT_NAME NOT LIKE (''BIN$%'')
AND D.OBJECT_NAME NOT LIKE(''MLOG$%'')
AND D.OBJECT_NAME NOT LIKE(''RUPD$%'')
AND D.OBJECT_NAME NOT LIKE(''ISEQ$$_%'')
AND D.OBJECT_NAME NOT LIKE(''SYS_%$'')
AND D.OBJECT_NAME NOT LIKE(''SYS_%'')'
WHERE SETTINGNAME = 'DISCOVERY_FILTER'
  */
  def bfirst = true
  println "Querying Repository Db"
	def conn = sql_connection(repo)
	
  println "Parsing criteria exclusions:"
  for (crit in exclusions["global"]) {
    def k = bfirst ? "" : " AND"
    println "- ${crit}"
    clause += "${k} ${bcls.replaceAll("ARG2",crit)}"
    bfirst = false
  }
	// Perform update query
  def query_string = base_query.replaceAll("ARG1",clause)
  println "Update Query:"
  println query_string
  def result = conn.execute(query_string)
  println "Result: ${result}"
  conn.close()

}
