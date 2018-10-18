echo off
echo #--------------------------------------------#
echo #      DBmaestro Revisions Processor         #
echo #--------------------------------------------#
java -cp ".;C:\Automation\dbm_demo\devops\lib\*;C:\Automation\dbm_demo\devops\lib\groovy-all-2.4.7.jar" groovy.ui.GroovyMain c:\Automation\dbm_demo\devops\git_revisions\revision_processor.groovy %*
IF %ERRORLEVEL% NEQ 0 ( 
   echo Groovy Script failed code: %ERRORLEVEL%
   EXIT /b %ERRORLEVEL% 
)
