ALTER SESSION SET CURRENT_SCHEMA = TSD_RATES_DEV;


ALTER TABLE "TSD_RATES_DEV"."TBPRDCHA_PRDT_CHARACTERISTIC" DROP PRIMARY KEY CASCADE;
ALTER TABLE "TSD_RATES_DEV"."TBPRDCHA_PRDT_CHARACTERISTIC" DROP CONSTRAINT "AK_PRDCHA_01" CASCADE;


DROP INDEX "TSD_RATES_DEV"."FK_PRDCHA_PRDT_01";



CREATE UNIQUE INDEX "TSD_RATES_DEV"."AK_PRDCHA_01" ON "TSD_RATES_DEV"."TBPRDCHA_PRDT_CHARACTERISTIC" ("PRDT_ID", "PRDCHA_TYP_CD", "PRDCHA_EFFCTV_DT")
;


ALTER SESSION SET CURRENT_SCHEMA = TSD_RATES_DEV;


DROP INDEX "TSD_RATES_DEV"."PK_PRDCHA";


