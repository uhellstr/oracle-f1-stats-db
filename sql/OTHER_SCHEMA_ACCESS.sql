REM
REM This script must be executed as SYS or INTERNAL
REM
whenever sqlerror exit rollback;
set echo off
set verify off



prompt "Give schemaname that should be able to access F1_DATA"
accept f1_schema char prompt "Enter username " 
-- Grant ROLE to a personal account...
grant F1_DATA_FORVALT_ROLE to &&f1_schema;
grant create view to &&f1_schema;
-- Direct grants to be able to create view in a other scema
grant select on F1_DATA.F1_DATA_DRIVER_IMAGES to &&f1_schema   ;
grant select on F1_DATA.F1_DATA_TRACK_IMAGES to &&f1_schema   ;
grant select on F1_DATA.V_F1_CONSTRUCTORS to &&f1_schema  ;
grant select on F1_DATA.V_F1_CONSTRUCTORSTANDINGS to &&f1_schema    ;
grant select on F1_DATA.V_F1_DRIVERS to &&f1_schema   ;
grant select on F1_DATA.V_F1_DRIVERSTANDINGS to &&f1_schema   ;
grant select on F1_DATA.V_F1_LAPTIMES to &&f1_schema    ;
grant select on F1_DATA.V_F1_QUALIFICATIONTIMES to &&f1_schema    ;
grant select on F1_DATA.V_F1_RACES to &&f1_schema   ;
grant select on F1_DATA.V_F1_RESULTS to &&f1_schema   ;
grant select on F1_DATA.V_F1_LAST_RACE_RESULTS to &&f1_schema   ;
grant select on F1_DATA.V_F1_SEASON to &&f1_schema   ;
grant select on F1_DATA.V_F1_SEASONS_RACE_DATES to &&f1_schema  ;
grant select on F1_DATA.V_F1_TRACKS to &&f1_schema  ;
grant select on F1_DATA.V_F1_UPCOMING_RACES to &&f1_schema   ;
grant select on F1_DATA.MV_F1_LAP_TIMES to &&f1_schema   ;
grant select on F1_DATA.MV_F1_QUALIFICATION_TIMES to &&f1_schema   ;
grant select on F1_DATA.MV_F1_RESULTS to &&f1_schema   ;

create or replace view &&f1_schema..V_MV_F1_QUALIFICATION_TIMES as select * from F1_DATA.MV_F1_QUALIFICATION_TIMES;
create or replace view &&f1_schema..V_MV_F1_RESULTS as select * from F1_DATA.MV_F1_RESULTS;
create or replace view &&f1_schema..V_F1_DATA_DRIVER_IMAGES as select * from F1_DATA.F1_DATA_DRIVER_IMAGES;
create or replace view &&f1_schema..V_F1_DATA_TRACK_IMAGES as select * from F1_DATA.F1_DATA_TRACK_IMAGES;
create or replace view &&f1_schema..V_F1_CONSTRUCTORS as select * from F1_DATA.V_F1_CONSTRUCTORS;
create or replace view &&f1_schema..V_F1_CONSTRUCTORSTANDINGS as select * from F1_DATA.V_F1_CONSTRUCTORSTANDINGS;
create or replace view &&f1_schema..V_F1_DRIVERS as select * from F1_DATA.V_F1_DRIVERS;
create or replace view &&f1_schema..V_F1_DRIVERSTANDINGS as select * from F1_DATA.V_F1_DRIVERSTANDINGS;
create or replace view &&f1_schema..V_F1_LAPTIMES as select * from F1_DATA.V_F1_LAPTIMES;
create or replace view &&f1_schema..V_F1_QUALIFICATIONTIMES as select * from F1_DATA.V_F1_QUALIFICATIONTIMES;
create or replace view &&f1_schema..V_F1_RACES as select * from F1_DATA.V_F1_RACES;
create or replace view &&f1_schema..V_F1_RESULTS as select * from F1_DATA.V_F1_RESULTS;
create or replace view &&f1_schema..V_F1_LAST_RACE_RESULTS as select * from F1_DATA.V_F1_LAST_RACE_RESULTS;
create or replace view &&f1_schema..V_F1_SEASON as select * from F1_DATA.V_F1_SEASON;
create or replace view &&f1_schema..V_F1_SEASONS_RACE_DATES as select * from F1_DATA.V_F1_SEASONS_RACE_DATES;
create or replace view &&f1_schema..V_F1_TRACKS as select * from F1_DATA.V_F1_TRACKS;
create or replace view &&f1_schema..V_F1_UPCOMING_RACES as select * from F1_DATA.V_F1_UPCOMING_RACES;
create or replace view &&f1_schema..V_MV_F1_LAP_TIMES as select * from F1_DATA.MV_F1_LAP_TIMES;