echo off
echo #----------------------------#
echo # DBmaestro Groovy Processor #
echo #----------------------------#
java -cp ".;lib\*;lib\groovy-all-2.4.7.jar" groovy.ui.GroovyMain dbm_api.groovy %*
IF %ERRORLEVEL% NEQ 0 ( 
   echo Groovy Script failed code: %ERRORLEVEL%
   EXIT /b %ERRORLEVEL% 
)
