/*
#---------- dbm_api.groovy ------------------#
This file will call the central PipelineInclude module which contains the pipeline logic.  In this file you can
put things specific to the branch that drives this work. Use the settings map to pass any variables into the
master include.
*/
//package src.com.dbmaestro

import src.com.dbmaestro.DbmConnect as DbmConnect
import src.com.dbmaestro.PipelineInclude as PipelineInclude

// #--- Set these primary variables which may vary by application ------------# 
def base_path = "C:\\Automation\\dbm_demo\\devops\\bamboo"
def local_settings = "C:\\Automation\\dbm_demo\\devops\\bamboo\\resources\\settings\\local_settings_include.json"
def landscape = "hr"
def arg_map = [:]
def settings = ["settings_file" : local_settings, "base_path" : base_path, "landscape" : landscape]
for (arg in this.args) {
  //println arg
  pair = arg.split("=")
  if(pair.size() == 2) {
    arg_map[pair[0].trim()] = pair[1].trim()
  }else{
    arg_map[arg] = ""
  }
}
settings["arg_map"] = arg_map
if(arg_map.containsKey("pipeline")){
  def dbm_pipeline = new PipelineInclude()
  dbm_pipeline.execute(settings)
}else{
  def dbm_connect = new DbmConnect()
  dbm_connect.execute(settings)
}
