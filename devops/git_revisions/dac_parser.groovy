/*
####### SQL Method Parser ################
#  Based on Microsoft DAC pac onverted output files

=> BJB 7/2/18
*/
import groovy.json.*
sep = "\\" //FIXME Reset for windows
def this_path = new File(getClass().protectionDomain.codeSource.location.path).parent
def settings_file = "${this_path}${sep}parser_input.json"
def file_path = ""
def delim = "GO"
def obj_dll = ""
settings = [:]
settings = get_settings(settings_file)
arg_map = [:]
parse_arguments(this.args)
def base_path = settings["general"]["base_path"]
delim = settings["general"]["code_separator"]
if (!arg_map.containsKey("dacpac_file")){
  println message_box("ERROR: No dacpac_file argument given", "title")
  System.exit(1)
}
def file_name = arg_map["file"]
def rpt = true
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
    if(rpt){println "accumulate ${icnt}"}
    rpt = false
  }
  //println "#=> Line: ${line}"
  last_line = line
  icnt += 1  
}
// FIXME - now add all the files to git and commit
// update_scm

 
def parse_arguments(args){
  for (arg in args) {
    //println arg
    pair = arg.split("=")
    if(pair.size() == 2) {
      arg_map[pair[0].trim()] = pair[1].trim()
    }else{
      arg_map[arg] = ""
    }
  }
  
}

def save_object(content){
  def base_path = "${settings["general"]["base_path"]}${sep}${settings["general"]["repository_name"]}"
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
    println "#=> Line: ${ln}"
    if(icnt < 4){
      obj_type = has_declaration(ln)
      if(obj_type != "not found"){
        cur_line = ln
        println "Found: ${cur_line}"
        break
      }
    }else{
      println "Did not find declaration in first 4 lines"
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
        prefix = settings["sub_objects"]["prefix"]      
        obj_type = subobj_type
        obj_name = dec_line.replaceFirst(sub_reg, '$1')
        println "SUB: ${obj_type}: ${obj_name}"
      }else{
        println "PRIMARY: ${obj_type}: ${obj_name}"
      }
    }else{
      prefix = settings["sub_modifiers"]["prefix"]
      obj_type = mod_type
      obj_name = cur_line.replaceFirst(mod_reg, '$1')
      println "MOD: ${obj_type}: ${obj_name}"
    }
    def path = "${base_path}${sep}${obj_type}"
    ensure_dir(path)
    def name = obj_name.replaceAll(/\;/,"").trim()
    name = "${prefix}${name}.sql"    
    def hnd = new File("${path}${sep}${name}")
    println "Saving: ${path}${sep}${name}"
    hnd.write content
  }
}

def has_declaration(line, type = "objects"){
  def obj_type = "not found"
  if(line == null || line.length() < 2){
    return obj_type
  }
  def declarations = settings[type]
  for(term in declarations.keySet()) {
    if(line.indexOf(term) > -1){
        obj_type = declarations[term]
        println "Found declaration: ${term}"
        break
     }
   }
  return obj_type
}

def get_settings(file_path) {
	def jsonSlurper = new JsonSlurper()
	def settings = [:]
	println "JSON Settings Document: ${file_path}"
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
  //println res
  return res
}

def separator( def ilength = 82){
  def dashy = "-" * (ilength - 2)
  //println "#${dashy}#"
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
