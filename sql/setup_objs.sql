@F1_DATA_TBS.sql
@F1_LOGIK_GRANTS.sql
@./role/F1_DATA_FORVALT_ROLE.sql
grant F1_DATA_FORVALT_ROLE to F1_ACCESS ;
grant F1_DATA_FORVALT_ROLE to F1_LOGIK ;
ALTER USER "F1_ACCESS" DEFAULT ROLE CONNECT,F1_DATA_FORVALT_ROLE;
ALTER USER "F1_LOGIK" DEFAULT ROLE "CONNECT","F1_DATA_FORVALT_ROLE";
@F1_INIT_PKG.sql
@F1_INIT_PKG_BODY.sql
@F1_ACCESS_OBJS.sql

REM
REM Helper functions
REM 

create or replace function f1_logik.to_millis 
(
    p_in_laptime in varchar2
) return number 
is

  lv_retval number;
  lv_hour varchar2(2);      
  lv_minutes varchar2(10);  
  lv_seconds varchar2(10);  
  lv_millis  varchar2(10);      

begin
   
    --dbms_output.put_line('-- before official f1 telemetry ---');
    if length(p_in_laptime) = 15 then  -- official f1 telemetry
      --dbms_output.put_line('F1 official full length timestamp');
      lv_hour := substr(p_in_laptime,1,2);
      lv_minutes := substr(p_in_laptime,4,2);
      lv_seconds := substr(p_in_laptime,7,2);
      lv_millis  := replace(substr(p_in_laptime,10,15),'000',''); 
      --dbms_output.put_line('Hour: '||lv_hour); 
      --dbms_output.put_line('Minutes: '||lv_minutes);
      --dbms_output.put_line('Seconds: '||lv_seconds);
      --dbms_output.put_line('Millisec: '||lv_millis);
      lv_retval := (to_number(lv_minutes) * 60000) + (to_number(lv_seconds) * 1000) + nvl(to_number(lv_millis),0);
    end if;
    --dbms_output.put_line('-- before official f1 telemetry missing millis ---');
    if (length(p_in_laptime) = 8 and instr(p_in_laptime,'.') = 0) then -- official f1 telemetry without millisecs
      --dbms_output.put_line('F1 official missing millisecs.'); 
      lv_hour := substr(p_in_laptime,1,2);
      lv_minutes := substr(p_in_laptime,4,2);
      lv_seconds := substr(p_in_laptime,7,2);
      --dbms_output.put_line('Hour: '||lv_hour); 
      --dbms_output.put_line('Minutes: '||lv_minutes);
      --dbms_output.put_line('Seconds: '||lv_seconds);
      --dbms_output.put_line('Millisec: '||lv_millis);      
      lv_retval := (to_number(lv_minutes) * 60000) + (to_number(lv_seconds) * 1000);
    end if;  
    -- else calculate using ergast format
    --dbms_output.put_line('-- before ergast ---');
    if (length(p_in_laptime) < 15 and regexp_count(p_in_laptime, ':') = 2 and instr(p_in_laptime,'.') > 0)  then -- We have hours in the string too
      --dbms_output.put_line('Ergast with hours');
      lv_hour := substr(p_in_laptime,1,instr(p_in_laptime,':',1)-1);
      lv_minutes := substr(p_in_laptime,instr(p_in_laptime,':',1)+1,instr(p_in_laptime,':',2));
      lv_seconds := substr(p_in_laptime,instr(p_in_laptime,':',1,2)+1,(length(p_in_laptime) - instr(p_in_laptime,'.',1)-1));
      lv_millis := substr(p_in_laptime,instr(p_in_laptime,'.',-1)+1);
      --dbms_output.put_line('Hour: '||lv_hour); 
      --dbms_output.put_line('Minutes: '||lv_minutes);
      --dbms_output.put_line('Seconds: '||lv_seconds);
      --dbms_output.put_line('Millisec: '||lv_millis);      
      lv_retval := ((to_number(lv_hour) * 60) * 60000) + (to_number(lv_minutes) * 60000) + (to_number(lv_seconds) * 1000) + to_number(lv_millis);
    end if; 
    -- ergast mi.ss.mi
    if (length(p_in_laptime) = 8 and regexp_count(p_in_laptime, ':') = 1 and instr(p_in_laptime,'.') > 0) then
      --dbms_output.put_line('Ergast mi.ss.mi');
      lv_minutes := substr(p_in_laptime,1,instr(p_in_laptime,':',1)-1);
      lv_seconds := substr(p_in_laptime,instr(p_in_laptime,':',1)+1,(length(p_in_laptime) - instr(p_in_laptime,'.',1)-1));
      lv_millis  := substr(p_in_laptime,instr(p_in_laptime,'.',-1)+1);
      --dbms_output.put_line('Minutes: '||lv_minutes);
      --dbms_output.put_line('Seconds: '||lv_seconds);
      --dbms_output.put_line('Millisec: '||lv_millis);      
      lv_retval := (to_number(lv_minutes) * 60000) + (to_number(lv_seconds) * 1000) + to_number(lv_millis);
    end if;
    
    return  lv_retval;

end to_millis;
/

create or replace function f1_logik.get_cur_f1_season 
(
  p_in_cur_year in varchar2 default to_char(current_date,'RRRR') 
) 
return varchar2 result_cache
as 

 lv_season varchar2(4);
 
begin

    with future_races as -- We need to handle between seasons where there are no races
    (
      select /*+ MATERIALIZE */ count(vfu.season) as any_races
      from f1_data.v_f1_upcoming_races vfu
      where vfu.season = substr(to_char(trunc(sysdate,'YEAR')),1,4)  --Fix to YEAR and substr(1,4) to garantee that we only get the YEAR part
    )
    select season into lv_season -- Is current season finished yet?
    from
    (
     select to_date(r.race_date,'RRRR-MM-DD') as race_date
            ,case
               when (r.race_date < trunc(sysdate) and x.any_races < 1) then to_char(to_number(to_char(current_date,'RRRR') - 1))
               when r.race_date < trunc(sysdate) then to_char(current_date,'RRRR')
               when (r.race_date > trunc(sysdate) and x.any_races > 0) then to_char(current_date,'RRRR')
               else '1900'
             end as season
     from f1_data.v_f1_seasons_race_dates r
          ,future_races x
     where r.season = p_in_cur_year
       and to_number(r.round) in (select max(to_number(rd.round)) from f1_data.v_f1_seasons_race_dates rd
                                  where rd.season  = r.season)
    );
    
    return lv_season;
    
end get_cur_f1_season;
/



create or replace function f1_logik.get_check_season 
(
  p_in_cur_year in varchar2 default to_char(current_date,'rrrr') 
) 
return varchar2 result_cache
as

 lv_retval varchar2(4);
 
begin

    select season into lv_retval -- Is current season finished yet?
    from
    (
     select to_date(r.race_date,'RRRR-MM-DD') as race_date
            ,case 
               when r.race_date < trunc(sysdate) then to_char(current_date,'RRRR')
               when r.race_date > trunc(sysdate) then to_char(to_number(to_char(current_date,'RRRR') - 1))
               else '1900'
             end as season
     from f1_data.v_f1_seasons_race_dates r
     where r.season = p_in_cur_year
       and to_number(r.round) in (select max(to_number(rd.round)) from f1_data.v_f1_seasons_race_dates rd
                                  where rd.season  = r.season)
    );
  return lv_retval;
  
end get_check_season;
/



create or replace function f1_logik.get_last_race 
(
  p_in_cur_year in varchar2 default to_char(current_date,'rrrr') 
) return number result_cache 
as 

  lv_retval number;
  
begin

    with last_race as -- we need to check if any upcoming races or if the last race for the season is done.
    (
    select /*+ MATERIALIZE */  nvl(min(to_number(x.round)-1),-1) as race -- check if any upcoming races this seaseon -1 and season is done
    from f1_data.v_f1_upcoming_races x
    where x.season = p_in_cur_year
    )
    select case when race = -1 then (select max(to_number(y.round))
                                   from  f1_data.v_f1_races y
                                   where y.season = to_char(to_number(p_in_cur_year)-1))
          else race
          end race
          into lv_retval
          from last_race;
          
   return lv_retval;

end get_last_race;
/

grant execute on f1_logik.to_millis to f1_access;
grant execute on f1_logik.get_cur_f1_season to f1_access;
grant execute on f1_logik.get_check_season to f1_access;
grant execute on f1_logik.get_last_race to f1_access;

@F1_DATA_SCHEDULER.sql
