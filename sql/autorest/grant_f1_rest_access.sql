REM
REM This script must be executed as SYS or INTERNAL
REM
whenever sqlerror exit rollback;
set echo off
set verify off

-- Grant ROLE to a personal account..
grant F1_DATA_FORVALT_ROLE to f1_rest_access;
grant create view to f1_rest_access;
grant execute on f1_logik.to_millis to f1_rest_access;
grant execute on f1_logik.get_cur_f1_season to f1_rest_access;
grant execute on f1_logik.get_check_season to f1_rest_access;
grant execute on f1_logik.get_last_race to f1_rest_access;
-- Direct grants to be able to create view in a other scema
grant select on F1_DATA.F1_DATA_DRIVER_IMAGES to f1_rest_access   ;
grant select on F1_DATA.F1_DATA_TRACK_IMAGES to f1_rest_access   ;
grant select on F1_DATA.V_F1_CONSTRUCTORS to f1_rest_access  ;
grant select on F1_DATA.V_F1_CONSTRUCTORSTANDINGS to f1_rest_access    ;
grant select on F1_DATA.V_F1_DRIVERS to f1_rest_access   ;
grant select on F1_DATA.V_F1_DRIVERSTANDINGS to f1_rest_access   ;
grant select on F1_DATA.V_F1_LAPTIMES to f1_rest_access    ;
grant select on F1_DATA.V_F1_QUALIFICATIONTIMES to f1_rest_access    ;
grant select on F1_DATA.V_F1_RACES to f1_rest_access   ;
grant select on F1_DATA.V_F1_RESULTS to f1_rest_access   ;
grant select on F1_DATA.V_F1_LAST_RACE_RESULTS to f1_rest_access   ;
grant select on F1_DATA.V_F1_SEASON to f1_rest_access   ;
grant select on F1_DATA.V_F1_SEASONS_RACE_DATES to f1_rest_access  ;
grant select on F1_DATA.V_F1_TRACKS to f1_rest_access  ;
grant select on F1_DATA.V_F1_UPCOMING_RACES to f1_rest_access   ;
grant select on F1_DATA.MV_F1_LAP_TIMES to f1_rest_access   ;
grant select on F1_DATA.MV_F1_QUALIFICATION_TIMES to f1_rest_access   ;
grant select on F1_DATA.MV_F1_RESULTS to f1_rest_access   ;
grant select on F1_DATA.f1_official_timedata to f1_rest_access ;
grant select on F1_DATA.f1_official_weather to f1_rest_access ;

create or replace view f1_rest_access.V_F1_OFFICIAL_TIMEDATA as select * from F1_DATA.f1_official_timedata;
create or replace view f1_rest_access.V_MV_F1_QUALIFICATION_TIMES as select * from F1_DATA.MV_F1_QUALIFICATION_TIMES;
create or replace view f1_rest_access.V_MV_F1_RESULTS as select * from F1_DATA.MV_F1_RESULTS;
create or replace view f1_rest_access.V_F1_DATA_DRIVER_IMAGES as select * from F1_DATA.F1_DATA_DRIVER_IMAGES;
create or replace view f1_rest_access.V_F1_DATA_TRACK_IMAGES as select * from F1_DATA.F1_DATA_TRACK_IMAGES;
create or replace view f1_rest_access.V_F1_CONSTRUCTORS as select * from F1_DATA.V_F1_CONSTRUCTORS;
create or replace view f1_rest_access.V_F1_CONSTRUCTORSTANDINGS as select * from F1_DATA.V_F1_CONSTRUCTORSTANDINGS;
create or replace view f1_rest_access.V_F1_DRIVERS as select * from F1_DATA.V_F1_DRIVERS;
create or replace view f1_rest_access.V_F1_DRIVERSTANDINGS as select * from F1_DATA.V_F1_DRIVERSTANDINGS;
create or replace view f1_rest_access.V_F1_LAPTIMES as select * from F1_DATA.V_F1_LAPTIMES;
create or replace view f1_rest_access.V_F1_QUALIFICATIONTIMES as select * from F1_DATA.V_F1_QUALIFICATIONTIMES;
create or replace view f1_rest_access.V_F1_RACES as select * from F1_DATA.V_F1_RACES;
create or replace view f1_rest_access.V_F1_RESULTS as select * from F1_DATA.V_F1_RESULTS;
create or replace view f1_rest_access.V_F1_LAST_RACE_RESULTS as select * from F1_DATA.V_F1_LAST_RACE_RESULTS;
create or replace view f1_rest_access.V_F1_SEASON as select * from F1_DATA.V_F1_SEASON;
create or replace view f1_rest_access.V_F1_SEASONS_RACE_DATES as select * from F1_DATA.V_F1_SEASONS_RACE_DATES;
create or replace view f1_rest_access.V_F1_TRACKS as select * from F1_DATA.V_F1_TRACKS;
create or replace view f1_rest_access.V_F1_UPCOMING_RACES as select * from F1_DATA.V_F1_UPCOMING_RACES;
create or replace view f1_rest_access.V_MV_F1_LAP_TIMES as select * from F1_DATA.MV_F1_LAP_TIMES;
create or replace view f1_rest_access.V_F1_OFFICIAL_TIMEDATA as select * from F1_DATA.F1_OFFICIAL_TIMEDATA ;
create or replace view f1_rest_access.V_F1_OFFICIAL_WEATHER as select * from F1_DATA.F1_OFFICIAL_WEATHER ;

-- Extra rest enabled views taken from the demo queries and restified

create or replace view f1_rest_access.v_f1_cur_season_standings as
select vfd.season
       ,rownum as position
       ,vfd.race
       ,vfd.points
       ,vfd.givenname
       ,vfd.familyname
       ,vfd.constructorid
from f1_rest_access.v_f1_driverstandings vfd
where vfd.season = f1_logik.get_cur_f1_season 
order by to_number(points) desc;

create or replace view f1_rest_access.v_f1_last_race_winners as
select
  vfr.season,
  vfr.race,
  vfr.racename,
  vfr.circuitid,
  vfr.circuitname,
  vfr.locality,
  vfr.country,
  vfr.racedate,
  vfr.pilotnr,
  vfr.position,
  vfr.positiontext,
  vfr.points,
  vfr.driverid,
  vfr.givenname,
  vfr.familyname,
  vfr.dateofbirth,
  vfr.nationality,
  vfr.constructorid,
  vfr.constructorname,
  vfr.constructornationality,
  vfr.grid,
  vfr.laps,
  vfr.status,
  vfr.ranking,
  vfr.fastestlap,
  vfr.units,
  vfr.speed,
  vfr.millis,
  vfr.racetime
from
  f1_rest_access.v_mv_f1_results vfr
where vfr.season = f1_logik.get_cur_f1_season
  and position is not null
  and vfr.race = f1_logik.get_last_race
order by to_number(vfr.position) asc
fetch first 10 rows only;

create or replace view f1_rest_access.v_f1_last_race_qualifiers as
select driverid
       ,position
       ,laps_hold_position
from
(
with f1_drivers as
(
  select driverid
  from f1_rest_access.v_f1_drivers
)
select f1_drivers.driverid
       ,to_number(f1l.position) as position
       ,count(f1l.position) as laps_hold_position
from f1_rest_access.v_mv_f1_lap_times f1l
inner join f1_drivers
on  f1l.driverid = f1_drivers.driverid
where f1l.season = f1_logik.get_cur_f1_season
group by f1_drivers.driverid,f1l.position
) order by  position asc,laps_hold_position desc, driverid asc;

create or replace view f1_rest_access.v_f1_dominating_teams as
with f1_wins as
(
select
    vfr.season,
    count(vfr.position) as wins,
    vfr.constructorinfo,
    vfr.constructorname,
    vfr.constructornationality
from f1_rest_access.v_mv_f1_results vfr
where vfr.position = 1
group by vfr.season,
      vfr.constructorinfo,
      vfr.constructorname,
      vfr.constructornationality
)
select *
from
(
select x.season
       ,x.wins
       ,max(to_number(r.round)) as races
       ,round((x.wins/max(to_number(r.round)))*100,1) as percentwins
       ,x.constructorname
       ,x.constructornationality
       ,x.constructorinfo
from f1_wins x
inner join f1_rest_access.v_f1_races r
on to_number(r.season) = x.season
group by x.season
         ,x.wins
         ,x.constructorname
         ,x.constructornationality
         ,x.constructorinfo
) order by season desc, wins desc;

create or replace view f1_rest_access.v_f1_cur_season_polesitters as
select vfq.familyname
      ,count(vfq.familyname) as pole_positions
from f1_rest_access.v_f1_qualificationtimes vfq
where vfq.season = f1_logik.get_cur_f1_season
  and vfq.position = 1
group by vfq.familyname;

create or replace view f1_rest_access.v_f1_champions as
select
    d.season,
    d.givenname,
    d.familyname,
    d.nationality,    
    d.points,
    d.wins,
    d.info,
    d.constructorname,
    d.constructorinfo,
    d.constructornationality
from
    f1_rest_access.v_f1_driverstandings d
    where d.race = (select max(e.race)
                    from f1_rest_access.v_f1_driverstandings e
                    where e.season = d.season)
      and d.position = 1
      and d.season <= f1_logik.get_check_season
order by d.season desc;

create or replace view f1_rest_access.v_f1_constructor_champions as
select
  c.season,
  c.points,
  c.wins,
  c.constructorname,
  c.constructorinfo,
  c.constructornationality
from
  f1_rest_access.v_f1_constructorstandings c
where to_number(c.race) = (select max(to_number(d.round))
                           from f1_rest_access.v_f1_races d
                           where to_number(d.season) = to_number(c.season))
  and to_number(c.position) = 1
  and c.season <= f1_logik.get_check_season
order by to_number(c.season) desc;
