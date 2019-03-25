--------------------------------------------------------------------------
-- __SCHEMA__@DOMDMA schema extracted by user BE82947
--------------------------------------------------------------------------
-- "Set define off" turns off substitution variables.
Set define off;

CREATE TABLE __SCHEMA__.FREQ_FACTOR
(
  FREQ_FACTOR_ID         NUMBER                 NOT NULL,
  TYPE_CD                VARCHAR2(10 CHAR)      NOT NULL,
  FREQ_UNIT_OF_MSR_CD    VARCHAR2(10 CHAR)      NOT NULL,
  PERIOD_UNIT_OF_MSR_CD  VARCHAR2(10 CHAR)      NOT NULL,
  EFFCTV_DT              DATE                   NOT NULL,
  END_DT                 DATE,
  VALUE                  NUMBER(19,4)           NOT NULL,
  SRC_CD                 VARCHAR2(10 CHAR)      NOT NULL,
  SRC_KEY                VARCHAR2(60 CHAR)
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

COMMENT ON TABLE __SCHEMA__.FREQ_FACTOR IS 'Paramètres de conversion des fréquences de paiement';


CREATE UNIQUE INDEX __SCHEMA__.PK_FREQ_FACTOR ON __SCHEMA__.FREQ_FACTOR
(FREQ_FACTOR_ID)
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

ALTER TABLE __SCHEMA__.FREQ_FACTOR
 ADD CONSTRAINT PK_FREQ_FACTOR
  PRIMARY KEY
  (FREQ_FACTOR_ID)
  RELY
  USING INDEX __SCHEMA__.PK_FREQ_FACTOR;

CREATE TABLE __SCHEMA__.GEO_SALE_TAX
(
  GEO_SALE_TAX_ID  NUMBER                       NOT NULL,
  AREA_CD          VARCHAR2(10 CHAR)            NOT NULL,
  TYPE_CD          VARCHAR2(10 CHAR)            NOT NULL,
  EFFCTV_DT        DATE                         NOT NULL,
  END_DT           DATE,
  SRC_CD           VARCHAR2(10 CHAR)            NOT NULL,
  SRC_KEY          VARCHAR2(60 CHAR)
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

COMMENT ON TABLE __SCHEMA__.GEO_SALE_TAX IS 'Type de taxes applicables sur les assurances par province canadienne (ex : TVQ, TPS)';


CREATE UNIQUE INDEX __SCHEMA__.PK_GEO_SALE_TAX ON __SCHEMA__.GEO_SALE_TAX
(GEO_SALE_TAX_ID)
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

ALTER TABLE __SCHEMA__.GEO_SALE_TAX
 ADD CONSTRAINT PK_GEO_SALE_TAX
  PRIMARY KEY
  (GEO_SALE_TAX_ID)
  RELY
  USING INDEX __SCHEMA__.PK_GEO_SALE_TAX;

CREATE TABLE __SCHEMA__.PRDT_CONDITION
(
  PRDT_CONDITION_ID      NUMBER                 NOT NULL,
  EFFCTV_DT              DATE                   NOT NULL,
  END_DT                 DATE,
  FRENCH_NAME            VARCHAR2(100 CHAR),
  SRC_CD                 VARCHAR2(10 CHAR)      NOT NULL,
  SRC_KEY                VARCHAR2(200 CHAR)     NOT NULL,
  REC_LAST_UPD_TM        TIMESTAMP(6),
  REC_LAST_UPD_BATCH_ID  NUMBER(12)
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

COMMENT ON TABLE __SCHEMA__.PRDT_CONDITION IS 'Ensemble de valeurs identifiant un taux unique (ex: variabilité du taux, terme, cote de risque, méthode de financement)';

COMMENT ON COLUMN __SCHEMA__.PRDT_CONDITION.PRDT_CONDITION_ID IS 'Unique identifier of the condition.';

COMMENT ON COLUMN __SCHEMA__.PRDT_CONDITION.SRC_CD IS 'Source code.';

COMMENT ON COLUMN __SCHEMA__.PRDT_CONDITION.SRC_KEY IS 'Identifier of the condition such as defined at the source.';


CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_CONDITION ON __SCHEMA__.PRDT_CONDITION
(PRDT_CONDITION_ID)
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

ALTER TABLE __SCHEMA__.PRDT_CONDITION
 ADD CONSTRAINT PK_PRDT_CONDITION
  PRIMARY KEY
  (PRDT_CONDITION_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_CONDITION;

CREATE TABLE __SCHEMA__.PRDT_CONDITION_BAK
(
  PRDT_CONDITION_ID      NUMBER                 NOT NULL,
  EFFCTV_DT              DATE                   NOT NULL,
  END_DT                 DATE,
  FRENCH_NAME            VARCHAR2(100 CHAR),
  SRC_CD                 VARCHAR2(10 CHAR)      NOT NULL,
  SRC_KEY                VARCHAR2(200 CHAR)     NOT NULL,
  REC_LAST_UPD_TM        TIMESTAMP(6),
  REC_LAST_UPD_BATCH_ID  NUMBER(12)
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

CREATE TABLE __SCHEMA__.PRDT_CONDTN_RLTNP
(
  PRDT_ID            VARCHAR2(70 BYTE)          NOT NULL,
  PRDT_CONDITION_ID  NUMBER                     NOT NULL,
  EFFCTV_DT          DATE                       NOT NULL,
  END_DT             DATE
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

COMMENT ON TABLE __SCHEMA__.PRDT_CONDTN_RLTNP IS 'Tale relation entre les produits et les conditions de taux';

COMMENT ON COLUMN __SCHEMA__.PRDT_CONDTN_RLTNP.PRDT_ID IS 'Identifiant de l''entente de produit';


CREATE INDEX __SCHEMA__.FK_PRDT_CONDTN_RLTNP_CONDTN_01 ON __SCHEMA__.PRDT_CONDTN_RLTNP
(PRDT_CONDITION_ID)
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

CREATE INDEX __SCHEMA__.FK_PRDT_CONDTN_RLTNP_PRDT_01 ON __SCHEMA__.PRDT_CONDTN_RLTNP
(PRDT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_CONDTN_RLTNP ON __SCHEMA__.PRDT_CONDTN_RLTNP
(PRDT_ID, PRDT_CONDITION_ID)
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

ALTER TABLE __SCHEMA__.PRDT_CONDTN_RLTNP
 ADD CONSTRAINT PK_PRDT_CONDTN_RLTNP
  PRIMARY KEY
  (PRDT_ID, PRDT_CONDITION_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_CONDTN_RLTNP;

CREATE TABLE __SCHEMA__.PRDT_CONDTN_RLTNP_BAK
(
  PRDT_ID            VARCHAR2(70 BYTE)          NOT NULL,
  PRDT_CONDITION_ID  NUMBER                     NOT NULL,
  EFFCTV_DT          DATE                       NOT NULL,
  END_DT             DATE
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

CREATE TABLE __SCHEMA__.PRDT_CRITERIA
(
  PRDT_CONDITION_ID         NUMBER              NOT NULL,
  TYPE_CD                   VARCHAR2(10 CHAR)   NOT NULL,
  NUMERIC_VALUE             NUMBER(19,4),
  STRING_CD_VALUE           VARCHAR2(30 CHAR),
  LOWER_VALUE               NUMBER(19,4),
  UPPER_VALUE               NUMBER(19,4),
  LOWER_COMPARISON_TYPE_CD  VARCHAR2(10 CHAR),
  UPPER_COMPARISON_TYPE_CD  VARCHAR2(10 CHAR),
  UNIT_OF_MSR_CD            VARCHAR2(10 CHAR)
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

COMMENT ON TABLE __SCHEMA__.PRDT_CRITERIA IS 'Critères utilisés pour chercher un taux (ex : Terme, terme minimum, terme maximum, âge, objectif financier)';


CREATE INDEX __SCHEMA__.FK_PRDT_CRITERIA_CONDTN_01 ON __SCHEMA__.PRDT_CRITERIA
(PRDT_CONDITION_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_CRITERIA ON __SCHEMA__.PRDT_CRITERIA
(PRDT_CONDITION_ID, TYPE_CD)
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

ALTER TABLE __SCHEMA__.PRDT_CRITERIA
 ADD CONSTRAINT PK_PRDT_CRITERIA
  PRIMARY KEY
  (PRDT_CONDITION_ID, TYPE_CD)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_CRITERIA;

CREATE TABLE __SCHEMA__.PRDT_CRITERIA_BAK
(
  PRDT_CONDITION_ID         NUMBER              NOT NULL,
  TYPE_CD                   VARCHAR2(10 CHAR)   NOT NULL,
  NUMERIC_VALUE             NUMBER(19,4),
  STRING_CD_VALUE           VARCHAR2(30 CHAR),
  LOWER_VALUE               NUMBER(19,4),
  UPPER_VALUE               NUMBER(19,4),
  LOWER_COMPARISON_TYPE_CD  VARCHAR2(10 CHAR),
  UPPER_COMPARISON_TYPE_CD  VARCHAR2(10 CHAR),
  UNIT_OF_MSR_CD            VARCHAR2(10 CHAR)
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

CREATE TABLE __SCHEMA__.PRDT_FREQ_FACTOR
(
  PRDT_ID         VARCHAR2(70 BYTE)             NOT NULL,
  FREQ_FACTOR_ID  NUMBER                        NOT NULL,
  EFFCTV_DT       DATE                          NOT NULL,
  END_DT          DATE
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

COMMENT ON TABLE __SCHEMA__.PRDT_FREQ_FACTOR IS 'Table relation entre les produits et les facteurs de fréquence';

COMMENT ON COLUMN __SCHEMA__.PRDT_FREQ_FACTOR.PRDT_ID IS 'Identifiant de l''entente de produit';


CREATE INDEX __SCHEMA__.FK_PRDT_FREQ_FACTOR_FREQ_01 ON __SCHEMA__.PRDT_FREQ_FACTOR
(FREQ_FACTOR_ID)
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

CREATE INDEX __SCHEMA__.FK_PRDT_FREQ_FACTOR_PRDT_01 ON __SCHEMA__.PRDT_FREQ_FACTOR
(PRDT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_FREQ_FACTOR ON __SCHEMA__.PRDT_FREQ_FACTOR
(PRDT_ID, FREQ_FACTOR_ID)
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

ALTER TABLE __SCHEMA__.PRDT_FREQ_FACTOR
 ADD CONSTRAINT PK_PRDT_FREQ_FACTOR
  PRIMARY KEY
  (PRDT_ID, FREQ_FACTOR_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_FREQ_FACTOR;

CREATE TABLE __SCHEMA__.PRDT_PRICING_BAK
(
  PRDT_CONDITION_ID         NUMBER              NOT NULL,
  PRDT_PRICING_TYPE_CD      VARCHAR2(10 CHAR)   NOT NULL,
  PRDT_PRICING_CURRENCY_CD  VARCHAR2(10 CHAR)   NOT NULL,
  PRDT_PRICING_EFFCTV_DT    DATE                NOT NULL,
  PRDT_PRICING_END_DT       DATE,
  REF_RATE_ID               NUMBER,
  PRDT_PRICING_VALUE        NUMBER(23,8)        NOT NULL,
  SPREAD_IND_CD             VARCHAR2(10 CHAR),
  OPERATOR_TYPE_CD          VARCHAR2(10 CHAR),
  UNIT_OF_MSR_CD            VARCHAR2(10 CHAR)
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

CREATE TABLE __SCHEMA__.PRDT_SALE_TAX_RLTNP
(
  PRDT_ID          VARCHAR2(70 BYTE)            NOT NULL,
  GEO_SALE_TAX_ID  NUMBER                       NOT NULL,
  EFFCTV_DT        DATE                         NOT NULL,
  END_DT           DATE
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

COMMENT ON TABLE __SCHEMA__.PRDT_SALE_TAX_RLTNP IS 'Table relation entre les produits et les types de taxes sur les assurances';

COMMENT ON COLUMN __SCHEMA__.PRDT_SALE_TAX_RLTNP.PRDT_ID IS 'Identifiant de l''entente de produit';


CREATE INDEX __SCHEMA__.FK_PRDT_SALE_TAX_RLTNP_GEO_01 ON __SCHEMA__.PRDT_SALE_TAX_RLTNP
(GEO_SALE_TAX_ID)
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

CREATE INDEX __SCHEMA__.FK_PRDT_SALE_TAX_RLTNP_PRDT_01 ON __SCHEMA__.PRDT_SALE_TAX_RLTNP
(PRDT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_SALE_TAX_RLTNP ON __SCHEMA__.PRDT_SALE_TAX_RLTNP
(PRDT_ID, GEO_SALE_TAX_ID)
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

ALTER TABLE __SCHEMA__.PRDT_SALE_TAX_RLTNP
 ADD CONSTRAINT PK_PRDT_SALE_TAX_RLTNP
  PRIMARY KEY
  (PRDT_ID, GEO_SALE_TAX_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_SALE_TAX_RLTNP;

CREATE TABLE __SCHEMA__.PRDT_THLD
(
  PRDT_THLD_TYPE_CD    VARCHAR2(10 CHAR)        NOT NULL,
  PRDT_ID              VARCHAR2(70 BYTE)        NOT NULL,
  PRDT_THLD_EFFCTV_DT  DATE                     NOT NULL,
  PRDT_THLD_END_DT     DATE,
  PRDT_THLD_VALUE      NUMBER(19,4),
  UNIT_OF_MSR_CD       VARCHAR2(10 CHAR),
  PRDT_THLD_SRC_CD     VARCHAR2(10 CHAR)        NOT NULL,
  PRDT_THLD_SRC_KEY    VARCHAR2(60 CHAR)
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

COMMENT ON TABLE __SCHEMA__.PRDT_THLD IS 'ATD (Amportissement Total Dette)
ABD (Amortissement Brut Dette)
Ratio RPV maximum (LTV)
Ratio RPV minimum (LTV)
Taux plafond
';

COMMENT ON COLUMN __SCHEMA__.PRDT_THLD.PRDT_ID IS 'Identifiant de l''entente de produit';


CREATE INDEX __SCHEMA__.FK_PRDT_THLD_PRDT_01 ON __SCHEMA__.PRDT_THLD
(PRDT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_THLD ON __SCHEMA__.PRDT_THLD
(PRDT_THLD_TYPE_CD, PRDT_ID, PRDT_THLD_EFFCTV_DT)
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

ALTER TABLE __SCHEMA__.PRDT_THLD
 ADD CONSTRAINT PK_PRDT_THLD
  PRIMARY KEY
  (PRDT_THLD_TYPE_CD, PRDT_ID, PRDT_THLD_EFFCTV_DT)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_THLD;

CREATE TABLE __SCHEMA__.REF_RATE
(
  REF_RATE_ID  NUMBER                           NOT NULL,
  TYPE_CD      VARCHAR2(10 CHAR)                NOT NULL,
  CURRENCY_CD  VARCHAR2(10 CHAR)                NOT NULL,
  EFFCTV_DT    DATE                             NOT NULL,
  END_DT       DATE,
  VALUE        NUMBER(23,8)                     NOT NULL,
  SRC_CD       VARCHAR2(10 CHAR)                NOT NULL,
  SRC_KEY      VARCHAR2(200 CHAR)               NOT NULL
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

COMMENT ON TABLE __SCHEMA__.REF_RATE IS 'Taux de référence :
- Taux de base
- Taux de la Banque du Canada
- Écart entre le taux de base et le taux BA
';

COMMENT ON COLUMN __SCHEMA__.REF_RATE.SRC_CD IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.REF_RATE.SRC_KEY IS 'Identifiant de l''entente de produit';


CREATE UNIQUE INDEX __SCHEMA__.PK_REF_RATE ON __SCHEMA__.REF_RATE
(REF_RATE_ID)
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

ALTER TABLE __SCHEMA__.REF_RATE
 ADD CONSTRAINT PK_REF_RATE
  PRIMARY KEY
  (REF_RATE_ID)
  RELY
  USING INDEX __SCHEMA__.PK_REF_RATE;

CREATE TABLE __SCHEMA__.SALE_TAX_RATE
(
  GEO_SALE_TAX_ID  NUMBER                       NOT NULL,
  EFFCTV_DT        DATE                         NOT NULL,
  END_DT           DATE,
  VALUE            NUMBER(13,5)                 NOT NULL,
  UNIT_OF_MSR_CD   VARCHAR2(10 CHAR)
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

COMMENT ON TABLE __SCHEMA__.SALE_TAX_RATE IS 'Les différents taux de  taxes applicables sur les assurances :
- Taxe fédérale TPS utilisée dans plusieurs provinces
- Taxe harmonisée HVT utilisée dans plusieurs provinces
- Taxe de vente provinciale CB, SK, MB
- Taxe de vente du Québec TVQ
- Taxe sur prime d''assurance
en fonction des provinces';


CREATE INDEX __SCHEMA__.FK_SALE_TAX_RATE_GEO_01 ON __SCHEMA__.SALE_TAX_RATE
(GEO_SALE_TAX_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_SALE_TAX_RATE ON __SCHEMA__.SALE_TAX_RATE
(GEO_SALE_TAX_ID, EFFCTV_DT)
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

ALTER TABLE __SCHEMA__.SALE_TAX_RATE
 ADD CONSTRAINT PK_SALE_TAX_RATE
  PRIMARY KEY
  (GEO_SALE_TAX_ID, EFFCTV_DT)
  RELY
  USING INDEX __SCHEMA__.PK_SALE_TAX_RATE;

CREATE TABLE __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
(
  LAST_EVT_TM                  TIMESTAMP(6),
  LAST_EVT_USER_ID             VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM              TIMESTAMP(6)     DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID         VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID        NUMBER(12),
  REC_LAST_UPD_SRC_CD          VARCHAR2(4 CHAR),
  PRDACT_ID                    NUMBER(12)       NOT NULL,
  PRDT_ID                      VARCHAR2(70 BYTE) NOT NULL,
  PRDACT_TYP_CD                VARCHAR2(100 CHAR) NOT NULL,
  PRDACT_EFFCTV_DT             DATE             NOT NULL,
  PRDACT_END_DT                DATE,
  PRDACT_RECURRNG_PERIODCT_CD  VARCHAR2(100 CHAR),
  PRDACT_RECURRNG_ACTVT_FLAG   NUMBER(1),
  PRDACT_EXPECTD_START_DT      DATE,
  PRDACT_EXPECTD_END_DT        DATE
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

COMMENT ON TABLE __SCHEMA__.TBPRDACT_PRDT_ACTIVITY IS 'Product Activity is used to provide a simplified ''life-history'' of a Product (potentially in isolation of Transactions). including past completed and future projected events.  Product Activity are intended to cover those Activities which pertain to the Product by its nature, terms and conditions (e.g. Product Launch, Share Issue, Interest Capitalization).  Activities which occur for Agreements related to a Product which not determined at the Product level should not be represented by Product Activity but Agreement Activity.
For example statement production for a demand deposit product could be determined at either the Product or Agreement level.
Some Product Activity will result in Agreement Activities (e.g. Dividend Payments) while others may not (e.g. Product Launch).
IBM Unique ID:BDW03107';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_ID IS 'Product Activity Unique Identifier.';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDT_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_TYP_CD IS 'Activity Type Unique Code';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_EFFCTV_DT IS 'The date on which the Product Activity actually began.IBM Unique ID:BDW03177';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_END_DT IS 'The date on which the Product Activity actually concluded.
(For a single occurrence Activity, the same value as Actual Start Date).
IBM Unique ID:BDW13423';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_RECURRNG_PERIODCT_CD IS 'Where the Recurring Activity Flag indicates that this is a multiple occurrence Product Activity, the unique identifier of the Periodicity Interval defining the interval between occurrences.
IBM Unique ID:BDW13438';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_RECURRNG_ACTVT_FLAG IS 'Indicates whether this is a single occurrence (0) or repeating (1) Product Activity.
IBM Unique ID:BDW13424';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_EXPECTD_START_DT IS 'The date on which the Product Activity is expected to begin.
IBM Unique ID:BDW03184';

COMMENT ON COLUMN __SCHEMA__.TBPRDACT_PRDT_ACTIVITY.PRDACT_EXPECTD_END_DT IS 'The date on which the Product Activity is expected to conclude. (For a single occurrence Activity, the same value as Expected Start Date).
IBM Unique ID:BDW03181';


CREATE UNIQUE INDEX __SCHEMA__.AK_PRDACT_01 ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
(PRDT_ID, PRDACT_TYP_CD, PRDACT_EFFCTV_DT, PRDACT_RECURRNG_PERIODCT_CD)
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

CREATE INDEX __SCHEMA__.FK_PRDACT_PRDT_01 ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
(PRDT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDACT ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
(PRDACT_ID)
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

ALTER TABLE __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
 ADD CONSTRAINT PK_PRDACT
  PRIMARY KEY
  (PRDACT_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDACT;

ALTER TABLE __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
 ADD CONSTRAINT AK_PRDACT_01
  UNIQUE (PRDT_ID, PRDACT_TYP_CD, PRDACT_EFFCTV_DT, PRDACT_RECURRNG_PERIODCT_CD)
  USING INDEX __SCHEMA__.AK_PRDACT_01;

CREATE TABLE __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
(
  LAST_EVT_TM               TIMESTAMP(6),
  LAST_EVT_USER_ID          VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM           TIMESTAMP(6)        DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID      VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID     NUMBER(12),
  REC_LAST_UPD_SRC_CD       VARCHAR2(4 CHAR),
  PRDASC_ID                 NUMBER(12)          NOT NULL,
  PRDACT_ID                 NUMBER(12)          NOT NULL,
  PRDASC_ACTUAL_AMT_UOM_CD  VARCHAR2(100 CHAR),
  PRDASC_CURRENCY_CD        VARCHAR2(100 CHAR)  NOT NULL,
  PRDASC_SCHEDULE_SEQ_NO    NUMBER(38)          NOT NULL,
  PRDASC_ACTUAL_AMT         NUMBER(23,8),
  PRDASC_ACTUAL_DT          DATE,
  PRDASC_SCHEDULED_AMT      NUMBER(23,8),
  PRDASC_SCHEDULED_DT       DATE
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

COMMENT ON TABLE __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE IS 'Product Activity Schedule defines a schedule of activities that recur at a regular frequency for a Product.  Examples would include Bond Coupon Payments, Interest Capitalization (if fixed at the level of the Product).
IBM Unique ID:BDW03106';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_ID IS 'The unique identifier of the Product Activity Schedule.';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDACT_ID IS 'The unique identifier of the relevant Product Activity. IBM Unique ID:BDW13425';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_ACTUAL_AMT_UOM_CD IS 'The Unit of Measure Code';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_CURRENCY_CD IS 'Currency Code (denormalization of the column CURRENCYID - The unique identifier of the Currency)';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_SCHEDULE_SEQ_NO IS 'A sequence number uniquely identifying a particular scheduled occurrence of a multiple occurrence Product Activity.
IBM Unique ID:BDW13426';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_ACTUAL_AMT IS 'The actual amount involved when the sub-Activity actually occurred, where applicable. For example, the actual dividend paid.
IBM Unique ID:BDW03176';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_ACTUAL_DT IS 'The date on which the scheduled sub-Activity actually occurred. For example, the date on which shares were actually issued.
IBM Unique ID:BDW03194';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_SCHEDULED_AMT IS 'The expected amount associated with a particular scheduled sub-Activity, where applicable.
For example, the number of shares to be issued, the expected dividend payment.IBM Unique ID:BDW03185';

COMMENT ON COLUMN __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE.PRDASC_SCHEDULED_DT IS 'The date on which the scheduled sub-Activity is expected to occur. For example, a planned Bond Coupon Payment date.
IBM Unique ID:BDW03195';


CREATE UNIQUE INDEX __SCHEMA__.AK_PRDASC_01 ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
(PRDACT_ID, PRDASC_ACTUAL_DT, PRDASC_SCHEDULE_SEQ_NO)
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

CREATE INDEX __SCHEMA__.FK_PRDASC_PRDACT_01 ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
(PRDACT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDASC ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
(PRDASC_ID)
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

ALTER TABLE __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
 ADD CONSTRAINT PK_PRDASC
  PRIMARY KEY
  (PRDASC_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDASC;

ALTER TABLE __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
 ADD CONSTRAINT AK_PRDASC_01
  UNIQUE (PRDACT_ID, PRDASC_ACTUAL_DT, PRDASC_SCHEDULE_SEQ_NO)
  USING INDEX __SCHEMA__.AK_PRDASC_01;

CREATE TABLE __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
(
  LAST_EVT_TM                   TIMESTAMP(6),
  LAST_EVT_USER_ID              VARCHAR2(30 CHAR),
  REC_LAST_UPD_TM               TIMESTAMP(6)    DEFAULT SYSDATE,
  REC_LAST_UPD_USER_ID          VARCHAR2(30 CHAR),
  REC_LAST_UPD_BATCH_ID         NUMBER(12),
  REC_LAST_UPD_SRC_CD           VARCHAR2(4 CHAR),
  PRDCHA_ID                     NUMBER(12)      NOT NULL,
  PRDT_ID                       VARCHAR2(70 BYTE) NOT NULL,
  PRDCHA_TYP_CD                 VARCHAR2(100 CHAR) NOT NULL,
  PRDCHA_EFFCTV_DT              DATE            NOT NULL,
  PRDCHA_END_DT                 DATE,
  PRDCHA_VAL_CD                 VARCHAR2(100 CHAR),
  PRDCHA_STRING_VAL             VARCHAR2(500 CHAR),
  PRDCHA_UOM_CD                 VARCHAR2(100 CHAR),
  PRDCHA_CURRENCY_CD            VARCHAR2(100 CHAR),
  PRDCHA_NUMERIC_VAL            NUMBER(19,4),
  PRDCHA_LOWER_COMPARSN_TYP_CD  VARCHAR2(100 CHAR),
  PRDCHA_LOWER_VAL              NUMBER(19,4),
  PRDCHA_UPPER_COMPARSN_TYP_CD  VARCHAR2(100 CHAR),
  PRDCHA_UPPER_VAL              NUMBER(19,4)
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

COMMENT ON TABLE __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC IS 'This entity is holding elements featuring the nature (minimum age, minimum participation) of the product.
A characteristic is defining the product whitout impacting pricing.
Examples:
  - Eligibility criteria (age, minimum amount)
  - Regions where the product is available
  -  Registered Plan eligibility (RRSP, RRIF, TFSA ou REER, FERR, CELI)
  -  Risk level';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.LAST_EVT_TM IS 'The  timestamp of the last change in the source system that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.LAST_EVT_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.REC_LAST_UPD_TM IS 'The timestamp of the last update of the record in this table.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.REC_LAST_UPD_USER_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.REC_LAST_UPD_BATCH_ID IS 'The userid of the user in the source system of the last change that triggered the publication of the golden record.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_ID IS 'Product Characteristic Unique Identifier';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDT_ID IS 'Identifiant de l''entente de produit';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_TYP_CD IS 'Product Characteristic Type Unique Code';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_EFFCTV_DT IS 'The date on which the Product Characteristic Id is active.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_END_DT IS 'The date on which the Product Characteristic Id is no longer active.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_VAL_CD IS 'The value of the product characteristic, when this value is a code (short string).';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_STRING_VAL IS 'The value of the product characteristic, when this value is a string.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_UOM_CD IS 'The Code of the Unit Of Measure.
IBM Unique ID:BDW06994';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_CURRENCY_CD IS 'Currency Code (denormalization of the column CURRENCYID - The unique identifier of the Currency)';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_NUMERIC_VAL IS 'The value of the product characteristic, when this value is a numeric.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_LOWER_COMPARSN_TYP_CD IS 'Lower Comparison Type Unique Code.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_LOWER_VAL IS 'Lower numeric value of the product characteristic.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_UPPER_COMPARSN_TYP_CD IS 'Upper Comparison Type Unique Code.';

COMMENT ON COLUMN __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC.PRDCHA_UPPER_VAL IS 'Upper numeric value of the product characteristic.';


CREATE UNIQUE INDEX __SCHEMA__.AK_PRDCHA_01 ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
(PRDT_ID, PRDCHA_TYP_CD, PRDCHA_EFFCTV_DT)
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

CREATE INDEX __SCHEMA__.FK_PRDCHA_PRDT_01 ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
(PRDT_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDCHA ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
(PRDCHA_ID)
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

ALTER TABLE __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
 ADD CONSTRAINT PK_PRDCHA
  PRIMARY KEY
  (PRDCHA_ID)
  RELY
  USING INDEX __SCHEMA__.PK_PRDCHA;

ALTER TABLE __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
 ADD CONSTRAINT AK_PRDCHA_01
  UNIQUE (PRDT_ID, PRDCHA_TYP_CD, PRDCHA_EFFCTV_DT)
  USING INDEX __SCHEMA__.AK_PRDCHA_01;

CREATE SEQUENCE __SCHEMA__.SQ_FREQ_FACTOR_ID
  START WITH 21
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SQ_GEO_SALE_TAX_ID
  START WITH 21
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SQ_PRDACT_ID
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SQ_PRDASC_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SQ_PRDCHA_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SQ_PRDT_CONDITION_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

CREATE SEQUENCE __SCHEMA__.SQ_REF_RATE_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  GLOBAL;

 /*
CREATE SYNONYM __SCHEMA__.TBPRDT_PRODUCT FOR ODS.TBPRDT_PRODUCT;

GRANT SELECT ON __SCHEMA__.FREQ_FACTOR TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.GEO_SALE_TAX TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CONDITION TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CONDITION_BAK TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CONDTN_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CONDTN_RLTNP_BAK TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CRITERIA TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CRITERIA_BAK TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_FREQ_FACTOR TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_PRICING_BAK TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_SALE_TAX_RLTNP TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_THLD TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.REF_RATE TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SALE_TAX_RATE TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_FREQ_FACTOR_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_GEO_SALE_TAX_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_PRDACT_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_PRDASC_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_PRDCHA_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_PRDT_CONDITION_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SQ_REF_RATE_ID TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE TO RL___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC TO RL___SCHEMA___READONLY;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.FREQ_FACTOR TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.GEO_SALE_TAX TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDITION TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDITION_BAK TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDTN_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDTN_RLTNP_BAK TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CRITERIA TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CRITERIA_BAK TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_FREQ_FACTOR TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_PRICING_BAK TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_SALE_TAX_RLTNP TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_THLD TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.REF_RATE TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.SALE_TAX_RATE TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_FREQ_FACTOR_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_GEO_SALE_TAX_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDACT_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDASC_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDCHA_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDT_CONDITION_ID TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_REF_RATE_ID TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE TO RL___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.FREQ_FACTOR TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.GEO_SALE_TAX TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CONDITION TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CONDTN_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_CRITERIA TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_FREQ_FACTOR TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_SALE_TAX_RLTNP TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.PRDT_THLD TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.REF_RATE TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.SALE_TAX_RATE TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE TO RO___SCHEMA___READONLY;

GRANT SELECT ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC TO RO___SCHEMA___READONLY;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.FREQ_FACTOR TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.GEO_SALE_TAX TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDITION TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDTN_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CRITERIA TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_FREQ_FACTOR TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_SALE_TAX_RLTNP TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_THLD TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.REF_RATE TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.SALE_TAX_RATE TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.FREQ_FACTOR TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.GEO_SALE_TAX TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDITION TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDTN_RLTNP TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CRITERIA TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_FREQ_FACTOR TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_SALE_TAX_RLTNP TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_THLD TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.REF_RATE TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.SALE_TAX_RATE TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_FREQ_FACTOR_ID TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_GEO_SALE_TAX_ID TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDACT_ID TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDASC_ID TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDCHA_ID TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_PRDT_CONDITION_ID TO RO_RATES_READWRITE;

GRANT SELECT ON __SCHEMA__.SQ_REF_RATE_ID TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.FREQ_FACTOR TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.GEO_SALE_TAX TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDITION TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CONDTN_RLTNP TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_CRITERIA TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_FREQ_FACTOR TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_SALE_TAX_RLTNP TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_THLD TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.REF_RATE TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.SALE_TAX_RATE TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDACT_PRDT_ACTIVITY TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE TO RO_RATES_TU1_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC TO RO_RATES_TU1_READWRITE;
*/
CREATE TABLE __SCHEMA__.PRDT_PRICING
(
  PRDT_CONDITION_ID         NUMBER              NOT NULL,
  PRDT_PRICING_TYPE_CD      VARCHAR2(10 CHAR)   NOT NULL,
  PRDT_PRICING_CURRENCY_CD  VARCHAR2(10 CHAR)   NOT NULL,
  PRDT_PRICING_EFFCTV_DT    DATE                NOT NULL,
  PRDT_PRICING_END_DT       DATE,
  REF_RATE_ID               NUMBER,
  PRDT_PRICING_VALUE        NUMBER(23,8)        NOT NULL,
  SPREAD_IND_CD             VARCHAR2(10 CHAR),
  OPERATOR_TYPE_CD          VARCHAR2(10 CHAR),
  UNIT_OF_MSR_CD            VARCHAR2(10 CHAR)
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

COMMENT ON TABLE __SCHEMA__.PRDT_PRICING IS 'Type de taux (ex: coût de fonds, taux d''assurance vie, taux affiché, taux de perte)';


CREATE INDEX __SCHEMA__.FK_PRDT_PRICING_CONDTN_01 ON __SCHEMA__.PRDT_PRICING
(PRDT_CONDITION_ID)
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

CREATE INDEX __SCHEMA__.FK_PRDT_PRICING_REF_RATE_01 ON __SCHEMA__.PRDT_PRICING
(REF_RATE_ID)
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

CREATE UNIQUE INDEX __SCHEMA__.PK_PRDT_PRICING ON __SCHEMA__.PRDT_PRICING
(PRDT_CONDITION_ID, PRDT_PRICING_TYPE_CD, PRDT_PRICING_CURRENCY_CD, PRDT_PRICING_EFFCTV_DT)
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

ALTER TABLE __SCHEMA__.PRDT_PRICING
 ADD CONSTRAINT PK_PRDT_PRICING
  PRIMARY KEY
  (PRDT_CONDITION_ID, PRDT_PRICING_TYPE_CD, PRDT_PRICING_CURRENCY_CD, PRDT_PRICING_EFFCTV_DT)
  RELY
  USING INDEX __SCHEMA__.PK_PRDT_PRICING;
/*
GRANT SELECT ON __SCHEMA__.PRDT_PRICING TO RL___SCHEMA___READONLY;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_PRICING TO RL___SCHEMA___READWRITE;

GRANT SELECT ON __SCHEMA__.PRDT_PRICING TO RO___SCHEMA___READONLY;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_PRICING TO RO___SCHEMA___READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_PRICING TO RO_RATES_READWRITE;

GRANT DELETE, INSERT, SELECT, UPDATE ON __SCHEMA__.PRDT_PRICING TO RO_RATES_TU1_READWRITE;

ALTER TABLE __SCHEMA__.PRDT_CONDTN_RLTNP
 ADD CONSTRAINT FK_PRDT_CONDTN_RLTNP_CONDTN_01 
  FOREIGN KEY (PRDT_CONDITION_ID) 
  REFERENCES __SCHEMA__.PRDT_CONDITION (PRDT_CONDITION_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_CONDTN_RLTNP
 ADD CONSTRAINT FK_PRDT_CONDTN_RLTNP_PRDT_01 
  FOREIGN KEY (PRDT_ID) 
  REFERENCES ODS_DV3.TBPRDT_PRODUCT (PRDT_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_CRITERIA
 ADD CONSTRAINT FK_PRDT_CRITERIA_CONDTN_01 
  FOREIGN KEY (PRDT_CONDITION_ID) 
  REFERENCES __SCHEMA__.PRDT_CONDITION (PRDT_CONDITION_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_FREQ_FACTOR
 ADD CONSTRAINT FK_PRDT_FREQ_FACTOR_FREQ_01 
  FOREIGN KEY (FREQ_FACTOR_ID) 
  REFERENCES __SCHEMA__.FREQ_FACTOR (FREQ_FACTOR_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_FREQ_FACTOR
 ADD CONSTRAINT FK_PRDT_FREQ_FACTOR_PRDT_01 
  FOREIGN KEY (PRDT_ID) 
  REFERENCES ODS_DV3.TBPRDT_PRODUCT (PRDT_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_SALE_TAX_RLTNP
 ADD CONSTRAINT FK_PRDT_SALE_TAX_RLTNP_GEO_01 
  FOREIGN KEY (GEO_SALE_TAX_ID) 
  REFERENCES __SCHEMA__.GEO_SALE_TAX (GEO_SALE_TAX_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_SALE_TAX_RLTNP
 ADD CONSTRAINT FK_PRDT_SALE_TAX_RLTNP_PRDT_01 
  FOREIGN KEY (PRDT_ID) 
  REFERENCES ODS_DV3.TBPRDT_PRODUCT (PRDT_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_THLD
 ADD CONSTRAINT FK_PRDT_THLD_PRDT_01 
  FOREIGN KEY (PRDT_ID) 
  REFERENCES ODS_DV3.TBPRDT_PRODUCT (PRDT_ID)
  RELY;

ALTER TABLE __SCHEMA__.SALE_TAX_RATE
 ADD CONSTRAINT FK_SALE_TAX_RATE_GEO_01 
  FOREIGN KEY (GEO_SALE_TAX_ID) 
  REFERENCES __SCHEMA__.GEO_SALE_TAX (GEO_SALE_TAX_ID)
  RELY;

ALTER TABLE __SCHEMA__.TBPRDACT_PRDT_ACTIVITY
 ADD CONSTRAINT FK_PRDACT_PRDT_01 
  FOREIGN KEY (PRDT_ID) 
  REFERENCES ODS_DV3.TBPRDT_PRODUCT (PRDT_ID)
  RELY;

ALTER TABLE __SCHEMA__.TBPRDASC_PRDT_ACTVT_SCHEDULE
 ADD CONSTRAINT FK_PRDASC_PRDACT_01 
  FOREIGN KEY (PRDACT_ID) 
  REFERENCES __SCHEMA__.TBPRDACT_PRDT_ACTIVITY (PRDACT_ID)
  RELY;

ALTER TABLE __SCHEMA__.TBPRDCHA_PRDT_CHARACTERISTIC
 ADD CONSTRAINT FK_PRDCHA_PRDT_01 
  FOREIGN KEY (PRDT_ID) 
  REFERENCES ODS_DV3.TBPRDT_PRODUCT (PRDT_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_PRICING
 ADD CONSTRAINT FK_PRDT_PRICING_CONDTN_01 
  FOREIGN KEY (PRDT_CONDITION_ID) 
  REFERENCES __SCHEMA__.PRDT_CONDITION (PRDT_CONDITION_ID)
  RELY;

ALTER TABLE __SCHEMA__.PRDT_PRICING
 ADD CONSTRAINT FK_PRDT_PRICING_REF_RATE_01 
  FOREIGN KEY (REF_RATE_ID) 
  REFERENCES __SCHEMA__.REF_RATE (REF_RATE_ID)
  RELY;
  */