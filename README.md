# dbm_demo - DBmaestro Script and Automation Community Library

Devops code and sample scripts for database deployment.  There are several pieces to the library:

* Jenkins groovy pipeline examples for DBmaestro deployment
* Bamboo pipeline scripts for DBmaestro deployment
* Sample ddl scripts, mostly for the oracle example hr schema
* Supplemental scripts to extend DBMaestro
* Feature scripts for DBmaestro capabilities like hooks and packaging

### Getting Started

-- BJB 4/2/19
On your machine (presumably the DBmaestro server), create a folder C:\Automation (if you cant use that path, there are just a few paths to change in the code).  Get the clone link for this project, install a git client if you dont have one, then go to git-bash in the /C:/Automation folder and run:

```
git clone https://github.com/bradybyrd/dbm_demo.git
```

Now localize the information. First copy the devops/local_settings_example.json file to local_settings.json and open that for editing.  Fix the variables in the top section to match your DBmaestro installation.
Note - all windows paths need \\ backslashes or groovy will interpret it as an escape.

```
{
  "### Instructions ###": 
    "Enter the local settings items for your installation",
    "general" : {
      "java_cmd" : "java -jar \"C:\\Program Files (x86)\\DBmaestro\\TeamWork\\TeamWorkOracleServer\\Automation\\DBmaestroAgent.jar\"",
      "staging_path" : "C:\\pipelinescript\\MP",
      "server" : "dbmtemplate",
  	  "username" : "dbmguest@dbmaestro.com",
  	  "token" : "2BqDtNyL7gQjp6J0Kp7HNHbB5P0WayH0"
    },
    "connections" : {
    "repository" : {
      "user" : "twmanagedb",
      "password" : "manage#2009",
      "connect" : "dbmtemplate:1521/orcl"
    }
```

- staging_path should point to the project group folder of your DBmaestro staging directory.  The code will add your project name and base schema to the path.
- Set the connection info for your automation user and DBmaestro server name.
- The repository connection is used commonly by the dbm_api automation which makes direct queries into the DBmaestro repository.

The branch map section is only used by the Jenkins groovy pipeline scripts

```
	"branch_map" : {
		"release" : [
		  {
		  "pipeline" : "HumanResources",
		  "base_env" : "DIT",
		  "base_schema" : "HR_DEV",
  	  "source_dir" : "C:\\Automation\\dbm_demo\\hr_demo\\versions",
	  	"platform" : "oracle",
		  "environments" : [
			 "DIT",
			 "QA1,QA2",
			 "STAGE",
			 "PROD"
		   ],
 		  "approvers" : [
 			 "teamwork",
 			 "teamwork",
 			 "teamwork",
 			 "teamwork"
 		   ]
		  }
		],
		"hrm" : [
		  {
		  "pipeline" : "HRMADM",
```

The branch map section has maps of your project/pipelines.  The key (release in the first example) should match the name of the Jenkins job (lowercase).  
- base_environment should be the name of your Release Source.
- base_schema should be the underlying schema for that.  
- source_dir is the folder where the automation will look for scripts to copy for packaging.
- environments should match your pipeline (unless you want to skip a few).
- approvers should match the number of environments and be the jenkins user (or AD group in CloudBees) that can approve deployment.
Note there can be several branch maps, so one local_settings file should support a family of pipelines.

## Jenkins Groovy Pipeline

After configuring the local_settings file for your pipeline, create a Jenkins job and give it a name that matches the key in the local_settings file that matches.  The jenkins job should beconfigured for git source control.  Point to the dbm_demo folder like this:

```
file:///C:/Automation/dbm_demo
```

then in the jenkinsfile section put this:

```
devops/jenkinsfile74.groovy
```

Configure the jenkinsfile74.groovy file.  If you are following all the defaults, nothing needs to be changed.  Otherwise, there are just a few line that might need editing. There's pretty good explanations in the file.
Note - all windows paths need \\ backslashes or groovy will interpret it as an escape.

```
// DBmaestro Jenkins Groovy Deployment Pipeline
// Set this variable to force it to pick the pipeline
// If it is set to job, then it will match the name of your jenkins job to the key in the branch map in the local_settings.json file.
def landscape = "job"
// Set this variable to point to the folder where your local_settings.json folder is if different from this file
def base_path = new File(getClass().protectionDomain.codeSource.location.path).parent
//def base_path = "C:\\Automation\\dbm_demo\\devops"
// Change this if you want to point to a different local settings file
def settings_file = "local_settings.json"
```

Now run your job.  You will get about 10 Jenkins sandbox violations that you will have to approve in Manage Jenkins | In Process Script Approval - yes they have to go one at a time.  Alternatively, in the jenkins_pipeline folder there is a copy of the scriptApproval.xml file.  Save your current one, or add the keys from this one to it.  It goes in the main Progream Files (x86)\Jenkins folder. That will get rid of a bunch of job failures based on approvals.

## dbm_api Methods

dbm_api provides extended capabilities based on information in the DBmaestro repository.  It uses the same local_settings.json file for configuration.

Informational Methods:

* List all packages in a project.  This is helpful to understand packages and scripts.


### Folder Organization
-- BJB 4/2/19
The main action is in the devops folder, it contains all the groovy and script examples.
Bamboo - has a collection of powershell scripts that are useful for building bamboo flows
Draft - ignore, or take a risk!
git_revisions - This has groovy script for exporting all your database DDL into files to be pushed into git.
hooks - This has groovy scripts to connect to using DBmaestro hook actions.
include_pipeline - This is a deconstructed version of the pipeline code using Jenkins global libraries.  Very useful if you have many pipelines that need to use the same devops code but be in different branches/repositories.
jenkins_pipeline - This is a collection of different flavors of the standard groovy pipeline
lib - jar files, database drivers etc
packaging - This has file examples of scripts for packaging
teamwork_migration - This has scripts and templates to export all pipeline information from legacy teamwork and import into DevOps Platform.
test - you can guess

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Disclosure

The contents of the project is community built.  DBmaestro takes no responsibility for the content and usability of the code contained herein.

