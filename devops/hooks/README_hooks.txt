#-----------------------  Hooks Receiver for git processing ----------------------
The batch script is called from the hook and passed and argument of the json file path






#-----------------------  SAMPLE OUTPUT ----------------------

C:\Automation\HR_Deploy>devops\git_hook.bat C:\Automation\HR_Deploy\devops\hook_input_wchange.json

C:\Automation\HR_Deploy>echo off
#--------------------------------------------#
#      DBmaestro git-hook Processor         #
#--------------------------------------------#
12/01/2018 22:19:23|INFO> #------------- New Run ---------------#
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> #                           Processing Hook for git Sync                         #
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> InputFile: C:\Automation\HR_Deploy\devops\hook_input_wchange.json
12/01/2018 22:19:23|INFO> JSON Settings Document: C:\Automation\HR_Deploy\devops\hook_input_wchange.json
12/01/2018 22:19:23|INFO> Job initiated by: automation@dbmaestro.com on 2018-11-15T12:20:24.293
12/01/2018 22:19:23|INFO> Pipeline: HumanResources, Environment: DIT, Version: V1.4.1-Financial
12/01/2018 22:19:23|INFO> #=> Scripts:
12/01/2018 22:19:23|INFO> Name                     | Schema
12/01/2018 22:19:23|INFO> add_tax_to_countries.sql | HR
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> #                              Oracle - DDL Processor                            #
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> => Processes DBmaestro revisions to files.
12/01/2018 22:19:23|INFO> Database: HR
12/01/2018 22:19:23|INFO> #---------------------------------------------------------------------------------------------
-----#
12/01/2018 22:19:23|INFO> Job initiated by: automation@dbmaestro.com on 2018-11-15T12:20:24.293
12/01/2018 22:19:23|INFO> Pipeline: HumanResources, Environment: DIT, Version: V1.4.1-Financial
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> #                              Update Git Repository                             #
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> Repository Path: C:\Automation\REPO
12/01/2018 22:19:23|INFO> Using Branch: master
12/01/2018 22:19:23|INFO> out> On branch master
12/01/2018 22:19:23|INFO> Your branch is ahead of 'origin/master' by 1 commit.
12/01/2018 22:19:23|INFO> (use "git push" to publish your local commits)
12/01/2018 22:19:23|INFO>
12/01/2018 22:19:23|INFO> Changes not staged for commit:
12/01/2018 22:19:23|INFO> (use "git add <file>..." to update what will be committed)
12/01/2018 22:19:23|INFO> (use "git checkout -- <file>..." to discard changes in working directory)
12/01/2018 22:19:23|INFO>
12/01/2018 22:19:23|INFO> modified:   oracle/HR/TABLE/COUNTRIES.sql
12/01/2018 22:19:23|INFO>
12/01/2018 22:19:23|INFO> no changes added to commit (use "git add" and/or "git commit -a")
12/01/2018 22:19:23|INFO> err>
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> Running: cd C:\Automation\REPO && git status
12/01/2018 22:19:23|INFO> out> On branch master
12/01/2018 22:19:23|INFO> Your branch is ahead of 'origin/master' by 1 commit.
12/01/2018 22:19:23|INFO> (use "git push" to publish your local commits)
12/01/2018 22:19:23|INFO>
12/01/2018 22:19:23|INFO> Changes not staged for commit:
12/01/2018 22:19:23|INFO> (use "git add <file>..." to update what will be committed)
12/01/2018 22:19:23|INFO> (use "git checkout -- <file>..." to discard changes in working directory)
12/01/2018 22:19:23|INFO>
12/01/2018 22:19:23|INFO> modified:   oracle/HR/TABLE/COUNTRIES.sql
12/01/2018 22:19:23|INFO>
12/01/2018 22:19:23|INFO> no changes added to commit (use "git add" and/or "git commit -a")
12/01/2018 22:19:23|INFO> err>
12/01/2018 22:19:23|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:23|INFO> Running: cd C:\Automation\REPO && git add *
12/01/2018 22:19:23|INFO> out>
12/01/2018 22:19:23|INFO> err> warning: LF will be replaced by CRLF in oracle/HR/TABLE/COUNTRIES.sql.
12/01/2018 22:19:23|INFO> The file will have its original line endings in your working directory.
12/01/2018 22:19:24|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:24|INFO> Running: cd C:\Automation\REPO && git read-tree --reset HEAD
12/01/2018 22:19:24|INFO> out>
12/01/2018 22:19:24|INFO> err>
12/01/2018 22:19:24|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:24|INFO> Running: cd C:\Automation\REPO && git commit -a -m "DBm Hook update - HumanResources => DIT fo
r version: V1.4.1-Financial"
12/01/2018 22:19:24|INFO> out> [master 61755d1] DBm Hook update - HumanResources => DIT for version: V1.4.1-Financial
12/01/2018 22:19:24|INFO> 1 file changed, 17 insertions(+), 16 deletions(-)
12/01/2018 22:19:24|INFO> rewrite oracle/HR/TABLE/COUNTRIES.sql (73%)
12/01/2018 22:19:24|INFO> err> warning: LF will be replaced by CRLF in oracle/HR/TABLE/COUNTRIES.sql.
12/01/2018 22:19:24|INFO> The file will have its original line endings in your working directory.
12/01/2018 22:19:25|INFO> #--------------------------------------------------------------------------------#
12/01/2018 22:19:25|INFO> Running: cd C:\Automation\REPO && git push origin master
12/01/2018 22:19:25|INFO> out>
12/01/2018 22:19:25|INFO> err>

C:\Automation\HR_Deploy>cd ..\REPO

C:\Automation\REPO>git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean

C:\Automation\REPO>git log -2
commit 61755d1da67ee722b5365d9eee14417edf8a3f19 (HEAD -> master, origin/master, origin/HEAD)
Author: Otto Mation <automation@dbmaestro.com>
Date:   Sat Dec 1 22:19:24 2018 +0000

    DBm Hook update - HumanResources => DIT for version: V1.4.1-Financial

commit a286f789283bf9c09ef839608423ba498ca3b88e
Author: Automation User <dbmdemo@dbmaestro.com>
Date:   Thu Nov 15 12:21:43 2018 +0000

    DBm Hook update - HumanResources => DIT for version: V1.4.1-Financial

C:\Automation\REPO>git diff a286f789283bf9c09ef839608423ba498ca3b88e
diff --git a/oracle/HR/TABLE/COUNTRIES.sql b/oracle/HR/TABLE/COUNTRIES.sql
index 7fde628..a34dd1b 100644
--- a/oracle/HR/TABLE/COUNTRIES.sql
+++ b/oracle/HR/TABLE/COUNTRIES.sql
@@ -1,4 +1,5 @@
-CREATE TABLE "HR"."COUNTRIES"
+
+  CREATE TABLE "COUNTRIES"
    (   "COUNTRY_ID" CHAR(2),
        "COUNTRY_NAME" VARCHAR2(40),
        "REGION_ID" NUMBER,
@@ -6,11 +7,11 @@ CREATE TABLE "HR"."COUNTRIES"
        "TAX_STRUCTURE" VARCHAR2(255),
         CONSTRAINT "COUNTRY_C_ID_PK" PRIMARY KEY ("COUNTRY_ID") ENABLE
    ) ORGANIZATION INDEX NOCOMPRESS ;
-   COMMENT ON COLUMN "HR"."COUNTRIES"."COUNTRY_ID" IS 'Primary key of countries table.';
-   COMMENT ON COLUMN "HR"."COUNTRIES"."COUNTRY_NAME" IS 'Country name';
-   COMMENT ON COLUMN "HR"."COUNTRIES"."REGION_ID" IS 'Region ID for the country. Foreign key to region_id column in the
 departments table.';
-   COMMENT ON TABLE "HR"."COUNTRIES"  IS 'country table. Contains 25 rows. References with locations table.';
-
-  ALTER TABLE "HR"."COUNTRIES" ADD CONSTRAINT "COUNTR_REG_FK" FOREIGN KEY ("REGION_ID")
-         REFERENCES "HR"."REGIONS" ("REGION_ID") ENABLE;
-  ALTER TABLE "HR"."COUNTRIES" MODIFY ("COUNTRY_ID" CONSTRAINT "COUNTRY_ID_NN" NOT NULL ENABLE);
\ No newline at end of file
+   COMMENT ON COLUMN "COUNTRIES"."COUNTRY_ID" IS 'Primary key of countries table.';
+   COMMENT ON COLUMN "COUNTRIES"."COUNTRY_NAME" IS 'Country name';
+   COMMENT ON COLUMN "COUNTRIES"."REGION_ID" IS 'Region ID for the country. Foreign key to region_id column in the depa
rtments table.';
+   COMMENT ON TABLE "COUNTRIES"  IS 'country table. Contains 25 rows. References with locations table.';
+
+  ALTER TABLE "COUNTRIES" ADD CONSTRAINT "COUNTR_REG_FK" FOREIGN KEY ("REGION_ID")
+         REFERENCES "REGIONS" ("REGION_ID") ENABLE;
+  ALTER TABLE "COUNTRIES" MODIFY ("COUNTRY_ID" CONSTRAINT "COUNTRY_ID_NN" NOT NULL ENABLE);
