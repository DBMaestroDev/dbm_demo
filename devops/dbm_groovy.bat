echo off
echo #----------------------------#
echo # DBmaestro Groovy Processor #
echo #----------------------------#
java -cp ".;ojdbc6.jar;C:\Program Files (x86)\Jenkins\war\WEB-INF\lib\groovy-all-1.8.9.jar" groovy.ui.GroovyMain c:\pipelinescript\Utility\dbm_connect.groovy %*
