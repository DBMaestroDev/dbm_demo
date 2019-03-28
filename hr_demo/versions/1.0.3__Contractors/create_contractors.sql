
--Script generated by \ on 23/08/2017 15:32
--Note: Please review this script prior to execution

HOST mkdir "C:\automation\hr\Spool"
SPOOL C:\automation\hr\Spool\2017-08-23-033259_Output_Spool.log APPEND

SET SERVEROUTPUT ON
SET DEFINE OFF
SET BLOCKTERMINATOR OFF
SET SQLBLANKLINES ON

-- Step 1: Creating table - 'CONTRACTORS'
EXECUTE DBMS_OUTPUT.PUT_LINE('Step 1: Creating table - CONTRACTORS');
CREATE TABLE "CONTRACTORS" 
   (	"ID" NUMBER, 
	"EMPLOYEE_ID" NUMBER, 
	"FIRST_NAME" VARCHAR2(40), 
	"LAST_NAME" VARCHAR2(50)
   ) ;


-- Step 3: Recompiling invalid objects
EXECUTE DBMS_OUTPUT.PUT_LINE('Step 3: Recompiling invalid objects');
BEGIN
DBMS_UTILITY.COMPILE_SCHEMA(USER, FALSE, FALSE);
END;
/


PROMPT Fetching invalid objects after deployment actions
PROMPT ****************************************************************************
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
FROM   ALL_OBJECTS
WHERE  STATUS <> 'VALID' AND OWNER = USER;


SET SQLBLANKLINES OFF
SET BLOCKTERMINATOR ON
SET DEFINE ON
SPOOL OFF




exit;

