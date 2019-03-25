echo off
echo #--------------------------------------------#
echo #      DBmaestro Processor         #
echo #--------------------------------------------#
java -cp ".;C:\Automation\dbm_demo\devops\lib\*;C:\Automation\dbm_demo\devops\lib\groovy-all-2.4.7.jar" groovy.ui.GroovyMain C:\Automation\Import\imports\db_installs.groovy %*
IF %ERRORLEVEL% NEQ 0 ( 
   echo Groovy Script failed code: %ERRORLEVEL%
   EXIT /b %ERRORLEVEL% 
)
