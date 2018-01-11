echo off
echo #----------------------------#
echo # DBmaestro Groovy Processor #
echo #----------------------------#
java -cp ".;C:\Automation\dbm_demo\devops\lib\*;C:\Program Files (x86)\Jenkins\war\WEB-INF\lib\groovy-all-1.8.9.jar" groovy.ui.GroovyMain c:\Automation\dbm_demo\devops\dbm_connect.groovy %*
