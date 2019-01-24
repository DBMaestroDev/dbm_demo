
HOST mkdir "C:\automation\hr\Spool"
SPOOL C:\automation\hr\Spool\2017-08-23-060058_Output_Spool.log APPEND

SET SERVEROUTPUT ON
SET DEFINE OFF
SET BLOCKTERMINATOR OFF
SET SQLBLANKLINES ON


-- Step 1: Creating columns
EXECUTE DBMS_OUTPUT.PUT_LINE('Step 1: Creating columns');
ALTER TABLE "CONTRACTORS" ADD ("CFIRM_ID" NUMBER DEFAULT NULL);

-- Step 2: Recompiling invalid objects
EXECUTE DBMS_OUTPUT.PUT_LINE('Step 2: Recompiling invalid objects');
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

