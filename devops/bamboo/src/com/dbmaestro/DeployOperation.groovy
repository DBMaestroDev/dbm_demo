package src.com.dbmaestro


def upgrade_environment(pipe, env_num){
  def environment = pipe["environments"][env_num]
  def approver = pipe["approvers"][env_num]
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
	println "#------------------- Performing Deploy on ${environment} --------------#"
	for(env in pair){
		result = shell_command("${pipe["java_cmd"]} -Upgrade -ProjectName ${pipe["pipeline"]} -EnvName ${env} -PackageName ${version} -Server ${pipe["server"]} ${pipe["credential"]}")
  }
}

def package_artifacts(pipe, env_num){
  def version = pipe["version"]
  def tasks = pipe["tasks"]
  def v_version = version
  def result = ""
  if( !version.startsWith("V") && version =~ /\d\.\d/ ) {v_version = "V#{version}" } 
  def staging_dir = pipe["staging_dir"]
  def source_dir = pipe["source_dir"]
  if(!System.getenv("Skip_Packaging") || System.getenv("Skip_Packaging") == "No"){
    println "#------------------- Copying files for ${version} ---------#"
    result = shell_command( "if exist ${staging_dir} del /q ${staging_dir}\\*" )
		println "# Cleaning Directory"
		result = shell_command( "del /q \"${staging_dir}\\*\"" )
		result = shell_command( "FOR /D %%p IN (\"${staging_dir}\\*.*\") DO rmdir \"%%p\" /s /q" )
    if(pipe["file_strategy"] == "version"){
      // This is for copying a whole directory
      result = shell_command( "xcopy /s /y /i \"${source_dir}${sep()}${version}\" \"${processed_dir}\"")
    }else{
      def processed_dir = "${source_dir}${sep()}processed${sep()}${v_version}"
      def version_dir = "${staging_dir}${sep()}${v_version}"
      ensure_dir(processed_dir)
      // This is for when files are prefixed with <dbcr_result>
      tasks.split(",").each {item->
        result = shell_command( "copy \"${source_dir}${sep()}${item.trim()}*.sql\" \"${version_dir}\"" )
        result = shell_command( "move \"${source_dir}${sep()}${item.trim()}*.sql\" \"${processed_dir}\"" )
      }
      
    }
    // trigger packaging
    println "#----------------- Packaging Files for ${version} -------#"
    result = shell_command( "${pipe["java_cmd"]} -Package -ProjectName ${pipe["pipeline"]} -Server ${pipe["server"]} ${pipe["credential"]}" )
    // version = adhoc_package(version)
  }else{
	  println "#-------------- Skipping packaging step (parameter set) ---------#"
  }
}

def execute(pipe_info, env_num){
  message_box(pipe_info["environments"][env_num], "title")
  if(env_num == 0){
	  this.package_artifacts(pipe_info, env_num)
  }
  this.upgrade_environment(pipe_info, env_num)
}

return this;
