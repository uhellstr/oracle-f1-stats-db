create or replace view APEX_F1.V_MV_F1_QUALIFICATION_TIMES as select * from F1_DATA.MV_F1_QUALIFICATION_TIMES;
create or replace view APEX_F1.V_MV_F1_RESULTS as select * from F1_DATA.MV_F1_RESULTS;
create or replace view APEX_F1.V_F1_DATA_DRIVER_IMAGES as select * from F1_DATA.F1_DATA_DRIVER_IMAGES;
create or replace view APEX_F1.V_F1_DATA_TRACK_IMAGES as select * from F1_DATA.F1_DATA_TRACK_IMAGES;
create or replace view APEX_F1.V_F1_CONSTRUCTORS as select * from F1_DATA.V_F1_CONSTRUCTORS;
create or replace view APEX_F1.V_F1_CONSTRUCTORSTANDINGS as select * from F1_DATA.V_F1_CONSTRUCTORSTANDINGS;
create or replace view APEX_F1.V_F1_DRIVERS as select * from F1_DATA.V_F1_DRIVERS;
create or replace view APEX_F1.V_F1_DRIVERSTANDINGS as select * from F1_DATA.V_F1_DRIVERSTANDINGS;
create or replace view APEX_F1.V_F1_LAPTIMES as select * from F1_DATA.V_F1_LAPTIMES;
create or replace view APEX_F1.V_F1_QUALIFICATIONTIMES as select * from F1_DATA.V_F1_QUALIFICATIONTIMES;
create or replace view APEX_F1.V_F1_RACES as select * from F1_DATA.V_F1_RACES;
create or replace view APEX_F1.V_F1_RESULTS as select * from F1_DATA.V_F1_RESULTS;
create or replace view APEX_F1.V_F1_LAST_RACE_RESULTS as select * from F1_DATA.V_F1_LAST_RACE_RESULTS;
create or replace view APEX_F1.V_F1_SEASON as select * from F1_DATA.V_F1_SEASON;
create or replace view APEX_F1.V_F1_SEASONS_RACE_DATES as select * from F1_DATA.V_F1_SEASONS_RACE_DATES;
create or replace view APEX_F1.V_F1_TRACKS as select * from F1_DATA.V_F1_TRACKS;
create or replace view APEX_F1.V_F1_UPCOMING_RACES as select * from F1_DATA.V_F1_UPCOMING_RACES;
create or replace view APEX_F1.V_MV_F1_LAP_TIMES as select * from F1_DATA.MV_F1_LAP_TIMES;
create or replace view APEX_F1.V_F1_OFFICIAL_TIMEDATA as select * from F1_DATA.f1_official_timedata;
create or replace view APEX_F1.V_F1_OFFICIAL_WEATHER as select * from F1_DATA.F1_OFFICIAL_WEATHER;
-- Additional views created 

-- Handle tracks used during a season
create or replace view APEX_F1.v_f1_seasons_and_tracks as
select vt.circuitid
       ,vt.info
       ,vt.circuitname
       ,vr.season
       ,vr.round
       ,to_number(vr.lat,'9999.99999999') as lat 
       ,to_number(vr.longitude,'9999.99999999') as longitude
       ,vr.locality
       ,vr.country
from APEX_F1.v_f1_tracks vt
inner join APEX_F1.v_f1_races vr
on vt.circuitid = vr.circuitid
order by to_number(vr.season) desc, to_number(vr.round) asc;

-- Dominating teams 

create or replace view APEX_F1.v_f1_dominating_teams as
with f1_wins as
(
select
    vfr.season,
    count(vfr.position) as wins,
    vfr.constructorinfo,
    vfr.constructorname,
    vfr.constructornationality
from APEX_F1.v_mv_f1_results vfr
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
inner join APEX_F1.v_f1_races r
on to_number(r.season) = x.season
group by x.season
         ,x.wins
         ,x.constructorname
         ,x.constructornationality
         ,x.constructorinfo
) order by season desc, wins desc;
