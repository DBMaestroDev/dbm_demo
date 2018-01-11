echo off
echo #----------------------------#
echo # Bamboo Groovy Processor #
echo #----------------------------#
java -cp "C:\Automation\Utility\lib\*;C:\Program Files (x86)\Jenkins\war\WEB-INF\lib\*" groovy.ui.GroovyMain C:\Automation\Utility\dbm_bamboo.groovy %*
