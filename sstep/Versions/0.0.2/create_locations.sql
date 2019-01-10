--  Adding Locations Table
CREATE TABLE LOCATIONS 
   (	  
   "LOCATION_ID" integer NOT NULL, 
	"STREET_ADDRESS" character varying(255), 
	"POSTAL_CODE" character varying(255), 
	"CITY" character varying(255), 
	"STATE_PROVINCE" character varying(255), 
	"COUNTRY_ID" character varying(255) 
	) ;
 --
-- Indexes
--
  CREATE INDEX LOC_CITY_IDX ON LOCATIONS USING btree ("CITY");
  CREATE INDEX LOC_POSTAL_IDX ON LOCATIONS USING btree ("POSTAL_CODE");
  CREATE INDEX LOC_STATE_IDX ON LOCATIONS USING btree ("STATE_PROVINCE");
 