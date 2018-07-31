#  Bamboo Pattern

Create a Plan and Build

Build will perform xx steps:
	1) Read <plan>_properties.txt
		gives these variables
			bamboo_dbm_java_cmd
			bamboo_dbm_base_path
			bamboo_dbm_staging_path
			bamboo_dbm_git_remote
			bamboo_dbm_server
			bamboo_dbm_pipeline_
			bamboo_dbm_password
	1) Read git commit and determine version to deploy (creates version.properties file)
			bamboo_dbm_version
	2) Copy files from source control to staging area
	3) Trigger DBmaestro packaging
	
Deploy will perform xx steps:
	1) Read <plan>_properties.txt
	2) Deploy to bamboo_dbm_environment

The job will be cloned for each environment and will have a different bamboo dbm environment.

Each task in bamboo will call the same powershell script: bamboo_dbm_operation.ps1

The tasks available are:
	deploy
	package
	git_params
	stage_files

