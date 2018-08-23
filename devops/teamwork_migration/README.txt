#--------------------------------------------------------------#
#  Teamwork Migration Helper
#--------------------------------------------------------------#
#  8/22/18 DBmaestro - BJB
=> A utility to export pipelines and environment information from DBmaestro Teamwork
    for import into DBmaestro DevOps Platform (DOP)
=> How it works:
The teamwork_export job will create two csv files with most of the information to create
your new pipelines.  You will need to edit them to include information that is missing or
encrypted in the teamwork database.  They should import easily into Excel and you can 
save them back to csv format.  In the second step, each managed environment (oracle-only) 
will need to be added to source control before the import.  Then, the third step will 
take the information from the csv files and merge them into a set of json templates.  
This will create a template for each project to be imported into DOP.    

+++ Instructions +++
Copy this zip file to a simple path on the dbmaestro server
=> Edit the information in the local_settings_sql.json
There are several values you dont need to worry about in this file, the important ones are:
> change this value to toggle between the repository you want to query
	general:
        "platform" : "oracle"   - [oracle, mssql]
> Put your repository information here for the SQLServer and Oracle versions 
    connections: 
        "repo_mssql" : {
        "user" : "dbmadmin",
        "password" : "123456",
        "connect" : "teamwork2012:1433;databaseName=TeamWorkRepository"
        },
        "repository" : {
        "user" : "twmanagedb",
        "password" : "manage#2009",
        "connect" : "teamwork2012:1521/orcl"
        },
> Here is where all the import values go.  project_group_id, project_group are the values from your DOP installation.
base_path is the base path for the dbmaestro staging folder.  If your project path in the configuration section is
C:\Automation\HR_POC\HumanResources, then the base_path is C:\Automation because HR_POC is the project group and 
HumanResources is the project.
import:
    	"info" : "### Enter the project group and id where the new projects will be imported to ###",
		"project_group_id" : 11,
		"project_group" : "HR",
		"base_path" : "C:\\Automation",
=> Edit the dbm_api.bat file and match the paths to where you expanded the zip file.
=> Run the scripts from the command line.  
    > First export the teamwork details:
        C:\migration> dbm_api.bat action=teamwork_export
    this will create the pipeline_oracle_export and env_oracle_export files (or mssql)
    > Edit the files in Excel and fill in the missing information.  Note for many schema in oracle that we managed
    in TeamWork, you will want them to be unmanaged in DOP.  For this flip the managed field to false, like this:
    3,MP_Release,SIT,teamwork2012,SID,orcl,1521,MP_SIT,MP_SIT,password,false, (the last comma is important)
    > Run the build step.  This should create a json file for each pipeline to be imported.
        C:\migration> dbm_api.bat action=build_import_json		
    > Import the project into DOP using the API.  Like this:
        C:\migration> java -jar DBmaestroAgent.jar -ImportProject -FilePath "C:\Automation\HRImport.json" 
         -Server teamwork2012 -AuthType DBmaestroAccount -UserName "automation@dbmaestro.com" -Password "123456" 