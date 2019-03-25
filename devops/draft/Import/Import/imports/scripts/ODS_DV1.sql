--------------------------------------------------------------------------
-- __SCHEMA__@DOMDMA schema extracted by user BE82947
--------------------------------------------------------------------------
-- "Set define off" turns off substitution variables.
Set define off;

CREATE TABLE __SCHEMA__.CDI_AUDIT
(
  CDI_AUDIT_ID         NUMBER(12)               NOT NULL,
  EVT_TYPE             VARCHAR2(32 CHAR),
  EVT_TIME             TIMESTAMP(6),
  EVT_USER_ID          VARCHAR2(30 CHAR),
  EVT_LOCATION         VARCHAR2(32 CHAR),
  EVT_STATUS           CHAR(1 CHAR),
  EVT_AUDIT            VARCHAR2(255 CHAR),
  SRC_CD               VARCHAR2(12 CHAR),
  SRC_NK               VARCHAR2(60 CHAR),
  CUR_EID              NUMBER(19),
  AUDIT_CREATION_TIME  TIMESTAMP(6)             DEFAULT CURRENT_TIMESTAMP     NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.CDI_AUDIT IS 'The key auditing table for CDI solution, this table associates user and system interactions with date and time values for audit trail management.';

COMMENT ON COLUMN __SCHEMA__.CDI_AUDIT.EVT_TIME IS 'The timestamp when the event type is invoked.';

COMMENT ON COLUMN __SCHEMA__.CDI_AUDIT.EVT_LOCATION IS 'Identify the source system requesting the event type.';

COMMENT ON COLUMN __SCHEMA__.CDI_AUDIT.EVT_AUDIT IS 'Audit information about the request and the response of the event type.';

COMMENT ON COLUMN __SCHEMA__.CDI_AUDIT.SRC_NK IS 'The identifier of the member in the source system when available in the request or the response of the event.  This column can be used as a search key for the audit records.
';

COMMENT ON COLUMN __SCHEMA__.CDI_AUDIT.CUR_EID IS 'The unique identifier of the Party when available in the request or the response of the event.  This column can be used as a search key for the audit records.
';

COMMENT ON COLUMN __SCHEMA__.CDI_AUDIT.AUDIT_CREATION_TIME IS 'The  creation time of the audit record.';


CREATE INDEX __SCHEMA__.AUDIT_TIME_INDEX ON __SCHEMA__.CDI_AUDIT
(AUDIT_CREATION_TIME)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.ENTITY_INDEX ON __SCHEMA__.CDI_AUDIT
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.MEM_INDEX ON __SCHEMA__.CDI_AUDIT
(SRC_NK, SRC_CD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_CDI_AUDIT ON __SCHEMA__.CDI_AUDIT
(CDI_AUDIT_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.CDI_AUDIT
 ADD CONSTRAINT PK_CDI_AUDIT
  PRIMARY KEY
  (CDI_AUDIT_ID)
  USING INDEX __SCHEMA__.PK_CDI_AUDIT;

CREATE TABLE __SCHEMA__.CDI_USER
(
  SRC_CD             VARCHAR2(12 CHAR)          NOT NULL,
  USER_ID            VARCHAR2(30 CHAR)          NOT NULL,
  EFF_START_DT       DATE,
  END_DT             DATE,
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.CDI_USER IS 'This table contains the list of users used in the CDI source systems to update their member data with the golden records.
';

COMMENT ON COLUMN __SCHEMA__.CDI_USER.USER_ID IS 'The userid in the source system.';

COMMENT ON COLUMN __SCHEMA__.CDI_USER.EFF_START_DT IS 'The date from which the user is used in the source system.';

COMMENT ON COLUMN __SCHEMA__.CDI_USER.END_DT IS 'The date after which the user is not used anymore.';

COMMENT ON COLUMN __SCHEMA__.CDI_USER.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';


CREATE UNIQUE INDEX __SCHEMA__.PK_IND_OCC ON __SCHEMA__.CDI_USER
(SRC_CD, USER_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.CDI_USER
 ADD CONSTRAINT PK_IND_OCC
  PRIMARY KEY
  (SRC_CD, USER_ID)
  USING INDEX __SCHEMA__.PK_IND_OCC;

CREATE TABLE __SCHEMA__.DR$PGR_ADDRESS_CTX$I
(
  TOKEN_TEXT   VARCHAR2(64 BYTE)                NOT NULL,
  TOKEN_TYPE   NUMBER(10)                       NOT NULL,
  TOKEN_FIRST  NUMBER(10)                       NOT NULL,
  TOKEN_LAST   NUMBER(10)                       NOT NULL,
  TOKEN_COUNT  NUMBER(10)                       NOT NULL,
  TOKEN_INFO   BLOB
)
LOB (TOKEN_INFO) STORE AS SECUREFILE (
  TABLESPACE  TSD_ODS
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  NOCACHE
  LOGGING)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX __SCHEMA__.DR$PGR_ADDRESS_CTX$X ON __SCHEMA__.DR$PGR_ADDRESS_CTX$I
(TOKEN_TEXT, TOKEN_TYPE, TOKEN_FIRST, TOKEN_LAST, TOKEN_COUNT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.DR$PGR_ADDRESS_CTX$K
(
  DOCID    NUMBER(38),
  TEXTKEY  ROWID, 
  CONSTRAINT SYS_IOT_TOP_442588
  PRIMARY KEY
  (TEXTKEY)
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOPARALLEL
NOMONITORING;

-- Index SYS_IOT_TOP_442588 is created automatically by Oracle with index organized table DR$PGR_ADDRESS_CTX$K.

CREATE TABLE __SCHEMA__.DR$PGR_ADDRESS_CTX$N
(
  NLT_DOCID  NUMBER(38),
  NLT_MARK   CHAR(1 BYTE)                       NOT NULL, 
  CONSTRAINT SYS_IOT_TOP_442594
  PRIMARY KEY
  (NLT_DOCID)
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOPARALLEL
NOMONITORING;

-- Index SYS_IOT_TOP_442594 is created automatically by Oracle with index organized table DR$PGR_ADDRESS_CTX$N.

CREATE TABLE __SCHEMA__.DR$PGR_ADDRESS_CTX$R
(
  ROW_NO  NUMBER(3),
  DATA    BLOB
)
LOB (DATA) STORE AS SECUREFILE (
  TABLESPACE  TSD_ODS
  DISABLE     STORAGE IN ROW
  CHUNK       8192
  CACHE
  LOGGING)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX __SCHEMA__.DRC$PGR_ADDRESS_CTX$R ON __SCHEMA__.DR$PGR_ADDRESS_CTX$R
(ROW_NO)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.DR$PGR_ADDRESS_CTX$R
 ADD CONSTRAINT DRC$PGR_ADDRESS_CTX$R
  PRIMARY KEY
  (ROW_NO)
  USING INDEX __SCHEMA__.DRC$PGR_ADDRESS_CTX$R;

CREATE TABLE __SCHEMA__.DR$PGR_INDIV_NAME_CTX$I
(
  TOKEN_TEXT   VARCHAR2(64 BYTE)                NOT NULL,
  TOKEN_TYPE   NUMBER(10)                       NOT NULL,
  TOKEN_FIRST  NUMBER(10)                       NOT NULL,
  TOKEN_LAST   NUMBER(10)                       NOT NULL,
  TOKEN_COUNT  NUMBER(10)                       NOT NULL,
  TOKEN_INFO   BLOB
)
LOB (TOKEN_INFO) STORE AS SECUREFILE (
  TABLESPACE  TSD_ODS
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  NOCACHE
  LOGGING)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX __SCHEMA__.DR$PGR_INDIV_NAME_CTX$X ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$I
(TOKEN_TEXT, TOKEN_TYPE, TOKEN_FIRST, TOKEN_LAST, TOKEN_COUNT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.DR$PGR_INDIV_NAME_CTX$K
(
  DOCID    NUMBER(38),
  TEXTKEY  ROWID, 
  CONSTRAINT SYS_IOT_TOP_442575
  PRIMARY KEY
  (TEXTKEY)
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOPARALLEL
NOMONITORING;

-- Index SYS_IOT_TOP_442575 is created automatically by Oracle with index organized table DR$PGR_INDIV_NAME_CTX$K.

CREATE TABLE __SCHEMA__.DR$PGR_INDIV_NAME_CTX$N
(
  NLT_DOCID  NUMBER(38),
  NLT_MARK   CHAR(1 BYTE)                       NOT NULL, 
  CONSTRAINT SYS_IOT_TOP_442581
  PRIMARY KEY
  (NLT_DOCID)
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOPARALLEL
NOMONITORING;

-- Index SYS_IOT_TOP_442581 is created automatically by Oracle with index organized table DR$PGR_INDIV_NAME_CTX$N.

CREATE TABLE __SCHEMA__.DR$PGR_INDIV_NAME_CTX$R
(
  ROW_NO  NUMBER(3),
  DATA    BLOB
)
LOB (DATA) STORE AS SECUREFILE (
  TABLESPACE  TSD_ODS
  DISABLE     STORAGE IN ROW
  CHUNK       8192
  CACHE
  LOGGING)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX __SCHEMA__.DRC$PGR_INDIV_NAME_CTX$R ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$R
(ROW_NO)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.DR$PGR_INDIV_NAME_CTX$R
 ADD CONSTRAINT DRC$PGR_INDIV_NAME_CTX$R
  PRIMARY KEY
  (ROW_NO)
  USING INDEX __SCHEMA__.DRC$PGR_INDIV_NAME_CTX$R;

CREATE TABLE __SCHEMA__.E_DISCLOSURE_CAT
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  CLEG_CD            VARCHAR2(10 CHAR)          NOT NULL,
  PRTY_DISC_CAT_VID  NUMBER(12)                 NOT NULL,
  ATT_CD             VARCHAR2(12 CHAR)          NOT NULL,
  ATT_STATUS         CHAR(1 CHAR)               NOT NULL,
  EVT_TIME           TIMESTAMP(6)               NOT NULL,
  EVT_USER_ID        VARCHAR2(30 CHAR),
  EVT_LOCATION       VARCHAR2(32 CHAR),
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)         NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.E_DISCLOSURE_CAT IS 'This table contains the disclosure consent of the BNGF clients. A consent must exist for each legal entity group a client is client of.';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.ATT_CD IS 'Fixed value:
IDISCLCAT for an Individual client
ODISCLCAT for an Organization client';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.EVT_TIME IS 'The event timestamp of the change in the source system.';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.EVT_USER_ID IS 'The userid of the user who did the change in the source system.';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.EVT_LOCATION IS 'Event location identifier (defined by external application). Identify the source system in which the event occured.';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.E_DISCLOSURE_CAT.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.DISC_CAT_EID_FK ON __SCHEMA__.E_DISCLOSURE_CAT
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_CEX_DISC_CAT ON __SCHEMA__.E_DISCLOSURE_CAT
(CUR_EID, CLEG_CD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.E_DISCLOSURE_CAT
 ADD CONSTRAINT PK_CEX_DISC_CAT
  PRIMARY KEY
  (CUR_EID, CLEG_CD)
  USING INDEX __SCHEMA__.PK_CEX_DISC_CAT;

CREATE TABLE __SCHEMA__.E_NBFG_CLIENT_SUM
(
  CUR_EID                         NUMBER(19)    NOT NULL,
  NB_CLT_LFCLS_TYPE_CD            VARCHAR2(10 CHAR),
  NB_END_CLT_DT                   DATE,
  PRV_BKG_1859_CLT_LFCLS_TYPE_CD  VARCHAR2(10 CHAR),
  FCC_CLT_FLG_CD                  VARCHAR2(10 CHAR),
  NBFG_CLT_LFCLS_TYPE_CD          VARCHAR2(10 CHAR),
  NBFG_EFFCTV_CLT_DT              DATE,
  NBFG_END_CLT_DT                 DATE,
  NBFG_DIST_CLT_LFCLS_TYPE_CD     VARCHAR2(10 CHAR),
  REC_LAST_UPD_TIME               TIMESTAMP(6)  DEFAULT SYSDATE               NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.E_NBFG_CLIENT_SUM.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.E_NBFG_CLIENT_SUM.NB_END_CLT_DT IS 'This is the date upon which the Party stops being a client of the National Bank.  This is the end date of the most recent National Bank client agreement, when all of his National Bank agreements are closed.';

COMMENT ON COLUMN __SCHEMA__.E_NBFG_CLIENT_SUM.NBFG_EFFCTV_CLT_DT IS 'The date upon which the party became a NBFG client.  This is the start date of the oldest NBFG client agreement.
';

COMMENT ON COLUMN __SCHEMA__.E_NBFG_CLIENT_SUM.NBFG_END_CLT_DT IS 'This is the date upon which the Party stops being a NBFG client.  All of the NBFG client agreements must be closed. This is the end date of the last NBFG client agreement that was closed.';

COMMENT ON COLUMN __SCHEMA__.E_NBFG_CLIENT_SUM.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record in this table.';


CREATE UNIQUE INDEX __SCHEMA__.PK_E_NBFG_CLIENT_SUM ON __SCHEMA__.E_NBFG_CLIENT_SUM
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.E_NBFG_CLIENT_SUM
 ADD CONSTRAINT PK_E_NBFG_CLIENT_SUM
  PRIMARY KEY
  (CUR_EID)
  USING INDEX __SCHEMA__.PK_E_NBFG_CLIENT_SUM;

CREATE TABLE __SCHEMA__.ENTITY
(
  CUR_EID                NUMBER(19)             NOT NULL,
  ENT_TYPE               VARCHAR2(12 CHAR),
  XML_DATA               SYS.XMLTYPE,
  XSD_VERSION            VARCHAR2(100 CHAR),
  GOLDEN_REC_HASH_CD     VARCHAR2(255 CHAR),
  LAST_EVT_TIME          TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  LAST_COMPARE_EVT_TIME  TIMESTAMP(6)           DEFAULT SYSDATE               NOT NULL,
  REC_LAST_UPD_TIME      TIMESTAMP(6)           DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY      VARCHAR2(100 CHAR)     NOT NULL
)
XMLTYPE XML_DATA STORE AS BASICFILE BINARY XML (
  TABLESPACE  TSD_ODS
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
ALLOW NONSCHEMA
DISALLOW ANYSCHEMA
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.ENTITY.XML_DATA IS 'The complete golden record content in binary XML format.The xsd of the golden record is based on a canonical data model.';

COMMENT ON COLUMN __SCHEMA__.ENTITY.XSD_VERSION IS 'The version of the XSD used for the XML stored in the XML data field. ';

COMMENT ON COLUMN __SCHEMA__.ENTITY.GOLDEN_REC_HASH_CD IS 'A hash code generated to represent the golden record data and to simplify the comparison with a new version of a golden record.';

COMMENT ON COLUMN __SCHEMA__.ENTITY.LAST_EVT_TIME IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.ENTITY.LAST_COMPARE_EVT_TIME IS 'The timestamp of the last compare event between a new golden record and this one.';

COMMENT ON COLUMN __SCHEMA__.ENTITY.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.ENTITY.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE UNIQUE INDEX __SCHEMA__.PK_ENTITY ON __SCHEMA__.ENTITY
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.ENTITY
 ADD CONSTRAINT PK_ENTITY
  PRIMARY KEY
  (CUR_EID)
  USING INDEX __SCHEMA__.PK_ENTITY;

CREATE TABLE __SCHEMA__.ENTITY_H
(
  CUR_EID                NUMBER(19)             NOT NULL,
  LAST_EVT_TIME          TIMESTAMP(6)           NOT NULL,
  ENT_TYPE               VARCHAR2(12 CHAR),
  XML_DATA               SYS.XMLTYPE,
  XSD_VERSION            VARCHAR2(10 CHAR),
  GOLDEN_REC_HASH_CD     VARCHAR2(255 CHAR),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TIME      TIMESTAMP(6)           DEFAULT SYSDATE               NOT NULL,
  EFF_END_TIME           TIMESTAMP(6),
  LAST_COMPARE_EVT_TIME  TIMESTAMP(6)           DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY      VARCHAR2(100 CHAR)     NOT NULL
)
XMLTYPE XML_DATA STORE AS BASICFILE BINARY XML (
  TABLESPACE  TSD_ODS
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  PCTVERSION  10
  NOCACHE
  NOLOGGING)
ALLOW NONSCHEMA
DISALLOW ANYSCHEMA
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            BUFFER_POOL      DEFAULT
           )
/*
		   PARTITION BY RANGE (EFF_END_TIME)
INTERVAL( NUMTODSINTERVAL(7,'DAY'))
(  
  PARTITION PFIRST VALUES LESS THAN (TIMESTAMP' 1900-01-01 00:00:00')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS

    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               )
)
*/
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.CUR_EID IS 'The unique identifier of the Party Type.
';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.LAST_EVT_TIME IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.ENT_TYPE IS 'id: Individual
hh: Household
og: Organization
pg: Party Group
';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.XSD_VERSION IS 'The version of the XSD used for the XML stored in the XML data field.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.GOLDEN_REC_HASH_CD IS 'A hash code generated to represent the golden record data and to simplify the comparison with a new version of a golden record.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.LAST_EVT_USER_ID IS 'The userid of the user who did the change in the source system.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.LAST_COMPARE_EVT_TIME IS 'The timestamp of the last compare event between a new golden record and this one.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_H.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE UNIQUE INDEX __SCHEMA__.PK_ENTITY_H ON __SCHEMA__.ENTITY_H
(CUR_EID, LAST_EVT_TIME)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.ENTITY_H
 ADD CONSTRAINT PK_ENTITY_H
  PRIMARY KEY
  (CUR_EID, LAST_EVT_TIME)
  USING INDEX __SCHEMA__.PK_ENTITY_H;

CREATE TABLE __SCHEMA__.ENTITY_H_IN1267055
(
  CUR_EID                NUMBER(19)             NOT NULL,
  LAST_EVT_TIME          TIMESTAMP(6)           NOT NULL,
  ENT_TYPE               VARCHAR2(12 CHAR),
  XML_DATA               SYS.XMLTYPE,
  XSD_VERSION            VARCHAR2(10 CHAR),
  GOLDEN_REC_HASH_CD     VARCHAR2(255 CHAR),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TIME      TIMESTAMP(6)           NOT NULL,
  EFF_END_TIME           TIMESTAMP(6),
  LAST_COMPARE_EVT_TIME  TIMESTAMP(6)           NOT NULL,
  MDM_DATA_CATEGORY      VARCHAR2(100 CHAR)     NOT NULL
)
XMLTYPE XML_DATA STORE AS SECUREFILE BINARY XML (
  TABLESPACE  TSD_ODS
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          104K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
ALLOW NONSCHEMA
DISALLOW ANYSCHEMA
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.ENTITY_IN1267055
(
  CUR_EID                NUMBER(19)             NOT NULL,
  ENT_TYPE               VARCHAR2(12 CHAR),
  XML_DATA               SYS.XMLTYPE,
  XSD_VERSION            VARCHAR2(100 CHAR),
  GOLDEN_REC_HASH_CD     VARCHAR2(255 CHAR),
  LAST_EVT_TIME          TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  LAST_COMPARE_EVT_TIME  TIMESTAMP(6)           NOT NULL,
  REC_LAST_UPD_TIME      TIMESTAMP(6)           NOT NULL,
  MDM_DATA_CATEGORY      VARCHAR2(100 CHAR)     NOT NULL
)
XMLTYPE XML_DATA STORE AS SECUREFILE BINARY XML (
  TABLESPACE  TSD_ODS
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          104K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
ALLOW NONSCHEMA
DISALLOW ANYSCHEMA
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.ENTITY_MEMBERS
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  SRC_CD             VARCHAR2(12 CHAR)          NOT NULL,
  SRC_NK             VARCHAR2(60 CHAR)          NOT NULL,
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.ENTITY_MEMBERS IS 'The mapping table between the enterprise IDs and the member IDs when the golden record is persisted. This table makes it efficient to get a persisted golden record by member id, a possible version of a getIndividualEntity.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS.CUR_EID IS 'The current enterprise id of the member.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS.SRC_CD IS 'The code that identifies the logical source of the member information.
PGFCC: A party group member from FCC
INDFCC: An individual member from FCC
INDOSS: An individual member from OSS
ORGFCC: An organization member from FCC
ORGOSS: An organization member from OSS
INFOCAN: An organization member from Info Canada';

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS.SRC_NK IS 'The identifier of the member in the source system.
FCC client number, OSS client number.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.ENT_MEM_INDEX ON __SCHEMA__.ENTITY_MEMBERS
(SRC_CD, SRC_NK)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_ENTITY_MEMBERS ON __SCHEMA__.ENTITY_MEMBERS
(CUR_EID, SRC_CD, SRC_NK)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.ENTITY_MEMBERS
 ADD CONSTRAINT PK_ENTITY_MEMBERS
  PRIMARY KEY
  (CUR_EID, SRC_CD, SRC_NK)
  USING INDEX __SCHEMA__.PK_ENTITY_MEMBERS;

CREATE TABLE __SCHEMA__.ENTITY_MEMBERS_IN1267055
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  SRC_CD             VARCHAR2(12 CHAR)          NOT NULL,
  SRC_NK             VARCHAR2(60 CHAR)          NOT NULL,
  REC_LAST_UPD_TIME  TIMESTAMP(6)               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)         NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.ENTITY_MEMBERS_NON_CDI
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  SRC_CD             VARCHAR2(12 CHAR)          NOT NULL,
  SRC_NK             VARCHAR2(60 CHAR)          NOT NULL,
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS_NON_CDI.CUR_EID IS 'The current enterprise id of the member.';

COMMENT ON COLUMN __SCHEMA__.ENTITY_MEMBERS_NON_CDI.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';


CREATE UNIQUE INDEX __SCHEMA__.PK_ENTITY_MEMBERS_NON_CDI ON __SCHEMA__.ENTITY_MEMBERS_NON_CDI
(CUR_EID, SRC_CD, SRC_NK)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.ENTITY_MEMBERS_NON_CDI
 ADD CONSTRAINT PK_ENTITY_MEMBERS_NON_CDI
  PRIMARY KEY
  (CUR_EID, SRC_CD, SRC_NK)
  USING INDEX __SCHEMA__.PK_ENTITY_MEMBERS_NON_CDI;

CREATE TABLE __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH
(
  CUR_EID  NUMBER(19)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX __SCHEMA__.PK_CLIENT_LFCLS_TO_PUBLISH ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH
 ADD CONSTRAINT PK_CLIENT_LFCLS_TO_PUBLISH
  PRIMARY KEY
  (CUR_EID)
  USING INDEX __SCHEMA__.PK_CLIENT_LFCLS_TO_PUBLISH;

CREATE TABLE __SCHEMA__.MDM_LFCLL_CLIENT_LIST
(
  LFCLL_SRC_CD_EIN  VARCHAR2(10 CHAR),
  LFCLL_SRC_NK      VARCHAR2(60 CHAR),
  LFCLL_SRC_CD_MDM  VARCHAR2(12 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX __SCHEMA__.PK_LFCLL_CLIENT_LIST ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST
(LFCLL_SRC_CD_EIN, LFCLL_SRC_NK)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.MDM_LFCLL_CLIENT_LIST
 ADD CONSTRAINT PK_LFCLL_CLIENT_LIST
  PRIMARY KEY
  (LFCLL_SRC_CD_EIN, LFCLL_SRC_NK)
  USING INDEX __SCHEMA__.PK_LFCLL_CLIENT_LIST;

CREATE TABLE __SCHEMA__.MDM_SEARCHCL_CRITERIA
(
  CRITERIA_ID    NUMBER                         NOT NULL,
  CRITERIA_NAME  VARCHAR2(25 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX __SCHEMA__.PK_MDM_SEARCHCL_CRITERIA ON __SCHEMA__.MDM_SEARCHCL_CRITERIA
(CRITERIA_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.MDM_SEARCHCL_CRITERIA
 ADD CONSTRAINT PK_MDM_SEARCHCL_CRITERIA
  PRIMARY KEY
  (CRITERIA_ID)
  USING INDEX __SCHEMA__.PK_MDM_SEARCHCL_CRITERIA;

CREATE TABLE __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO
(
  CRITERIA_ID          NUMBER                   NOT NULL,
  INFO_COLUMN_INDEX    VARCHAR2(30 CHAR),
  INFO_COLUMN_NAME     VARCHAR2(30 CHAR),
  INFO_TABLE_NAME      VARCHAR2(30 CHAR),
  INFO_FUZZY_SEARCH    NUMBER,
  INFO_JOIN_TYPE       VARCHAR2(200 CHAR),
  CLEAN_SPECIAL_CHARS  NUMBER,
  INFO_PRIORITY        NUMBER,
  INFO_SUB_QUERY       VARCHAR2(500 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX __SCHEMA__.PK_MDM_SEARCHCL_CRITERIA_INFO ON __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO
(CRITERIA_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO
 ADD CONSTRAINT PK_MDM_SEARCHCL_CRITERIA_INFO
  PRIMARY KEY
  (CRITERIA_ID)
  USING INDEX __SCHEMA__.PK_MDM_SEARCHCL_CRITERIA_INFO;

CREATE TABLE __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER
(
  CRITERIA_ID        NUMBER                     NOT NULL,
  PATTERN_ID         NUMBER,
  MODIFIER_FUNCTION  VARCHAR2(100 CHAR)         DEFAULT 'x'                   NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER.MODIFIER_FUNCTION IS 'Mathematical function to apply to the score obtained for this criterion / pattern : Column = x (Default) means f(x) = x. Column = x * 1 + 5 means f(x) = x * 1 + 5';


CREATE UNIQUE INDEX __SCHEMA__.PK_MDM_SEARCH_WEIGHT_MODIFIER ON __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER
(CRITERIA_ID, PATTERN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER
 ADD CONSTRAINT PK_MDM_SEARCH_WEIGHT_MODIFIER
  PRIMARY KEY
  (CRITERIA_ID, PATTERN_ID)
  USING INDEX __SCHEMA__.PK_MDM_SEARCH_WEIGHT_MODIFIER;

CREATE TABLE __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID
(
  LFCLL_SRC_CD_EIN  VARCHAR2(10 CHAR)           NOT NULL,
  LFCLL_SRC_NK      VARCHAR2(60 CHAR)           NOT NULL,
  CUR_EID           NUMBER(19)                  NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN
(
  CUR_EID        NUMBER(19)                     NOT NULL,
  SRC_NK         VARCHAR2(60 CHAR)              NOT NULL,
  SRC_CD         VARCHAR2(10 CHAR)              NOT NULL,
  TYPEENTENTE    VARCHAR2(12 CHAR)              NOT NULL,
  EFF_DT         VARCHAR2(19 BYTE),
  END_DT         VARCHAR2(19 BYTE),
  SYSTEMESOURCE  VARCHAR2(10 CHAR)              NOT NULL,
  PRAG_ID        VARCHAR2(70 CHAR)              NOT NULL,
  OGUN_ID        VARCHAR2(70 BYTE)              NOT NULL,
  PAOU_TYPE_CD   VARCHAR2(10 CHAR)              NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.PGR_ADDRESS
(
  CUR_EID                     NUMBER(19)        NOT NULL,
  MEM_ADDR_NK                 VARCHAR2(60 CHAR),
  ADDR_NK                     VARCHAR2(60 CHAR),
  PRTY_ADDR_TYPE_VCD          VARCHAR2(100 CHAR),
  PRTY_ADDR_TYPE_VID          NUMBER(12),
  EFF_DT                      DATE,
  END_DT                      DATE,
  PRTY_WRONG_ADDR_FLG_VCD     VARCHAR2(100 CHAR),
  PRTY_WRONG_ADDR_FLG_VID     NUMBER(12),
  ORG_NM                      VARCHAR2(100 CHAR),
  ORG_DEPT                    VARCHAR2(100 CHAR),
  CONTACT_COMPLETE            VARCHAR2(100 CHAR),
  BLDG_COMPLETE               VARCHAR2(100 CHAR),
  BLDG_DESC                   VARCHAR2(10 CHAR),
  BLDG_NO                     VARCHAR2(30 CHAR),
  BLDG_NM                     VARCHAR2(100 CHAR),
  SUB_BLDG_COMPLETE           VARCHAR2(100 CHAR),
  SUB_BLDG_DESC               VARCHAR2(100 CHAR),
  SUB_BLDG_NO                 VARCHAR2(100 CHAR),
  ST_COMPLETE                 VARCHAR2(100 CHAR),
  ST_NM                       VARCHAR2(100 CHAR),
  ST_POST_DESC                VARCHAR2(25 CHAR),
  ST_PRE_DIRECTIONAL          VARCHAR2(10 CHAR),
  ST_POST_DIRECTIONAL         VARCHAR2(25 CHAR),
  ST_PRE_DESC                 VARCHAR2(10 CHAR),
  NO_COMPLETE                 VARCHAR2(50 CHAR),
  DLV_SVC_ADDR_INFO           VARCHAR2(100 CHAR),
  DLV_SVC_COMPLETE            VARCHAR2(100 CHAR),
  DLV_SVC_DESC                VARCHAR2(100 CHAR),
  DLV_SVC_NO                  VARCHAR2(100 CHAR),
  LOCALITY_COMPLETE           VARCHAR2(100 CHAR),
  LOCALITY_SORTING_CD         VARCHAR2(50 CHAR),
  POSTAL_CD_UNFORMATTED       VARCHAR2(50 CHAR),
  PROV_ABBRV                  VARCHAR2(100 CHAR),
  PROV_EXTENDED               VARCHAR2(100 CHAR),
  PROV_CNTRY_STD              VARCHAR2(20 CHAR),
  CNTRY_NM                    VARCHAR2(100 CHAR),
  CNTRY_ISO2                  VARCHAR2(100 CHAR),
  CNTRY_ISO3                  VARCHAR2(100 CHAR),
  RESIDUE_SUPERFLUOUS         VARCHAR2(255 CHAR),
  RESIDUE_UNRECOGNIZED        VARCHAR2(255 CHAR),
  ADDR_COMPLETE               VARCHAR2(255 CHAR),
  FORMATTED_ADDR_LINE_1       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_2       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_3       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_4       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_5       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_6       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_7       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_8       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_9       VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_10      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_11      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_12      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_13      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_14      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_15      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_16      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_17      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_18      VARCHAR2(100 CHAR),
  FORMATTED_ADDR_LINE_19      VARCHAR2(100 CHAR),
  DLV_ADDR_LINE_1             VARCHAR2(100 CHAR),
  DLV_ADDR_LINE_2             VARCHAR2(100 CHAR),
  DLV_ADDR_LINE_3             VARCHAR2(100 CHAR),
  DLV_ADDR_LINE_4             VARCHAR2(100 CHAR),
  DLV_ADDR_LINE_5             VARCHAR2(100 CHAR),
  DLV_ADDR_LINE_6             VARCHAR2(100 CHAR),
  RECIPIENT_LINE_1            VARCHAR2(100 CHAR),
  RECIPIENT_LINE_2            VARCHAR2(100 CHAR),
  RECIPIENT_LINE_3            VARCHAR2(100 CHAR),
  RECIPIENT_LINE_4            VARCHAR2(100 CHAR),
  RECIPIENT_LINE_5            VARCHAR2(100 CHAR),
  RECIPIENT_LINE_6            VARCHAR2(100 CHAR),
  CNTRY_SPEC_LOCALITY_LINE_1  VARCHAR2(100 CHAR),
  CNTRY_SPEC_LOCALITY_LINE_2  VARCHAR2(100 CHAR),
  CNTRY_SPEC_LOCALITY_LINE_3  VARCHAR2(100 CHAR),
  CNTRY_SPEC_LOCALITY_LINE_4  VARCHAR2(100 CHAR),
  CNTRY_SPEC_LOCALITY_LINE_5  VARCHAR2(100 CHAR),
  CNTRY_SPEC_LOCALITY_LINE_6  VARCHAR2(100 CHAR),
  MAILABILITY_SCORE_VCD       VARCHAR2(100 CHAR),
  MAILABILITY_SCORE_VID       NUMBER(12),
  RESULT_NUM                  VARCHAR2(10 CHAR),
  RESULT_PERCENTAGE           NUMBER(8,5),
  HOLD_MAIL_TYPE_VCD          VARCHAR2(100 CHAR),
  HOLD_MAIL_TYPE_VID          NUMBER(12),
  PROCESS_STATUS_VCD          VARCHAR2(100 CHAR),
  PROCESS_STATUS_VID          NUMBER(12),
  COMPLETE_TELPH_NUM          VARCHAR2(50 CHAR),
  REC_LAST_UPD_TIME           TIMESTAMP(6)      DEFAULT SYSDATE               NOT NULL,
  POSTAL_CD_REPORT            VARCHAR2(50 CHAR),
  MDM_DATA_CATEGORY           VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.EFF_DT IS 'The date this address becomes effective for the member.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.END_DT IS 'The date this is not an address anymore for the member.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.ORG_NM IS 'Company or Organization name including a
company type descriptor such as Inc., AG,
or GmbH.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CONTACT_COMPLETE IS 'My addition to the international address format.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.BLDG_COMPLETE IS 'Building name. Frequently used in the United Kingdom.
';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.SUB_BLDG_COMPLETE IS 'Information that further subdivides a
Building, e.g. the floor, the suite and/or apartment number: Suite 4400, # 145, App 805, Bureau 200.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.SUB_BLDG_DESC IS 'Information that further subdivides a
Building, e.g. the floor, the suite and/or apartment
number.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.SUB_BLDG_NO IS 'The number in the sub building information.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_SVC_DESC IS 'Code of the respective post office in charge
of delivery: PO Box, Stn Main, RR, Po, Ss, Succ Bureau-Chef, Bdp.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_SVC_NO IS 'Post Box descriptor (POBox, Postfach, Case
Postale etc.) and number.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.LOCALITY_SORTING_CD IS 'Speeds up delivery in certain countries for
large localities, like for example Prague or
Dublin.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.PROV_CNTRY_STD IS 'Store the state, province, canton,
prefecture or other sub-division of a
country.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_NM IS 'Optionally needed if required for display. It
is recommended to just store the ISO code
so that the country name can be displayed
in any language.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_ISO2 IS 'ISO alpha2 code according to ISO 3166.
Can be used to generate the name of a
country in any language.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.ADDR_COMPLETE IS 'The complete address as one string, lines are separated by delimiters';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_ADDR_LINE_1 IS 'Building, SubBuilding, Street, House Number';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_ADDR_LINE_2 IS 'Building, SubBuilding, Street, House Number';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_ADDR_LINE_3 IS 'Building, SubBuilding, Street, House Number';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_ADDR_LINE_4 IS 'Building, SubBuilding, Street, House Number';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_ADDR_LINE_5 IS 'Building, SubBuilding, Street, House Number';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.DLV_ADDR_LINE_6 IS 'Building, SubBuilding, Street, House Number';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RECIPIENT_LINE_1 IS 'Organization, Department, Contact';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RECIPIENT_LINE_2 IS 'Organization, Department, Contact';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RECIPIENT_LINE_3 IS 'Organization, Department, Contact';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RECIPIENT_LINE_4 IS 'Organization, Department, Contact';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RECIPIENT_LINE_5 IS 'Organization, Department, Contact';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RECIPIENT_LINE_6 IS 'Organization, Department, Contact';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_SPEC_LOCALITY_LINE_1 IS 'Locality (Cities)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_SPEC_LOCALITY_LINE_2 IS 'Locality (Cities)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_SPEC_LOCALITY_LINE_3 IS 'Locality (Cities)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_SPEC_LOCALITY_LINE_4 IS 'Locality (Cities)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_SPEC_LOCALITY_LINE_5 IS 'Locality (Cities)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.CNTRY_SPEC_LOCALITY_LINE_6 IS 'Locality (Cities)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.MAILABILITY_SCORE_VCD IS 'The mailability score (0..5) value code.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.MAILABILITY_SCORE_VID IS 'The mailability score (0..5) value id.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RESULT_NUM IS 'The number of the result (1..20)';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.RESULT_PERCENTAGE IS 'The percentage of the result';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.HOLD_MAIL_TYPE_VCD IS 'The Hold Mail Type Value code.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.HOLD_MAIL_TYPE_VID IS 'Unique identifier of the Hold Mail Type Value.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.PROCESS_STATUS_VCD IS 'The Process Status Value code.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.PROCESS_STATUS_VID IS 'Unique identifier of the Process Status Value.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_ADDRESS.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.IDX_PGR_ADDR_ADDR_TYPE_VCD ON __SCHEMA__.PGR_ADDRESS
(PRTY_ADDR_TYPE_VCD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_ADDR_CNTRY_ISO2 ON __SCHEMA__.PGR_ADDRESS
(CNTRY_ISO2)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_ADDR_NO_COMPLETE ON __SCHEMA__.PGR_ADDRESS
(NO_COMPLETE)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_ADDR_POSTAL_CD ON __SCHEMA__.PGR_ADDRESS
(POSTAL_CD_REPORT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_ADDR_PROV_CNTRY_STD ON __SCHEMA__.PGR_ADDRESS
(PROV_CNTRY_STD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.PGR_ADDR_ENTITY_FK ON __SCHEMA__.PGR_ADDRESS
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_CLIENT
(
  CUR_EID                       NUMBER(19)      NOT NULL,
  CLT_RLTNP_VALUATION_TYPE_VCD  VARCHAR2(100 CHAR),
  CLT_RLTNP_VALUATION_TYPE_VID  NUMBER(12),
  NRA_TAXATION_POOL_VCD         VARCHAR2(100 CHAR),
  NRA_TAXATION_POOL_VID         NUMBER(12),
  CDN_NON_RESID_TYP_VCD         VARCHAR2(100 CHAR),
  CDN_NON_RESID_TYP_VID         NUMBER(12),
  MAIN_AGMT_PURPOSE_TYP_VCD     VARCHAR2(100 CHAR),
  MAIN_AGMT_PURPOSE_TYP_VID     NUMBER(12),
  EFF_CLT_DT                    DATE,
  REC_LAST_UPD_TIME             TIMESTAMP(6)    DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY             VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.PGR_CLIENT IS 'A Client is a role played by an Party that is considered to be receiving services or products from the Financial Institution or one of its Organization Units, or who is a potential recipient of such services or products.
';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT.EFF_CLT_DT IS 'The date upon which the Party became a Customer of the Financial  Institution.
';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_CLT_ENTITY_FK ON __SCHEMA__.PGR_CLIENT
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  LFCLS_DMN_CD       VARCHAR2(100 CHAR),
  LFCLS_TYPE_CD      VARCHAR2(100 CHAR),
  LFCLS_EFF_DT       DATE,
  LFCLS_END_DT       DATE,
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)         NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS IS 'Client Life Cycle Status classifies a Client according to the life cycle states through which it may pass over time.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS.LFCLS_EFF_DT IS 'The effective date of the party life cycle status type.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS.LFCLS_END_DT IS 'The end date of the party life cycle status type.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_CLT_LFCLS_ENTITY_FK ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_CLIENT_SPECIFIC_COND
(
  CUR_EID             NUMBER(19)                NOT NULL,
  CLIENT_SPE_COND_NK  VARCHAR2(60 CHAR),
  LINES_CONTENT       VARCHAR2(255 CHAR),
  REC_LAST_UPD_TIME   TIMESTAMP(6)              DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY   VARCHAR2(100 CHAR)        NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.PGR_CLIENT_SPECIFIC_COND IS 'This is free text describing special conditions that are applicable to a client.  From FCC, we only have one set of specific conditions.  When we will add other sources, we may have other sets of specific conditions. We should survive all the specific conditions that are applicable to a client.  Since a client can have potentially multiple specific conditions, this information is stored in the CDI extension.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_SPECIFIC_COND.LINES_CONTENT IS 'Free text description of the client specific conditions.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_SPECIFIC_COND.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_CLIENT_SPECIFIC_COND.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_CLT_SPEC_CONDITIONS_ENTITY ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_DELTA_CONTROL
(
  CUR_EID             NUMBER(19)                NOT NULL,
  GOLDEN_REC_HASH_CD  VARCHAR2(255 CHAR)        NOT NULL,
  STATUS_CD           CHAR(1 CHAR)              NOT NULL,
  REC_LAST_UPD_TIME   TIMESTAMP(6)              NOT NULL,
  MDM_DATA_CATEGORY   VARCHAR2(100 CHAR)        NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.PGR_DELTA_CONTROL IS 'Staging table used to generate delta transformations of the Golden Record from XML format into the relational model';

COMMENT ON COLUMN __SCHEMA__.PGR_DELTA_CONTROL.CUR_EID IS 'The unique identifier of the Entity';

COMMENT ON COLUMN __SCHEMA__.PGR_DELTA_CONTROL.GOLDEN_REC_HASH_CD IS 'A hash code generated to represent the golden record data and to simplify the comparison with a new version of a golden record.';

COMMENT ON COLUMN __SCHEMA__.PGR_DELTA_CONTROL.STATUS_CD IS 'A status code of the update required (I)nsert, (U)pdate, (D)elete, (S)ynchronized';

COMMENT ON COLUMN __SCHEMA__.PGR_DELTA_CONTROL.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.PGR_DELTA_CONTROL.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE UNIQUE INDEX __SCHEMA__.PK_PGR_DELTA_CONTROL ON __SCHEMA__.PGR_DELTA_CONTROL
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.PGR_DELTA_CONTROL
 ADD CONSTRAINT PK_PGR_DELTA_CONTROL
  PRIMARY KEY
  (CUR_EID)
  USING INDEX __SCHEMA__.PK_PGR_DELTA_CONTROL;

CREATE TABLE __SCHEMA__.PGR_INDIVIDUAL
(
  CUR_EID                         NUMBER(19)    NOT NULL,
  CLT_LIFE_CYCLE_STATUS_TYP_VCD   VARCHAR2(100 CHAR),
  CLT_LIFE_CYCLE_STATUS_TYP_VID   NUMBER(12),
  CLT_MARKET_SEG_VCD              VARCHAR2(100 CHAR),
  CLT_MARKET_SEG_VID              NUMBER(12),
  CLT_PROFITABILITY_SEG_VCD       VARCHAR2(100 CHAR),
  CLT_PROFITABILITY_SEG_VID       NUMBER(12),
  CONTINUITY_OF_ADDR_SEG_VCD      VARCHAR2(100 CHAR),
  CONTINUITY_OF_ADDR_SEG_VID      NUMBER(12),
  CNTRL_GRP_IND_VCD               VARCHAR2(100 CHAR),
  CNTRL_GRP_IND_VID               NUMBER(12),
  DEP_ACCT_LOB_VCD                VARCHAR2(100 CHAR),
  DEP_ACCT_LOB_VID                NUMBER(12),
  ESTATE_SETTLEMENT_VCD           VARCHAR2(100 CHAR),
  ESTATE_SETTLEMENT_VID           NUMBER(12),
  GENDER_VCD                      VARCHAR2(100 CHAR),
  GENDER_VID                      NUMBER(12),
  HRSDC_NAT_OCCUPATION_CLASS_VCD  VARCHAR2(100 CHAR),
  HRSDC_NAT_OCCUPATION_CLASS_VID  NUMBER(12),
  INCOME_LEVEL_VCD                VARCHAR2(100 CHAR),
  INCOME_LEVEL_VID                NUMBER(12),
  INDV_AGE_GRP_VCD                VARCHAR2(100 CHAR),
  INDV_AGE_GRP_VID                NUMBER(12),
  INDV_EMPL_STATUS_TYP_VCD        VARCHAR2(100 CHAR),
  INDV_EMPL_STATUS_TYP_VID        NUMBER(12),
  INDV_EMPLTM_COMMITMENT_VCD      VARCHAR2(100 CHAR),
  INDV_EMPLTM_COMMITMENT_VID      NUMBER(12),
  INDV_MARITAL_STATUS_TYP_VCD     VARCHAR2(100 CHAR),
  INDV_MARITAL_STATUS_TYP_VID     NUMBER(12),
  INDV_OCCUPATION_TYP_VCD         VARCHAR2(100 CHAR),
  INDV_OCCUPATION_TYP_VID         NUMBER(12),
  INDV_PURSUIT_TYP_VCD            VARCHAR2(100 CHAR),
  INDV_PURSUIT_TYP_VID            NUMBER(12),
  INSIDER_IND_VCD                 VARCHAR2(100 CHAR),
  INSIDER_IND_VID                 NUMBER(12),
  IRS_EXEMPTION_VCD               VARCHAR2(100 CHAR),
  IRS_EXEMPTION_VID               NUMBER(12),
  LOGICAL_SRC_CAT_VCD             VARCHAR2(100 CHAR),
  LOGICAL_SRC_CAT_VID             NUMBER(12),
  MATRIMONIAL_UNION_REGIME_VCD    VARCHAR2(100 CHAR),
  MATRIMONIAL_UNION_REGIME_VID    NUMBER(12),
  MOTHER_TONGUE_VCD               VARCHAR2(100 CHAR),
  MOTHER_TONGUE_VID               NUMBER(12),
  NBFG_EMPLOYEE_FLG_VCD           VARCHAR2(100 CHAR),
  NBFG_EMPLOYEE_FLG_VID           NUMBER(12),
  NBFG_EMPLOYER_LEGAL_ENTITY_VCD  VARCHAR2(100 CHAR),
  NBFG_EMPLOYER_LEGAL_ENTITY_VID  NUMBER(12),
  NET_WORTH_LEVEL_VCD             VARCHAR2(100 CHAR),
  NET_WORTH_LEVEL_VID             NUMBER(12),
  OWNER_RENTER_TYP_VCD            VARCHAR2(100 CHAR),
  OWNER_RENTER_TYP_VID            NUMBER(12),
  PRTY_FIN_LEGAL_STATUS_VCD       VARCHAR2(100 CHAR),
  PRTY_FIN_LEGAL_STATUS_VID       NUMBER(12),
  PRTY_TYP_VCD                    VARCHAR2(100 CHAR),
  PRTY_TYP_VID                    NUMBER(12),
  PERSONAL_INFO_IRS_IND_VCD       VARCHAR2(100 CHAR),
  PERSONAL_INFO_IRS_IND_VID       NUMBER(12),
  BNC_CLT_RLTNP_OFFICER_USER_ID   VARCHAR2(100 CHAR),
  GE_CAP_LSNG_CLTRLTNP_OFF_USRID  VARCHAR2(100 CHAR),
  MEMBER_STATUS                   VARCHAR2(100 CHAR),
  TRUST_CLT_RLTNP_OFFICER_USERID  VARCHAR2(100 CHAR),
  INDV_BIRTH_DT                   DATE,
  EFFCTV_CUST_DT                  DATE,
  INDV_DEATH_DT                   DATE,
  INDV_FISCAL_YEAR_END_DT         VARCHAR2(19 CHAR),
  LAST_CRED_BUREAU_INQ_DT         DATE,
  NEXT_FIN_STATEMENT_DT           DATE,
  PRTY_EFFECTIVE_DT               DATE,
  PREF_CONTACT_LANG_VCD           VARCHAR2(100 CHAR),
  PREF_CONTACT_LANG_VID           NUMBER(12),
  INDV_SMOKING_HABIT_TYP_VCD      VARCHAR2(100 CHAR),
  INDV_SMOKING_HABIT_TYP_VID      NUMBER(12),
  NON_PERMANENT_RESIDENT_VCD      VARCHAR2(100 CHAR),
  NON_PERMANENT_RESIDENT_VID      NUMBER(12),
  ACT_SECTOR_TYP_VCD              VARCHAR2(100 CHAR),
  ACT_SECTOR_TYP_VID              NUMBER(12),
  CDI_LOGICAL_SRC_SYSTEM_VCD      VARCHAR2(100 CHAR),
  CDI_LOGICAL_SRC_SYSTEM_VID      NUMBER(12),
  DOUBTFUL_CAUTION_FLG_VCD        VARCHAR2(100 CHAR),
  DOUBTFUL_CAUTION_FLG_VID        NUMBER(12),
  FAKE_PROFILE_FLG_VCD            VARCHAR2(100 CHAR),
  FAKE_PROFILE_FLG_VID            NUMBER(12),
  INDV_LIFE_CYCLE_STATUS_TYP_VCD  VARCHAR2(100 CHAR),
  INDV_LIFE_CYCLE_STATUS_TYP_VID  NUMBER(12),
  NO_OF_DEPENDENTS                NUMBER(5),
  REC_LAST_UPD_TIME               TIMESTAMP(6)  DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY               VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.CLT_MARKET_SEG_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.CLT_PROFITABILITY_SEG_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.CONTINUITY_OF_ADDR_SEG_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.CNTRL_GRP_IND_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.DEP_ACCT_LOB_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.ESTATE_SETTLEMENT_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.GENDER_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.HRSDC_NAT_OCCUPATION_CLASS_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INCOME_LEVEL_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_AGE_GRP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_EMPL_STATUS_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_EMPLTM_COMMITMENT_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_MARITAL_STATUS_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_OCCUPATION_TYP_VCD IS '***Michelle Leclair 8 Fev 2012 ***
This attribute is obsolete, it is replaced by "Individual employment agreement"."Employment position type code"
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_PURSUIT_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INSIDER_IND_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.IRS_EXEMPTION_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.LOGICAL_SRC_CAT_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.MATRIMONIAL_UNION_REGIME_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.MOTHER_TONGUE_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.NBFG_EMPLOYEE_FLG_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.NBFG_EMPLOYER_LEGAL_ENTITY_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.NET_WORTH_LEVEL_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.OWNER_RENTER_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.PRTY_FIN_LEGAL_STATUS_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.PRTY_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.PERSONAL_INFO_IRS_IND_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.BNC_CLT_RLTNP_OFFICER_USER_ID IS 'The value of the attribute.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.GE_CAP_LSNG_CLTRLTNP_OFF_USRID IS 'The value of the attribute.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.MEMBER_STATUS IS 'The value of the attribute.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.TRUST_CLT_RLTNP_OFFICER_USERID IS 'The value of the attribute.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.EFFCTV_CUST_DT IS 'The date value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.INDV_FISCAL_YEAR_END_DT IS 'The date value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.LAST_CRED_BUREAU_INQ_DT IS 'The date value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.NEXT_FIN_STATEMENT_DT IS 'The date value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.PRTY_EFFECTIVE_DT IS 'The date value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.PREF_CONTACT_LANG_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.DOUBTFUL_CAUTION_FLG_VCD IS 'The Value Code is a ''meaningful'' mnemonic code for a value of the value domain.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.IDX_PGR_INDIV_BIRTH_DT ON __SCHEMA__.PGR_INDIVIDUAL
(INDV_BIRTH_DT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.PGR_INDV_ENTITY_FK ON __SCHEMA__.PGR_INDIVIDUAL
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_INDIVIDUAL_IDENT
(
  CUR_EID                         NUMBER(19)    NOT NULL,
  MEMBER_IDENT_NK                 VARCHAR2(60 CHAR),
  INDV_IDENT_TYPE_CD              VARCHAR2(100 CHAR),
  INITIATED_DT                    DATE,
  ID_METHOD_VCD                   VARCHAR2(100 CHAR),
  ID_METHOD_VID                   NUMBER(12),
  CHECKED_BY_LOB_VCD              VARCHAR2(100 CHAR),
  CHECKED_BY_LOB_VID              NUMBER(12),
  CHECKED_BY_EMP_NO               VARCHAR2(50 CHAR),
  CHECKED_BY_DIST_NO              VARCHAR2(50 CHAR),
  CHECKED_BY_DIST_OFFICE_NO       VARCHAR2(50 CHAR),
  PRTY_ID_LFCL_STS_TYP_VCD        VARCHAR2(100 CHAR),
  PRTY_ID_LFCL_STS_TYP_VID        NUMBER(12),
  CRED_BUREAU_VCD                 VARCHAR2(100 CHAR),
  CRED_BUREAU_VID                 NUMBER(12),
  CRED_BUREAU_DESC                VARCHAR2(100 CHAR),
  CRED_BUREAU_RISK_RATING_DT      DATE,
  ID_PRDT_VCD                     VARCHAR2(100 CHAR),
  ID_PRDT_VID                     NUMBER(12),
  IDENT_PRODUCT_DESC              VARCHAR2(100 CHAR),
  ID_PRDT_REQUEST_REF_NO          VARCHAR2(50 CHAR),
  ID_PRDT_REQUEST_RETURNED_DT     DATE,
  DEP_ACCNT_DT_CONFIRMED          DATE,
  DEP_ACCNT_FIN_INST_NO           VARCHAR2(10 CHAR),
  DEP_ACCNT_BRANCH                VARCHAR2(10 CHAR),
  DEP_ACCNT_NO                    VARCHAR2(50 CHAR),
  OFFCHK_DACCNT_FIN_INST_NO       VARCHAR2(10 CHAR),
  OFFCHK_DACCNT_BRANCH_NO         VARCHAR2(10 CHAR),
  OFFCHK_DACCNT_NO                VARCHAR2(50 CHAR),
  OFFCHK_CACCNT_FIN_INST_NO       VARCHAR2(10 CHAR),
  OFFCHK_CACCNT_BRANCH_NO         VARCHAR2(10 CHAR),
  OFFCHK_CACCNT_NO                VARCHAR2(50 CHAR),
  OFFCHK_DEPOSIT_DT               DATE,
  OFFCHK_AMOUNT                   NUMBER(15,4),
  ID_ITM_DOC_NO                   VARCHAR2(50 CHAR),
  ID_ITM_DOC_TYPE_VCD             VARCHAR2(100 CHAR),
  ID_ITM_DOC_TYPE_VID             NUMBER(12),
  ID_ITM_DOC_DESC                 VARCHAR2(100 CHAR),
  ID_ITM_DOC_EXPIRATION_DT        DATE,
  ID_ITM_DOC_ISSUE_DT             DATE,
  ID_ITM_ISSNG_GEO_AREA_TYPE_VCD  VARCHAR2(100 CHAR),
  ID_ITM_ISSNG_GEO_AREA_TYPE_VID  NUMBER(12),
  ID_ITM_ISSNG_GEO_AREA_VCD       VARCHAR2(100 CHAR),
  ID_ITM_ISSNG_GEO_AREA_VID       NUMBER(12),
  ID_ITM_NOTE                     VARCHAR2(100 CHAR),
  REC_LAST_UPD_TIME               TIMESTAMP(6)  DEFAULT SYSDATE               NOT NULL,
  ID_ITM_DOC_NO_REPORT            VARCHAR2(50 CHAR),
  MDM_DATA_CATEGORY               VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_METHOD_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.CHECKED_BY_LOB_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.PRTY_ID_LFCL_STS_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.CRED_BUREAU_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.CRED_BUREAU_DESC IS 'Used when we just have the name of the credit bureau, and no domain value.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_PRDT_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.IDENT_PRODUCT_DESC IS 'Used when we just have the name of the identification product used.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_PRDT_REQUEST_REF_NO IS 'The reference number for the identification request.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_PRDT_REQUEST_RETURNED_DT IS 'The date the identification request is returned.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.DEP_ACCNT_DT_CONFIRMED IS 'Date the existence of the account is confirmed.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_NO IS 'The number which uniquely identifies the Party identification document.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_TYPE_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_DESC IS 'Used when we just have the name of the identification item.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_EXPIRATION_DT IS 'The expiration date of the identification document.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_ITM_ISSNG_GEO_AREA_TYPE_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.ID_ITM_ISSNG_GEO_AREA_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_IDENT.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.IDX_PGR_ID_ITM_DOC_NO_REPORT ON __SCHEMA__.PGR_INDIVIDUAL_IDENT
(ID_ITM_DOC_NO_REPORT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_ID_ITM_DOC_TYPE_VCD ON __SCHEMA__.PGR_INDIVIDUAL_IDENT
(ID_ITM_DOC_TYPE_VCD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.PGR_INDV_IDENT_ENTITY_FK ON __SCHEMA__.PGR_INDIVIDUAL_IDENT
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_INDIVIDUAL_NAME
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  PRTY_NM            VARCHAR2(100 CHAR),
  GIVEN_NM           VARCHAR2(100 CHAR),
  MIDDLE_NM          VARCHAR2(100 CHAR),
  SURNAME            VARCHAR2(100 CHAR),
  SALUTATION_VCD     VARCHAR2(100 CHAR),
  SALUTATION_VID     NUMBER(12),
  NM_QUAL_VCD        VARCHAR2(100 CHAR),
  NM_QUAL_VID        NUMBER(12),
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)         NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_NAME.SALUTATION_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_NAME.NM_QUAL_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_NAME.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_NAME.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_INDIV_NAME_CTX ON __SCHEMA__.PGR_INDIVIDUAL_NAME
(SURNAME)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS('DATASTORE ods.indiv_name_multi_ds section group ods.name_sg STORAGE ods.odsstore wordlist ods.name_wl')
NOPARALLEL;

CREATE INDEX __SCHEMA__.PGR_INDV_NM_ENTITY_FK ON __SCHEMA__.PGR_INDIVIDUAL_NAME
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION
(
  CUR_EID                         NUMBER(19)    NOT NULL,
  IND_OCC_NK                      VARCHAR2(60 CHAR),
  IND_OCC_TYPE_VCD                VARCHAR2(100 CHAR),
  IND_OCC_TYPE_VID                NUMBER(12),
  IND_OCC_DESC                    VARCHAR2(255 CHAR),
  EMPL_STATUS_TYPE_VCD            VARCHAR2(100 CHAR),
  EMPL_STATUS_TYPE_VID            NUMBER(12),
  EMPLOYER_NAME                   VARCHAR2(100 CHAR),
  EMPLOYER_NAICS_2DUS2007_VCD     VARCHAR2(100 CHAR),
  EMPLOYER_NAICS_2DUS2007_VID     NUMBER(12),
  EMPLOYEE_NUM                    VARCHAR2(30 CHAR),
  IND_OCC_EFF_DT                  DATE,
  IND_OCC_END_DT                  DATE,
  EMPL_CONTRACT_TYPE_VCD          VARCHAR2(100 CHAR),
  EMPL_CONTRACT_TYPE_VID          NUMBER(12),
  EMPL_TIME_COMMITTMENT_TYPE_VCD  VARCHAR2(100 CHAR),
  EMPL_TIME_COMMITTMENT_TYPE_VID  NUMBER(12),
  MONTHS_EMPLOYED                 VARCHAR2(2 CHAR),
  YEARS_EMPLOYED                  VARCHAR2(2 CHAR),
  REC_LAST_UPD_TIME               TIMESTAMP(6)  DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY               VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.IND_OCC_DESC IS 'Description of the individual occupation.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.EMPLOYER_NAME IS 'The name of the employer of the individual.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.EMPLOYEE_NUM IS 'An identifier by which the Employee is known to the Organization he is working in.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.IND_OCC_EFF_DT IS 'The date from which the individual occupation is effective.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.IND_OCC_END_DT IS 'The calendar date after which the individual occupation is no longer valid.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.EMPL_CONTRACT_TYPE_VID IS 'A value id from the Individual Employment Contract Type domain value.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.EMPL_TIME_COMMITTMENT_TYPE_VID IS 'A value id from the Individual Employment Time CommittmentType domain value.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_INDV_OCCUPATION_ENTITY_FK ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT
(
  CUR_EID                      NUMBER(19),
  MEM_ORG_UNIT_NK              VARCHAR2(60 CHAR),
  MEM_ORG_UNIT_RLTNP_TYPE_VCD  VARCHAR2(100 CHAR),
  MEM_ORG_UNIT_RLTNP_TYPE_VID  NUMBER(12),
  ORG_UNIT_TYPE_VCD            VARCHAR2(100 CHAR),
  ORG_UNIT_TYPE_VID            NUMBER(12),
  ORG_UNIT_CD                  VARCHAR2(30 CHAR),
  ORGU_IND_NAME                VARCHAR2(100 CHAR),
  ORGU_IND_MEM_RLTNP_TYPE_VCD  VARCHAR2(100 CHAR),
  ORGU_IND_MEM_RLTNP_TYPE_VID  NUMBER(12),
  ORGU_IND_USERID              VARCHAR2(30 CHAR),
  ORGU_IND_EMPLOYEE_NUM        VARCHAR2(30 CHAR),
  REC_LAST_UPD_TIME            TIMESTAMP(6)     DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY            VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT.ORG_UNIT_CD IS 'The organization unit code.';

COMMENT ON COLUMN __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT.ORGU_IND_NAME IS 'The name of the individual of the administrative unit having a relationship with the member.
';

COMMENT ON COLUMN __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT.ORGU_IND_USERID IS 'The userid of the individual of the administrative unit having a relationship with the member.
';

COMMENT ON COLUMN __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT.ORGU_IND_EMPLOYEE_NUM IS 'The employee number of the individual of the administrative unit having a relationship with the member.
';

COMMENT ON COLUMN __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_MEM_OGUN_ENTITY_FK ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS
(
  CUR_EID                        NUMBER(19)     NOT NULL,
  PRTY_EMAIL_ADDR_RLTNP_TYP_VCD  VARCHAR2(100 CHAR),
  PRTY_EMAIL_ADDR_RLTNP_TYP_VID  NUMBER(12),
  EFF_DT                         DATE,
  END_DT                         DATE,
  EMAIL_ADDR                     VARCHAR2(100 CHAR),
  REC_LAST_UPD_TIME              TIMESTAMP(6)   DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY              VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS.EMAIL_ADDR IS 'E-Mail Address is an Electronic Address which identifies a logical address which can be used to send and receive correspondence over a computer network; for example,''jsmith@jonesinc.com''.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.IDX_PGR_EMAIL_ADDR ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS
(EMAIL_ADDR)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.PGR_PRTY_EMAIL_ADDR_ENTITY_FK ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_PARTY_EVENT
(
  CUR_EID            NUMBER(19)                 NOT NULL,
  PRTY_EVT_DMN_VCD   VARCHAR2(100 CHAR),
  PRTY_EVT_DMN_VID   NUMBER(12),
  PRTY_EVT_TYPE_VCD  VARCHAR2(100 CHAR),
  PRTY_EVT_TYPE_VID  NUMBER(12),
  PRTY_EVT_COMMENT   VARCHAR2(255 CHAR),
  PRTY_EVT_EFF_DT    DATE,
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)         NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EVENT.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EVENT.PRTY_EVT_COMMENT IS 'Description of the party event.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EVENT.PRTY_EVT_EFF_DT IS 'The effective date of the party event.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EVENT.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_EVENT.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_PRTY_EVT_ENTITY_FK ON __SCHEMA__.PGR_PARTY_EVENT
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_PARTY_GEO_AREA
(
  CUR_EID                      NUMBER(19)       NOT NULL,
  MEMBER_GEO_AREA_NK           VARCHAR2(60 CHAR),
  PRTY_GEO_AREA_RLTNP_TYP_VCD  VARCHAR2(100 CHAR),
  PRTY_GEO_AREA_RLTNP_TYP_VID  NUMBER(12),
  GEO_AREA_TYP_VCD             VARCHAR2(100 CHAR),
  GEO_AREA_TYP_VID             NUMBER(12),
  GEO_AREA_VCD                 VARCHAR2(100 CHAR),
  GEO_AREA_VID                 NUMBER(12),
  EFF_DT                       DATE,
  END_DT                       DATE,
  REC_LAST_UPD_TIME            TIMESTAMP(6)     DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY            VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.PGR_PARTY_GEO_AREA IS 'Party / Geographic Area Relationship identifies an occurrence of an association between an instance of Party and an instance of Geographic Area, and defines the purpose for the association. For example, an Individual''s tax domicile (Country), the State in which an Organization is incorporated.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_GEO_AREA.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_GEO_AREA.PRTY_GEO_AREA_RLTNP_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_GEO_AREA.GEO_AREA_TYP_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_GEO_AREA.GEO_AREA_VCD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_GEO_AREA.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_GEO_AREA.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_PRTY_GEO_ENTITY_FK ON __SCHEMA__.PGR_PARTY_GEO_AREA
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_PARTY_LIST_MEMBER
(
  CUR_EID            NUMBER(19),
  PRTY_LIST_MEM_NK   VARCHAR2(60 CHAR),
  PRTY_LIST_VCD      VARCHAR2(100 CHAR),
  PRTY_LIST_VID      NUMBER(12),
  REC_LAST_UPD_TIME  TIMESTAMP(6)               DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY  VARCHAR2(100 CHAR)         NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_LIST_MEMBER.PRTY_LIST_VCD IS '
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_LIST_MEMBER.PRTY_LIST_VID IS '
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_LIST_MEMBER.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_LIST_MEMBER.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_PRTY_LIST_MEM_ENTITY_FK ON __SCHEMA__.PGR_PARTY_LIST_MEMBER
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_PARTY_TELEPHONE
(
  CUR_EID                    NUMBER(19)         NOT NULL,
  MEMBER_PHONE_NK            VARCHAR2(60 CHAR),
  PRTY_PHONE_RLTNP_TYPE_VCD  VARCHAR2(100 CHAR),
  PRTY_PHONE_RLTNP_TYPE_VID  NUMBER(12),
  COMPLETE_PHONE_NO          VARCHAR2(30 CHAR),
  CNTRY_PHONE_CD             CHAR(4 CHAR),
  PHONE_CD                   NUMBER(5),
  LOCAL_NO                   VARCHAR2(30 CHAR),
  EXTENSION                  VARCHAR2(30 CHAR),
  REC_LAST_UPD_TIME          TIMESTAMP(6)       DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY          VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_TELEPHONE.CNTRY_PHONE_CD IS 'A code from the value domain *ISO 3166-1 Alpha-2 Country*. The ISO country code of the telephone number.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_TELEPHONE.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_TELEPHONE.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.IDX_PGR_TEL_COMPL_PHONE_NO ON __SCHEMA__.PGR_PARTY_TELEPHONE
(COMPLETE_PHONE_NO)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_TEL_EXTENSION ON __SCHEMA__.PGR_PARTY_TELEPHONE
(EXTENSION)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_TEL_LOCAL_NO ON __SCHEMA__.PGR_PARTY_TELEPHONE
(LOCAL_NO)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_TEL_PHONE_CD ON __SCHEMA__.PGR_PARTY_TELEPHONE
(PHONE_CD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IDX_PGR_TEL_PHONE_RLTNP_VCD ON __SCHEMA__.PGR_PARTY_TELEPHONE
(PRTY_PHONE_RLTNP_TYPE_VCD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.PGR_PRTY_PHONE_ENTITY_FK ON __SCHEMA__.PGR_PARTY_TELEPHONE
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.PGR_PARTY_WEB_ADDRESS
(
  CUR_EID                       NUMBER(19)      NOT NULL,
  PRTY_WEB_ADDR_RLTNP_TYPE_VCD  VARCHAR2(100 CHAR),
  PRTY_WEB_ADDR_RLTNP_TYPE_ID   NUMBER(12),
  EFF_DT                        DATE,
  END_DT                        DATE,
  UNIVERSAL_RESOURCE_LOCATOR    VARCHAR2(100 CHAR),
  REC_LAST_UPD_TIME             TIMESTAMP(6)    DEFAULT SYSDATE               NOT NULL,
  MDM_DATA_CATEGORY             VARCHAR2(100 CHAR) NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_WEB_ADDRESS.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_WEB_ADDRESS.UNIVERSAL_RESOURCE_LOCATOR IS 'A string in Universal Resource Locator format, containing the Web Address.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_WEB_ADDRESS.REC_LAST_UPD_TIME IS 'The timestamp of the last update of the record.';

COMMENT ON COLUMN __SCHEMA__.PGR_PARTY_WEB_ADDRESS.MDM_DATA_CATEGORY IS 'This values domain represents a MDM-CDI information category. e.g. An information Profile can either be Internal or external.';


CREATE INDEX __SCHEMA__.PGR_PRTY_WEB_ADDR_ENTITY_FK ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE TABLE __SCHEMA__.TBACTR_ACCTG_TRST
(
  LAST_EVT_TM                TIMESTAMP(6),
  LAST_EVT_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM            TIMESTAMP(6),
  REC_LAST_UPD_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID      NUMBER(12),
  ACTR_ID                    VARCHAR2(70 BYTE)  NOT NULL,
  ACTR_SRC_CD                VARCHAR2(10 CHAR)  NOT NULL,
  ACTR_SRC_KEY               VARCHAR2(60 CHAR)  NOT NULL,
  ACTR_CD                    VARCHAR2(10 CHAR),
  ACTR_FR_NAME               VARCHAR2(100 CHAR),
  ACTR_EN_NAME               VARCHAR2(100 CHAR),
  ACTR_EFFCTV_DT             DATE,
  ACTR_END_DT                DATE,
  ACTR_LIFE_CYCLE_STATUS_CD  VARCHAR2(10 CHAR),
  REC_LAST_UPD_SRC_CD        VARCHAR2(4 BYTE)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBACTR_ACCTG_TRST IS 'List of the Financial Institution Legal Entity for which we have clients in our systems.  Currently, OSS and GUA are two sources for those legal entities.  This is not a normalized list of legal entities, currently  it is a union of the existing lists in OSS and GUA:
OSS Correspondent Brokers
GUA Distributor
GUA BNGF Legal Entities';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_ID IS 'The identifier of the Financial Institution Legal Entity. This identifier is the unique key of the Financial Institution Legal Entity table and its value must be provided by the sources.
Proposed identifier for each source.
Identifier from GUA:
GUA + BNGF  + Entity Number + Legal Number for GUA BNGF Legal entities
GUA + DIST + Distributor Number for a GUA Distributor
Identifier from OSS:
OSS + CB + Dealer Number + ?  for a broker legal entity
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_SRC_CD IS 'The code that identifies the logical source of the Financial Institution Legal Entity information.
Values:
GUA
OSS';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_SRC_KEY IS 'The identifier of the Financial Institution Legal Entity. This identifier is the unique key of the Financial Institution Legal Entity table and its value must be provided by the sources.
Proposed identifier for each source.
Identifier from GUA:
GUA + BNGF  + Entity Number + Legal Number for GUA BNGF Legal entities
GUA + DIST + Distributor Number for a GUA Distributor
Identifier from OSS:
OSS + CB + Dealer Number + ?  for a broker legal entity
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_CD IS 'The code of the Financial Institution Legal Entity.
Proposed code for each source.
Code from GUA:
Entity Number + Legal Number for GUA BNGF Legal entities
Distributor Number for a GUA Distributor';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_FR_NAME IS 'The name of the Financial Institution Legal Entity.
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_EN_NAME IS 'The name of the Financial Institution Legal Entity.
';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_EFFCTV_DT IS 'Date d''ouverture de l''unité organisationnelle';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_END_DT IS 'Date de fermeture de l''unité organisationnelle';

COMMENT ON COLUMN __SCHEMA__.TBACTR_ACCTG_TRST.ACTR_LIFE_CYCLE_STATUS_CD IS 'Référence au Code du statut de l''unité administrative. Exemple: Ouvert, Fermé¿)';


CREATE UNIQUE INDEX __SCHEMA__.PK_ACTR_01 ON __SCHEMA__.TBACTR_ACCTG_TRST
(ACTR_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBACTR_ACCTG_TRST
 ADD CONSTRAINT PK_ACTR_01
  PRIMARY KEY
  (ACTR_ID)
  USING INDEX __SCHEMA__.PK_ACTR_01;

CREATE TABLE __SCHEMA__.TBCARD_CARD
(
  LAST_EVT_TM                TIMESTAMP(6),
  LAST_EVT_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM            TIMESTAMP(6)       DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID      NUMBER(12),
  REC_LAST_UPD_SRC_CD        VARCHAR2(4 CHAR),
  CARD_ID                    VARCHAR2(70 CHAR)  NOT NULL,
  PRAG_ID                    VARCHAR2(70 CHAR)  NOT NULL,
  CUR_EID                    NUMBER(19),
  CARD_PTY_MBR_SRC_CD        VARCHAR2(10 CHAR)  NOT NULL,
  CARD_PTY_MBR_SRC_NTRL_KEY  VARCHAR2(60 CHAR)  NOT NULL,
  CARD_SRC_CD                VARCHAR2(10 CHAR),
  CARD_SRC_NTRL_KEY          VARCHAR2(40 CHAR),
  CARD_SRC_NO                VARCHAR2(30 CHAR),
  CARD_TYP_CD                VARCHAR2(10 CHAR),
  CARD_STATUS_CD             VARCHAR2(10 CHAR),
  CARD_RESTRCTN_TYP_CD       VARCHAR2(10 CHAR),
  CARD_DEP_WTD_QUOT          VARCHAR2(10 CHAR),
  CARD_DAILY_WTD_QUOT        VARCHAR2(10 CHAR),
  CARD_WEEKLY_WTD_QUOT       VARCHAR2(10 CHAR),
  CARD_EMBSSMNT_DT           DATE,
  CARD_ACTVTN_DT             DATE,
  CARD_CLOSING_DT            DATE,
  CARD_CLOSING_REASON_CD     VARCHAR2(10 CHAR),
  CARD_BAL_AMT               NUMBER(16,4),
  CARD_CREDIT_LIMIT_AMT      NUMBER(16,4),
  CARD_CASH_ADVNC_LIMIT_AMT  NUMBER(14,2),
  CARD_TECHNLG_TYP_CD        VARCHAR2(25 CHAR)
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
/*
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
*/

NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_ID IS 'Card identifier';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_PTY_MBR_SRC_CD IS 'Code identifying the source system where the Product Agreement comes from';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_PTY_MBR_SRC_NTRL_KEY IS 'What make a Product Agreement Member unique in the source system';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_SRC_CD IS 'Code dÃ¢â?¬Å¡signant le systÃ?Â me opÃ¢â?¬Å¡rationnel source (CARDPAC, FBS, CARTE-CLIENT, etc.) de la carte de dÃ¢â?¬Å¡bit ou crÃ¢â?¬Å¡dit';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_SRC_NTRL_KEY IS 'Identifiant(s) de la carte de dÃ¢â?¬Å¡bit ou crÃ¢â?¬Å¡dit dans le systÃ?Â me opÃ¢â?¬Å¡rationnel source (CO, PH, OSS, etc.). Dans la plupart des cas il s''agit du numÃ¢â?¬Å¡ro de carte, mais parfois il est nÃ¢â?¬Å¡cessaire d''y ajouter de l''information pour qu''il soit unique. NÃ¢â?¬Å¡anmoins, pour que cet identifiant soit unique Ã¢â?¬Â¦ travers tout l''entrepÃ¢â?¬Å?t de donnÃ¢â?¬Å¡es, on doit y ajouter le code du systÃ?Â me source.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_SRC_NO IS 'NumÃ¢â?¬Å¡ro de la carte dans le systÃ?Â me opÃ¢â?¬Å¡rationnel source.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_TYP_CD IS 'Code dÃ¢â?¬Å¡signant le type de carte (crÃ¢â?¬Å¡dit, dÃ¢â?¬Å¡bit, etc.)';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_STATUS_CD IS 'Code dÃ¢â?¬Å¡signant le statut de la carte (Exemple: ouverte mais non activÃ¢â?¬Å¡e, ouverte, gelÃ¢â?¬Å¡e, etc.)';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_RESTRCTN_TYP_CD IS 'Code dÃ¢â?¬Å¡signant le type de restriction qui s''applique sur la carte (aucun retrait permis, en surveillance par la sÃ¢â?¬Å¡curitÃ¢â?¬Å¡, carte volÃ¢â?¬Å¡e, etc.)';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_DEP_WTD_QUOT IS 'Cote dÃ¢â?¬Å¡terminant le montant qui peut Ã?â? tre retirÃ¢â?¬Å¡ Ã¢â?¬Â¦ la suite d''un dÃ¢â?¬Å¡pÃ¢â?¬Å?t, sans que le dÃ¢â?¬Å¡pÃ¢â?¬Å?t ait Ã¢â?¬Å¡tÃ¢â?¬Å¡ vÃ¢â?¬Å¡rifiÃ¢â?¬Å¡ et confirmÃ¢â?¬Å¡.  Ces cotes sont dictÃ¢â?¬Å¡es par l''application Carte-Client.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_DAILY_WTD_QUOT IS 'Cote de la limite quotidienne de retrait allouÃ¢â?¬Å¡ Ã¢â?¬Â¦ la carte.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_WEEKLY_WTD_QUOT IS 'Cote de la limite hebdomaire de retrait allouÃ¢â?¬Å¡ Ã¢â?¬Â¦ la carte.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_EMBSSMNT_DT IS 'Date Ã¢â?¬Â¦ laquelle l''embossage de la carte a Ã¢â?¬Å¡tÃ¢â?¬Å¡ effectuÃ¢â?¬Å¡.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_ACTVTN_DT IS 'Date Ã¢â?¬Â¦ laquelle l''activation de la carte a Ã¢â?¬Å¡tÃ¢â?¬Å¡ effectuÃ¢â?¬Å¡e.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_CLOSING_DT IS 'Date Ã¢â?¬Â¦ laquelle la carte a Ã¢â?¬Å¡tÃ¢â?¬Å¡ fermÃ¢â?¬Å¡e dans le systÃ?Â me.';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_CLOSING_REASON_CD IS 'Code de la raison de fermeture de la carte';

COMMENT ON COLUMN __SCHEMA__.TBCARD_CARD.CARD_TECHNLG_TYP_CD IS 'Code indiquant le type de technologie disponible sur la carte: piste, puce, puce avec antenne, etc.';


CREATE INDEX __SCHEMA__.CARD_SRC_NO_TBCARD_CARD ON __SCHEMA__.TBCARD_CARD
(CARD_SRC_NO)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.IN_CARD_01 ON __SCHEMA__.TBCARD_CARD
(PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   20
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOGGING
/*
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
*/
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_TBCARD_CARD ON __SCHEMA__.TBCARD_CARD
(CARD_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBCARD_CARD
 ADD CONSTRAINT PK_TBCARD_CARD
  PRIMARY KEY
  (CARD_ID)
  USING INDEX __SCHEMA__.PK_TBCARD_CARD;

CREATE TABLE __SCHEMA__.TBCNL_CHANNL
(
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 CHAR),
  CNL_ID                 VARCHAR2(70 CHAR)      NOT NULL,
  CNL_NM_FR              VARCHAR2(100 CHAR),
  CNL_NM_EN              VARCHAR2(100 CHAR),
  PARENT_CNL_ID          VARCHAR2(70 CHAR),
  CNL_LEVEL_NO           NUMBER(3)              NOT NULL,
  CNL_HIGH_LEVEL_FLG     CHAR(1 CHAR)           NOT NULL,
  CNL_LOW_LEVEL_FLG      CHAR(1 CHAR)           NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
CACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.REC_LAST_UPD_USER_ID IS 'The userid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.REC_LAST_UPD_BATCH_ID IS 'The batchid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.REC_LAST_UPD_SRC_CD IS 'The update source code of the last update of the record in this table. Domain : BNGF system code from Casewise.';

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.CNL_ID IS 'The unique identifier of a Channel
';

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.CNL_NM_FR IS 'Name in french of the Channel';

COMMENT ON COLUMN __SCHEMA__.TBCNL_CHANNL.CNL_NM_EN IS 'Name in english of the Channel';


CREATE UNIQUE INDEX __SCHEMA__.PK_CNL ON __SCHEMA__.TBCNL_CHANNL
(CNL_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBCNL_CHANNL
 ADD CONSTRAINT PK_CNL
  PRIMARY KEY
  (CNL_ID)
  USING INDEX __SCHEMA__.PK_CNL;

CREATE TABLE __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP
(
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 CHAR),
  DISCN_ID               VARCHAR2(70 CHAR)      NOT NULL,
  OGUN_ID                VARCHAR2(70 CHAR)      NOT NULL,
  DCOU_TYPE_CD           VARCHAR2(10 CHAR)      NOT NULL,
  DCOU_START_DT          DATE                   NOT NULL,
  DCOU_END_DT            DATE
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP IS 'Illustrate the relation existing between a Distribution Channel and an Organisation Unit.

Example : The accounting Organisation Unit of an ATM machine.';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.DISCN_ID IS 'The unique identifier of a Distribution Channel.';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.OGUN_ID IS 'The identifier of the organization unit in the system managing the organization unit.  Those organization units are managed in GUA for the bank, and OSS for the trading.
Key from OSS:
OSS   RC    Rep code for a rep code
OSS   BR   Branch code for a branch
Key from GUA:
GUA   Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.DCOU_TYPE_CD IS 'Relation Type Between Organisation Unit and Distribution Channel.

Example: The Accounting Organisation Unit of a ATM machine.';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.DCOU_START_DT IS 'Starting date of the relation.';

COMMENT ON COLUMN __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP.DCOU_END_DT IS 'Ending date of the relation. Default : 9999-12-31';


CREATE UNIQUE INDEX __SCHEMA__.PK_DCOU ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP
(OGUN_ID, DCOU_TYPE_CD, DISCN_ID, DCOU_START_DT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP
 ADD CONSTRAINT PK_DCOU
  PRIMARY KEY
  (OGUN_ID, DCOU_TYPE_CD, DISCN_ID, DCOU_START_DT)
  USING INDEX __SCHEMA__.PK_DCOU;

CREATE TABLE __SCHEMA__.TBDISCN_DISTRBTN_CHANNL
(
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 CHAR),
  DISCN_ID               VARCHAR2(70 CHAR)      NOT NULL,
  CNL_ID                 VARCHAR2(70 CHAR),
  DISCN_NM_FR            VARCHAR2(100 CHAR),
  DISCN_NM_EN            VARCHAR2(100 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
CACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.REC_LAST_UPD_USER_ID IS 'The userid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.REC_LAST_UPD_BATCH_ID IS 'The batchid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.REC_LAST_UPD_SRC_CD IS 'The update source code of the last update of the record in this table. Domain : BNGF system code from Casewise.';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.DISCN_ID IS 'The unique identifier of a Distribution Channel.';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.CNL_ID IS 'The unique identifier of a Channel Type.
';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.DISCN_NM_FR IS 'Name in french of the Distribution Channel';

COMMENT ON COLUMN __SCHEMA__.TBDISCN_DISTRBTN_CHANNL.DISCN_NM_EN IS 'Name in english of the Distribution Channel';


CREATE UNIQUE INDEX __SCHEMA__.PK_DISCN ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL
(DISCN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBDISCN_DISTRBTN_CHANNL
 ADD CONSTRAINT PK_DISCN
  PRIMARY KEY
  (DISCN_ID)
  USING INDEX __SCHEMA__.PK_DISCN;

CREATE TABLE __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM        TIMESTAMP(6),
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  FGLE_ID                VARCHAR2(70 BYTE)      NOT NULL,
  FGLE_SRC_CD            VARCHAR2(10 CHAR)      NOT NULL,
  FGLE_SRC_KEY           VARCHAR2(60 CHAR)      NOT NULL,
  FGLE_CD                VARCHAR2(10 CHAR),
  FGLE_FR_NAME           VARCHAR2(100 CHAR),
  FGLE_EN_NAME           VARCHAR2(100 CHAR),
  FGLE_TYPE_CD           VARCHAR2(10 CHAR),
  CLEG_CD                VARCHAR2(10 CHAR),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY IS 'List of the Financial Institution Legal Entity for which we have clients in our systems.  Currently, OSS and GUA are two sources for those legal entities.  This is not a normalized list of legal entities, currently  it is a union of the existing lists in OSS and GUA:
OSS Correspondent Brokers
GUA Distributor
GUA BNGF Legal Entities';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.FGLE_ID IS 'The identifier of the Financial Institution Legal Entity. This identifier is the unique key of the Financial Institution Legal Entity table and its value must be provided by the sources.
Proposed identifier for each source.
Identifier from GUA:
GUA + BNGF  + Entity Number + Legal Number for GUA BNGF Legal entities
GUA + DIST + Distributor Number for a GUA Distributor
Identifier from OSS:
OSS + CB + Dealer Number + ?  for a broker legal entity
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.FGLE_SRC_CD IS 'The code that identifies the logical source of the Financial Institution Legal Entity information.
Values:
GUA
OSS';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.FGLE_SRC_KEY IS 'The identifier of the Financial Institution Legal Entity. This identifier is the unique key of the Financial Institution Legal Entity table and its value must be provided by the sources.
Proposed identifier for each source.
Identifier from GUA:
GUA + BNGF  + Entity Number + Legal Number for GUA BNGF Legal entities
GUA + DIST + Distributor Number for a GUA Distributor
Identifier from OSS:
OSS + CB + Dealer Number + ?  for a broker legal entity
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.FGLE_CD IS 'The code of the Financial Institution Legal Entity.
Proposed code for each source.
Code from GUA:
Entity Number + Legal Number for GUA BNGF Legal entities
Distributor Number for a GUA Distributor';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.FGLE_FR_NAME IS 'The name of the Financial Institution Legal Entity.
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.FGLE_EN_NAME IS 'The name of the Financial Institution Legal Entity.
';

COMMENT ON COLUMN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY.CLEG_CD IS 'The code of the Financial Institution Legal Entity.
Proposed code for each source.
Code from GUA:
Entity Number + Legal Number for GUA BNGF Legal entities
Distributor Number for a GUA Distributor';


CREATE UNIQUE INDEX __SCHEMA__.PK_TBFGLE_FIN_GRP_LGL_ENTITY ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY
(FGLE_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY
 ADD CONSTRAINT PK_TBFGLE_FIN_GRP_LGL_ENTITY
  PRIMARY KEY
  (FGLE_ID)
  USING INDEX __SCHEMA__.PK_TBFGLE_FIN_GRP_LGL_ENTITY;

CREATE TABLE __SCHEMA__.TBLGPR_LEGACY_PRODUCT
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM        TIMESTAMP(6),
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  LGPR_ID                VARCHAR2(70 BYTE)      NOT NULL,
  LGPR_SRC_CD            VARCHAR2(10 CHAR)      NOT NULL,
  LGPR_SRC_KEY           VARCHAR2(60 CHAR)      NOT NULL,
  LGPR_FR_NAME           VARCHAR2(100 CHAR),
  LGPR_EN_NAME           VARCHAR2(100 CHAR),
  LGPR_EFFCTV_DT         DATE,
  LGPR_END_DT            DATE,
  PRDT_ID                VARCHAR2(70 BYTE)      NOT NULL,
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_SRC_CD IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_SRC_KEY IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_FR_NAME IS 'Lorsqu''il s''agit d''une entente de prêt hypothécaire, il s''agit du numéro permettant de regrouper les tranches hypothécaires qui financent une même propriété. Concrètement il s''agit du numéro de compte de l''application PH.';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_EN_NAME IS 'Lorsqu''il s''agit d''une entente de prêt hypothécaire, il s''agit du numéro permettant de regrouper les tranches hypothécaires qui financent une même propriété. Concrètement il s''agit du numéro de compte de l''application PH.';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_EFFCTV_DT IS 'Date à laquelle l''entente de produit a été ouverte dans le système.';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.LGPR_END_DT IS 'Date à laquelle l''entente de produit a été fermée dans le système.';

COMMENT ON COLUMN __SCHEMA__.TBLGPR_LEGACY_PRODUCT.PRDT_ID IS 'Identifiant de l''entente de produit';


CREATE UNIQUE INDEX __SCHEMA__.PK_LGPR_01 ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT
(LGPR_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBLGPR_LEGACY_PRODUCT
 ADD CONSTRAINT PK_LGPR_01
  PRIMARY KEY
  (LGPR_ID)
  RELY
  USING INDEX __SCHEMA__.PK_LGPR_01;

CREATE TABLE __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC
(
  REC_LAST_UPD_TM                TIMESTAMP(6)   DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID          NUMBER(12),
  REC_LAST_UPD_SRC_CD            VARCHAR2(4 CHAR),
  LPVG_ID                        NUMBER(12)     NOT NULL,
  LGPR_ID                        VARCHAR2(70 CHAR) NOT NULL,
  LPVG_ISSUANCE_DT               DATE           NOT NULL,
  LPVG_MATURITY_DT               DATE           NOT NULL,
  LPVG_INITIAL_STOCK_INDEX_AMT   NUMBER(16,4),
  LPVG_AVG_STOCK_INDEX_AMT       NUMBER(16,4),
  LPVG_AVG_INDEX_EFFCTV_DT       DATE,
  LPVG_GROSS_RATE_RETURN_PCT     NUMBER(10,4),
  LPVG_GUARNTD_INT_MATURITY_PCT  NUMBER(10,4),
  LPVG_MAX_INT_MATURITY_PCT      NUMBER(10,4),
  LPVG_TYP_CD                    VARCHAR2(10 CHAR),
  LPGV_TERM_MONTH_CNT            NUMBER(3)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
COMPRESS FOR OLTP 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC IS 'Entity contains characteristics and rates associate with GIC.
¬ Intial stock index
¬ Gross rate of return
¬ ...
Feed from PAT - REER database.
Business keys are :
Legacy product ID
Issuance date
Maturity date';

COMMENT ON COLUMN __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';


CREATE UNIQUE INDEX __SCHEMA__.PK_TBLPVG_LEGACY_PRODUCT_VAR_G ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC
(LPVG_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   4
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC
 ADD CONSTRAINT PK_TBLPVG_LEGACY_PRODUCT_VAR_G
  PRIMARY KEY
  (LPVG_ID)
  RELY
  USING INDEX __SCHEMA__.PK_TBLPVG_LEGACY_PRODUCT_VAR_G;

CREATE TABLE __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP
(
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 CHAR)       NOT NULL,
  OGOG_SBJ_OGUN_ID       VARCHAR2(70 CHAR)      NOT NULL,
  OGOG_OBJ_OGUN_ID       VARCHAR2(70 CHAR)      NOT NULL,
  OGOG_TYPE_CD           VARCHAR2(10 CHAR)      NOT NULL,
  OGOG_START_DT          DATE                   NOT NULL,
  OGOG_END_DT            DATE
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP IS 'Illustrate the relation existing between two Organisation Unit

Example : The clearing Organisation Unit of a Organisation Unit.

Source : Relation TABLE ODS.from GUA.';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.OGOG_SBJ_OGUN_ID IS '[Subject of the relation | the FROM]
The identifier of the organization unit in the system managing the organization unit.  Those organization units are managed in GUA for the bank, and OSS for the trading.
Key from OSS:
OSS   RC    Rep code for a rep code
OSS   BR   Branch code for a branch
Key from GUA:
GUA   Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.OGOG_OBJ_OGUN_ID IS 'The identifier of the organization unit in the system managing the organization unit. Those organization units are managed in GUA for the bank, and OSS for the trading. Key from OSS: OSS   RC   Rep code for a rep code OSS   BR   Branch code for a branch Key from GUA: GUA   Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.OGOG_TYPE_CD IS 'Relation Type Between Organisation Unit and Organisation Unit.

Example: The compensation Organisation Unit of a Organisation Unit.';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.OGOG_START_DT IS 'Starting date of the relation.';

COMMENT ON COLUMN __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP.OGOG_END_DT IS 'End date of the relation. Default 9999-12-31';


CREATE INDEX __SCHEMA__.IDX_OGOG_01 ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP
(OGOG_SBJ_OGUN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_OGOG ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP
(OGOG_SBJ_OGUN_ID, OGOG_TYPE_CD, OGOG_START_DT, OGOG_OBJ_OGUN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP
 ADD CONSTRAINT PK_OGOG
  PRIMARY KEY
  (OGOG_SBJ_OGUN_ID, OGOG_TYPE_CD, OGOG_START_DT, OGOG_OBJ_OGUN_ID)
  RELY
  USING INDEX __SCHEMA__.PK_OGOG;

CREATE TABLE __SCHEMA__.TBOGUN_ORG_UNIT
(
  LAST_EVT_TM                TIMESTAMP(6),
  LAST_EVT_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM            TIMESTAMP(6),
  REC_LAST_UPD_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID      NUMBER(12),
  OGUN_ID                    VARCHAR2(70 BYTE)  NOT NULL,
  OGUN_SRC_CD                VARCHAR2(10 CHAR)  NOT NULL,
  OGUN_SRC_KEY               VARCHAR2(60 CHAR)  NOT NULL,
  OGUN_TYPE_CD               VARCHAR2(10 CHAR)  NOT NULL,
  OGUN_FR_NAME               VARCHAR2(100 CHAR),
  OGUN_EN_NAME               VARCHAR2(100 CHAR),
  OGUN_EFFCTV_DT             DATE,
  OGUN_END_DT                DATE,
  OGUN_LIFE_CYCLE_STATUS_CD  VARCHAR2(10 CHAR)  NOT NULL,
  FGLE_ID                    VARCHAR2(70 BYTE)  NOT NULL,
  ACTR_ID                    VARCHAR2(70 BYTE),
  REC_LAST_UPD_SRC_CD        VARCHAR2(4 BYTE),
  OGUN_CAR_LOB_WEALTH_CD     VARCHAR2(10 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBOGUN_ORG_UNIT IS 'Le transit est défini comme l''unité de base sur laquelle repose la structure administrative de la BNGF. Ce qui peut inclure autant les constructions physiques que les entités conceptuelles (projet ou centre de coût).
GRANULARITÉ: Chaque transit.
IDENTIFIANT NATUREL: Numéro de transit,  Date d''ouverture.';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_ID IS 'The identifier of the organization unit in the system managing the organization unit.  Those organization units are managed in GUA for the bank, and OSS for the trading.
Key from OSS:
OSS + RC +  Rep code for a rep code
OSS + BR + Branch code for a branch
Key from GUA:
GUA + Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_SRC_CD IS 'The code that identifies the logical source of the organization unit information.
Values:
GUA
OSS';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_SRC_KEY IS 'The identifier of the organization unit in the system managing the organization unit.  Those organization units are managed in GUA for the bank, and OSS for the trading.
Key from OSS:
OSS + RC +  Rep code for a rep code
OSS + BR + Branch code for a branch
Key from GUA:
GUA + Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_TYPE_CD IS 'Natural key of a value of the normalized value domain Organization Unit Type Code.
Code du type du transit, désigné et suivi par le service comptable.  Il reflète la vraie et officielle classification des unités administratives. Son utilité est reconnue et recommandée pour les analyses au sein de l''environnement informationnel.  Elle est portée à évoluer en fonction des besoins d''affaire.  À distinguer du type d''unité administrative GUA, qui répond plutôt aux besoins/contraintes des systèmes opérationnels qui lui sont liés.
From EIN:
Code du type de transit
Values:
To be defined';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_FR_NAME IS 'Nom du transit.';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_EN_NAME IS 'Nom du transit.';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_EFFCTV_DT IS 'Date d''ouverture de l''unité organisationnelle';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_END_DT IS 'Date de fermeture de l''unité organisationnelle';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.OGUN_LIFE_CYCLE_STATUS_CD IS 'Référence au Code du statut de l''unité administrative. Exemple: Ouvert, Fermé¿)';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.FGLE_ID IS 'The identifier of the Financial Institution Legal Entity. This identifier is the unique key of the Financial Institution Legal Entity table and its value must be provided by the sources.
Proposed identifier for each source.
Identifier from GUA:
GUA + BNGF  + Entity Number + Legal Number for GUA BNGF Legal entities
GUA + DIST + Distributor Number for a GUA Distributor
Identifier from OSS:
OSS + CB + Dealer Number + ?  for a broker legal entity
';

COMMENT ON COLUMN __SCHEMA__.TBOGUN_ORG_UNIT.ACTR_ID IS 'The identifier of the Financial Institution Legal Entity. This identifier is the unique key of the Financial Institution Legal Entity table and its value must be provided by the sources.
Proposed identifier for each source.
Identifier from GUA:
GUA + BNGF  + Entity Number + Legal Number for GUA BNGF Legal entities
GUA + DIST + Distributor Number for a GUA Distributor
Identifier from OSS:
OSS + CB + Dealer Number + ?  for a broker legal entity
';


CREATE UNIQUE INDEX __SCHEMA__.PK_TRST ON __SCHEMA__.TBOGUN_ORG_UNIT
(OGUN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBOGUN_ORG_UNIT
 ADD CONSTRAINT PK_TRST
  PRIMARY KEY
  (OGUN_ID)
  RELY
  USING INDEX __SCHEMA__.PK_TRST;

CREATE TABLE __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT
(
  REC_INS_TM        TIMESTAMP(6)                DEFAULT SYSDATE               NOT NULL,
  REC_INS_USER_ID   VARCHAR2(30 CHAR),
  REC_INS_BATCH_ID  NUMBER(12),
  REC_INS_SRC_CD    VARCHAR2(4 CHAR)            NOT NULL,
  REC_INS_LOGCL_DT  DATE                        NOT NULL,
  PAACT_ID          NUMBER(12)                  NOT NULL,
  PAACT_DT          TIMESTAMP(6)                NOT NULL,
  PAACT_DOMN_ID     VARCHAR2(25 CHAR)           NOT NULL,
  PAACT_TYP_ID      VARCHAR2(25 CHAR)           NOT NULL,
  PAACT_VAL_TYP_CD  VARCHAR2(25 CHAR)           NOT NULL,
  PAACT_STRING_VAL  VARCHAR2(100 CHAR),
  PAACT_NUM_VAL     NUMBER(19,4),
  PAACT_UOM_CD      VARCHAR2(10 CHAR)           NOT NULL,
  PRAG_ID           VARCHAR2(70 CHAR)           NOT NULL
)
COMPRESS FOR OLTP 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    0
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING
/*
PARTITION BY RANGE (REC_INS_LOGCL_DT)
INTERVAL( NUMTODSINTERVAL(1,'DAY'))
(  
  PARTITION P_TBPAACT_PRDT_AGMT_ACTVT_01 VALUES LESS THAN (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    NOLOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    0
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
               )
)
*/
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT IS 'Activity associated to an agreement: account opening, limit change, package subscription, etc.
GRANULARITY: Activity of a Product Agreement at a specific Date.
NATURAL KEY: Source system of the agreement, Natural key of the agreement in the source system, Date of the activity, Type of the activity.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.REC_INS_TM IS 'The timestamp of the insert of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.REC_INS_USER_ID IS 'The userid of the insert of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.REC_INS_BATCH_ID IS 'The batchid of the insert of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.REC_INS_SRC_CD IS 'The source code of the insert of the record in this table. Domain : BNGF system code from Casewise.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.REC_INS_LOGCL_DT IS 'The logical date of the insert of the record in this table. Represent the logical date of the transaction. When we process the file of monday we use a logical date that represent monday. Maybe we process these data on tuesday witch will be the Record Insert Date. On this monday date we will probably process Event date of other day like the past Saterday and Sunday.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_ID IS 'The unique identifier of an Activity associated to a Product Agreement. Generated by an Oracle sequence for join between tables.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_DT IS 'Date the activity was captured.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_DOMN_ID IS 'The unique identifier of the Domain of the Activity Type.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_TYP_ID IS 'The unique identifier of the Activity Type.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_VAL_TYP_CD IS 'Identify the type of the value.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_STRING_VAL IS 'The value of the Activity, when this value is a string.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_NUM_VAL IS 'The value of the Activity, when this value is a numeric.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PAACT_UOM_CD IS 'The unique identifier of the Unit Of Measure of the Activity Type.';

COMMENT ON COLUMN __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT.PRAG_ID IS 'Unique identifier of a product agreement.';


CREATE UNIQUE INDEX __SCHEMA__.PK_TBPAACT_PRDT_AGMT_ACTVT ON __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT
(PAACT_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   4
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT
 ADD CONSTRAINT PK_TBPAACT_PRDT_AGMT_ACTVT
  PRIMARY KEY
  (PAACT_ID)
  USING INDEX __SCHEMA__.PK_TBPAACT_PRDT_AGMT_ACTVT;

CREATE TABLE __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  PRAG_ID                VARCHAR2(70 BYTE)      NOT NULL,
  PAAM_START_DT          DATE                   NOT NULL,
  PAAM_END_DT            DATE,
  PAAM_SRC_CD            VARCHAR2(10 CHAR)      NOT NULL,
  PAAM_SRC_KEY           VARCHAR2(60 CHAR)      NOT NULL,
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE)       NOT NULL
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            BUFFER_POOL      DEFAULT
           )
/*
		   PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
*/
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP IS 'The mapping table between the agreement entity IDs and the agreement member IDs when the agreement entity record is persisted. This table makes it efficient to get a persisted agreement entity, a possible version of a getIndividualEntity.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.PAAM_START_DT IS 'Date de début à laquelle les deux produits sont reliées.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.PAAM_END_DT IS 'Date de fin de à laquelle les deux produits cessent d''être reliées.';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.PAAM_SRC_CD IS 'Code identifying the source system where the Product Agreement Member comes from';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.PAAM_SRC_KEY IS 'What make a Product Agreement Member unique in the source system';

COMMENT ON COLUMN __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP.REC_LAST_UPD_SRC_CD IS 'The source system of the last change to the current record';


CREATE INDEX __SCHEMA__.ETL_PAAM_01 ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP
(PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   20
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_PAAM_PRAG_01 ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP
(REC_LAST_UPD_SRC_CD, PRAG_ID, PAAM_SRC_CD, PAAM_SRC_KEY)
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP
 ADD CONSTRAINT PK_PAAM_PRAG_01
  PRIMARY KEY
  (REC_LAST_UPD_SRC_CD, PRAG_ID, PAAM_SRC_CD, PAAM_SRC_KEY)
  USING INDEX LOCAL;

CREATE TABLE __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  PRAG_ID                VARCHAR2(70 BYTE)      NOT NULL,
  OGUN_ID                VARCHAR2(70 BYTE)      NOT NULL,
  PAOU_TYPE_CD           VARCHAR2(10 CHAR)      NOT NULL,
  PAOU_START_DT          DATE,
  PAOU_END_DT            DATE,
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE)       NOT NULL
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.OGUN_ID IS 'The identifier of the organization unit in the system managing the organization unit.  Those organization units are managed in GUA for the bank, and OSS for the trading.
Key from OSS:
OSS + RC +  Rep code for a rep code
OSS + BR + Branch code for a branch
Key from GUA:
GUA + Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.PAOU_START_DT IS 'Date de début à laquelle les deux produits sont reliées.';

COMMENT ON COLUMN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP.PAOU_END_DT IS 'Date de fin de à laquelle les deux produits cessent d''être reliées.';


CREATE INDEX __SCHEMA__.ETL_PAOU_01 ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP
(PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   20
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_TBPAOU_PRAG_ORG_UNIT_RLTNP ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP
(REC_LAST_UPD_SRC_CD, PRAG_ID, OGUN_ID, PAOU_TYPE_CD)
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP
 ADD CONSTRAINT PK_TBPAOU_PRAG_ORG_UNIT_RLTNP
  PRIMARY KEY
  (REC_LAST_UPD_SRC_CD, PRAG_ID, OGUN_ID, PAOU_TYPE_CD)
  USING INDEX LOCAL;

CREATE TABLE __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  SUBJECT_PRAG_ID        VARCHAR2(70 BYTE)      NOT NULL,
  OBJECT_PRAG_ID         VARCHAR2(70 BYTE)      NOT NULL,
  PAPA_TYPE_CD           VARCHAR2(10 BYTE)      NOT NULL,
  PAPA_START_DT          DATE                   NOT NULL,
  PAPA_END_DT            DATE,
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE)       NOT NULL
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (SUBJECT_PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP IS 'Contient le lien entre deux ententes. Par exemple, le lien entre une Entente Globale de Financement et les ententes sous-jacentes.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.SUBJECT_PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.OBJECT_PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.PAPA_TYPE_CD IS 'Référence au Code désignant le type de relation des deux produits.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.PAPA_START_DT IS 'Date de début à laquelle les deux produits sont reliées.';

COMMENT ON COLUMN __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP.PAPA_END_DT IS 'Date de fin de à laquelle les deux produits cessent d''être reliées.';


CREATE INDEX __SCHEMA__.ETL_PAPA_01 ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP
(SUBJECT_PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   20
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_PAPA_01 ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP
(REC_LAST_UPD_SRC_CD, SUBJECT_PRAG_ID, OBJECT_PRAG_ID, PAPA_TYPE_CD)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP
 ADD CONSTRAINT PK_PAPA_01
  PRIMARY KEY
  (REC_LAST_UPD_SRC_CD, SUBJECT_PRAG_ID, OBJECT_PRAG_ID, PAPA_TYPE_CD)
  USING INDEX LOCAL;

CREATE TABLE __SCHEMA__.TBPAP_PRDT_AGMT_PREF
(
  REC_LAST_UPD_TM        TIMESTAMP(6),
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 CHAR),
  PRAG_ID                VARCHAR2(70 CHAR)      NOT NULL,
  PAP_DOMAIN_CD          VARCHAR2(10 CHAR)      NOT NULL,
  PAP_TYPE_CD            VARCHAR2(10 CHAR)      NOT NULL,
  PAP_VAL                VARCHAR2(200 CHAR)     NOT NULL,
  PAP_START_DT           TIMESTAMP(6)           NOT NULL,
  PAP_END_DT             TIMESTAMP(6)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX __SCHEMA__.IN_TBPAP_02 ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF
(PRAG_ID, PAP_DOMAIN_CD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_PAP_01 ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF
(PRAG_ID, PAP_DOMAIN_CD, PAP_TYPE_CD, PAP_START_DT)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPAP_PRDT_AGMT_PREF
 ADD CONSTRAINT PK_PAP_01
  PRIMARY KEY
  (PRAG_ID, PAP_DOMAIN_CD, PAP_TYPE_CD, PAP_START_DT)
  USING INDEX __SCHEMA__.PK_PAP_01;

CREATE TABLE __SCHEMA__.TBPRAG_PRDT_AGMT
(
  LAST_EVT_TM                     TIMESTAMP(6),
  LAST_EVT_USER_ID                VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM                 TIMESTAMP(6)  DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID            VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID           NUMBER(12),
  PRAG_ID                         VARCHAR2(70 BYTE) CONSTRAINT "BIN$UhtjvMHRAobgUwpEHj+wbA==$0" NOT NULL,
  PRAG_TYPE_CD                    VARCHAR2(10 CHAR),
  LGPR_ID                         VARCHAR2(70 BYTE),
  AGMT_TYPE_CD                    VARCHAR2(10 CHAR),
  PRAG_EFFCTV_DT                  DATE,
  PRAG_END_DT                     DATE,
  PRAG_MTGG_LOAN_GRP_NO           VARCHAR2(30 CHAR),
  PRAG_LIFE_CYCLE_STATUS_CD       VARCHAR2(10 CHAR),
  PRAG_BAL_AMT                    NUMBER(18,4),
  PRAG_CREDIT_LIMIT_AMT           NUMBER(18,4),
  PRAG_CASH_ADV_LIMIT_AMT         NUMBER(18,4),
  PRAG_CUR_CD                     VARCHAR2(3 BYTE),
  PRAG_BAL_AMT_CCY                NUMBER(18,4),
  PRAG_CREDIT_LIMIT_AMT_CCY       NUMBER(18,4),
  PRAG_CASH_ADV_LIMIT_AMT_CCY     NUMBER(18,4),
  PRAG_SRC_CD                     VARCHAR2(10 CHAR) CONSTRAINT "BIN$UhtjvMHSAobgUwpEHj+wbA==$0" NOT NULL,
  PRAG_SRC_KEY                    VARCHAR2(60 CHAR) CONSTRAINT "BIN$UhtjvMHTAobgUwpEHj+wbA==$0" NOT NULL,
  PRAG_SIGNAT_REQRD_CNT           NUMBER(3),
  PRAG_SIGNAT_SPECIFIC_CONDT_DSC  VARCHAR2(255 CHAR),
  PRAG_SIGNAT_CONDT_PAPER_FLG     CHAR(1 CHAR),
  REC_LAST_UPD_TM_MQ              TIMESTAMP(6),
  REC_LAST_UPD_SRC_CD             VARCHAR2(4 BYTE) CONSTRAINT "BIN$UhtjvMHUAobgUwpEHj+wbA==$0" NOT NULL,
  PRAG_REGSTD_PLAN_TYPE_CD        VARCHAR2(10 CHAR),
  PRAG_SPOUSAL_REGSTD_PLAN_FLG    CHAR(1 CHAR),
  PRAG_ORIGINAL_AMT               NUMBER(18,4),
  PRAG_CREDIT_INTEREST_RATE_PCT   NUMBER(8,5),
  PRAG_TOT_INTEREST_MATURITY_AMT  NUMBER(18,4),
  PRAG_ISSUANCE_DT                DATE,
  PRAG_MATURITY_DT                DATE,
  PRAG_GIVEN_COLLATERAL_FLAG      CHAR(1 CHAR),
  PRAG_REDMBL_FLAG                CHAR(1 CHAR),
  PRAG_NOMINEE_ACCT_FLAG          CHAR(1 BYTE),
  PRAG_DUP_FLAG                   CHAR(1 BYTE),
  PRAG_CASH_BAL_AMT               NUMBER(18,4),
  PRAG_CASH_BAL_AMT_CCY           NUMBER(18,4),
  PKG_ID                          VARCHAR2(70 CHAR) DEFAULT 'N/A' CONSTRAINT "BIN$UhtjvMHVAobgUwpEHj+wbA==$0" NOT NULL,
  LPVG_ID                         NUMBER(12)    DEFAULT -1,
  PRAG_INTEREST_CALCLTN_TYP_CD    VARCHAR2(10 CHAR),
  PRAG_FREQ_INT_CAL_TYP_CD        VARCHAR2(10 CHAR),
  PRAG_INT_COMP_FREQ_TYP_CD       VARCHAR2(10 CHAR),
  PRAG_MATURITY_INSTRCTN_TYP_CD   VARCHAR2(10 CHAR),
  PRAG_BAL_AMT_MATURITY_CCY       NUMBER(16,4),
  PRAG_BAL_AMT_MATURITY           NUMBER(16,4),
  PRAG_MKT_VAL_VAR_GIC_AMT_CCY    NUMBER(16,4),
  PRAG_MKT_VAL_VAR_GIC_AMT        NUMBER(16,4),
  PRAG_INT_ACCRUED_AMT_CCY        NUMBER(16,4),
  PRAG_INT_ACCRUED_AMT            NUMBER(16,4),
  PRAG_CURR_PROM_CD               VARCHAR2(10 CHAR),
  PRAG_CURR_PROM_START_DT         DATE,
  PRAG_PREV_PROM_CD               VARCHAR2(10 CHAR),
  PRAG_PREV_PROM_START_DT         DATE,
  PRAG_PREV_PROM_END_DT           DATE,
  PRAG_LOC_TYP_CD                 VARCHAR2(10 CHAR) DEFAULT NULL,
  PRAG_CLOSING_REASON_TYP_CD      VARCHAR2(10 CHAR) DEFAULT NULL,
  REC_LAST_UPD_TM_DLT_NO_BAL      TIMESTAMP(6),
  PRAG_INTER_ACCESS_TYP_CD        VARCHAR2(10 CHAR) DEFAULT NULL
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   10
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBPRAG_PRDT_AGMT IS 'Représente la détention par le client d''un produit ou d''un service offerts par la Banque Nationale Groupe Financier.
GRANULARITÉ: Chaque Entente de produit.
IDENTIFIANT NATUREL: Code désignant le système source, Clé naturelle de l''entente de produit dans le système source.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_TYPE_CD IS 'Référence au Code désignant le type d''entente de produit (Investissement, financement, ...)';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.LGPR_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.AGMT_TYPE_CD IS 'Référence au Code désignant le type d''entente de produit (Investissement, financement, ...)';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_EFFCTV_DT IS 'Date à laquelle l''entente de produit a été ouverte dans le système.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_END_DT IS 'Date à laquelle l''entente de produit a été fermée dans le système.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_MTGG_LOAN_GRP_NO IS 'Lorsqu''il s''agit d''une entente de prêt hypothécaire, il s''agit du numéro permettant de regrouper les tranches hypothécaires qui financent une même propriété. Concrètement il s''agit du numéro de compte de l''application PH.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_LIFE_CYCLE_STATUS_CD IS 'Référence au Code désignant le statut de l''entente de produit (ouvert, fermé, gelé, etc.)';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_BAL_AMT IS 'The product agreement balance, normalized in CAD';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_CREDIT_LIMIT_AMT IS 'The product agreement credit limit, normalized in CAD';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_CASH_ADV_LIMIT_AMT IS 'The product agreement cash advance limit, normalized in CAD';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_CUR_CD IS 'Identifiant de la devise de l''entente, correspond au code ISO de la devise. Tous les montants exprimés en devise originale de l''entente sont dans cette devise';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_BAL_AMT_CCY IS 'The product agreement balance, in it''s original currency';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_CREDIT_LIMIT_AMT_CCY IS 'The product agreement credit limit, in it''s original currency';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_CASH_ADV_LIMIT_AMT_CCY IS 'The product agreement cash advance limit, in it''s original currency';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_SRC_CD IS 'Code identifying the source system where the Product Agreement comes from';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_SRC_KEY IS 'What make a Product Agreement Member unique in the source system';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_SIGNAT_REQRD_CNT IS 'Number of signatures required to make an operation on this product agreement';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_SIGNAT_SPECIFIC_CONDT_DSC IS 'Free texte describing the specific conditions applied with the signature';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_SIGNAT_CONDT_PAPER_FLG IS 'Flag indicating if signature conditions are maintained on paper (in customer folder into a branch)';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.REC_LAST_UPD_TM_MQ IS 'The timestamp of the last update of the record in this table - used for MQ serie delta process';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.LPVG_ID IS 'Legacy Product Variable GIC Id';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_INTEREST_CALCLTN_TYP_CD IS 'The product agreement interest calculation type code for a CIG. Simple or Compounded';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_FREQ_INT_CAL_TYP_CD IS 'The product agreement frequency interest calculation type code.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_INT_COMP_FREQ_TYP_CD IS 'The product agreement interest composition frequency type code.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_MATURITY_INSTRCTN_TYP_CD IS 'The product agreement maturity instruction type code';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_BAL_AMT_MATURITY_CCY IS 'The product agreement balance amount in original currency at maturity.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_BAL_AMT_MATURITY IS 'The product agreement balance amount in CAD at maturity.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_MKT_VAL_VAR_GIC_AMT_CCY IS 'The product agreement market value amount in original currency for variable GIC manufactured by NBC.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_MKT_VAL_VAR_GIC_AMT IS 'The product agreement market value amount in CAD currency for variable GIC manufactured by NBC.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_INT_ACCRUED_AMT_CCY IS 'The product agreement interest accrued amount in original currency';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_INT_ACCRUED_AMT IS 'The product agreement interest accrued amount in CAD currency';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_LOC_TYP_CD IS 'The line of credit type code. In CO it defined the type of line of credit : REER, Étudiant, ...';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_CLOSING_REASON_TYP_CD IS 'The closing reason of the agreement.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.REC_LAST_UPD_TM_DLT_NO_BAL IS 'The timestamp of the last update of the record in this table doing the delta without considering the Balance Field. Than the record could have a most recent REC_LAST_UDP_TM because of a balance change but this timestamp wont be updated until an attribute other than a balances fields as change.';

COMMENT ON COLUMN __SCHEMA__.TBPRAG_PRDT_AGMT.PRAG_INTER_ACCESS_TYP_CD IS 'An attribute for operational account describing the type of Inter Access of the account between Branch';


CREATE INDEX __SCHEMA__."BIN$UhtjvMHWAobgUwpEHj+wbA==$0" ON __SCHEMA__.TBPRAG_PRDT_AGMT
(PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   20
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   20
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE INDEX __SCHEMA__."BIN$UhtjvMHXAobgUwpEHj+wbA==$0" ON __SCHEMA__.TBPRAG_PRDT_AGMT
(AGMT_TYPE_CD, PRAG_SRC_KEY)
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
PARALLEL ( DEGREE 16 INSTANCES 1 );

CREATE INDEX __SCHEMA__."BIN$UhtjvMHYAobgUwpEHj+wbA==$0" ON __SCHEMA__.TBPRAG_PRDT_AGMT
(LGPR_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__."BIN$UhtjvMHZAobgUwpEHj+wbA==$0" ON __SCHEMA__.TBPRAG_PRDT_AGMT
("PRAG_SRC_CD"||"PRAG_SRC_KEY")
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   4
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_PRAG_01 ON __SCHEMA__.TBPRAG_PRDT_AGMT
(REC_LAST_UPD_SRC_CD, PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              INITIAL          16K
              NEXT             256K
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          16K
                NEXT             256K
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPRAG_PRDT_AGMT
 ADD CONSTRAINT PK_PRAG_01
  PRIMARY KEY
  (REC_LAST_UPD_SRC_CD, PRAG_ID)
  RELY
  USING INDEX LOCAL;

CREATE TABLE __SCHEMA__.TBPRDT_PRODUCT
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM        TIMESTAMP(6),
  REC_LAST_UPD_USER_ID   VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  PRDT_ID                VARCHAR2(70 BYTE)      NOT NULL,
  PRDT_SRC_CD            VARCHAR2(10 CHAR)      NOT NULL,
  PRDT_SRC_KEY           VARCHAR2(60 CHAR)      NOT NULL,
  PRDT_FR_ABREV_NAME     VARCHAR2(100 CHAR),
  PRDT_EN_ABREV_NAME     VARCHAR2(100 CHAR),
  PRDT_EFFCTV_DT         DATE,
  PRDT_END_DT            DATE,
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE),
  PRDT_TYPE_CD           VARCHAR2(100 CHAR)     DEFAULT NULL                  NOT NULL,
  PRDT_DOMAIN_CD         VARCHAR2(100 CHAR)     DEFAULT NULL                  NOT NULL,
  PRDT_LEVEL_CD          VARCHAR2(100 CHAR)     DEFAULT NULL                  NOT NULL,
  PRDT_FR_NAME           VARCHAR2(100 CHAR),
  PRDT_EN_NAME           VARCHAR2(100 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_SRC_CD IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_SRC_KEY IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_FR_ABREV_NAME IS 'Lorsqu''il s''agit d''une entente de prêt hypothécaire, il s''agit du numéro permettant de regrouper les tranches hypothécaires qui financent une même propriété. Concrètement il s''agit du numéro de compte de l''application PH.';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_EN_ABREV_NAME IS 'Lorsqu''il s''agit d''une entente de prêt hypothécaire, il s''agit du numéro permettant de regrouper les tranches hypothécaires qui financent une même propriété. Concrètement il s''agit du numéro de compte de l''application PH.';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_EFFCTV_DT IS 'Date à laquelle l''entente de produit a été ouverte dans le système.';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_END_DT IS 'Date à laquelle l''entente de produit a été fermée dans le système.';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_TYPE_CD IS 'Product Type Code';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_DOMAIN_CD IS 'Product Domain Code';

COMMENT ON COLUMN __SCHEMA__.TBPRDT_PRODUCT.PRDT_LEVEL_CD IS 'Product Level Code';


CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_01 ON __SCHEMA__.TBPRDT_PRODUCT
(PRDT_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPRDT_PRODUCT
 ADD CONSTRAINT PK_PRDT_01
  PRIMARY KEY
  (PRDT_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_01;

CREATE TABLE __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP
(
  LAST_EVT_TM                TIMESTAMP(6),
  LAST_EVT_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM            TIMESTAMP(6),
  REC_LAST_UPD_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID      NUMBER(12),
  REC_LAST_UPD_SRC_CD        VARCHAR2(4 CHAR)   NOT NULL,
  PRAG_ID                    VARCHAR2(70 CHAR)  NOT NULL,
  PYMPA_PTYMBR_SRC_CD        VARCHAR2(10 CHAR)  NOT NULL,
  PYMPA_PTYMBR_SRC_NTRL_KEY  VARCHAR2(60 CHAR)  NOT NULL,
  PYMPA_TYPE_CD              VARCHAR2(12 CHAR)  NOT NULL,
  PYMPA_START_DT             DATE,
  PYMPA_END_DT               DATE
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
NOCACHE
PARALLEL ( DEGREE 16 INSTANCES 1 )
MONITORING;

CREATE INDEX __SCHEMA__.IN_PYMPA_02 ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP
(PRAG_ID)
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
PARALLEL ( DEGREE 16 INSTANCES 1 );

CREATE INDEX __SCHEMA__.IN_PYMPA_03 ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP
(PYMPA_PTYMBR_SRC_CD, PYMPA_PTYMBR_SRC_NTRL_KEY)
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
PARALLEL ( DEGREE 16 INSTANCES 1 );

CREATE UNIQUE INDEX __SCHEMA__.PK_PYMPA_01 ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP
(PRAG_ID, PYMPA_PTYMBR_SRC_CD, PYMPA_PTYMBR_SRC_NTRL_KEY, PYMPA_TYPE_CD, REC_LAST_UPD_SRC_CD)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   2
  MAXTRANS   255
  STORAGE    (
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP
 ADD CONSTRAINT PK_PYMPA_01
  PRIMARY KEY
  (PRAG_ID, PYMPA_PTYMBR_SRC_CD, PYMPA_PTYMBR_SRC_NTRL_KEY, PYMPA_TYPE_CD, REC_LAST_UPD_SRC_CD)
  USING INDEX LOCAL;

CREATE TABLE __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP
(
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 BYTE),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE)       NOT NULL,
  CUR_EID                NUMBER(19)             NOT NULL,
  OGUN_ID                VARCHAR2(70 BYTE)      NOT NULL,
  PYOGP_DISTRBTR_SRC_CD  VARCHAR2(10 BYTE)      NOT NULL,
  PYOGP_SUBSDR_SRC_CD    VARCHAR2(10 BYTE)      NOT NULL,
  PYOGP_START_DT         DATE                   NOT NULL,
  PYOGP_END_DT           DATE
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP IS 'This entity make the relation between a Party with the Client Role and an Organisation Unit base on a set of business rule. The purpose is to determined the Priority Organisation Unit of a Client. A Client can only have one priority Organisation Unit by Legal Entity or Distribution Channel.

The source of this table is a table calculated in the EIN : DIM.TBD_POSPP_POS_PRIORTR_PCP

P. Rinfret 28 Janvier 2016';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.CUR_EID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.OGUN_ID IS 'The identifier of the organization unit in the system managing the organization unit. Those organization units are managed in GUA for the bank, and OSS for the trading. Key from OSS: OSS   RC   Rep code for a rep code OSS   BR   Branch code for a branch Key from GUA: GUA   Transit Code';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.PYOGP_DISTRBTR_SRC_CD IS 'Domain source from GUA

All GUA Distributor Code

Example :
001 Banque Nationale
014 Investor Group';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.PYOGP_SUBSDR_SRC_CD IS 'Domain source from GUA.

Liste of BNC subsidiary.

Example:
BNC
FBN
...';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.PYOGP_START_DT IS 'Effective start date of the relationship.';

COMMENT ON COLUMN __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP.PYOGP_END_DT IS 'Effective end date of the relationship.';


CREATE UNIQUE INDEX __SCHEMA__.PK_PYOGP ON __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP
(CUR_EID, PYOGP_START_DT, PYOGP_DISTRBTR_SRC_CD, PYOGP_SUBSDR_SRC_CD, OGUN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP
 ADD CONSTRAINT PK_PYOGP
  PRIMARY KEY
  (CUR_EID, PYOGP_START_DT, PYOGP_DISTRBTR_SRC_CD, PYOGP_SUBSDR_SRC_CD, OGUN_ID)
  USING INDEX __SCHEMA__.PK_PYOGP;

CREATE TABLE __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP
(
  PRAG_ID                    VARCHAR2(70 CHAR)  NOT NULL,
  CUR_ENT_ID                 NUMBER(19)         NOT NULL,
  PYPA_TYPE_CD               VARCHAR2(12 CHAR)  NOT NULL,
  PYPA_START_DT              DATE,
  PYPA_END_DT                DATE,
  LAST_EVT_TM                TIMESTAMP(6),
  LAST_EVT_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM            TIMESTAMP(6)       DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID      NUMBER(12),
  REC_LAST_UPD_SRC_CD        VARCHAR2(4 BYTE)   NOT NULL,
  PYPA_PTY_MBR_SRC_CD        VARCHAR2(10 CHAR)  NOT NULL,
  PYPA_PTY_MBR_SRC_NTRL_KEY  VARCHAR2(60 CHAR)  NOT NULL,
  PYPA_SIGNAT_TYP_CD         VARCHAR2(10 CHAR)  DEFAULT NULL
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   10
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    COMPRESS FOR OLTP 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   4
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 1 STORE IN (TSD_ODS)
)
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP IS '2012-03-12 Party Name changed by Entity - as requested by C.Bonnaud on 2012-03-12';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.PRAG_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.CUR_ENT_ID IS 'The unique identifier of the Party.
';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.PYPA_TYPE_CD IS 'A code which identifies the type of relationship.  There should be a different type for each combination of entity type:
CGINRL: Client Group / Individual Relationship
CGOGRL: Client Group / Organization Relationship';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.PYPA_START_DT IS 'Effective start date of the relationship.';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.PYPA_END_DT IS 'Effective end date of the relationship.';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.
';

COMMENT ON COLUMN __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP.PYPA_SIGNAT_TYP_CD IS 'The party relationship product agreement signature type code associated with the operational account.';


CREATE INDEX __SCHEMA__.ETL_PYPA_01 ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP
(PRAG_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   8
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE INDEX __SCHEMA__.IN_PYPA_01 ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP
(CUR_ENT_ID)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   8
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              BUFFER_POOL      DEFAULT
             )
LOGGING
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_MEMBER_MEMBER_RLTNP ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP
(REC_LAST_UPD_SRC_CD, PRAG_ID, CUR_ENT_ID, PYPA_TYPE_CD)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   4
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.PK_PYPA_01 ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP
(REC_LAST_UPD_SRC_CD, PRAG_ID, CUR_ENT_ID, PYPA_TYPE_CD, PYPA_START_DT)
  TABLESPACE TSD_ODS
  PCTFREE    10
  INITRANS   4
  MAXTRANS   255
  STORAGE    (
              INITIAL          64K
              NEXT             1M
              BUFFER_POOL      DEFAULT
             )
LOCAL (  
  PARTITION P_SRC_0005
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0016
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0022
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0025
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0026
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0057
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0084
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0085
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0087
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0091
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0116
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0358
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0371
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0638
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0641
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0643
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0704
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0790
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0796
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0960
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1111
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1393
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_PAIE
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0425
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_1578
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_0729
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS),  
  PARTITION P_SRC_2426
    NOLOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   8
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    STORE IN (TSD_ODS)
)
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP
 ADD CONSTRAINT PK_MEMBER_MEMBER_RLTNP
  PRIMARY KEY
  (REC_LAST_UPD_SRC_CD, PRAG_ID, CUR_ENT_ID, PYPA_TYPE_CD, PYPA_START_DT)
  USING INDEX LOCAL;

CREATE TABLE __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP_B
(
  PRAG_ID                    VARCHAR2(70 CHAR)  NOT NULL,
  CUR_ENT_ID                 NUMBER(19)         NOT NULL,
  PYPA_TYPE_CD               VARCHAR2(12 CHAR)  NOT NULL,
  PYPA_START_DT              DATE,
  PYPA_END_DT                DATE,
  LAST_EVT_TM                TIMESTAMP(6),
  LAST_EVT_USER_ID           VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM            TIMESTAMP(6),
  REC_LAST_UPD_USER_ID       VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID      NUMBER(12),
  REC_LAST_UPD_SRC_CD        VARCHAR2(4 BYTE)   NOT NULL,
  PYPA_PTY_MBR_SRC_CD        VARCHAR2(10 CHAR)  NOT NULL,
  PYPA_PTY_MBR_SRC_NTRL_KEY  VARCHAR2(60 CHAR)  NOT NULL
)
NOCOMPRESS 
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
PARTITION BY LIST (REC_LAST_UPD_SRC_CD)
SUBPARTITION BY HASH (PRAG_ID)
(  
  PARTITION P_SRC_0005 VALUES ('0005')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0016 VALUES ('0016')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0022 VALUES ('0022')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0025 VALUES ('0025')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0026 VALUES ('0026')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0057 VALUES ('0057')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0084 VALUES ('0084')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0085 VALUES ('0085')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0087 VALUES ('0087')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0091 VALUES ('0091')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0116 VALUES ('0116')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0358 VALUES ('0358')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0371 VALUES ('0371')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0638 VALUES ('0638')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0641 VALUES ('0641')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0643 VALUES ('0643')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0704 VALUES ('0704')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0790 VALUES ('0790')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0796 VALUES ('0796')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0960 VALUES ('0960')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_1111 VALUES ('1111')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_1393 VALUES ('1393')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_PAIE VALUES ('PAIE')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0425 VALUES ('0425')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_1578 VALUES ('1578')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_0729 VALUES ('0729')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS),  
  PARTITION P_SRC_2426 VALUES ('2426')
    LOGGING
    NOCOMPRESS 
    TABLESPACE TSD_ODS
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                MAXSIZE          UNLIMITED
                BUFFER_POOL      DEFAULT
               )
    SUBPARTITIONS 16 STORE IN (TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS,TSD_ODS)
)
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.TBSS_SRC_SYSTM
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 BYTE),
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 BYTE),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE),
  SS_SRC_SYSTM_ID        VARCHAR2(10 BYTE)      NOT NULL,
  SST_SRC_SYST_TYP_ID    VARCHAR2(10 BYTE)      NOT NULL,
  SS_NM_FR               VARCHAR2(100 BYTE),
  SS_NM_EN               VARCHAR2(100 BYTE)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBSS_SRC_SYSTM IS 'List of source systems that provide the data that is integrated in the ODS database.




';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.REC_LAST_UPD_USER_ID IS 'The userid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.REC_LAST_UPD_BATCH_ID IS 'The batchid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.REC_LAST_UPD_SRC_CD IS 'The update source code of the last update of the record in this table. Domain : BNGF system code from Casewise.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.SS_SRC_SYSTM_ID IS 'The unique identifier of the source system where the data comes from. Domain : casewise application number and extension for non BNC application (example : Intria).';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.SST_SRC_SYST_TYP_ID IS 'Unique identifier of the type of the source system where the data comes from: Channel, Operating System, Control System, etc.

CHNL/SYST: System that manages the interactions with the clients.
CNTRL/SYST: System that controls the validity of the client transactions.
OPER/SYST: System that manages the operations made to client accounts.
ADJ/SYST: System that manages adjustments to be posted to client accounts.
etc.
';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.SS_NM_FR IS 'Name in french of the Source System.';

COMMENT ON COLUMN __SCHEMA__.TBSS_SRC_SYSTM.SS_NM_EN IS 'Name in english of the Source System.';


CREATE UNIQUE INDEX __SCHEMA__.PK_SS_SRC ON __SCHEMA__.TBSS_SRC_SYSTM
(SS_SRC_SYSTM_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBSS_SRC_SYSTM
 ADD CONSTRAINT PK_SS_SRC
  PRIMARY KEY
  (SS_SRC_SYSTM_ID)
  USING INDEX __SCHEMA__.PK_SS_SRC;

CREATE TABLE __SCHEMA__.TBSST_SRC_SYSTM_TYP
(
  LAST_EVT_TM            TIMESTAMP(6),
  LAST_EVT_USER_ID       VARCHAR2(30 BYTE),
  REC_LAST_UPD_TM        TIMESTAMP(6)           DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID   VARCHAR2(30 BYTE),
  REC_LAST_UPD_BATCH_ID  NUMBER(12),
  REC_LAST_UPD_SRC_CD    VARCHAR2(4 BYTE),
  SST_SRC_SYST_TYP_ID    VARCHAR2(10 BYTE)      NOT NULL,
  SST_NM_FR              VARCHAR2(100 BYTE),
  SST_NM_EN              VARCHAR2(100 BYTE)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBSST_SRC_SYSTM_TYP IS 'Source System Type classifies the source system.




';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.REC_LAST_UPD_USER_ID IS 'The userid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.REC_LAST_UPD_BATCH_ID IS 'The batchid of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.REC_LAST_UPD_SRC_CD IS 'The update source code of the last update of the record in this table. Domain : BNGF system code from Casewise.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.SST_SRC_SYST_TYP_ID IS 'Unique identifier of the type of the source system where the data comes from: Channel, Operating System, Control System, etc.

CHNL/SYST: System that manages the interactions with the clients.
CNTRL/SYST: System that controls the validity of the client transactions.
OPER/SYST: System that manages the operations made to client accounts.
ADJ/SYST: System that manages adjustments to be posted to client accounts.
etc.
';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.SST_NM_FR IS 'Name in french of the Source System Type.';

COMMENT ON COLUMN __SCHEMA__.TBSST_SRC_SYSTM_TYP.SST_NM_EN IS 'Name in english of the Source System Type.';


CREATE UNIQUE INDEX __SCHEMA__.PK_SST_SRC ON __SCHEMA__.TBSST_SRC_SYSTM_TYP
(SST_SRC_SYST_TYP_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBSST_SRC_SYSTM_TYP
 ADD CONSTRAINT PK_SST_SRC
  PRIMARY KEY
  (SST_SRC_SYST_TYP_ID)
  USING INDEX __SCHEMA__.PK_SST_SRC;

CREATE TABLE __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS
(
  REC_LAST_UPD_TM         TIMESTAMP(6)          DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID    VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID   NUMBER(12),
  REC_LAST_UPD_SRC_CD     VARCHAR2(4 CHAR),
  SYSDF_DATA_TARGET_NAME  VARCHAR2(40 CHAR)     NOT NULL,
  SYSDF_DATA_SRC_CD       VARCHAR2(10 CHAR)     NOT NULL,
  SYSDF_DATA_LOGICAL_DT   DATE                  NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
COMPRESS FOR OLTP 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS IS 'System table that contain the logical date of the data freshness.';

COMMENT ON COLUMN __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS.SYSDF_DATA_TARGET_NAME IS 'System Data Freshness Data Target Name (in EINUTL NOM_CIBL)';

COMMENT ON COLUMN __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS.SYSDF_DATA_SRC_CD IS 'System Data Freshness Data Source Code : the system source code to be track for the data freshness (Code System Source)';

COMMENT ON COLUMN __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS.SYSDF_DATA_LOGICAL_DT IS 'System Data Freshness Logical Date';


CREATE UNIQUE INDEX __SCHEMA__.PK_TBSYSDF ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS
(SYSDF_DATA_TARGET_NAME, SYSDF_DATA_SRC_CD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   4
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS
 ADD CONSTRAINT PK_TBSYSDF
  PRIMARY KEY
  (SYSDF_DATA_TARGET_NAME, SYSDF_DATA_SRC_CD)
  RELY
  USING INDEX __SCHEMA__.PK_TBSYSDF;

CREATE TABLE __SCHEMA__.VALUE
(
  VID                      NUMBER(12)           NOT NULL,
  VALUE_DMN_ID             NUMBER(12)           NOT NULL,
  VALUE_CD                 VARCHAR2(100 CHAR)   NOT NULL,
  VALUE_NM                 VARCHAR2(100 CHAR)   NOT NULL,
  VALUE_AN                 VARCHAR2(25 CHAR),
  VALUE_DEFAULT_VALUE_IND  VARCHAR2(10 CHAR),
  VALUE_EFF_DT             DATE,
  VALUE_END_DT             DATE,
  VALUE_DESC               VARCHAR2(255 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.VALUE IS 'The entity Value contains the values that belong to each Value Domain used at the BNGF.  All the values here are defined in French.';

COMMENT ON COLUMN __SCHEMA__.VALUE.VID IS 'Unique identifier of the Value.';

COMMENT ON COLUMN __SCHEMA__.VALUE.VALUE_DMN_ID IS 'The identifier of the Value Domain the value code belongs to.
';

COMMENT ON COLUMN __SCHEMA__.VALUE.VALUE_CD IS 'The Value Code is a ''meaningful'' mnemonic code in French for the Value.
';

COMMENT ON COLUMN __SCHEMA__.VALUE.VALUE_AN IS 'The Value Abbreviated Name in French.
';

COMMENT ON COLUMN __SCHEMA__.VALUE.VALUE_EFF_DT IS 'The date from which an instance of the value is used.';

COMMENT ON COLUMN __SCHEMA__.VALUE.VALUE_END_DT IS 'The Calendar date after which an instance of the entity is no longer used.';

COMMENT ON COLUMN __SCHEMA__.VALUE.VALUE_DESC IS 'The Value Description in French.
';


CREATE UNIQUE INDEX __SCHEMA__.PK_VALUE ON __SCHEMA__.VALUE
(VID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE UNIQUE INDEX __SCHEMA__.VALUE_AK ON __SCHEMA__.VALUE
(VALUE_CD, VALUE_DMN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.VALUE_VALUE_DOMAIN_FK ON __SCHEMA__.VALUE
(VALUE_DMN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.VALUE
 ADD CONSTRAINT PK_VALUE
  PRIMARY KEY
  (VID)
  USING INDEX __SCHEMA__.PK_VALUE;

CREATE TABLE __SCHEMA__.VALUE_DOMAIN
(
  VALUE_DOMAIN_ID           NUMBER(12)          NOT NULL,
  VALUE_DOMAIN_CD           VARCHAR2(10 CHAR),
  VALUE_DMN_NM              VARCHAR2(100 CHAR),
  VALUE_DMN_AN              VARCHAR2(25 CHAR),
  VALUE_DMN_CAT_ID          NUMBER(12),
  VALUE_DMN_NBFG_STD_FLG    VARCHAR2(10 CHAR),
  VALUE_DMN_STD_URL         VARCHAR2(255 CHAR),
  VALUE_DMN_DESC            VARCHAR2(255 CHAR),
  VALUE_DMN_TECHNICAL_DESC  VARCHAR2(255 CHAR),
  EFF_DT                    DATE,
  END_DT                    DATE
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.VALUE_DOMAIN IS 'The Value Domain entity contains the list of data domains used at BNGF.  A Value Domain is essentially a list of values.  For example, the Value Domain ISO 3166-1 Alpha-2 Country contains the list of countries.';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.VALUE_DOMAIN_ID IS 'Unique identifier of the Value domain.
';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.VALUE_DOMAIN_CD IS 'The defined mnemonic for the Value Domain, for example ''MAR'' for Marital Status.
';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.VALUE_DMN_AN IS 'Abbreviated Name of the Value Domain.';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.VALUE_DMN_CAT_ID IS 'Identifier of the Value Domain Category of the Value Domain.  For example, the value domain
ISO 3166-1 Alpha-2 Country belong to the category Country.';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.VALUE_DMN_DESC IS 'Provides a textual explanation or free form comments about the Value Domain.';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.VALUE_DMN_TECHNICAL_DESC IS 'Provides a textual explanation or free form technical description about the Value Domain.';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.EFF_DT IS 'The date from which the Value Domain is used.';

COMMENT ON COLUMN __SCHEMA__.VALUE_DOMAIN.END_DT IS 'The Calendar date after which the Value Domain is no longer used.';


CREATE UNIQUE INDEX __SCHEMA__.PK_VALUE_DOMAIN ON __SCHEMA__.VALUE_DOMAIN
(VALUE_DOMAIN_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.VALUE_DOMAIN_AK ON __SCHEMA__.VALUE_DOMAIN
(VALUE_DOMAIN_CD)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.VALUE_DOMAIN
 ADD CONSTRAINT PK_VALUE_DOMAIN
  PRIMARY KEY
  (VALUE_DOMAIN_ID)
  USING INDEX __SCHEMA__.PK_VALUE_DOMAIN;

CREATE TABLE __SCHEMA__.VALUE_TRANSLATION
(
  VID                       NUMBER(12)          NOT NULL,
  LANG_ID                   NUMBER(12)          NOT NULL,
  VALUE_TRANSLATION_CD      VARCHAR2(100 CHAR),
  VALUE_TRANSLATION_AN      VARCHAR2(25 CHAR),
  VALUE_TRANSLATION_NM      VARCHAR2(100 CHAR),
  VALUE_TRANSLATION_DESC    VARCHAR2(255 CHAR),
  VALUE_TRANSLATION_EFF_DT  DATE,
  VALUE_TRANSLATION_END_DT  DATE,
  VALUE_DEFAULT_VALUE_IND   VARCHAR2(10 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.VALUE_TRANSLATION IS 'The entity Value Translation contains the translation of the Values in a language different than French.  Currently, we will only find translations here in English.
';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.VID IS 'Identifier of the Value we are translating.
';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.LANG_ID IS 'Identifier of the translation language (the "to" language).';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.VALUE_TRANSLATION_AN IS 'The translated Value Abbreviated Name in the translation language.';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.VALUE_TRANSLATION_NM IS 'The translated Value Name in the translation language.
';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.VALUE_TRANSLATION_DESC IS 'The translated Value Description in the translation language.';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.VALUE_TRANSLATION_EFF_DT IS 'The date from which an instance of the tanslated value is used.';

COMMENT ON COLUMN __SCHEMA__.VALUE_TRANSLATION.VALUE_TRANSLATION_END_DT IS 'The Calendar date after which an instance of the tanslated value is no longer used.';


CREATE UNIQUE INDEX __SCHEMA__.PK_VALUE_TRANSLATION ON __SCHEMA__.VALUE_TRANSLATION
(VID, LANG_ID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.VALUE_TRANSLATION_VALUE_FK ON __SCHEMA__.VALUE_TRANSLATION
(VID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.VALUE_TRANSLATION
 ADD CONSTRAINT PK_VALUE_TRANSLATION
  PRIMARY KEY
  (VID, LANG_ID)
  USING INDEX __SCHEMA__.PK_VALUE_TRANSLATION;

CREATE TABLE __SCHEMA__.VALUE_VALUE_RLTNP
(
  VID_SRC               NUMBER(12)              NOT NULL,
  VID_TARGET            NUMBER(12)              NOT NULL,
  VALUE_MAPPING_EFF_DT  DATE,
  VALUE_MAPPING_END_DT  DATE
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE __SCHEMA__.VALUE_VALUE_RLTNP IS 'The entity Value / Value Relationship is used to define the mapping between the values of different Value Domains.  This mapping is used to normalize a value from a source Value Domain to a target Value Domain, and to denormalize a value from a target Value Domain to a source Data Domain.';

COMMENT ON COLUMN __SCHEMA__.VALUE_VALUE_RLTNP.VALUE_MAPPING_EFF_DT IS 'The date from which the mapping  is valid.';

COMMENT ON COLUMN __SCHEMA__.VALUE_VALUE_RLTNP.VALUE_MAPPING_END_DT IS 'The Calendar date after which an instance of the mapping is no longer valid.';


CREATE UNIQUE INDEX __SCHEMA__.PK_VALUE_VALUE_RLTNP ON __SCHEMA__.VALUE_VALUE_RLTNP
(VID_SRC, VID_TARGET)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.VALUE_VALUE_SRC_FK ON __SCHEMA__.VALUE_VALUE_RLTNP
(VID_SRC)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX __SCHEMA__.VALUE_VALUE_TARGET_FK ON __SCHEMA__.VALUE_VALUE_RLTNP
(VID_TARGET)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE __SCHEMA__.VALUE_VALUE_RLTNP
 ADD CONSTRAINT PK_VALUE_VALUE_RLTNP
  PRIMARY KEY
  (VID_SRC, VID_TARGET)
  USING INDEX __SCHEMA__.PK_VALUE_VALUE_RLTNP;

CREATE TABLE __SCHEMA__.VERSION_SCHEMA
(
  MAJOR                 NUMBER(3)               NOT NULL,
  INTER                 NUMBER(3)               NOT NULL,
  MINOR                 NUMBER(3)               NOT NULL,
  INSTALLED_DT          DATE                    DEFAULT sysdate               NOT NULL,
  INSTALLED_BY          VARCHAR2(100 CHAR)      DEFAULT SYS_CONTEXT('USERENV','OS_USER') || ' - ' || user NOT NULL,
  REC_LAST_UPD_TM       TIMESTAMP(6)            DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID  VARCHAR2(30 CHAR)       DEFAULT SYS_CONTEXT('USERENV','OS_USER') || ' - ' || user,
  DESCRIPTION           VARCHAR2(2000 CHAR)
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.WORK_CDI_MCP_INITIAL_LOAD
(
  WORK_SRC_NK  VARCHAR2(60 CHAR)                NOT NULL,
  WORK_SRC_CD  VARCHAR2(12 CHAR)                NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE TABLE __SCHEMA__.WORK_CDI_RECONCILIATION
(
  CUR_EID   NUMBER(19)                          NOT NULL,
  MEMIDNUM  VARCHAR2(60 CHAR)                   NOT NULL,
  SRCCODE   VARCHAR2(12 CHAR)                   NOT NULL
)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE INDEX __SCHEMA__.WORK_CDI_RECONCIL_NDX1 ON __SCHEMA__.WORK_CDI_RECONCILIATION
(CUR_EID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE SEQUENCE __SCHEMA__.SEQ_CDI_AUDIT
  START WITH 86979685
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SEQ_LPVG_ID
  START WITH 38381
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SEQ_PAACT_ID
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE OR REPLACE PACKAGE __SCHEMA__.ODS_PKG AS

FUNCTION GET_CLEAN_PATTERN
  RETURN VARCHAR2;

FUNCTION CLEAN_SPECIAL_CHARS_FOR_REPORT(
    p_value IN VARCHAR2)
  RETURN VARCHAR2;

FUNCTION CLEAN_ID_ITM_DOC_NO(
    P_VALUE IN PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_NO%TYPE)
  RETURN VARCHAR2;

END ODS_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY __SCHEMA__.ODS_PKG AS

  /*
  * Regex Pattern used to clean column content for reporting an search purpose.
  */
  CLEAN_PATTERN VARCHAR2(30) := '[-| \/.\\*#;=+><&,''@]';

FUNCTION GET_CLEAN_PATTERN
  RETURN VARCHAR2
AS
BEGIN
  RETURN CLEAN_PATTERN;
END;

FUNCTION CLEAN_SPECIAL_CHARS_FOR_REPORT(
    p_value IN VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN REGEXP_REPLACE(p_value, CLEAN_PATTERN);
END;

FUNCTION CLEAN_ID_ITM_DOC_NO(
    P_VALUE IN PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_NO%TYPE)
  RETURN VARCHAR2
AS
  TEMP PGR_INDIVIDUAL_IDENT.ID_ITM_DOC_NO%TYPE := P_VALUE;
BEGIN
  --Prefixes
  TEMP := REGEXP_REPLACE(TEMP, '^(EXP[^ ]*)(.*)', '\2');
  TEMP := REGEXP_REPLACE(TEMP, '^(NO DOC[ ]*:*|99:|DL[ ]*:|9999[ ]+REF:|BE:|#*[ ]*FCC.*:|SED[ ]*:|FATHER:|CIS:|SFN:|RÉF:|NO INSCRIPTION:|ID CLIENT:|MERE:|ID:|BCID[ ]*:|BCDL:|51 NO:|LDL:|CIS#:|PERE:|NI:|INS:|NO. EMPLOYE:|CER:|SIN:|N:|NO INSC:|04:|DOC:|DRIVER_LICENSE:|REF:|IUC[ ]*:|UCI:|C-ID:|D/N[ ]*:|DI:|CSQ:|NO D''INSCRIPTION:|NDL:|NUMIC :|MARRIAGE LICENSE #:|ID|CERT:|CLT ID:|ACC #:|I[.]D[.]|PASSEPORT|REGISTRATION #)', '');
  --Suffixes
  TEMP := REGEXP_REPLACE(TEMP, '(.*)\(.*\).*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}.*)[ ]*(NO|N.|NDE)[ ]*DOC.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}.*)[ ]*PASS.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}.*)[ ]*FILE#.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!E:)*) E:.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!EX)*)EX.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!ÉC)*)ÉC.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!ECH)*)ECH.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!ESP)*)ESP.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!XP)*) XP.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!PERMI)*) PERMI.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!WORK)*) WORK.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!REG)*) REG.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!XY:)*) XY:.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!ID)*) ID.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!GROUP)*) GROUP.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!#)*) #.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!IUC)*) IUC.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!IMM)*)IMM.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!EPX)*) EPX.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!CDN)*)CDN.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!REF)*) REF.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!PERS)*) PERS.*', '\1');
  TEMP := REGEXP_REPLACE(TEMP, '(.{6}(?!DOSS)*)DOSS.*', '\1');
  --Remove tailing dates
  TEMP := REGEXP_REPLACE(TEMP, '^(.{6}.*)[ ]+(\d{4}(-|/| |\\)\d{2}((-|/| |\\)\d{2})*|\d{2](-|/| |\\)\d{2}|(\d{2}(-|/| |\\))*\d{2}(-|/| |\\)\d{4})[ ]*$', '\1');
  RETURN CLEAN_SPECIAL_CHARS_FOR_REPORT(TEMP);
END;

END ODS_PKG;
/

SHOW ERRORS;

CREATE OR REPLACE PROCEDURE __SCHEMA__.drop_old_partitions(p_table_owner varchar2, p_table_name varchar2, p_semaines number, status_cd out number, status_msg out varchar2) is

table_name  varchar2(30);
partition_name varchar2(30);
V_HIGHVALUE varchar2(200);
v_part_date varchar2(50);
NO_PARTS exception;
num_parts number := 0;

cursor c_partitions is
select table_name, partition_name, high_value
from user_tab_partitions
where table_name = p_table_name
  and partition_name like 'SYS%'
order by partition_name;

begin

dbms_output.put_line('Cutoff date: '||trunc(sysdate - (p_semaines*7)));

open c_partitions;

fetch c_partitions into table_name, partition_name, v_highvalue;

if c_partitions%NOTFOUND
then
  close c_partitions;
  raise NO_PARTS;
end if;

while c_partitions%FOUND loop

v_part_date := substr(v_highvalue,12,10);

if to_date(v_part_date, 'YYYY-MM-DD') < trunc(sysdate - (p_semaines*7) ) then
  dbms_output.put_line('Owner: '||p_table_owner||' Tab name: '||table_name||' partition name: '||partition_name||' high value: '||v_highvalue||' part date: '||v_part_date);
  execute immediate 'alter table '||p_table_owner||'.'||table_name||' drop partition '||partition_name||' update global indexes';
  num_parts := num_parts + 1;
end if;

fetch c_partitions into table_name, partition_name, v_highvalue;

end loop;

status_msg := num_parts || ' partitions for table ' || p_table_owner  || '.' || p_table_name || ' have been removed';
status_cd := 0;

close c_partitions;

EXCEPTION
WHEN NO_PARTS THEN
    status_msg := 'No partitions for ' || p_table_owner  || '.' || p_table_name || ' found!';
    status_cd := 1;
WHEN OTHERS THEN
    status_msg :=  SUBSTR(SQLERRM, 1, 220);
    status_cd := 2;
end;
/

SHOW ERRORS;

CREATE OR REPLACE PROCEDURE __SCHEMA__.mdm_load_tmp_tables is
begin

execute immediate 'truncate table MDM_TMP1_CLIENT_CUR_EID';
execute immediate 'truncate table MDM_TMP2_CLIENT_AGR_PRD_RLTN';

insert /*+ APPEND */ into MDM_TMP1_CLIENT_CUR_EID
WITH PYPA AS (
SELECT T1.CUR_ENT_ID AS CUR_EID, 
    T1.PYPA_PTY_MBR_SRC_CD AS LFCLL_SRC_CD_EIN, 
    T1.PYPA_PTY_MBR_SRC_NTRL_KEY AS LFCLL_SRC_NK, 
    ROW_NUMBER() OVER (PARTITION BY T1.PYPA_PTY_MBR_SRC_CD, T1.PYPA_PTY_MBR_SRC_NTRL_KEY ORDER BY 
    T1.PYPA_PTY_MBR_SRC_NTRL_KEY ASC, T1.CUR_ENT_ID DESC, T1.PYPA_END_DT DESC) AS RN
FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP T1
INNER JOIN ENTITY_MEMBERS T2
  ON T1.CUR_ENT_ID = T2.CUR_EID )
SELECT  T1.LFCLL_SRC_CD_EIN, 
        T1.LFCLL_SRC_NK, 
        T1.CUR_EID
FROM PYPA T1
INNER JOIN MDM_LFCLL_CLIENT_LIST T2
    ON T1.LFCLL_SRC_CD_EIN = T2.LFCLL_SRC_CD_EIN
    AND T1.LFCLL_SRC_NK = T2.LFCLL_SRC_NK
WHERE T1.RN = 1;

commit;

insert /*+ APPEND */ into MDM_TMP2_CLIENT_AGR_PRD_RLTN
WITH PYPA_PAOU AS (
SELECT DISTINCT py.CUR_ENT_ID AS CUR_EID,
       py.PYPA_PTY_MBR_SRC_NTRL_KEY AS SRC_NK,
       py.PYPA_PTY_MBR_SRC_CD AS SRC_CD,
       py.PYPA_TYPE_CD AS TYPEENTENTE,
       TO_CHAR(py.PYPA_START_DT, 'YYYY-MM-DD HH24:MI:SS') AS EFF_DT,
       TO_CHAR(py.PYPA_END_DT, 'YYYY-MM-DD HH24:MI:SS') AS END_DT,
       py.PYPA_PTY_MBR_SRC_CD AS SYSTEMESOURCE,
       py.PRAG_ID,
       paou.OGUN_ID,
       paou.PAOU_TYPE_CD,
       CASE PAOU_TYPE_CD 
           WHEN 'COMPTBL' THEN 1
           WHEN 'DETNTN' THEN 2
           ELSE 3
       END AS ORDERTYPE
FROM MDM_TMP1_CLIENT_CUR_EID T1
INNER JOIN TBPYPA_PARTY_PRDT_AGMT_RLTNP py
    ON T1.CUR_EID = py.CUR_ENT_ID
INNER JOIN TBPAOU_PRAG_ORG_UNIT_RLTNP paou
    ON py.PRAG_ID = paou.PRAG_ID
WHERE paou.PAOU_TYPE_CD <> 'OUVRTR'
), SUBS_SET AS (
SELECT  CUR_EID, 
        SRC_NK, 
        SRC_CD, 
        TYPEENTENTE, 
        EFF_DT, 
        END_DT, 
        SYSTEMESOURCE, 
        PRAG_ID, 
        OGUN_ID, 
        PAOU_TYPE_CD, 
        ROW_NUMBER() OVER (PARTITION BY SRC_NK, SRC_CD, PRAG_ID, OGUN_ID ORDER BY ORDERTYPE ASC) AS RN
FROM PYPA_PAOU)
SELECT CUR_EID, 
        SRC_NK, 
        SRC_CD, 
        TYPEENTENTE, 
        EFF_DT, 
        END_DT, 
        SYSTEMESOURCE, 
        PRAG_ID, 
        OGUN_ID, 
        PAOU_TYPE_CD
FROM SUBS_SET WHERE RN = 1;

commit;

end;
/

SHOW ERRORS;

CREATE OR REPLACE PROCEDURE __SCHEMA__.pr_update_lifecycle (in_src_cd varchar2, in_num_rows number) as

v_party_org  varchar2(32000);
v_xml_type    xmltype;

cursor c_party_eid (c_in_num_rows number) is
  select distinct pmou.cur_eid, e.ent_type, e.xsd_version, e.mdm_data_category
  from pgr_member_organization_unit pmou,
       entity e
  where pmou.cur_eid = e.cur_eid
    and pmou.MEM_ORG_UNIT_RLTNP_TYPE_VCD = 'UAPD'
    and e.last_evt_user_id != 'DATAFIX2'
    and rownum <= c_in_num_rows;

cursor c_party_org_list (c_cur_eid number) is
  select pmou.cur_eid, pmou.mem_org_unit_rltnp_type_vcd, pmou.org_unit_type_vcd, pmou.org_unit_cd
  from pgr_member_organization_unit pmou
  where pmou.cur_eid = c_cur_eid;

begin

-- fetch cur_eid and loop

for c_party_eid_rec in c_party_eid(in_num_rows)
loop

		-- open party member list TAG
		v_party_org := '<PartyOrganizationUnitList>';

				-- loop and add tags
				for c_party_org_list_rec in c_party_org_list(c_party_eid_rec.cur_eid)
				loop
				v_party_org := v_party_org||'<PartyOrganizationUnit><ns2:ptyOrgUnitTypeCd>'||c_party_org_list_rec.mem_org_unit_rltnp_type_vcd||'</ns2:ptyOrgUnitTypeCd>';
				v_party_org := v_party_org||'<ns2:orgUnitTypeCd>'||c_party_org_list_rec.org_unit_type_vcd||'</ns2:orgUnitTypeCd>';
				v_party_org := v_party_org||'<ns2:orgUnitCd>'||c_party_org_list_rec.org_unit_cd||'</ns2:orgUnitCd></PartyOrganizationUnit>';
				end loop;

		-- close life cycle xml TAG
		v_party_org := v_party_org || '</PartyOrganizationUnitList>';

		if v_party_org = '<PartyOrganizationUnitList></PartyOrganizationUnitList>' then
		v_party_org := '';
		end if;

		select xmltype(replace(deleteXML(xml_data, '/ns2:Individual/PartyOrganizationUnitList','xmlns:ns2="http://www.nbfg.ca/ClientServices"').getClobVal(),
                                      '</PartyMemberList>','</PartyMemberList>'||v_party_org)) into v_xml_type
		from entity
		where cur_eid = c_party_eid_rec.cur_eid for update;

		update entity
		  set xml_data = v_xml_type,
							   GOLDEN_REC_HASH_CD = '0',
							   REC_LAST_UPD_TIME = sysdate,
							   LAST_EVT_USER_ID = 'DATAFIX2'
		where cur_eid = c_party_eid_rec.cur_eid;

		-- close entity_h record

		update entity_h
		set eff_end_time = sysdate,
			rec_last_upd_time = sysdate,
			LAST_EVT_USER_ID = 'DATAFIX2'
		where cur_eid = c_party_eid_rec.cur_eid
		  and eff_end_time = to_date('01-01-2999','DD-MM-YYYY');

		-- insert new entity_h row

		insert into entity_h (CUR_EID,
							  LAST_EVT_TIME,
							  ENT_TYPE,
							  XML_DATA,
							  XSD_VERSION,
							  GOLDEN_REC_HASH_CD,
							  LAST_EVT_USER_ID,
							  REC_LAST_UPD_TIME,
							  EFF_END_TIME,
							  LAST_COMPARE_EVT_TIME,
                                                          MDM_DATA_CATEGORY)
		values (c_party_eid_rec.cur_eid,
				sysdate,
				c_party_eid_rec.ent_type,
				v_xml_type,
				c_party_eid_rec.xsd_version,
				0,
				'DATAFIX2',
				sysdate,
				to_date('01-01-2999','DD-MM-YYYY'),
				sysdate,
				c_party_eid_rec.mdm_data_category);

		-- commit data back into entity
		commit;

end loop; -- end cur_eid loop

end;
/

SHOW ERRORS;

CREATE OR REPLACE PROCEDURE __SCHEMA__.set_ts_sbip(SBIP_TS_LAST_EXEC IN TIMESTAMP, SS_SRC_CD IN VARCHAR2 )
AS
    STATEMENT varchar2(3000);
    SBIP_DT_LAST_EXEC DATE;

BEGIN
         DBMS_SESSION.SET_CONTEXT( 'ODSDLT_SBIP', 'TS_LAST_EXEC', SBIP_TS_LAST_EXEC);
         DBMS_SESSION.SET_CONTEXT( 'ODSDLT_SBIP', 'SS_SRC_CD', SS_SRC_CD );

         STATEMENT :=  'SELECT MAX(PYPA_START_DT) FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP WHERE REC_LAST_UPD_TM < '''||SBIP_TS_LAST_EXEC||''' AND REC_LAST_UPD_SRC_CD =  '''||SS_SRC_CD||'''';
--         DBMS_OUTPUT.PUT_LINE(STATEMENT);
         EXECUTE IMMEDIATE STATEMENT INTO SBIP_DT_LAST_EXEC;

         DBMS_SESSION.SET_CONTEXT( 'ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC', SBIP_DT_LAST_EXEC);

END;
/

SHOW ERRORS;

CREATE OR REPLACE FUNCTION __SCHEMA__.mdm_external_policy(
  schema_in IN VARCHAR2,
  object_in IN VARCHAR2
 )
RETURN VARCHAR2
IS
  l_return_value VARCHAR2(32767);
BEGIN

 -- when fid = 0 we can't see all data, when fid = 1 then we can
 CASE SYS_CONTEXT('fid_ctx', 'fid_priv')
 WHEN 0 THEN
    l_return_value := 'mdm_data_category = ''INTERNAL''';
 ELSE
    l_return_value := '1=1';
 END CASE;
 RETURN l_return_value;
END mdm_external_policy;
/

SHOW ERRORS;

CREATE MATERIALIZED VIEW __SCHEMA__.VPMPAR (PTY$SRCCD,PTY$TYPECD,PRD$ABBREVFR,PRD$ABBREVEN,LEGACY$LONGNAMEFR,LEGACY$LONGNAMEEN,PTY$MEMBERID,AGMT$PRAGID,AGMT$TYPECD,AGMT$SRCKEY,AGMT$CURCD,AGMT$EFFCTVDATE,AGMT$ENDDATE,AGMT$LIFECYCLESTATUS,LEGACY$SRCKEY,AGMT$DOMAINCD,LEGAL$ENTITYGRPCD,AGMT$CONDITIONSTRINGVALUE,AGMT$BALAMT,AGMT$BALAMTCCY,AGMT$CREDITLIMITAMT,AGMT$CREDITLIMITAMTCCY,AGMT$CASHADVLMTAMT,AGMT$CASHADVLMTAMTCCY,AGMT$TOTINTMATURITYAMT,AGMT$CASHBALAMT,AGMT$CASHBALAMTCCY,AGMT$CREDITINTRATEPCT,AGMT$ORIGINALAMT,AGMT$REGSTDPLANTYPECD,AGMT$SPOUSALREGSTDPLANFLG,AGMT$GIVENCOLLATERALFLAG,AGMT$ISSUANCEDT,AGMT$MATURITYDT,AGMT$REDEEMABLEFLAG,AGMT$NOMINEEACCTFLAG)
TABLESPACE TSD_ODS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE 24 INSTANCES 1 )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
SELECT
            TPMPAR.PYMPA_PTYMBR_SRC_CD AS pty$srcCd,
            TPMPAR.PYMPA_TYPE_CD AS pty$typeCd,
              PRD.PRDT_FR_ABREV_NAME AS prd$abbrevFr,
              PRD.PRDT_EN_ABREV_NAME AS prd$abbrevEn,
              TLP.LGPR_FR_NAME AS legacy$longNameFr,
              TLP.LGPR_EN_NAME AS legacy$longNameEn,
            TPMPAR.PYMPA_PTYMBR_SRC_NTRL_KEY AS pty$memberId,
            TPA.PRAG_ID AS agmt$pragId,
            TPA.AGMT_TYPE_CD AS agmt$typeCd,
            TPA.PRAG_SRC_KEY AS agmt$srcKey,
            TPA.PRAG_CUR_CD AS agmt$curCd,
            TPA.PRAG_EFFCTV_DT AS agmt$effctvDate,
            TPA.PRAG_END_DT AS agmt$endDate,
            TPA.PRAG_LIFE_CYCLE_STATUS_CD AS agmt$lifeCycleStatus,
            TLP.LGPR_SRC_KEY AS legacy$srcKey,
            TPA.PRAG_TYPE_CD AS agmt$DomainCd,  
            FGLE.CLEG_CD AS legal$EntityGrpCd,  
            TPA.PKG_ID AS agmt$conditionStringValue, 
            TPA.PRAG_BAL_AMT AS agmt$balAmt,
            TPA.PRAG_BAL_AMT_CCY AS agmt$balAmtCCY,
            TPA.PRAG_CREDIT_LIMIT_AMT AS agmt$creditLimitAmt,
            TPA.PRAG_CREDIT_LIMIT_AMT_CCY AS agmt$creditLimitAmtCCY,
            TPA.PRAG_CASH_ADV_LIMIT_AMT AS agmt$cashAdvLmtAmt,
            TPA.PRAG_CASH_ADV_LIMIT_AMT_CCY AS agmt$cashAdvLmtAmtCCY,
            TPA.PRAG_TOT_INTEREST_MATURITY_AMT AS agmt$totIntMaturityAmt,
            TPA.PRAG_CASH_BAL_AMT AS agmt$cashBalAmt,
            TPA.PRAG_CASH_BAL_AMT_CCY AS agmt$cashBalAmtCCY,
            TPA.PRAG_CREDIT_INTEREST_RATE_PCT AS agmt$creditIntRatePCT,
            TPA.PRAG_ORIGINAL_AMT AS agmt$originalAmt,
            TPA.PRAG_REGSTD_PLAN_TYPE_CD AS agmt$regstdPlanTypeCd,
            TPA.PRAG_SPOUSAL_REGSTD_PLAN_FLG AS agmt$spousalRegstdPlanFlg,
            TPA.PRAG_GIVEN_COLLATERAL_FLAG AS agmt$givenCollateralFlag,
            TPA.PRAG_ISSUANCE_DT AS agmt$issuanceDt,
            TPA.PRAG_MATURITY_DT AS agmt$maturityDt,
            TPA.PRAG_REDMBL_FLAG AS agmt$redeemableFlag,
            TPA.PRAG_NOMINEE_ACCT_FLAG AS agmt$nomineeAcctFlag 
        FROM 
            __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TPMPAR 
            INNER JOIN __SCHEMA__.TBPRAG_PRDT_AGMT TPA ON TPMPAR.PRAG_ID = TPA.PRAG_ID 
            INNER JOIN __SCHEMA__.TBLGPR_LEGACY_PRODUCT TLP ON TLP.LGPR_ID = TPA.LGPR_ID 
            INNER JOIN __SCHEMA__.TBPRDT_PRODUCT PRD on PRD.PRDT_ID = TLP.PRDT_ID 
            INNER JOIN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP PAOU on TPA.PRAG_ID = PAOU.PRAG_ID and PAOU.PAOU_TYPE_CD = 'DETNTN' and PAOU.PAOU_END_DT = TO_DATE ('99991231', 'yyyymmdd')
            INNER JOIN __SCHEMA__.TBOGUN_ORG_UNIT OGUN on PAOU.OGUN_ID = OGUN.OGUN_ID
            INNER JOIN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY FGLE on FGLE.FGLE_ID = OGUN.FGLE_ID
        WHERE 
            TPMPAR.PYMPA_END_DT = TO_DATE ('99991231', 'yyyymmdd')
    UNION ALL
                select
                        PYPA2.PYPA_PTY_MBR_SRC_CD AS pty$srcCd,
                        PYPA2.PYPA_TYPE_CD AS pty$typeCd,
                        PRD2.PRDT_FR_ABREV_NAME AS prd$abbrevFr,
                        PRD2.PRDT_EN_ABREV_NAME AS prd$abbrevEn,
                        TLP2.LGPR_FR_NAME AS legacy$longNameFr,
                        TLP2.LGPR_EN_NAME AS legacy$longNameEn,
                        PYPA2.PYPA_PTY_MBR_SRC_NTRL_KEY AS pty$memberId,
                        CRD2.CARD_ID AS agmt$pragId,
                        'CCSU' AS agmt$typeCd,
                        CRD2.CARD_SRC_NO AS agmt$srcKey,
                        TPA2.PRAG_CUR_CD AS agmt$curCd,
                        TPA2.PRAG_EFFCTV_DT AS agmt$effctvDate,
                        CRD2.CARD_CLOSING_DT AS agmt$endDate,
                        CRD2.CARD_STATUS_CD AS agmt$lifeCycleStatus,
                        TLP2.LGPR_SRC_KEY AS legacy$srcKey,
                        TPA2.PRAG_TYPE_CD AS agmt$DomainCd,  
                        FGLE.CLEG_CD as legal$EntityGrpCd,
                        TPA2.PKG_ID AS agmt$conditionStringValue,
                        null AS agmt$balAmt,
                        null AS agmt$balAmtCCY,
                        null AS agmt$creditLimitAmt,
                        null AS agmt$creditLimitAmtCCY,
                        null AS agmt$cashAdvLmtAmt,
                        null AS agmt$cashAdvLmtAmtCCY,
                        null AS agmt$totIntMaturityAmt,
                        null AS agmt$cashBalAmt,
                        null AS agmt$cashBalAmtCCY,
                        null AS agmt$creditIntRatePCT,
                        null AS agmt$originalAmt,
                        null AS agmt$regstdPlanTypeCd,
                        null AS agmt$spousalRegstdPlanFlg,
                        null AS agmt$givenCollateralFlag,
                        null AS agmt$issuanceDt,
                        null AS agmt$maturityDt,
                        null AS agmt$redeemableFlag,
                        null AS agmt$nomineeAcctFlag
                    FROM 
                        __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP PYPA2 
                        inner JOIN __SCHEMA__.TBCARD_CARD CRD2 on CRD2.CUR_EID = PYPA2.CUR_ENT_ID AND CRD2.PRAG_ID = PYPA2.PRAG_ID 
                        inner JOIN __SCHEMA__.TBPRAG_PRDT_AGMT TPA2 ON PYPA2.PRAG_ID = TPA2.PRAG_ID 
                        inner JOIN __SCHEMA__.TBLGPR_LEGACY_PRODUCT TLP2 ON TLP2.LGPR_ID = TPA2.LGPR_ID 
                        inner JOIN __SCHEMA__.TBPRDT_PRODUCT PRD2 on PRD2.PRDT_ID = TLP2.PRDT_ID 
                        inner JOIN __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP PAOU on TPA2.PRAG_ID = PAOU.PRAG_ID and PAOU.PAOU_TYPE_CD = 'DETNTN' 
                        and PAOU.PAOU_END_DT = TO_DATE ('99991231', 'yyyymmdd')
                        inner JOIN __SCHEMA__.TBOGUN_ORG_UNIT OGUN on PAOU.OGUN_ID = OGUN.OGUN_ID
                        inner JOIN __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY FGLE on FGLE.FGLE_ID = OGUN.FGLE_ID     
                    WHERE 
                        PYPA2.REC_LAST_UPD_SRC_CD = '0084' AND
                        PYPA2.PYPA_END_DT = TO_DATE ('99991231', 'yyyymmdd');


COMMENT ON MATERIALIZED VIEW __SCHEMA__.VPMPAR IS 'snapshot table for snapshot __SCHEMA__.VPMPAR';

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_ENTITY_MEMBERS
(CUR_EID, SRC_CD, SRC_NK, REC_LAST_UPD_TIME)
BEQUEATH DEFINER
AS 
SELECT CUR_EID,
          SRC_CD,
          SRC_NK,
          REC_LAST_UPD_TIME
     FROM __SCHEMA__.ENTITY_MEMBERS
   UNION
   SELECT CUR_EID,
          SRC_CD,
          SRC_NK,
          REC_LAST_UPD_TIME
     FROM __SCHEMA__.ENTITY_MEMBERS_NON_CDI;

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_ENTITY_RECONCILIATION
(CUR_EID, ENT_TYPE, XML_DATA, XSD_VERSION, GOLDEN_REC_HASH_CD, 
 LAST_EVT_TIME, LAST_EVT_USER_ID, LAST_COMPARE_EVT_TIME, REC_LAST_UPD_TIME)
BEQUEATH DEFINER
AS 
SELECT ENT.CUR_EID,
          ENT.ENT_TYPE,
          ENT.XML_DATA,
          ENT.XSD_VERSION,
          ENT.GOLDEN_REC_HASH_CD,
          ENT.LAST_EVT_TIME,
          ENT.LAST_EVT_USER_ID,
          ENT.LAST_COMPARE_EVT_TIME,
          ENT.REC_LAST_UPD_TIME
     FROM ENTITY ENT
          INNER JOIN
          (SELECT DISTINCT CUR_EID FROM WORK_CDI_RECONCILIATION) RECON
             ON ENT.CUR_EID = RECON.CUR_EID;

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_ODSDLT_SBIP_0025
(FLAGTRSTCHG, LEGALENTITYGRPCD, FLAGPRAGCHG, ACCOUNTNUMBER, FLAGPAPACHG, 
 PARENTACCOUNTKEYS, STATUS, ENDDATE, CURRENCY, FLAGPYPACHG, 
 FLAGPYPARELTNEND, RELATIONSHIPTYPE, CLISRCCD, CLIMEMBERIDNO, BILLPAYMENTELIGIBLE, 
 TRANSFERFROMELIGIBLE, TRANSFERTOELIGIBLE, TOTALELIGIBLE, CLISTARTDT, CLIENDDT, 
 FLAGCHANGE, LEGACYPRODUCTSRCKEY, LEGACYPRODUCTSRCCD, CREDITLIMIT)
BEQUEATH DEFINER
AS 
SELECT rs.flagTrstChg,
       rs.legalEntityGrpCd,
       rs.flagPragChg,
       rs.accountNumber,
       rs.flagPapaChg,
       rs.parentAccountKeys,
       rs.status,
       rs.endDate,
       rs.currency,
       rs.flagPypaChg,
       rs.flagPypaReltnEnd,
       rs.relationshipType,
       rs.cliSrcCd,
       rs.cliMemberIdNo,
       CASE
        WHEN
            rs.status = 'OUVERT'
        AND rs.currency = 'CAD'
        AND rs.relationshipType <> 'BENEFIC'
        AND rs.typeMCR <> 'MCR/REER'
        AND rs.interAccess NOT IN ('DT/IA/NP','OUI')
        AND rs.nbSignature = 1
        AND rs.codeSignature <> 'NON/AUTHRS'
        THEN 1 Else 0
       END as billPaymentEligible,
       CASE
        WHEN
            rs.status = 'OUVERT'
        AND rs.currency = 'CAD'
        AND rs.relationshipType <> 'BENEFIC'
        AND rs.typeMCR <> 'MCR/REER'
        AND rs.interAccess NOT IN ('DT/IA/NP','OUI')
        AND rs.nbSignature = 1
        AND rs.codeSignature <> 'NON/AUTHRS'
        THEN 1 Else 0
       END as transferFromEligible,
       CASE
        WHEN
            rs.status = 'OUVERT'
        AND rs.currency = 'CAD'
        AND rs.relationshipType <> 'BENEFIC'
        AND rs.interAccess NOT IN ('CT/IA/NP','OUI')
        THEN 1 Else 0
       END as transferToEligible,
       CASE
        WHEN rs.relationshipType <> 'PROCUREUR'
        THEN 1 Else 0
       END as totalEligible,
       rs.cliStartDt,
       rs.cliEndDt,
       rs.flagChange,
       rs.legacyProductSrcKey,
       rs.legacyProductSrcCD,
       rs.creditlimit
  FROM (SELECT CASE
                  WHEN    FGLE.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR OGUN.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR PAOU.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagTrstChg,
               FGLE.CLEG_CD AS legalEntityGrpCd,
               CASE
                  WHEN PRAG.REC_LAST_UPD_TM_DLT_NO_BAL >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPragChg,
               SUBSTR (PRAG.PRAG_SRC_KEY, -12) AS accountNumber,
               CASE
                  WHEN PAPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPapaChg,
               SUBSTR (PAPA.OBJECT_PRAG_ID, 9, 12) AS parentAccountKeys,
               CASE
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
                  THEN
                     'FERME'
                  WHEN    PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                       OR PRAG.PRAG_END_DT IS NOT NULL
                  THEN
                     'FERME'
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND RANK ()
                           OVER (
                              PARTITION BY PYPA.PRAG_ID,
                                           PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                              ORDER BY PYPA.PYPA_START_DT ASC) = 1
                  THEN
                     'OUVERT'
                  WHEN    (    PYPA.REC_LAST_UPD_TM >
                                  SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                           AND PYPA_END_DT <>
                                  TO_DATE ('99991231', 'YYYYMMDD'))
                       OR PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                  THEN
                     'FERME'
                  ELSE
                     'OUVERT'
               END
                  AS status,
               PRAG.PRAG_END_DT AS endDate,
               PRAG.PRAG_CUR_CD AS currency,
               CASE
                  WHEN PYPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaChg,
               CASE
                  WHEN PYPA.PYPA_END_DT <=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaReltnEnd,
               PYPA.PYPA_TYPE_CD AS relationshipType,
               PYPA.PYPA_PTY_MBR_SRC_CD AS cliSrcCd,
               PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY AS cliMemberIdNo,
               PYPA.PYPA_START_DT AS cliStartDt,
               PYPA.PYPA_END_DT AS cliEndDt,
               RANK ()
               OVER (
                  PARTITION BY PYPA.PRAG_ID, PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                  ORDER BY PYPA.PYPA_START_DT DESC)
                  AS rankRelation,
               CASE
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
                  THEN
                     'DEL'
                  WHEN    PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                       OR PRAG.PRAG_END_DT IS NOT NULL
                  THEN
                     'DEL'
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND RANK ()
                           OVER (
                              PARTITION BY PYPA.PRAG_ID,
                                           PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                              ORDER BY PYPA.PYPA_START_DT ASC) = 1
                  THEN
                     'ADD'
                  WHEN    (    PYPA.REC_LAST_UPD_TM >
                                  SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                           AND PYPA_END_DT <>
                                  TO_DATE ('99991231', 'YYYYMMDD'))
                       OR PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                  THEN
                     'DEL'
                  ELSE
                     'MOD'
               END
                  AS flagChange,
               PRODUCT.LGPR_SRC_KEY AS legacyProductSrcKey,
               PRODUCT.LGPR_SRC_CD AS legacyProductSrcCD,
               PRAG.PRAG_LOC_TYP_CD AS typeMCR,
               PRAG.PRAG_CREDIT_LIMIT_AMT_CCY AS creditlimit,
               PRAG.PRAG_INTER_ACCESS_TYP_CD AS interAccess,
               PRAG.PRAG_SIGNAT_REQRD_CNT AS nbSignature,
               PYPA.PYPA_SIGNAT_TYP_CD AS codeSignature
          FROM TBPRAG_PRDT_AGMT prag
               INNER JOIN TBPYPA_PARTY_PRDT_AGMT_RLTNP pypa
                  ON PRAG.PRAG_ID = PYPA.PRAG_ID
               INNER JOIN TBPAOU_PRAG_ORG_UNIT_RLTNP paou
                  ON     PRAG.PRAG_ID = PAOU.PRAG_ID
                     AND PAOU.PAOU_TYPE_CD = 'DETNTN'
                     AND PAOU.PAOU_START_DT <= SYSDATE
                     AND PAOU.PAOU_END_DT >= SYSDATE
               INNER JOIN TBOGUN_ORG_UNIT ogun ON PAOU.OGUN_ID = OGUN.OGUN_ID
               INNER JOIN TBFGLE_FIN_GRP_LGL_ENTITY fgle
                  ON OGUN.FGLE_ID = FGLE.FGLE_ID
               LEFT JOIN TBPAPA_PRAG_PRAG_RLTNP papa
                  ON     PRAG.PRAG_ID = PAPA.SUBJECT_PRAG_ID
                     AND PAPA.PAPA_TYPE_CD = 'ENT/GLOBL'
                     AND PAPA.PAPA_START_DT <= SYSDATE
                     AND PAPA.PAPA_END_DT >= SYSDATE
                     AND PAPA.REC_LAST_UPD_SRC_CD = PRAG.REC_LAST_UPD_SRC_CD
               LEFT JOIN TBLGPR_LEGACY_PRODUCT product
                  ON PRAG.LGPR_ID = PRODUCT.LGPR_ID
         WHERE     PRAG.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND PYPA.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND PAOU.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND (   PRAG.REC_LAST_UPD_TM_DLT_NO_BAL >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PYPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PAOU.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR OGUN.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR FGLE.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PAPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PRODUCT.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC'))
               AND (   PYPA.REC_LAST_UPD_TM >
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PYPA.PYPA_END_DT = TO_DATE ('99991231', 'YYYYMMDD')))
       rs
 WHERE rs.rankRelation = 1;

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_ODSDLT_SBIP_0057
(FLAGTRSTCHG, LEGALENTITYGRPCD, FLAGPRAGCHG, ACCOUNTNUMBER, STATUS, 
 ENDDATE, CURRENCY, BALANCE, FLAGPYPACHG, FLAGPYPARELTNEND, 
 RELATIONSHIPTYPE, CLISRCCD, CLIMEMBERIDNO, CLISTARTDT, CLIENDDT, 
 FLAGCHANGE, LEGACYPRODUCTSRCKEY, LEGACYPRODUCTSRCCD)
BEQUEATH DEFINER
AS 
SELECT rs.flagTrstChg,
       rs.legalEntityGrpCd,
       rs.flagPragChg,
       rs.accountNumber,
       rs.status,
       rs.endDate,
       rs.currency,
       rs.balance,
       rs.flagPypaChg,
       rs.flagPypaReltnEnd,
       rs.relationshipType,
       rs.cliSrcCd,
       rs.cliMemberIdNo,
       rs.cliStartDt,
       rs.cliEndDt,
       rs.flagChange,
       rs.legacyProductSrcKey,
       rs.legacyProductSrcCD
  FROM (SELECT CASE
                  WHEN    FGLE.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR OGUN.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR PAOU.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagTrstChg,
               FGLE.CLEG_CD AS legalEntityGrpCd,
               CASE
                  WHEN PRAG.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPragChg,
               SUBSTR (PRAG.PRAG_SRC_KEY, -16) AS accountNumber,
				CASE
				   WHEN
					  PYPA.REC_LAST_UPD_TM > SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
					  AND PYPA_START_DT > SYS_CONTEXT ('ODSDLT_SBIP','DT_LOGIC_LAST_EXEC')
					  AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
				 THEN
					   'FERME'
				  WHEN
							  PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('ANNULE', 'FERME')
					  OR
							  (PRAG.PRAG_LIFE_CYCLE_STATUS_CD = 'FERM/FINAL' AND
							  PRAG.PRAG_CLOSING_REASON_TYP_CD NOT IN
									 ('MEILL/COND','CLT/INSAT','REPRISE'))
					  OR
							  PRAG.PRAG_END_DT IS NOT NULL
				   THEN
					  'FERME'
				 WHEN
					  PYPA.REC_LAST_UPD_TM >  SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
					  AND PYPA_START_DT > SYS_CONTEXT ('ODSDLT_SBIP','DT_LOGIC_LAST_EXEC')
					  AND RANK ()
						 OVER (PARTITION BY PYPA.PRAG_ID, PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
						 ORDER BY PYPA.PYPA_START_DT ASC) = 1
				 THEN
					   'OUVERT'
				 WHEN
							  (PYPA.REC_LAST_UPD_TM > SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
							  AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD'))
						OR
							  PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('ANNULE', 'FERME')
						OR
							  (PRAG.PRAG_LIFE_CYCLE_STATUS_CD = 'FERM/FINAL' AND
							  PRAG.PRAG_CLOSING_REASON_TYP_CD NOT IN
									 ('MEILL/COND','CLT/INSAT','REPRISE'))
				 THEN
					   'FERME'
				 ELSE
					   'OUVERT'
				END
                  AS status,
               PRAG.PRAG_END_DT AS endDate,
               PRAG.PRAG_CUR_CD AS currency,
               (PRAG.PRAG_BAL_AMT_CCY * -1) AS balance,
               CASE
                  WHEN PYPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaChg,
               CASE
                  WHEN PYPA.PYPA_END_DT <=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaReltnEnd,
               PYPA.PYPA_TYPE_CD AS relationshipType,
               PYPA.PYPA_PTY_MBR_SRC_CD AS cliSrcCd,
               PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY AS cliMemberIdNo,
               PYPA.PYPA_START_DT AS cliStartDt,
               PYPA.PYPA_END_DT AS cliEndDt,
               RANK ()
               OVER (
                  PARTITION BY PYPA.PRAG_ID, PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                  ORDER BY PYPA.PYPA_START_DT DESC)
                  AS rankRelation,
				CASE
				  WHEN
						PYPA.REC_LAST_UPD_TM > SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
						AND PYPA_START_DT > SYS_CONTEXT ('ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC')
						AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
				  THEN
					  'DEL'
				  WHEN
							  PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('ANNULE', 'FERME')
					  OR
							  (PRAG.PRAG_LIFE_CYCLE_STATUS_CD = 'FERM/FINAL' AND
							  PRAG.PRAG_CLOSING_REASON_TYP_CD NOT IN
									 ('MEILL/COND','CLT/INSAT','REPRISE'))
					  OR
							  PRAG.PRAG_END_DT IS NOT NULL
				  THEN
						 'DEL'
				  WHEN
						PYPA.REC_LAST_UPD_TM > SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
						AND PYPA_START_DT > SYS_CONTEXT ('ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC')
						AND RANK ()
						   OVER (PARTITION BY PYPA.PRAG_ID, PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
						   ORDER BY PYPA.PYPA_START_DT ASC) = 1
				  THEN
					  'ADD'
				  WHEN
							  (PYPA.REC_LAST_UPD_TM > SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
							  AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD'))
						OR
							  PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('ANNULE', 'FERME')
						OR
							  (PRAG.PRAG_LIFE_CYCLE_STATUS_CD = 'FERM/FINAL' AND
							  PRAG.PRAG_CLOSING_REASON_TYP_CD NOT IN
									 ('MEILL/COND','CLT/INSAT','REPRISE'))
				  THEN
					  'DEL'
				  ELSE
					  'MOD'
				END
                  AS flagChange,
               PRODUCT.LGPR_SRC_KEY AS legacyProductSrcKey,
               PRODUCT.LGPR_SRC_CD AS legacyProductSrcCD
          FROM TBPRAG_PRDT_AGMT prag
               INNER JOIN TBPYPA_PARTY_PRDT_AGMT_RLTNP pypa
                  ON PRAG.PRAG_ID = PYPA.PRAG_ID
               INNER JOIN TBPAOU_PRAG_ORG_UNIT_RLTNP paou
                  ON     PRAG.PRAG_ID = PAOU.PRAG_ID
                     AND PAOU.PAOU_TYPE_CD = 'DETNTN'
                     AND PAOU.PAOU_START_DT <= SYSDATE
                     AND PAOU.PAOU_END_DT >= SYSDATE
               INNER JOIN TBOGUN_ORG_UNIT ogun ON PAOU.OGUN_ID = OGUN.OGUN_ID
               INNER JOIN TBFGLE_FIN_GRP_LGL_ENTITY fgle
                  ON OGUN.FGLE_ID = FGLE.FGLE_ID
               LEFT JOIN TBLGPR_LEGACY_PRODUCT product
                  ON PRAG.LGPR_ID = PRODUCT.LGPR_ID
         WHERE     PRAG.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND PYPA.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND PAOU.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND (   PRAG.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PYPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PAOU.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR OGUN.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR FGLE.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PRODUCT.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC'))
               AND (   PYPA.REC_LAST_UPD_TM >
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PYPA.PYPA_END_DT = TO_DATE ('99991231', 'YYYYMMDD'))
               AND PYPA.PYPA_TYPE_CD <> 'CAUTION'
               AND PRAG.PRAG_TYPE_CD != 'ENT/GLOBL') rs
 WHERE rs.rankRelation = 1;

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_ODSDLT_SBIP_0084
(FLAGTRSTCHG, LEGALENTITYGRPCD, FLAGPRAGCHG, ACCOUNTNUMBER, CARDNUMBER, 
 STATUS, ENDDATE, CURRENCY, FLAGPYPACHG, FLAGPYPARELTNEND, 
 RELATIONSHIPTYPE, CLISRCCD, CLIMEMBERIDNO, CLISTARTDT, CLIENDDT, 
 FLAGCHANGE, LEGACYPRODUCTSRCKEY, LEGACYPRODUCTSRCCD, CREDITLIMIT, AUTHORIZEDUSER, 
 SECONDARYCARDNUMBER)
BEQUEATH DEFINER
AS 
SELECT CASE
                  WHEN    FGLE.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR OGUN.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR PAOU.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagTrstChg,
               FGLE.CLEG_CD AS legalEntityGrpCd,
               CASE
                  WHEN PRAG.REC_LAST_UPD_TM_DLT_NO_BAL >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPragChg,
               PRAG.PRAG_SRC_KEY AS accountNumber,
               CARD.cardNumber,
               CASE
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                             SYS_CONTEXT ('ODSDLT_SBIP','DT_LOGIC_LAST_EXEC')
                       AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
                  THEN
                     'FERME'
                  WHEN    PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                       OR PRAG.PRAG_END_DT IS NOT NULL
                  THEN
                     'FERME'
                  WHEN     PYPA.REC_LAST_UPD_TM >
                               SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP','DT_LOGIC_LAST_EXEC')
                  THEN
                     'OUVERT'
                  WHEN    (    PYPA.REC_LAST_UPD_TM >
                                  SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                           AND PYPA_END_DT <>
                                  TO_DATE ('99991231', 'YYYYMMDD'))
                       OR PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                  THEN
                     'FERME'
                  ELSE
                     'OUVERT'
               END
                  AS status,
               PRAG.PRAG_END_DT AS endDate,
               PRAG.PRAG_CUR_CD AS currency,
               CASE
                  WHEN PYPA.REC_LAST_UPD_TM >=
                           SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaChg,
               CASE
                  WHEN PYPA.PYPA_END_DT <=
                          SYS_CONTEXT ('ODSDLT_SBIP','DT_LOGIC_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaReltnEnd,
               PYPA.PYPA_TYPE_CD AS relationshipType,
               PYPA.PYPA_PTY_MBR_SRC_CD AS cliSrcCd,
               PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY AS cliMemberIdNo,
               PYPA.PYPA_START_DT AS cliStartDt,
               PYPA.PYPA_END_DT AS cliEndDt,
               CASE
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC')
                       AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
                  THEN
                     'DEL'
                  WHEN    PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                       OR PRAG.PRAG_END_DT IS NOT NULL
                  THEN
                     'DEL'
                  WHEN     PYPA.REC_LAST_UPD_TM >
                            SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP','DT_LOGIC_LAST_EXEC')
                  THEN
                     'ADD'
                  WHEN    (    PYPA.REC_LAST_UPD_TM >
                                 SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                           AND PYPA_END_DT <>
                                  TO_DATE ('99991231', 'YYYYMMDD'))
                       OR PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                  THEN
                     'DEL'
                  ELSE
                     'MOD'
               END
                  AS flagChange,
               PRODUCT.LGPR_SRC_KEY AS legacyProductSrcKey,
               PRODUCT.LGPR_SRC_CD AS legacyProductSrcCD,
               PRAG.PRAG_CREDIT_LIMIT_AMT_CCY AS creditlimit,
               CASE
                WHEN PYPA.PYPA_TYPE_CD = 'DET/PRINC' THEN 0
                WHEN PYPA.PYPA_TYPE_CD = 'DET/UNIQUE' THEN 0
                ELSE 1
               END AS authorizedUser,
               CARD.SECONDARYCARDNUMBER
          FROM TBPRAG_PRDT_AGMT prag
               INNER JOIN (
SELECT PYPA.* FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP PYPA,
        (SELECT PYPA.PRAG_ID, PYPA.CUR_ENT_ID, PYPA.PYPA_START_DT, MAX(PYPA_TYPE_CD) AS PYPA_TYPE_CD
        FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP PYPA,
                    (SELECT PYPA.PRAG_ID, PYPA.CUR_ENT_ID, MAX(PYPA_START_DT) AS PYPA_START_DT
                    FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP PYPA,
                              (SELECT PRAG_ID, CUR_ENT_ID,
                                MIN(
                                CASE
                                WHEN PYPA_START_DT <= SYSDATE AND PYPA_END_DT >= SYSDATE AND (PYPA_TYPE_CD = 'DET/PRINC' OR PYPA_TYPE_CD = 'DET/UNIQUE') THEN 1  -- ACTIF ET PRINCIPAL
                                WHEN PYPA_START_DT <= SYSDATE AND PYPA_END_DT >= SYSDATE AND PYPA_TYPE_CD <> 'DET/PRINC' AND PYPA_TYPE_CD = 'DET/UNIQUE' THEN 2  -- ACTIF ET DETENTEUR
                                ELSE 3 -- INACTIF
                                END
                                ) AS INDICATEUR
                              FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP PYPA
                            WHERE REC_LAST_UPD_SRC_CD = '0084'
                            GROUP BY PRAG_ID, CUR_ENT_ID) SCOPE -- Actif-princ, Actif-Det, inactif
                    WHERE PYPA.REC_LAST_UPD_SRC_CD = '0084'
                    AND PYPA.PRAG_ID = SCOPE.PRAG_ID
                    AND PYPA.CUR_ENT_ID = SCOPE.CUR_ENT_ID
                    AND CASE
                    WHEN PYPA_START_DT <= SYSDATE AND PYPA_END_DT >= SYSDATE AND (PYPA_TYPE_CD = 'DET/PRINC' OR PYPA_TYPE_CD = 'DET/UNIQUE') THEN 1  -- ACTIF ET PRINCIPAL
                    WHEN PYPA_START_DT <= SYSDATE AND PYPA_END_DT >= SYSDATE AND PYPA_TYPE_CD <> 'DET/PRINC' AND PYPA_TYPE_CD = 'DET/UNIQUE' THEN 2  -- ACTIF ET DETENTEUR
                    ELSE 3 -- INACTIF
                    END  = SCOPE.INDICATEUR
                    GROUP BY PYPA.PRAG_ID, PYPA.CUR_ENT_ID)  SCOPE  --MAX Start_dt
        WHERE
        PYPA.REC_LAST_UPD_SRC_CD = '0084'
        AND PYPA.PRAG_ID = SCOPE.PRAG_ID
        AND PYPA.CUR_ENT_ID = SCOPE.CUR_ENT_ID
        AND  PYPA.PYPA_START_DT = SCOPE.PYPA_START_DT
        GROUP BY PYPA.PRAG_ID, PYPA.CUR_ENT_ID, PYPA.PYPA_START_DT) SCOPE
WHERE         PYPA.PRAG_ID = SCOPE.PRAG_ID
AND PYPA.CUR_ENT_ID = SCOPE.CUR_ENT_ID
AND  PYPA.PYPA_START_DT = SCOPE.PYPA_START_DT
AND  PYPA.PYPA_TYPE_CD = SCOPE.PYPA_TYPE_CD
AND PYPA.REC_LAST_UPD_SRC_CD = '0084'
) pypa
                  ON PRAG.PRAG_ID = PYPA.PRAG_ID
               INNER JOIN TBPAOU_PRAG_ORG_UNIT_RLTNP paou
                  ON     PRAG.PRAG_ID = PAOU.PRAG_ID
                     AND PAOU.PAOU_TYPE_CD = 'DETNTN'
                     AND PAOU.PAOU_START_DT <= SYSDATE
                     AND PAOU.PAOU_END_DT >= SYSDATE
               INNER JOIN TBOGUN_ORG_UNIT ogun ON PAOU.OGUN_ID = OGUN.OGUN_ID
               INNER JOIN TBFGLE_FIN_GRP_LGL_ENTITY fgle
                  ON OGUN.FGLE_ID = FGLE.FGLE_ID

------------
               LEFT JOIN
(SELECT PRAG_ID, CUR_EID,
         SUBSTR (
            LISTAGG (CARD_SRC_NO, '|') WITHIN GROUP (ORDER BY CARD_SRC_NO),
            0,
            CASE
               WHEN INSTR (
                       LISTAGG (CARD_SRC_NO, '|')
                          WITHIN GROUP (ORDER BY CARD_SRC_NO),
                       '|') = 0
               THEN
                  LENGTH (
                     LISTAGG (CARD_SRC_NO, '|')
                        WITHIN GROUP (ORDER BY CARD_SRC_NO))
               ELSE
                    INSTR (
                       LISTAGG (CARD_SRC_NO, '|')
                          WITHIN GROUP (ORDER BY CARD_SRC_NO),
                       '|')
                  - 1
            END)
            CARDNUMBER,
         SUBSTR (
            LISTAGG (CARD_SRC_NO, '|') WITHIN GROUP (ORDER BY CARD_SRC_NO),
            CASE
               WHEN INSTR (
                       LISTAGG (CARD_SRC_NO, '|')
                          WITHIN GROUP (ORDER BY CARD_SRC_NO),
                       '|') = 0
               THEN
                  0
               ELSE
                    INSTR (
                       LISTAGG (CARD_SRC_NO, '|')
                          WITHIN GROUP (ORDER BY CARD_SRC_NO),
                       '|')
                  + 1
            END,
            CASE
               WHEN INSTR (
                       LISTAGG (CARD_SRC_NO, '|')
                          WITHIN GROUP (ORDER BY CARD_SRC_NO),
                       '|') = 0
               THEN
                  0
               ELSE
                  LENGTH (
                     LISTAGG (CARD_SRC_NO, '|')
                        WITHIN GROUP (ORDER BY CARD_SRC_NO))
            END)
            SECONDARYCARDNUMBER
 FROM TBCARD_CARD CARD
WHERE CARD_STATUS_CD IN ('GELE', 'ACTIF','N/ACTIF')
GROUP BY PRAG_ID, CUR_EID)  CARD
                  ON     PYPA.PRAG_ID = CARD.PRAG_ID
                     AND PYPA.CUR_ENT_ID = CARD.CUR_EID
-----------------
               LEFT JOIN
               (SELECT DISTINCT PRAG_ID, CUR_EID
                  FROM TBCARD_CARD
                 WHERE REC_LAST_UPD_SRC_CD = '0084'
            AND REC_LAST_UPD_TM >
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')) cardChange
                  ON     PYPA.PRAG_ID = cardChange.PRAG_ID
                     AND (PYPA.CUR_ENT_ID = cardChange.CUR_EID)
               LEFT JOIN
               (SELECT DISTINCT PRAG_ID, CUR_ENT_ID
                  FROM TBPYPA_PARTY_PRDT_AGMT_RLTNP
                 WHERE REC_LAST_UPD_SRC_CD = '0084'
            AND REC_LAST_UPD_TM >
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')) pypaChange
                  ON     PYPA.PRAG_ID = pypaChange.PRAG_ID AND
            PYPA.CUR_ENT_ID = pypaChange.CUR_ENT_ID
               INNER JOIN TBLGPR_LEGACY_PRODUCT product
                  ON PRAG.LGPR_ID = PRODUCT.LGPR_ID
         WHERE
              PRAG.REC_LAST_UPD_SRC_CD = '0084'
               AND PYPA.REC_LAST_UPD_SRC_CD = '0084'
               AND PAOU.REC_LAST_UPD_SRC_CD = '0084'
               AND (   PRAG.REC_LAST_UPD_TM_DLT_NO_BAL >= SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR pypaChange.PRAG_ID IS NOT NULL
                    OR cardChange.PRAG_ID IS NOT NULL
                    OR PAOU.REC_LAST_UPD_TM >= SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR OGUN.REC_LAST_UPD_TM >= SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR FGLE.REC_LAST_UPD_TM >= SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC'))
               AND (   pypaChange.PRAG_ID IS NOT NULL
                    OR PYPA.PYPA_END_DT = TO_DATE ('99991231', 'YYYYMMDD'));

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_ODSDLT_SBIP_0091
(FLAGTRSTCHG, LEGALENTITYGRPCD, FLAGPRAGCHG, ACCOUNTNUMBER, FLAGPAPACHG, 
 PARENTACCOUNTKEYS, STATUS, ENDDATE, CURRENCY, BALANCE, 
 FLAGPYPACHG, FLAGPYPARELTNEND, RELATIONSHIPTYPE, CLISRCCD, CLIMEMBERIDNO, 
 CLISTARTDT, CLIENDDT, FLAGCHANGE, LEGACYPRODUCTSRCKEY, LEGACYPRODUCTSRCCD)
BEQUEATH DEFINER
AS 
SELECT rs.flagTrstChg,
       rs.legalEntityGrpCd,
       rs.flagPragChg,
       rs.accountNumber,
       rs.flagPapaChg,
       rs.parentAccountKeys,
       rs.status,
       rs.endDate,
       rs.currency,
       rs.balance,
       rs.flagPypaChg,
       rs.flagPypaReltnEnd,
       rs.relationshipType,
       rs.cliSrcCd,
       rs.cliMemberIdNo,
       rs.cliStartDt,
       rs.cliEndDt,
       rs.flagChange,
       rs.legacyProductSrcKey,
       rs.legacyProductSrcCD
  FROM (SELECT CASE
                  WHEN    FGLE.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR OGUN.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       OR PAOU.REC_LAST_UPD_TM >=
                             SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagTrstChg,
               FGLE.CLEG_CD AS legalEntityGrpCd,
               CASE
                  WHEN PRAG.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPragChg,
                  SUBSTR (PRAG.PRAG_MTGG_LOAN_GRP_NO, 1, 11)
               || SUBSTR (PRAG.PRAG_SRC_KEY, -7)
               || SUBSTR (PRAG.PRAG_MTGG_LOAN_GRP_NO, -3)
                  AS accountNumber,
               CASE
                  WHEN PAPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPapaChg,
               SUBSTR (PAPA.OBJECT_PRAG_ID, 9, 12) AS parentAccountKeys,
               CASE
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
                  THEN
                     'FERME'
                  WHEN
                       PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL', 'ANNULE', 'FERME') OR
                       PRAG.PRAG_END_DT IS NOT NULL
                  THEN
                     'FERME'
				  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND RANK ()
                           OVER (
                              PARTITION BY PYPA.PRAG_ID,
                                           PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                              ORDER BY PYPA.PYPA_START_DT ASC) = 1
                  THEN
                     'OUVERT'
                  WHEN    (    PYPA.REC_LAST_UPD_TM >
                                  SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                           AND PYPA_END_DT <>
                                  TO_DATE ('99991231', 'YYYYMMDD'))
                       OR PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                  THEN
                     'FERME'
                  ELSE
                     'OUVERT'
               END
                  AS status,
               PRAG.PRAG_END_DT AS endDate,
               PRAG.PRAG_CUR_CD AS currency,
               (PRAG.PRAG_BAL_AMT_CCY * -1) AS balance,
               CASE
                  WHEN PYPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaChg,
               CASE
                  WHEN PYPA.PYPA_END_DT <=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'DT_LOGIC_LAST_EXEC')
                  THEN
                     1
                  ELSE
                     0
               END
                  AS flagPypaReltnEnd,
               PYPA.PYPA_TYPE_CD AS relationshipType,
               PYPA.PYPA_PTY_MBR_SRC_CD AS cliSrcCd,
               PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY AS cliMemberIdNo,
               PYPA.PYPA_START_DT AS cliStartDt,
               PYPA.PYPA_END_DT AS cliEndDt,
               RANK ()
               OVER (
                  PARTITION BY PYPA.PRAG_ID, PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                  ORDER BY PYPA.PYPA_START_DT DESC)
                  AS rankRelation,
               CASE
                  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND PYPA_END_DT <> TO_DATE ('99991231', 'YYYYMMDD')
                  THEN
                     'DEL'
                  WHEN
                       PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL', 'ANNULE', 'FERME') OR
                       PRAG.PRAG_END_DT IS NOT NULL
                  THEN
                     'DEL'
				  WHEN     PYPA.REC_LAST_UPD_TM >
                              SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                       AND PYPA_START_DT >
                              SYS_CONTEXT ('ODSDLT_SBIP',
                                           'DT_LOGIC_LAST_EXEC')
                       AND RANK ()
                           OVER (
                              PARTITION BY PYPA.PRAG_ID,
                                           PYPA.PYPA_PTY_MBR_SRC_NTRL_KEY
                              ORDER BY PYPA.PYPA_START_DT ASC) = 1
                  THEN
                     'ADD'
                  WHEN    (    PYPA.REC_LAST_UPD_TM >
                                  SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                           AND PYPA_END_DT <>
                                  TO_DATE ('99991231', 'YYYYMMDD'))
                       OR PRAG.PRAG_LIFE_CYCLE_STATUS_CD IN ('FERM/FINAL',
                                                             'ANNULE',
                                                             'FERME')
                  THEN
                     'DEL'
                  ELSE
                     'MOD'
               END
                  AS flagChange,
               PRODUCT.LGPR_SRC_KEY AS legacyProductSrcKey,
               PRODUCT.LGPR_SRC_CD AS legacyProductSrcCD
          FROM TBPRAG_PRDT_AGMT prag
               INNER JOIN TBPYPA_PARTY_PRDT_AGMT_RLTNP pypa
                  ON PRAG.PRAG_ID = PYPA.PRAG_ID
               INNER JOIN TBPAOU_PRAG_ORG_UNIT_RLTNP paou
                  ON     PRAG.PRAG_ID = PAOU.PRAG_ID
                     AND PAOU.PAOU_TYPE_CD = 'DETNTN'
                     AND PAOU.PAOU_START_DT <= SYSDATE
                     AND PAOU.PAOU_END_DT >= SYSDATE
               INNER JOIN TBOGUN_ORG_UNIT ogun ON PAOU.OGUN_ID = OGUN.OGUN_ID
               INNER JOIN TBFGLE_FIN_GRP_LGL_ENTITY fgle
                  ON OGUN.FGLE_ID = FGLE.FGLE_ID
               LEFT JOIN TBPAPA_PRAG_PRAG_RLTNP papa
                  ON     PRAG.PRAG_ID = PAPA.SUBJECT_PRAG_ID
                     AND PAPA.PAPA_TYPE_CD = 'ENT/GLOBL'
                     AND PAPA.PAPA_START_DT <= SYSDATE
                     AND PAPA.PAPA_END_DT >= SYSDATE
                     AND PAPA.REC_LAST_UPD_SRC_CD = PRAG.REC_LAST_UPD_SRC_CD
               INNER JOIN TBLGPR_LEGACY_PRODUCT product
                  ON PRAG.LGPR_ID = PRODUCT.LGPR_ID
         WHERE     PRAG.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND PYPA.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND PAOU.REC_LAST_UPD_SRC_CD =
                      SYS_CONTEXT ('ODSDLT_SBIP', 'SS_SRC_CD')
               AND (   PRAG.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PYPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PAOU.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR OGUN.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR FGLE.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PAPA.REC_LAST_UPD_TM >=
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC'))
               AND (   PYPA.REC_LAST_UPD_TM >
                          SYS_CONTEXT ('ODSDLT_SBIP', 'TS_LAST_EXEC')
                    OR PYPA.PYPA_END_DT = TO_DATE ('99991231', 'YYYYMMDD'))
               AND PRAG.PRAG_TYPE_CD != 'SERVICE') rs
 WHERE rs.rankRelation = 1;

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_SYSDF_SBIP
(SYSDFUDPTM, SYSDFDATASRCCD, SYSDFDATALOGICALDT)
BEQUEATH DEFINER
AS 
SELECT SYSDF.REC_LAST_UPD_TM AS sysdfUdpTm,
          CASE
             WHEN SYSDF.SYSDF_DATA_SRC_CD IN ('025',
                                              '057',
                                              '084',
                                              '091')
             THEN
                LPAD (SYSDF.SYSDF_DATA_SRC_CD, 4, '0')
             ELSE
                SYSDF.SYSDF_DATA_SRC_CD
          END
             AS sysdfDataSrcCd,
          SYSDF.SYSDF_DATA_LOGICAL_DT AS sysdfDataLogicalDt
     FROM TBSYSDF_SYS_DATA_FRESHNESS sysdf
    WHERE SYSDF.SYSDF_DATA_TARGET_NAME = 'TBPRAG_PRDT_AGMT';

CREATE OR REPLACE FORCE VIEW __SCHEMA__.VW_TBCNL_CHANNL
(CNL_DETAIL_ID, CNL_SUBTYP_ID, CNL_TYP_ID)
BEQUEATH DEFINER
AS 
select
  X.CNL_ID as CNL_DETAIL_ID
, Y.CNL_ID as CNL_SUBTYP_ID
, Z.CNL_ID as CNL_TYP_ID
from TBCNL_CHANNL x
LEFT JOIN TBCNL_CHANNL Y ON X.PARENT_CNL_ID = Y.CNL_ID AND Y.CNL_LEVEL_NO = 2
LEFT JOIN TBCNL_CHANNL Z ON Y.PARENT_CNL_ID = Z.CNL_ID AND Z.CNL_LEVEL_NO = 1
where X.CNL_LEVEL_NO = 3
UNION
select
  X.CNL_ID as CNL_DETAIL_ID
, X.CNL_ID as CNL_SUBTYP_ID
, Z.CNL_ID as CNL_TYP_ID
from TBCNL_CHANNL x
LEFT JOIN TBCNL_CHANNL Z ON X.PARENT_CNL_ID = Z.CNL_ID AND Z.CNL_LEVEL_NO = 1
where X.CNL_LEVEL_NO = 2
UNION
select
  X.CNL_ID as CNL_DETAIL_ID
, X.CNL_ID as CNL_SUBTYP_ID
, X.CNL_ID as CNL_TYP_ID
from TBCNL_CHANNL x
where X.CNL_LEVEL_NO = 1;

CREATE OR REPLACE TRIGGER __SCHEMA__.TG_VERSION_SCHEMA
BEFORE UPDATE
ON __SCHEMA__.VERSION_SCHEMA
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

/******************************************************************************
   NAME:       tg_version_schema
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8-14-2012      thuchr01       1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     tg_version_schema
      Sysdate:         8-14-2012
      Date and Time:   8-14-2012, 9:49:43 , and 8-14-2012 9:49:43
      Username:        thuchr01 (set in TOAD Options, Proc Templates)
      Table Name:      VERSION_SCHEMA (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN

   :NEW.REC_LAST_UPD_TM := SYSDATE;
   :NEW.REC_LAST_UPD_USER_ID := SYS_CONTEXT('USERENV','OS_USER') || ' - ' || user;

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END tg_version_schema;
/
SHOW ERRORS;

CREATE SYNONYM __SCHEMA__.EBS_VALUE FOR __SCHEMA__.VALUE;

CREATE SYNONYM __SCHEMA__.EBS_VALUE_DOMAIN FOR __SCHEMA__.VALUE_DOMAIN;

CREATE SYNONYM __SCHEMA__.EBS_VALUE_TRANSLATION FOR __SCHEMA__.VALUE_TRANSLATION;

CREATE SYNONYM __SCHEMA__.EBS_VALUE_VALUE_RLTNP FOR __SCHEMA__.VALUE_VALUE_RLTNP;

CREATE SYNONYM __SCHEMA__.USR_SBIP_ODSSET_TS_SBIP FOR __SCHEMA__.SET_TS_SBIP;

BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_PARTY_WEB_ADDRESS'
    ,policy_name           => 'PGR_PARTY_WEB_ADDRESS_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_PARTY_TELEPHONE'
    ,policy_name           => 'PGR_PARTY_TELEPHONE_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_PARTY_LIST_MEMBER'
    ,policy_name           => 'PGR_PARTY_LIST_MEMB_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_PARTY_GEO_AREA'
    ,policy_name           => 'PGR_PARTY_GEO_AREA_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_PARTY_EVENT'
    ,policy_name           => 'PGR_PARTY_EVENT_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_PARTY_EMAIL_ADDRESS'
    ,policy_name           => 'PGR_PARTY_EMAIL_ADD_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_MEMBER_ORGANIZATION_UNIT'
    ,policy_name           => 'PGR_MEMBER_ORG_UNIT_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_INDIVIDUAL_OCCUPATION'
    ,policy_name           => 'PGR_INDIV_OCCUPATION_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_INDIVIDUAL_NAME'
    ,policy_name           => 'PGR_INDIV_NAME_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_INDIVIDUAL_IDENT'
    ,policy_name           => 'PGR_INDIV_IDENT_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_INDIVIDUAL'
    ,policy_name           => 'PGR_INDIVIDUAL_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_DELTA_CONTROL'
    ,policy_name           => 'PGR_DELTA_CONTROL_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_CLIENT_SPECIFIC_COND'
    ,policy_name           => 'PGR_CLIENT_SPEC_COND_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_CLIENT_LIFE_CYCLE_STATUS'
    ,policy_name           => 'PGR_CL_LIFE_CYCLE_ST_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_CLIENT'
    ,policy_name           => 'PGR_CLIENT_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'PGR_ADDRESS'
    ,policy_name           => 'PGR_ADDRESS_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'E_DISCLOSURE_CAT'
    ,policy_name           => 'E_DISCLOSURE_CAT_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'ENTITY_H'
    ,policy_name           => 'ENTITY_H_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'ENTITY_MEMBERS'
    ,policy_name           => 'ENTITY_MEMBERS_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => '__SCHEMA__'
    ,object_name           => 'ENTITY'
    ,policy_name           => 'ENTITY_POLICY'
    ,function_schema       => '__SCHEMA__'
    ,policy_function       => 'MDM_EXTERNAL_POLICY'
    ,statement_types       => 'SELECT,INSERT,UPDATE,DELETE'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/

/*
GRANT SELECT ON __SCHEMA__.ENTITY TO BO_USR;

GRANT SELECT ON __SCHEMA__.CDI_AUDIT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.CDI_USER TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.E_DISCLOSURE_CAT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.E_NBFG_CLIENT_SUM TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.ENTITY TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.ENTITY_H TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.ENTITY_MEMBERS TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_ADDRESS TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_DELTA_CONTROL TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EVENT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_GEO_AREA TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_TELEPHONE TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBACTR_ACCTG_TRST TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBOGUN_ORG_UNIT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO INVEST_AGMT_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPRAG_PRDT_AGMT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPRDT_PRODUCT TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.VALUE TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.VALUE_DOMAIN TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.VALUE_TRANSLATION TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.VALUE_VALUE_RLTNP TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.VERSION_SCHEMA TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.WORK_CDI_RECONCILIATION TO INVEST_AGMT_USR_DV1;

GRANT SELECT ON __SCHEMA__.CDI_AUDIT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.CDI_USER TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.E_DISCLOSURE_CAT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.E_NBFG_CLIENT_SUM TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.ENTITY TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.ENTITY_H TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.ENTITY_MEMBERS TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_ADDRESS TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_DELTA_CONTROL TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EVENT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_GEO_AREA TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_TELEPHONE TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBACTR_ACCTG_TRST TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBOGUN_ORG_UNIT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO INVEST_AGMT_USR_TU1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBPRAG_PRDT_AGMT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBPRDT_PRODUCT TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.VALUE TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.VALUE_DOMAIN TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.VALUE_TRANSLATION TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.VALUE_VALUE_RLTNP TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.VERSION_SCHEMA TO INVEST_AGMT_USR_TU1;

GRANT SELECT ON __SCHEMA__.WORK_CDI_RECONCILIATION TO INVEST_AGMT_USR_TU1;

GRANT EXECUTE ON __SCHEMA__.DROP_OLD_PARTITIONS TO ODS_ETL;

GRANT EXECUTE ON __SCHEMA__.MDM_LOAD_TMP_TABLES TO ODS_ETL;

GRANT EXECUTE ON __SCHEMA__.ODS_PKG TO ODS_ETL;

GRANT EXECUTE ON __SCHEMA__.PR_UPDATE_LIFECYCLE TO ODS_ETL;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO ODS_ETL;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, READ, DEBUG, FLASHBACK ON __SCHEMA__.VPMPAR TO ODS_ETL;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO ODS_ETL;

GRANT SELECT ON __SCHEMA__.VW_TBCNL_CHANNL TO ODS_ETL;

GRANT EXECUTE ON __SCHEMA__.DROP_OLD_PARTITIONS TO ODS_ETL_DV1;

GRANT EXECUTE ON __SCHEMA__.MDM_LOAD_TMP_TABLES TO ODS_ETL_DV1;

GRANT EXECUTE ON __SCHEMA__.ODS_PKG TO ODS_ETL_DV1;

GRANT EXECUTE ON __SCHEMA__.PR_UPDATE_LIFECYCLE TO ODS_ETL_DV1;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO ODS_ETL_DV1;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, READ, DEBUG, FLASHBACK ON __SCHEMA__.VPMPAR TO ODS_ETL_DV1;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO ODS_ETL_DV1;

GRANT EXECUTE ON __SCHEMA__.DROP_OLD_PARTITIONS TO PRTYPREFSOA3044_BAT;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO PRTYPREFSOA3044_BAT;

GRANT SELECT ON __SCHEMA__.VW_TBCNL_CHANNL TO PRTYPREFSOA3044_BAT;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_RECONCILIATION TO PRTYPREFSOA3044_USR;

GRANT EXECUTE ON __SCHEMA__.DROP_OLD_PARTITIONS TO PRTYPREFSOA3044_USR_DV1;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO PRTYPREFSOA3044_USR_DV1;

GRANT SELECT ON __SCHEMA__.VW_TBCNL_CHANNL TO PRTYPREFSOA3044_USR_DV1;

GRANT REFERENCES ON __SCHEMA__.CDI_AUDIT TO RATES;

GRANT REFERENCES ON __SCHEMA__.CDI_USER TO RATES;

GRANT REFERENCES ON __SCHEMA__.E_DISCLOSURE_CAT TO RATES;

GRANT REFERENCES ON __SCHEMA__.E_NBFG_CLIENT_SUM TO RATES;

GRANT REFERENCES ON __SCHEMA__.ENTITY TO RATES;

GRANT REFERENCES ON __SCHEMA__.ENTITY_H TO RATES;

GRANT REFERENCES ON __SCHEMA__.ENTITY_MEMBERS TO RATES;

GRANT REFERENCES ON __SCHEMA__.ENTITY_MEMBERS_NON_CDI TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_ADDRESS TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_CLIENT TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_DELTA_CONTROL TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_INDIVIDUAL TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_PARTY_EVENT TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_PARTY_GEO_AREA TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_PARTY_TELEPHONE TO RATES;

GRANT REFERENCES ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBACTR_ACCTG_TRST TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBCARD_CARD TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBOGUN_ORG_UNIT TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBPRDT_PRODUCT TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO RATES;

GRANT REFERENCES ON __SCHEMA__.VALUE TO RATES;

GRANT REFERENCES ON __SCHEMA__.VALUE_DOMAIN TO RATES;

GRANT REFERENCES ON __SCHEMA__.VALUE_TRANSLATION TO RATES;

GRANT REFERENCES ON __SCHEMA__.VALUE_VALUE_RLTNP TO RATES;

GRANT REFERENCES ON __SCHEMA__.VERSION_SCHEMA TO RATES;

GRANT REFERENCES ON __SCHEMA__.WORK_CDI_RECONCILIATION TO RATES;

GRANT REFERENCES ON __SCHEMA__.TBACTR_ACCTG_TRST TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBOGUN_ORG_UNIT TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RATES_DV1;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON __SCHEMA__.TBPRDT_PRODUCT TO RATES_DV1;

GRANT REFERENCES ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RATES_DV1;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON __SCHEMA__.TBPRDT_PRODUCT TO RATES_DV3;

GRANT SELECT ON __SCHEMA__.CDI_AUDIT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.CDI_USER TO RL___SCHEMA___READONLY;

GRANT EXECUTE ON __SCHEMA__.DROP_OLD_PARTITIONS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_ADDRESS_CTX$I TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_ADDRESS_CTX$K TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_ADDRESS_CTX$N TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_ADDRESS_CTX$R TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$I TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$K TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$N TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$R TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.E_DISCLOSURE_CAT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.E_NBFG_CLIENT_SUM TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_H TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_H_IN1267055 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_IN1267055 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_MEMBERS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_MEMBERS_IN1267055 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_MEMBERS_NON_CDI TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH TO RL___SCHEMA___READONLY;

GRANT EXECUTE ON __SCHEMA__.MDM_EXTERNAL_POLICY TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST TO RL___SCHEMA___READONLY;

GRANT EXECUTE ON __SCHEMA__.MDM_LOAD_TMP_TABLES TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_SEARCHCL_CRITERIA TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN TO RL___SCHEMA___READONLY;

GRANT EXECUTE ON __SCHEMA__.ODS_PKG TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_ADDRESS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_DELTA_CONTROL TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EVENT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_GEO_AREA TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_TELEPHONE TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO RL___SCHEMA___READONLY;

GRANT EXECUTE ON __SCHEMA__.PR_UPDATE_LIFECYCLE TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SEQ_CDI_AUDIT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SEQ_LPVG_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SEQ_PAACT_ID TO RL___SCHEMA___READONLY;

GRANT EXECUTE ON __SCHEMA__.SET_TS_SBIP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBACTR_ACCTG_TRST TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBCARD_CARD TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBCNL_CHANNL TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBOGUN_ORG_UNIT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDT_PRODUCT TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP_B TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBSS_SRC_SYSTM TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBSST_SRC_SYSTM_TYP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE_DOMAIN TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE_TRANSLATION TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE_VALUE_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VERSION_SCHEMA TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VPMPAR TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_RECONCILIATION TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0025 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0057 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0084 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0091 TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_SYSDF_SBIP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_TBCNL_CHANNL TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.WORK_CDI_MCP_INITIAL_LOAD TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.WORK_CDI_RECONCILIATION TO RL___SCHEMA___READONLY;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_AUDIT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_USER TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.DROP_OLD_PARTITIONS TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_ADDRESS_CTX$I TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_ADDRESS_CTX$K TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_ADDRESS_CTX$N TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_ADDRESS_CTX$R TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$I TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$K TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$N TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.DR$PGR_INDIV_NAME_CTX$R TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_DISCLOSURE_CAT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_NBFG_CLIENT_SUM TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_H TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_H_IN1267055 TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_IN1267055 TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS_IN1267055 TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS_NON_CDI TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.MDM_EXTERNAL_POLICY TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.MDM_LOAD_TMP_TABLES TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_CRITERIA TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.ODS_PKG TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_ADDRESS TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_DELTA_CONTROL TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EVENT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_GEO_AREA TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_TELEPHONE TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.PR_UPDATE_LIFECYCLE TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SEQ_CDI_AUDIT TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SEQ_LPVG_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SEQ_PAACT_ID TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.SET_TS_SBIP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBACTR_ACCTG_TRST TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCARD_CARD TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCNL_CHANNL TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBOGUN_ORG_UNIT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDT_PRODUCT TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP_B TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSS_SRC_SYSTM TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSST_SRC_SYSTM_TYP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_DOMAIN TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_TRANSLATION TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_VALUE_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VERSION_SCHEMA TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VPMPAR TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_RECONCILIATION TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0025 TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0057 TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0084 TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0091 TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_SYSDF_SBIP TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_TBCNL_CHANNL TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.WORK_CDI_MCP_INITIAL_LOAD TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.WORK_CDI_RECONCILIATION TO RL___SCHEMA___READWRITE;

GRANT EXECUTE ON __SCHEMA__.SET_TS_SBIP TO RL_SBIP_DV1_ODS_LECT;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0057 TO RL_SBIP_DV1_ODS_LECT;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0084 TO RL_SBIP_DV1_ODS_LECT;

GRANT SELECT ON __SCHEMA__.VW_ODSDLT_SBIP_0091 TO RL_SBIP_DV1_ODS_LECT;

GRANT SELECT ON __SCHEMA__.VW_SYSDF_SBIP TO RL_SBIP_DV1_ODS_LECT;

GRANT SELECT ON __SCHEMA__.CDI_AUDIT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.CDI_USER TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.E_DISCLOSURE_CAT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.E_NBFG_CLIENT_SUM TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_H TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.ENTITY_MEMBERS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_ADDRESS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_DELTA_CONTROL TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_EVENT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_GEO_AREA TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_TELEPHONE TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBACTR_ACCTG_TRST TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBCARD_CARD TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBCNL_CHANNL TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBOGUN_ORG_UNIT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDT_PRODUCT TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP_B TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBSS_SRC_SYSTM TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBSST_SRC_SYSTM_TYP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE_DOMAIN TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE_TRANSLATION TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VALUE_VALUE_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VERSION_SCHEMA TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_MEMBERS TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_RECONCILIATION TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.WORK_CDI_MCP_INITIAL_LOAD TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.WORK_CDI_RECONCILIATION TO RO___SCHEMA___READONLY;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_AUDIT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_USER TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_DISCLOSURE_CAT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_NBFG_CLIENT_SUM TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_H TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_CRITERIA TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_ADDRESS TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_DELTA_CONTROL TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EVENT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_GEO_AREA TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_TELEPHONE TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO RO___SCHEMA___READWRITE;

GRANT ALTER, SELECT ON __SCHEMA__.SEQ_PAACT_ID TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBACTR_ACCTG_TRST TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCARD_CARD TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBOGUN_ORG_UNIT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAACT_PRDT_AGMT_ACTVT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDT_PRODUCT TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_DOMAIN TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_TRANSLATION TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_VALUE_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VERSION_SCHEMA TO RO___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.VW_ENTITY_RECONCILIATION TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.WORK_CDI_MCP_INITIAL_LOAD TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.WORK_CDI_RECONCILIATION TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_AUDIT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_USER TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_DISCLOSURE_CAT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_NBFG_CLIENT_SUM TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_H TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS_NON_CDI TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST TO RO_ODS_READWRITE;

GRANT SELECT ON __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID TO RO_ODS_READWRITE;

GRANT SELECT ON __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_ADDRESS TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_DELTA_CONTROL TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EVENT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_GEO_AREA TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_TELEPHONE TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO RO_ODS_READWRITE;

GRANT ALTER, SELECT ON __SCHEMA__.SEQ_CDI_AUDIT TO RO_ODS_READWRITE;

GRANT ALTER, SELECT ON __SCHEMA__.SEQ_LPVG_ID TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBACTR_ACCTG_TRST TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCARD_CARD TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCNL_CHANNL TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBOGUN_ORG_UNIT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRAG_PRDT_AGMT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDT_PRODUCT TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYOGP_PTY_OGUN_PRIO_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSS_SRC_SYSTM TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSST_SRC_SYSTM_TYP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_DOMAIN TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_TRANSLATION TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_VALUE_RLTNP TO RO_ODS_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.WORK_CDI_RECONCILIATION TO RO_ODS_READWRITE;

GRANT SELECT ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP_B TO RO_ODS_TU1_READONLY;

GRANT SELECT ON __SCHEMA__.WORK_CDI_MCP_INITIAL_LOAD TO RO_ODS_TU1_READONLY;

GRANT SELECT ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP TO SOA_LOCATIONINFMGMT_DV1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO SOA_LOCATIONINFMGMT_DV1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP TO SOA_LOCATIONINFMGMT_DV1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBOGUN_ORG_UNIT TO SOA_LOCATIONINFMGMT_DV1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBDCOU_DC_ORG_UNIT_RLTNP TO SOA_LOCATIONINFMGMT_TU1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO SOA_LOCATIONINFMGMT_TU1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBOGOG_OGUN_OGUN_RLTNP TO SOA_LOCATIONINFMGMT_TU1 WITH GRANT OPTION;

GRANT SELECT ON __SCHEMA__.TBOGUN_ORG_UNIT TO SOA_LOCATIONINFMGMT_TU1 WITH GRANT OPTION;

GRANT EXECUTE ON __SCHEMA__.SET_TS_SBIP TO USR_SBIP_ODS;

GRANT EXECUTE ON __SCHEMA__.SET_TS_SBIP TO USR_SBIP___SCHEMA__;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_AUDIT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.CDI_USER TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_DISCLOSURE_CAT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.E_NBFG_CLIENT_SUM TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_H TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.ENTITY_MEMBERS_NON_CDI TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_CLIENT_LFCLS_TO_PUBLISH TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_LFCLL_CLIENT_LIST TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_CRITERIA TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_CRITERIA_INFO TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_SEARCHCL_WEIGHT_MODIFIER TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_TMP1_CLIENT_CUR_EID TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.MDM_TMP2_CLIENT_AGR_PRD_RLTN TO WAS_USR_DV1;

GRANT EXECUTE ON __SCHEMA__.ODS_PKG TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_ADDRESS TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_LIFE_CYCLE_STATUS TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_CLIENT_SPECIFIC_COND TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_DELTA_CONTROL TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_IDENT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_NAME TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_INDIVIDUAL_OCCUPATION TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_MEMBER_ORGANIZATION_UNIT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EMAIL_ADDRESS TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_EVENT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_GEO_AREA TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_LIST_MEMBER TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_TELEPHONE TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PGR_PARTY_WEB_ADDRESS TO WAS_USR_DV1;

GRANT ALTER, SELECT ON __SCHEMA__.SEQ_CDI_AUDIT TO WAS_USR_DV1;

GRANT ALTER, SELECT ON __SCHEMA__.SEQ_LPVG_ID TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBACTR_ACCTG_TRST TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCARD_CARD TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBCNL_CHANNL TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBDISCN_DISTRBTN_CHANNL TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBFGLE_FIN_GRP_LGL_ENTITY TO WAS_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBLGPR_LEGACY_PRODUCT TO WAS_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBLPVG_LEGACY_PRODUCT_VAR_GIC TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBOGUN_ORG_UNIT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAAM_PRAG_PAGM_RLTNP TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAOU_PRAG_ORG_UNIT_RLTNP TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAPA_PRAG_PRAG_RLTNP TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPAP_PRDT_AGMT_PREF TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRAG_PRDT_AGMT TO WAS_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBPRDT_PRODUCT TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYMPA_PTYMBR_PRDT_AGMT_RLTNP TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPYPA_PARTY_PRDT_AGMT_RLTNP TO WAS_USR_DV1;

GRANT SELECT ON __SCHEMA__.TBSYSDF_SYS_DATA_FRESHNESS TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_DOMAIN TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_TRANSLATION TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VALUE_VALUE_RLTNP TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.VERSION_SCHEMA TO WAS_USR_DV1;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.WORK_CDI_RECONCILIATION TO WAS_USR_DV1;
*/

CREATE INDEX __SCHEMA__.IDX_VPMPAR ON __SCHEMA__.VPMPAR
(PTY$SRCCD, PTY$MEMBERID)
LOGGING
TABLESPACE TSD_ODS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;