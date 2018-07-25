package src.com.dbmaestro

import src.com.dbmaestro.Utils as Utils

def upgrade_environment(pipe, env_num){
  def environment = pipe["environments"][env_num]
  def approver = pipe["approvers"][env_num]
	def ssl = pipe["use_ssl"] == "false" ? "" : "-useSSL y "
  def pair = environment.split(",")
  def do_pair = false
  def result = ""
  def version = pipe["version"]
  if(!version.startsWith("V") && version =~ /\d\.\d/) { version = "V${version}" }
  if (pair.size() > 1) {environment = pair[0] }
  do_pair = (pair.size() > 1) 
  /*if(approver != "none"){
	  input message: "Deploy to ${environment}?", submitter: approver
  } */
	ut.message_box "Performing Deploy on ${environment}"
	for(env in pair){
		result = ut.shell_command("${pipe["java_cmd"]} -Upgrade -ProjectName ${pipe["pipeline"]} -EnvName ${env} -PackageName ${version} -Server ${pipe["server"]} ${ssl}${pipe["credential"]}")
  }
}

def package_artifacts(pipe, env_num){
  def version = pipe["version"]
  def tasks = pipe["tasks"]
  def v_version = version
	def ssl = pipe["use_ssl"] == "false" ? "" : "-useSSL y "
  def result = ""
  if( !version.startsWith("V") && version =~ /\d\.\d/ ) {v_version = "V#{version}" } 
  def staging_dir = pipe["staging_dir"]
  def source_dir = pipe["source_dir"]
  if(!System.getenv("Skip_Packaging") || System.getenv("Skip_Packaging") == "No"){
    ut.message_box "Copying files for ${version}"
    result = ut.shell_command( "if exist ${staging_dir} del /q ${staging_dir}\\*" )
		println "# Cleaning Directory"
		result = ut.shell_command( "del /q \"${staging_dir}\\*\"" )
		result = ut.shell_command( "FOR /D %%p IN (\"${staging_dir}\\*.*\") DO rmdir \"%%p\" /s /q" )
    def processed_dir = "${source_dir}${ut.sep()}processed${ut.sep()}${v_version}"
      def version_dir = "${staging_dir}${ut.sep()}${v_version}"
      if(pipe["file_strategy"] == "version"){
      // This is for copying a whole directory
      result = ut.shell_command( "xcopy /s /y /i \"${source_dir}${ut.sep()}${version}\" \"${version_dir}\"")
    }else{
      ut.ensure_dir(processed_dir)
      // This is for when files are prefixed with <dbcr_result>
      tasks.split(",").each {item->
        result = ut.shell_command( "copy \"${source_dir}${ut.sep()}${item.trim()}*.sql\" \"${version_dir}\"" )
        result = ut.shell_command( "move \"${source_dir}${ut.sep()}${item.trim()}*.sql\" \"${processed_dir}\"" )
      }
      
    }
    // trigger packaging
    ut.message_box "Packaging Files for ${version}"
    result = ut.shell_command( "${pipe["java_cmd"]} -Package -ProjectName ${pipe["pipeline"]} ${ssl}-Server ${pipe["server"]} ${pipe["credential"]}" )
    // version = adhoc_package(version)
  }else{
	  ut.message_box "Skipping packaging step (parameter set)"
  }
}

def execute(pipe_info, env_num){
  ut = new Utils()
  ut.message_box(pipe_info["environments"][env_num], "title")
  if(env_num == 0){
	  this.package_artifacts(pipe_info, env_num)
  }
  this.upgrade_environment(pipe_info, env_num)
}

return this;
