/*
#---------- dbm_api.groovy ------------------#
This file will call the central PipelineInclude module which contains the pipeline logic.  In this file you can
put things specific to the branch that drives this work. Use the settings map to pass any variables into the
master include.
*/
//package src.com.dbmaestro

import src.com.dbmaestro.DbmConnect as DbmConnect

def arg_map = [:]

for (arg in this.args) {
  //println arg
  pair = arg.split("=")
  if(pair.size() == 2) {
    arg_map[pair[0].trim()] = pair[1].trim()
  }else{
    arg_map[arg] = ""
  }
}

def dbm_connect = new DbmConnect()
dbm_connect.execute(arg_map)