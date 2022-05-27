CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_CONSTRUCTORS AS SELECT * FROM APEX_F1_DATA.S_F1_CONSTRUCTORS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_CONSTRUCTORSTANDINGS AS SELECT * FROM  APEX_F1_DATA.S_F1_CONSTRUCTORSTANDINGS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_DRIVERS AS SELECT * FROM APEX_F1_DATA.S_F1_DRIVERS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_DRIVERSTANDINGS AS SELECT * FROM APEX_F1_DATA.S_F1_DRIVERSTANDINGS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_LAPTIMES AS SELECT * FROM APEX_F1_DATA.S_F1_LAPTIMES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_LAST_RACE_RESULTS AS SELECT * FROM APEX_F1_DATA.S_F1_LAST_RACE_RESULTS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_RACES AS SELECT * FROM APEX_F1_DATA.S_F1_RACES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_RESULTS AS SELECT * FROM APEX_F1_DATA.S_F1_RESULTS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_SEASON AS SELECT * FROM APEX_F1_DATA.S_F1_SEASON;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_SEASONS_RACE_DATES AS SELECT * FROM APEX_F1_DATA.S_F1_SEASONS_RACE_DATES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_TRACKS AS SELECT * FROM APEX_F1_DATA.S_F1_TRACKS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_UPCOMING_RACES AS SELECT * FROM APEX_F1_DATA.S_F1_UPCOMING_RACES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_QUALIFICATIONTIMES AS SELECT * FROM APEX_F1_DATA.S_F1_QUALIFICATIONTIMES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_MV_F1_LAP_TIMES AS SELECT * FROM APEX_F1_DATA.S_MV_F1_LAP_TIMES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_MV_F1_QUALIFICATION_TIMES AS SELECT * FROM APEX_F1_DATA.S_MV_F1_QUALIFICATION_TIMES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_MV_F1_RESULTS AS SELECT * FROM APEX_F1_DATA.S_MV_F1_RESULTS;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_DRIVER_IMAGES AS SELECT * FROM APEX_F1_DATA.S_F1_DRIVER_IMAGES;
CREATE OR REPLACE VIEW APEX_F1_DATA.R_F1_TRACK_IMAGES AS SELECT * FROM APEX_F1_DATA.S_F1_TRACK_IMAGES;
-- Additional views created 

-- Handle tracks used during a season
create or replace view apex_f1_data.r_f1_seasons_and_tracks as
select vt.circuitid
       ,vt.info
       ,vt.circuitname
       ,vr.season
       ,vr.round
       ,to_number(vr.lat,'9999.99999999') as lat 
       ,to_number(vr.longitude,'9999.99999999') as longitude
       ,vr.locality
       ,vr.country
from apex_f1_data.r_f1_tracks vt
inner join apex_f1_data.r_f1_races vr
on vt.circuitid = vr.circuitid
order by to_number(vr.season) desc, to_number(vr.round) asc;

-- Dominating teams 

create or replace view apex_f1_data.r_f1_dominating_teams as
with f1_wins as
(
select
    vfr.season,
    count(vfr.position) as wins,
    vfr.constructorinfo,
    vfr.constructorname,
    vfr.constructornationality
from apex_f1_data.r_mv_f1_results vfr
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
inner join apex_f1_data.r_f1_races r
on to_number(r.season) = x.season
group by x.season
         ,x.wins
         ,x.constructorname
         ,x.constructornationality
         ,x.constructorinfo
) order by season desc, wins desc;