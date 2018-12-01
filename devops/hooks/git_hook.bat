echo off
echo #--------------------------------------------#
echo #      DBmaestro git-hook Processor         #
echo #--------------------------------------------#
java -cp ".;C:\Automation\dbm_demo\devops\lib\*;C:\Automation\dbm_demo\devops\lib\groovy-all-2.4.7.jar" groovy.ui.GroovyMain c:\Automation\HR_Deploy\devops\git_hook.groovy %*
IF %ERRORLEVEL% NEQ 0 ( 
   echo Groovy Script failed code: %ERRORLEVEL%
   EXIT /b %ERRORLEVEL% 
)
