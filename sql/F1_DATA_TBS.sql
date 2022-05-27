--------------------------------------------------------
--  File created - söndag-december-22-2019   
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Function TO_MILLIS
--------------------------------------------------------

CREATE OR REPLACE EDITIONABLE FUNCTION "F1_DATA"."TO_MILLIS" 
(
    p_in_laptime in varchar2
) return number 
is
  v_hour number;
  v_minutes number;
  v_seconds number;
  v_millis  number;
  lv_retval number;

begin

    if regexp_count(p_in_laptime, ':') = 2 then -- We have hours in the string too 
      v_hour := to_number(substr(p_in_laptime,1,instr(p_in_laptime,':',1)-1));
      v_minutes := to_number(substr(p_in_laptime,instr(p_in_laptime,':',1)+1,instr(p_in_laptime,':',2)));
      v_seconds := to_number(substr(p_in_laptime,instr(p_in_laptime,':',1,2)+1,(length(p_in_laptime) - instr(p_in_laptime,'.',1)-1)));
      v_millis := to_number(substr(p_in_laptime,instr(p_in_laptime,'.',-1)+1));
      lv_retval := ((v_hour * 60) * 60000) + (v_minutes * 60000) + (v_seconds * 1000) + v_millis;
    else -- mi.ss.mi
      v_minutes := to_number(substr(p_in_laptime,1,instr(p_in_laptime,':',1)-1));
      v_seconds := to_number(substr(p_in_laptime,instr(p_in_laptime,':',1)+1,(length(p_in_laptime) - instr(p_in_laptime,'.',1)-1)));
      v_millis  := to_number(substr(p_in_laptime,instr(p_in_laptime,'.',-1)+1));
      lv_retval := (v_minutes * 60000) + (v_seconds * 1000) + v_millis;
    end if;
    return  lv_retval;

end to_millis;
/

--------------------------------------------------------
--  DDL for Table F1_DATA_DRIVER_IMAGES
--------------------------------------------------------
prompt "F1_DATA_DRIVER_IMAGES"
 --------------------------------------------------------
--  DDL for Table F1_DATA_DRIVER_IMAGES
--------------------------------------------------------

  CREATE TABLE "F1_DATA"."F1_DATA_DRIVER_IMAGES" 
   (	"DRIVERID" VARCHAR2(50 BYTE), 
	"IMAGE" BLOB, 
	"IMAGE_BASE64" BLOB, 
	"IMAGE_TYPE" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"   NO INMEMORY 
 LOB ("IMAGE") STORE AS SECUREFILE "SYS_LOB0000080232C00002$$"(
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("IMAGE_BASE64") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

--------------------------------------------------------
--  DDL for Index F1_DATA_DRIVER_IMAGES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_DATA_DRIVER_IMAGES_PK" ON "F1_DATA"."F1_DATA_DRIVER_IMAGES" ("DRIVERID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table F1_DATA_DRIVER_IMAGES
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_DATA_DRIVER_IMAGES" MODIFY ("DRIVERID" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_DRIVER_IMAGES" ADD CONSTRAINT "F1_DATA_DRIVER_IMAGES_PK" PRIMARY KEY ("DRIVERID")
  USING INDEX "F1_DATA"."F1_DATA_DRIVER_IMAGES_PK"  ENABLE;

--------------------------------------------------------
--  DDL for Index F1_DATA_DRIVER_IMAGES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_DATA_DRIVER_IMAGES_PK" ON "F1_DATA"."F1_DATA_DRIVER_IMAGES" ("DRIVERID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table F1_DATA_DRIVER_IMAGES
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_DATA_DRIVER_IMAGES" MODIFY ("DRIVERID" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_DRIVER_IMAGES" MODIFY ("IMAGE" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_DRIVER_IMAGES" ADD CONSTRAINT "F1_DATA_DRIVER_IMAGES_PK" PRIMARY KEY ("DRIVERID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;

--------------------------------------------------------
--  DDL for Table F1_DATA_TRACKS_IMAGES
--------------------------------------------------------
prompt "F1_DATA_TRACK_IMAGES"
--------------------------------------------------------
--  DDL for Table F1_DATA_TRACK_IMAGES
--------------------------------------------------------

 --------------------------------------------------------
--  DDL for Table F1_DATA_TRACK_IMAGES
--------------------------------------------------------

  CREATE TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" 
   (	"CIRCUITID" VARCHAR2(50 BYTE), 
	"YEAR" NUMBER, 
	"RACE" NUMBER, 
	"IMAGE" BLOB, 
	"IMAGE_BASE64" BLOB, 
	"IMAGE_TYPE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 LOB ("IMAGE") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("IMAGE_BASE64") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

--------------------------------------------------------
--  DDL for Index F1_DATA_TRACK_IMAGES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_DATA_TRACK_IMAGES_PK" ON "F1_DATA"."F1_DATA_TRACK_IMAGES" ("CIRCUITID", "YEAR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table F1_DATA_TRACK_IMAGES
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" MODIFY ("CIRCUITID" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" ADD CONSTRAINT "F1_DATA_TRACK_IMAGES_PK" PRIMARY KEY ("CIRCUITID", "YEAR")
  USING INDEX "F1_DATA"."F1_DATA_TRACK_IMAGES_PK"  ENABLE;

--------------------------------------------------------
--  Constraints for Table F1_DATA_TRACK_IMAGES
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" MODIFY ("CIRCUITID" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DATA_TRACK_IMAGES" ADD CONSTRAINT "F1_DATA_TRACK_IMAGES_PK" PRIMARY KEY ("CIRCUITID", "YEAR")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;

--------------------------------------------------------
--  DDL for Table F1_CONSTRUCTORS_JSON
--------------------------------------------------------
prompt "F1_CONSTRUCTORS_JSON"

CREATE TABLE "F1_DATA"."F1_CONSTRUCTORS_JSON" 
   (	"CONSTRUCTORTID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"CONSTRUCTOR" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_CONSTRUCTORSTANDINGS_JSON
--------------------------------------------------------
prompt "F1_CONSTRUCTORSTANDINGS_JSON" 

  CREATE TABLE "F1_DATA"."F1_CONSTRUCTORSTANDINGS_JSON" 
   (	"CONSTRUCTORID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER(4,0), 
	"CONSTRUCTORSTANDINGS" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_DRIVERS_JSON
--------------------------------------------------------
prompt "F1_DRIVERS_JSON"

CREATE TABLE "F1_DATA"."F1_DRIVERS_JSON" 
   (	"DRIVERID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"DRIVERS" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_DRIVERSTANDINGS_JSON
--------------------------------------------------------
prompt "F1_DRIVERSTANDINGS_JSON" 

CREATE TABLE "F1_DATA"."F1_DRIVERSTANDINGS_JSON" 
   (	"STANDINGID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER(4,0), 
	"DRIVERSTANDING" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_LAPTIMES_JSON
--------------------------------------------------------
prompt "F1_LAPTIMES_JSON"

CREATE TABLE "F1_DATA"."F1_LAPTIMES_JSON" 
   (	"RESULTID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER(4,0), 
	"ROUND" NUMBER(4,0), 
	"LAP" NUMBER(4,0), 
	"LAPTIMES" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_QUALIFICATION_JSON
--------------------------------------------------------
prompt "F1_QUALIFICATION_JSON"

CREATE TABLE "F1_DATA"."F1_QUALIFICATION_JSON" 
   (	"SEASONID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER, 
	"ROUND" NUMBER, 
	"QUALIFICATION" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_RACE_JSON
--------------------------------------------------------
prompt "F1_RACE_JSON" 

CREATE TABLE "F1_DATA"."F1_RACE_JSON" 
   (	"RACID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER(4,0), 
	"RACE" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_RACERESULTS_JSON
--------------------------------------------------------
prompt "F1_RACERESULTS_JSON"

CREATE TABLE "F1_DATA"."F1_RACERESULTS_JSON" 
   (	"RESULTID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER(4,0), 
	"ROUND" NUMBER(4,0), 
	"RESULT" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_SEASONS_JSON
--------------------------------------------------------
prompt "F1_SEASONS_JSON"

CREATE TABLE "F1_DATA"."F1_SEASONS_JSON" 
   (	"SEASONID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"SEASON" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_SEASONS_RACE_DATES
--------------------------------------------------------
prompt "F1_SEASONS_RACE_DATES"

CREATE TABLE "F1_DATA"."F1_SEASONS_RACE_DATES" 
   (	"SEASONID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"YEAR" NUMBER(4,0), 
	"RACE_DATE" CLOB
   ) ;
--------------------------------------------------------
--  DDL for Table F1_TRACKS_JSON
--------------------------------------------------------
prompt "F1_TRACKS_JSON"

CREATE TABLE "F1_DATA"."F1_TRACKS_JSON" 
   (	"TRACKID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"FETCHED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"TRACKS" CLOB
   ) ;
   
--------------------------------------------------------
--  DDL for Table F1_OFFICIAL_TIMEDATA
--------------------------------------------------------
prompt "F1_OFFICIAL_TIMEDATA"

CREATE TABLE "F1_DATA"."F1_OFFICIAL_TIMEDATA" 
   (	"SEASON" NUMBER(4,0), 
	"RACE" NUMBER(2,0), 
	"RACETYPE" VARCHAR2(3 BYTE), 
	"DATAPOINT" NUMBER(4,0), 
	"TIME" VARCHAR2(20 BYTE), 
	"DRIVERNUMBER" NUMBER(2,0), 
	"LAPTIME" VARCHAR2(20 BYTE), 
	"LAPNUMBER" NUMBER(3,0), 
	"STINT" NUMBER(3,0), 
	"PITOUTTIME" VARCHAR2(20 BYTE), 
	"PITINTIME" VARCHAR2(20 BYTE), 
	"SECTOR1TIME" VARCHAR2(20 BYTE), 
	"SECTOR2TIME" VARCHAR2(20 BYTE), 
	"SECTOR3TIME" VARCHAR2(20 BYTE), 
	"SECTOR1SESSIONTIME" VARCHAR2(20 BYTE), 
	"SECTOR2SESSIONTIME" VARCHAR2(20 BYTE), 
	"SECTOR3SESSIONTIME" VARCHAR2(20 BYTE), 
	"SPEEDI1" NUMBER(4,1), 
	"SPEEDI2" NUMBER(4,1), 
	"SPEEDFL" NUMBER(4,1), 
	"SPEEDST" NUMBER(4,1), 
	"ISPERSONALBEST" VARCHAR2(5 BYTE), 
	"COMPOUND" VARCHAR2(20 BYTE), 
	"TYRELIFE" NUMBER(3,1), 
	"FRESHTYRE" VARCHAR2(5 BYTE), 
	"LAPSTARTTIME" VARCHAR2(20 BYTE), 
	"TEAM" VARCHAR2(20 BYTE), 
	"DRIVER" VARCHAR2(5 BYTE), 
	"TRACKSTATUS" NUMBER(3,0), 
	"ISACCURATE" VARCHAR2(5 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
);
  

--------------------------------------------------------
--  DDL for Index IND1_OFFICIAL_TIMEDATA
--------------------------------------------------------

CREATE INDEX "F1_DATA"."IND1_OFFICIAL_TIMEDATA" ON "F1_DATA"."F1_OFFICIAL_TIMEDATA" ("SEASON", "RACE", "RACETYPE") 
PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);
   
--------------------------------------------------------
--  DDL for View V_F1_CONSTRUCTORS
--------------------------------------------------------
prompt "V_F1_CONSTRUCTORS"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_CONSTRUCTORS"  AS 
  select f1.constructorid
       ,f1.info
       ,f1.name
       ,f1.nationality
from f1_constructors_json ftab,
     json_table(ftab.constructor,'$.MRData.ConstructorTable.Constructors[*]'
                COLUMNS( constructorId PATH '$.constructorId',
                          info PATH '$.url',
                          name PATH '$.name',
                          nationality PATH '$.nationality')
               ) f1;
--------------------------------------------------------
--  DDL for View V_F1_CONSTRUCTORSTANDINGS
--------------------------------------------------------
prompt "V_F1_CONSTRUCTORSTANDINGS"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_CONSTRUCTORSTANDINGS" AS 
select f1.season
       ,f1.race 
       ,f1.position
       ,f1.positionText
       ,f1.points
       ,f1.wins                             
       ,f1.constructorId
       ,f1.constructorinfo
       ,f1.constructorname
       ,f1.constructornationality
from f1_constructorstandings_json ftab,
     json_table(ftab.constructorstandings,'$.MRData.StandingsTable.StandingsLists[*]'
                COLUMNS ( season PATH '$.season',
                          race PATH '$.round',
                          nested path '$.ConstructorStandings[*]'
                          COLUMNS
                           (
                             position PATH '$.position',
                             positionText PATH '$.positionText',
                             points PATH '$.points',
                             wins PATH '$.wins',                             
                             constructorId PATH '$.Constructor.constructorId',
                             constructorinfo PATH '$.Constructor.url',
                             constructorname PATH '$.Constructor.name',
                             constructornationality PATH '$.Constructor.nationality'
                           )
                       )   
               ) f1 
order by to_number(f1.season),to_number(f1.race);
--------------------------------------------------------
--  DDL for View V_F1_DRIVERS
--------------------------------------------------------
prompt "V_F1_DRIVERS"
CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_DRIVERS" AS 
select f1.driverid
       ,f1.permanentNumber
       ,f1.code
       ,f1.info
       ,f1.givenname
       ,f1.familyname
       ,f1.dateofbirth
       ,f1.nationality
from f1_drivers_json ftab,
     json_table(ftab.drivers,'$.MRData.DriverTable.Drivers[*]'
                COLUMNS ( driverid PATH '$.driverId',
                          permanentNumber PATH '$.permanentNumber',
                          code PATH '$.code',
                          info PATH '$.url',
                          givenName PATH '$.givenName',
                          familyName PATH '$.familyName',
                          dateOfBirth PATH '$.dateOfBirth',
                          nationality PATH '$.nationality')
               ) f1;
--------------------------------------------------------
--  DDL for View V_F1_DRIVERSTANDINGS
--------------------------------------------------------
prompt "V_F1_DRIVERSTANDINGS"
CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_DRIVERSTANDINGS" AS 
  select f1.season
       ,f1.race
       ,f1.position
       ,f1.positionText
       ,f1.points
       ,f1.wins
       ,f1.driverId
       ,f1.permanentNumber
       ,f1.code
       ,f1.info
       ,f1.givenname
       ,f1.familyName
       ,f1.dateOfBirth
       ,f1.nationality
       ,f1.constructorId
       ,f1.constructorinfo
       ,f1.constructorname
       ,f1.constructornationality
from f1_driverstandings_json ftab,
     json_table(ftab.driverstanding,'$.MRData.StandingsTable.StandingsLists[*]'
                COLUMNS ( season PATH '$.season',
                          race PATH '$.round',
                          nested path '$.DriverStandings[*]'
                          COLUMNS
                           (
                             position PATH '$.position',
                             positionText PATH '$.positionText',
                             points PATH '$.points',
                             wins PATH '$.wins',
                             driverId PATH '$.Driver.driverId',
                             permanentNumber PATH '$.Driver.permanentNumber',
                             code PATH '$.Driver.code',
                             info PATH '$.Driver.url',
                             givenname PATH '$.Driver.givenName',
                             familyName PATH '$.Driver.familyName',
                             dateOfBirth PATH '$.Driver.dateOfBirth',
                             nationality PATH '$.Driver.nationality',
                             constructorId PATH '$.Constructors.constructorId',
                             constructorinfo PATH '$.Constructors.url',
                             constructorname PATH '$.Constructors.name',
                             constructornationality PATH '$.Constructors.nationality'
                           )
                       )   
               ) f1 
order by to_number(f1.season),to_number(f1.race),to_number(f1.position);
--------------------------------------------------------
--  DDL for View V_F1_LAPTIMES
--------------------------------------------------------
prompt "V_F1_LAPTIMES"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_LAPTIMES" AS 
select f1.season,
       f1.round,
       f1.info,
       f1.racename,
       f1.circuitid,
       f1.url,
       f1.circuitname,
       f1.race_date,
       f1.race_time,
       f1.lap_number,
       f1.driverid,
       f1.position,
       f1.laptime
from f1_laptimes_json ftab,
     json_table(ftab.laptimes,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          nested path '$.Circuit[*]'
                          COLUMNS(
                             circuitid PATH '$.circuitId',
                             url PATH '$.url',
                             circuitName PATH '$.circuitName'),
                         race_date PATH '$.date',
                         race_time PATH '$.time',
                         nested path '$.Laps[*]'
                         COLUMNS(
                            lap_number PATH '$.number',
                            nested PATH '$.Timings[*]'
                            COLUMNS(
                               driverId PATH '$.driverId',
                               position PATH '$.position',
                               laptime PATH '$.time')))   
               ) f1 
order by to_number(f1.season),to_number(f1.round),to_number(f1.lap_number),to_number(f1.position);


--------------------------------------------------------
--  DDL for View V_F1_QUALIFICATIONTIMES
--------------------------------------------------------
prompt "V_F1_QUALIFICATIONTIMES"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_QUALIFICATIONTIMES" AS 
  select f1.season,
        f1.round,
        f1.raceinfo,
        f1.raceName,
        f1.circuitid,
        f1.circuiturl,
        f1.circuitName,
        f1.racedate,
        f1.racetime,
        f1.drivernumber,
        f1.position,
        f1.driverid,
        f1.permanentnumber,
        f1.code,
        f1.driverinfo,
        f1.givenName,
        f1.familyName,
        f1.dateOfBirth,
        f1.nationality,
        f1.Constructor,
        f1.Constructorinfo,
        f1.constructorname,
        f1.constructornationality,
        f1.q1,
        f1.q2,
        f1.q3        
from f1_qualification_json ftab,
     json_table(ftab.qualification,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          raceinfo PATH '$.url',
                          raceName PATH '$.raceName',
                          nested path '$.Circuit[*]'
                          COLUMNS(
                             circuitid PATH '$.circuitId',
                             circuiturl PATH '$.url',
                             circuitName PATH '$.circuitName'),
                         racedate PATH '$.date',
                         racetime PATH '$.time',
                         nested path '$.QualifyingResults[*]'
                         COLUMNS(
                            drivernumber PATH '$.number',
                            position PATH '$.position',
                            driverId PATH '$.Driver.driverId',
                            permanentnumber PATH '$.Driver.permanentNumber',
                            code PATH '$.Driver.code',
                            driverinfo PATH '$.Driver.url',
                            givenName PATH '$.Driver.givenName',
                            familyName PATH '$.Driver.familyName',
                            dateOfBirth PATH '$.Driver.dateOfBirth',
                            nationality PATH '$.Driver.nationality',
                            Constructor PATH '$.Constructor.constructorId',
                            Constructorinfo PATH '$.Constructor.url',
                            constructorname PATH '$.Constructor.name',
                            constructornationality PATH '$.Constructor.nationality',
                            q1 PATH '$.Q1',
                            q2 PATH '$.Q2',
                            q3 PATH '$.Q3'))) f1
order by to_number(f1.season),to_number(f1.round);
--------------------------------------------------------
--  DDL for View V_F1_RACES
--------------------------------------------------------
prompt "V_F1_RACES"
CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_RACES"  AS 
  select f1.season
       ,f1.round
       ,f1.info
       ,f1.racename
       ,f1.circuitid
       ,f1.url
       ,f1.circuitname
       ,f1.lat
       ,f1.lon as longitude
       ,f1.locality
       ,f1.country
from f1_race_json ftab,
     json_table(ftab.race,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          circuitId PATH '$.Circuit.circuitId',
                          url PATH '$.Circuit.url',
                          circuitName PATH '$.Circuit.circuitName',
                          lat PATH '$.Circuit.Location.lat',
                          lon PATH '$.Circuit.Location.long',
                          locality PATH '$.Circuit.Location.locality',
                          country PATH '$.Circuit.Location.country'
                        )
               ) f1;

--------------------------------------------------------
--  DDL for View V_F1_RESULTS
--------------------------------------------------------
prompt "V_F1_RESULTS"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_RESULTS" AS 
  select f1.season
       ,f1.race
       ,f1.info
       ,f1.raceName
       ,f1.circuitId
       ,f1.url
       ,f1.circuitName
       ,f1.lat
       ,f1.lon
       ,f1.locality
       ,f1.country
       ,f1.racedate
       ,f1.pilotnr
       ,f1.position
       ,f1.positionText
       ,f1.points
       ,f1.driverId
       ,f1.drivurl
       ,f1.givenName
       ,f1.familyName
       ,f1.dateOfBirth
       ,f1.nationality
       ,f1.constructorId
       ,f1.constructorinfo
       ,f1.constructorname
       ,f1.constructornationality
       ,f1.grid
       ,f1.laps
       ,f1.status
       ,f1.ranking
       ,fastestlap
       ,units
       ,speed
       ,f1.millis
       ,f1.racetime
from f1_raceresults_json ftab,
     json_table(ftab.result,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          race PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          circuitId PATH '$.Circuit.circuitId',
                          url PATH '$.Circuit.url',
                          circuitName PATH '$.Circuit.circuitName',
                          lat PATH '$.Circuit.Location.lat',
                          lon PATH '$.Circuit.Location.long',
                          locality PATH '$.Circuit.Location.locality',
                          country PATH '$.Circuit.Location.country',
                          racedate PATH '$.date',
                          nested path '$.Results[*]'
                          COLUMNS
                           (
                             pilotnr PATH '$.number',
                             position PATH '$.position',
                             positionText PATH '$.positionText',
                             points PATH '$.points',
                             driverId PATH '$.Driver.driverId',
                             drivurl PATH '$.Driver.url',
                             givenName PATH '$.Driver.givenName',
                             familyName PATH '$.Driver.familyName',
                             dateOfBirth PATH '$.Driver.dateOfBirth',
                             nationality PATH '$.Driver.nationality',
                             constructorId PATH '$.Constructor.constructorId',
                             constructorinfo PATH '$.Constructor.url',
                             constructorname PATH '$.Constructor.name',
                             constructornationality PATH '$.Constructor.nationality',
                             grid PATH '$.grid',
                             laps PATH '$.laps',
                             status PATH '$.status',
                             ranking PATH '$.FastestLap.rank',
                             fastestlap PATH '$.FastestLap.lap',
                             units  PATH '$.FastestLap.units',
                             speed  PATH '$.FastestLap.speed',
                             millis PATH '$.Time.millis',
                             racetime PATH '$.Time.time'
                          )
                       )   
               ) f1 
order by f1.season,f1.race;

--------------------------------------------------------
--  DDL for View V_F1_LAST_RACE_RESULTS
--------------------------------------------------------
prompt "V_F1_LAST_RACE_RESULTS"
CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_LAST_RACE_RESULTS" AS 
  select r.season,
       r.race,
       r.racename,
       r.position,
       r.points,
       r.givenname,
       r.familyname
from v_f1_results r
where r.season = to_char(trunc(sysdate),'RRRR')
  and r.race = (select max(to_number(race))
                from v_f1_results
                where season = to_char(trunc(sysdate),'RRRR'))
  and r.position < 11
order by to_number(r.position) asc;
--------------------------------------------------------
--  DDL for View V_F1_SEASON
--------------------------------------------------------
prompt "V_F1_SEASON"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_SEASON" AS 
  select f1.season,f1.info
from f1_seasons_json ftab,
     json_table(ftab.season,'$.MRData.SeasonTable.Seasons[*]'
                COLUMNS ( season PATH '$.season',
                          info PATH '$.url')
               ) f1;
--------------------------------------------------------
--  DDL for View V_F1_SEASONS_RACE_DATES
--------------------------------------------------------
prompt "V_F1_SEASONS_RACE_DATES"

CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_SEASONS_RACE_DATES"  AS 
  select f1.season,
       f1.round,
       f1.info,
       f1.racename,
       f1.circuitid,
       f1.url,
       f1.circuitname,
       f1.race_date
from f1_seasons_race_dates ftab,
     json_table(ftab.race_date,'$.MRData.RaceTable.Races[*]'
                COLUMNS ( season PATH '$.season',
                          round PATH '$.round',
                          info PATH '$.url',
                          raceName PATH '$.raceName',
                          nested path '$.Circuit[*]'
                          COLUMNS(circuitid PATH '$.circuitId',
                                  url PATH '$.url',
                                  circuitName PATH '$.circuitName'),
                         race_date PATH '$.date'  
                       )   
               ) f1 
order by to_number(f1.season),to_number(f1.round);

--------------------------------------------------------
--  DDL for View V_F1_TRACKS
--------------------------------------------------------
prompt "V_F1_TRACKS"
CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_TRACKS" AS 
  select f1.circuitid
       ,f1.info
       ,f1.circuitname
       ,f1.lat
       ,f1.lon as longitud
       ,f1.locality
       ,f1.country
from f1_tracks_json ftab,
     json_table(ftab.tracks,'$.MRData.CircuitTable.Circuits[*]'
                COLUMNS ( circuitId PATH '$.circuitId',
                          info PATH '$.url',
                          circuitName PATH '$.circuitName',
                          lat PATH '$.Location.lat',
                          lon PATH '$.Location.long',
                          locality PATH '$.Location.locality',
                          country PATH '$.Location.country'
                          )
               ) f1;
--------------------------------------------------------
--  DDL for View V_F1_UPCOMING_RACES
--------------------------------------------------------
prompt "V_F1_UPCOMING_RACES"
CREATE OR REPLACE FORCE EDITIONABLE VIEW "F1_DATA"."V_F1_UPCOMING_RACES" AS 
  select a.season,
       a.round,
       a.race_date
from v_f1_seasons_race_dates a
where a.round not in ( select b.race
                     from v_f1_results b
                     where a.season = b.season
                       and a.round = b.race)
  and a.season = to_char(trunc(sysdate),'RRRR');
--------------------------------------------------------
--  DDL for Materialized View MV_F1_LAP_TIMES
--------------------------------------------------------
prompt "MV_F1_LAP_TIMES"
CREATE MATERIALIZED VIEW "F1_DATA"."MV_F1_LAP_TIMES" ("SEASON", "ROUND", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "RACE_DATE", "RACE_TIME", "LAP", "DRIVERID", "POSITION", "LAPTIME", "LAPTIMES_MILLIS")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS select 
    to_number(l.season) as season,
    to_number(l.round) as round,
    l.info,
    l.racename,
    r.circuitid,
    l.url,
    r.circuitname,
    l.race_date,
    l.race_time,
    to_number(l.lap_number) as lap,
    l.driverid,
    l.position,
    l.laptime,
    to_millis(l.laptime) as laptimes_millis
from
    f1_data.v_f1_laptimes l
inner join f1_data.v_f1_races r
on (r.season = l.season and  r.round = l.round);

CREATE INDEX "F1_DATA"."MV_F1_LAP_TIMES_INDEX1" ON "F1_DATA"."MV_F1_LAP_TIMES" ("SEASON", "ROUND") 
;

COMMENT ON MATERIALIZED VIEW "F1_DATA"."MV_F1_LAP_TIMES"  IS 'snapshot table for snapshot F1_DATA.MV_F1_LAP_TIMES';
--------------------------------------------------------
--  DDL for Materialized View MV_F1_QUALIFICATION_TIMES
--------------------------------------------------------
prompt "MV_F1_QUALIFICATION_TIMES"

CREATE MATERIALIZED VIEW "F1_DATA"."MV_F1_QUALIFICATION_TIMES" ("SEASON", "ROUND", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "LOCALITY", "COUNTRY", "RACEDATE", "RACETIME", "DRIVERNUMBER", "POSITION", "DRIVERID", "PERMANENTNUMBER", "CODE", "DRIVERINFO", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY", "CONSTRUCTOR", "CONSTRUCTORINFO", "CONSTRUCTORNAME", "CONSTRUCTORNATIONALITY", "Q1", "Q1_MILLIS", "Q2", "Q2_MILLIS", "Q3", "Q3_MILLIS")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS select
  to_number(q.season) as season,
  to_number(q.round) as round,
  r.info,
  r.racename,
  r.circuitid,
  r.url,
  r.circuitname,
  r.locality,
  r.country,
  q.racedate,
  q.racetime,
  q.drivernumber,
  q.position,
  q.driverid,
  q.permanentnumber,
  q.code,
  q.driverinfo,
  q.givenname,
  q.familyname,
  q.dateofbirth,
  q.nationality,
  q.constructor,
  q.constructorinfo,
  q.constructorname,
  q.constructornationality,
  q.q1,
  to_millis(q.q1) as q1_millis,
  q.q2,
  to_millis(q.q2) as q2_millis,
  q.q3,
  to_millis(q.q3) as q3_millis
from
  v_f1_qualificationtimes q
inner join v_f1_races r
on q.season = r.season and q.round = r.round;

  CREATE INDEX "F1_DATA"."MV_F1_QUALIFICATION_TIMES_INDEX2" ON "F1_DATA"."MV_F1_QUALIFICATION_TIMES" ("SEASON", "ROUND") 
  ;

   COMMENT ON MATERIALIZED VIEW "F1_DATA"."MV_F1_QUALIFICATION_TIMES"  IS 'snapshot table for snapshot F1_DATA.MV_F1_QUALIFICATION_TIMES';
--------------------------------------------------------
--  DDL for Materialized View MV_F1_RESULTS
--------------------------------------------------------
prompt "MV_F1_RESULTS"
CREATE MATERIALIZED VIEW "F1_DATA"."MV_F1_RESULTS" ("SEASON", "RACE", "INFO", "RACENAME", "CIRCUITID", "URL", "CIRCUITNAME", "LAT", "LON", "LOCALITY", "COUNTRY", "RACEDATE", "PILOTNR", "POSITION", "POSITIONTEXT", "POINTS", "DRIVERID", "DRIVURL", "GIVENNAME", "FAMILYNAME", "DATEOFBIRTH", "NATIONALITY", "CONSTRUCTORID", "CONSTRUCTORINFO", "CONSTRUCTORNAME", "CONSTRUCTORNATIONALITY", "GRID", "LAPS", "STATUS", "RANKING", "FASTESTLAP", "UNITS", "SPEED", "MILLIS", "RACETIME")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS select
  to_number(season) as season,
  to_number(race) as race,
  info,
  racename,
  circuitid,
  url,
  circuitname,
  lat,
  lon,
  locality,
  country,
  racedate,
  pilotnr,
  to_number(position) as position,
  positiontext,
  points,
  driverid,
  drivurl,
  givenname,
  familyname,
  dateofbirth,
  nationality,
  constructorid,
  constructorinfo,
  constructorname,
  constructornationality,
  grid,
  laps,
  status,
  ranking,
  fastestlap,
  units,
  speed,
  millis,
  racetime
from
  v_f1_results;

  
  COMMENT ON MATERIALIZED VIEW "F1_DATA"."MV_F1_RESULTS"  IS 'snapshot table for snapshot F1_DATA.MV_F1_RESULTS';
--------------------------------------------------------
--  DDL for Index F1_SEASONS_RACE_DATES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_SEASONS_RACE_DATES_PK" ON "F1_DATA"."F1_SEASONS_RACE_DATES" ("SEASONID", "YEAR") 
  ;
--------------------------------------------------------
--  DDL for Index MV_F1_RESULTS_INDEX1
--------------------------------------------------------

  CREATE INDEX "F1_DATA"."MV_F1_RESULTS_INDEX2" ON "F1_DATA"."MV_F1_RESULTS" ("SEASON", "RACE") 
  ;
--------------------------------------------------------
--  DDL for Index MV_F1_LAP_TIMES_INDEX1
--------------------------------------------------------

  CREATE INDEX "F1_DATA"."MV_F1_LAP_TIMES_INDEX1" ON "F1_DATA"."MV_F1_LAP_TIMES" ("SEASON", "ROUND") 
  ;
--------------------------------------------------------
--  DDL for Index F1_RACERESULTS_JSON_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_RACERESULTS_JSON_PK" ON "F1_DATA"."F1_RACERESULTS_JSON" ("RESULTID", "YEAR", "ROUND") 
  ;
--------------------------------------------------------
--  DDL for Index F1_DRIVERSTANDINGS_JSON_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_DRIVERSTANDINGS_JSON_PK" ON "F1_DATA"."F1_DRIVERSTANDINGS_JSON" ("STANDINGID", "YEAR") 
  ;
--------------------------------------------------------
--  DDL for Index F1_QUALIFICATION_JSON_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_QUALIFICATION_JSON_PK" ON "F1_DATA"."F1_QUALIFICATION_JSON" ("YEAR", "ROUND", "SEASONID") 
  ;
--------------------------------------------------------
--  DDL for Index F1_RACE_JSON_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "F1_DATA"."F1_RACE_JSON_PK" ON "F1_DATA"."F1_RACE_JSON" ("RACID", "YEAR") 
  ;
--------------------------------------------------------
--  DDL for Index MV_F1_QUALIFICATION_TIMES_INDEX1
--------------------------------------------------------

CREATE INDEX "F1_DATA"."MV_F1_QUALIFICATION_TIMES_INDEX1" ON "F1_DATA"."MV_F1_QUALIFICATION_TIMES" ("SEASON", "ROUND") 
;
--------------------------------------------------------
--  DDL for Index F1_CONSTRUCTORSTANDINGS_JSON_PK
--------------------------------------------------------

CREATE UNIQUE INDEX "F1_DATA"."F1_CONSTRUCTORSTANDINGS_JSON_PK" ON "F1_DATA"."F1_CONSTRUCTORSTANDINGS_JSON" ("CONSTRUCTORID", "YEAR") 
;
--------------------------------------------------------
--  DDL for Index F1_LAPTIMES_JSON_PK
--------------------------------------------------------

CREATE UNIQUE INDEX "F1_DATA"."F1_LAPTIMES_JSON_PK" ON "F1_DATA"."F1_LAPTIMES_JSON" ("RESULTID", "YEAR", "ROUND", "LAP") 
;

--------------------------------------------------------
--  Constraints for Table F1_DRIVERSTANDINGS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_DRIVERSTANDINGS_JSON" ADD CONSTRAINT "DRIVERSTANDING_ISJSON" CHECK (driverstanding is json) ENABLE;
  ALTER TABLE "F1_DATA"."F1_DRIVERSTANDINGS_JSON" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_DRIVERSTANDINGS_JSON" ADD CONSTRAINT "F1_DRIVERSTANDINGS_JSON_PK" PRIMARY KEY ("STANDINGID", "YEAR")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_RACERESULTS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_RACERESULTS_JSON" ADD CONSTRAINT "RESULT_ISJSON" CHECK (result is json) ENABLE;
  ALTER TABLE "F1_DATA"."F1_RACERESULTS_JSON" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_RACERESULTS_JSON" MODIFY ("ROUND" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_RACERESULTS_JSON" ADD CONSTRAINT "F1_RACERESULTS_JSON_PK" PRIMARY KEY ("RESULTID", "YEAR", "ROUND")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_CONSTRUCTORSTANDINGS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_CONSTRUCTORSTANDINGS_JSON" ADD CONSTRAINT "CONSTRUCTORSTANDING_ISJSON" CHECK (constructorstandings is json) ENABLE;
  ALTER TABLE "F1_DATA"."F1_CONSTRUCTORSTANDINGS_JSON" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_CONSTRUCTORSTANDINGS_JSON" ADD CONSTRAINT "F1_CONSTRUCTORSTANDINGS_JSON_PK" PRIMARY KEY ("CONSTRUCTORID", "YEAR")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_DRIVERS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_DRIVERS_JSON" ADD CONSTRAINT "DRIVERS_ISJSON" CHECK (drivers is json) ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_SEASONS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_SEASONS_JSON" ADD CONSTRAINT "SEASON_ISJSON" CHECK (season is json) ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_RACE_JSON
--------------------------------------------------------

ALTER TABLE "F1_DATA"."F1_RACE_JSON" ADD CONSTRAINT "RACE_ISJSON" CHECK (race is json) ENABLE;
ALTER TABLE "F1_DATA"."F1_RACE_JSON" MODIFY ("YEAR" NOT NULL ENABLE);
ALTER TABLE "F1_DATA"."F1_RACE_JSON" ADD CONSTRAINT "F1_RACE_JSON_PK" PRIMARY KEY ("RACID", "YEAR")
USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_SEASONS_RACE_DATES
--------------------------------------------------------
ALTER TABLE "F1_DATA"."F1_SEASONS_RACE_DATES" ADD CONSTRAINT "RACEDATE_ISJSON" CHECK (race_date is json) ENABLE;
ALTER TABLE "F1_DATA"."F1_SEASONS_RACE_DATES" MODIFY ("YEAR" NOT NULL ENABLE);
ALTER TABLE "F1_DATA"."F1_SEASONS_RACE_DATES" ADD CONSTRAINT "F1_SEASONS_RACE_DATES_PK" PRIMARY KEY ("SEASONID", "YEAR")
USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_LAPTIMES_JSON
--------------------------------------------------------


  ALTER TABLE "F1_DATA"."F1_LAPTIMES_JSON" ADD CONSTRAINT "LAPTIME_ISJSON" CHECK (laptimes is json) ENABLE;
  ALTER TABLE "F1_DATA"."F1_LAPTIMES_JSON" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_LAPTIMES_JSON" MODIFY ("ROUND" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_LAPTIMES_JSON" MODIFY ("LAP" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_LAPTIMES_JSON" ADD CONSTRAINT "F1_LAPTIMES_JSON_PK" PRIMARY KEY ("RESULTID", "YEAR", "ROUND", "LAP")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_CONSTRUCTORS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_CONSTRUCTORS_JSON" ADD CONSTRAINT "CONSTRUCTOR_ISJSON" CHECK (constructor is json) ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_QUALIFICATION_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_QUALIFICATION_JSON" ADD CONSTRAINT "QUALIFICATION_ISJSON" CHECK (qualification is json) ENABLE;
  ALTER TABLE "F1_DATA"."F1_QUALIFICATION_JSON" MODIFY ("YEAR" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_QUALIFICATION_JSON" MODIFY ("ROUND" NOT NULL ENABLE);
  ALTER TABLE "F1_DATA"."F1_QUALIFICATION_JSON" ADD CONSTRAINT "F1_QUALIFICATION_JSON_PK" PRIMARY KEY ("YEAR", "ROUND", "SEASONID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table F1_TRACKS_JSON
--------------------------------------------------------

  ALTER TABLE "F1_DATA"."F1_TRACKS_JSON" ADD CONSTRAINT "TRACKID_ISJSON" CHECK (tracks is json) ENABLE;

