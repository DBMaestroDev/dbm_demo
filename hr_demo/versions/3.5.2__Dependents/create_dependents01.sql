
--Script generated by \ on 23/08/2017 15:32
--Note: Please review this script prior to execution

HOST mkdir "C:\automation\hr\Spool"
SPOOL C:\automation\hr\Spool\2017-08-23-033259_Output_Spool.log APPEND

SET SERVEROUTPUT ON
SET DEFINE OFF
SET BLOCKTERMINATOR OFF
SET SQLBLANKLINES ON

-- Step 1: Creating table - 'DEPENDENTS'
EXECUTE DBMS_OUTPUT.PUT_LINE('Step 1: Creating table - Dependents');
CREATE TABLE "DEPENDENTS" 
   ("ID" NUMBER, 
	"EMPLOYEE_ID" NUMBER, 
	"FIRST_NAME" VARCHAR2(40), 
	"LAST_NAME" VARCHAR2(50),
	"RELATIONSHIP" VARCHAR2(100)
   ) ;



SET SQLBLANKLINES OFF
SET BLOCKTERMINATOR ON
SET DEFINE ON
SPOOL OFF




exit;

