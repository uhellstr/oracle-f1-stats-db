create or replace package body f1_logik.f1_init_pkg
as

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function return_race_date
             (
               p_in_season in varchar2
               ,p_in_round in number
             ) return date
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Function: return_race_date
  -- API: Private not published outside body
  -- Purpose: Return the race date for a specific race in a season in date format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
  is 
   lv_retval date;
  begin

    select to_date(race_date,'RRRR-MM-DD') as race_date into lv_retval
    from f1_data.v_f1_seasons_race_dates
    where season = p_in_season
     and round = p_in_round;

    return lv_retval;

  end return_race_date;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function ret_next_race_in_cur_season
  return number result_cache
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Function: ret_next_race_in_cur_season
  -- API: Private not published outside body
  -- Purpose: Return the next upcoming race in current season. If no races are left then return 0
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  as
    lv_retval number;
    lv_last_race number;

  begin

    select round into lv_retval
    from
    (
      select to_number(round) as round
      from f1_data.v_f1_upcoming_races
      --where to_date(race_date,'YYYY-MM-DD') > trunc(sysdate)
      order by to_number(round)
    ) where rownum < 2;


    return lv_retval;

  -- Season my have ended
  exception
    when no_data_found then
       return 0;

  end ret_next_race_in_cur_season;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_seasons
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: Load all years that F1 has done races-
  -- API: Private not published outside body
  -- Purpose: Fetch data about all seasons that F1 has done races.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin

    -- Only one JSON document fetched so we reload it every time.
    delete from f1_data.f1_seasons_json;

    insert into f1_data.f1_seasons_json(
      season
    ) values
    ( apex_web_service.make_rest_request
      (
        p_url => 'http://ergast.com/api/f1/seasons.json?limit=1000',
        p_http_method => 'GET'
      )
    );
    commit;

  end load_f1_seasons;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_drivers
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_drivers
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 drivers thru the history from ergast.com and save it in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin

    delete from f1_data.f1_drivers_json;

    insert into f1_data.f1_drivers_json(
      drivers
    ) values
    ( apex_web_service.make_rest_request
      (
        p_url => 'http://ergast.com/api/f1/drivers.json?limit=2000',
        p_http_method => 'GET'
      )
    );
    commit;

  end load_f1_drivers;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_tracks
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_tracks
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 tracks ever raced on from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin

    delete from f1_data.f1_tracks_json;
    insert into f1_data.f1_tracks_json(
      tracks
    ) values
    ( apex_web_service.make_rest_request
      (
        p_url => 'http://ergast.com/api/f1/circuits.json?limit=1000',
        p_http_method => 'GET'
      )
    );
    commit;

  end load_f1_tracks;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_races
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_races
  -- API: Private not published outside body
  -- Purpose: Fetch all historic and for current season planned F1 races from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://ergast.com/api/f1/{YEAR}.json?limit=1000';
    calling_url clob;

    cursor cur_get_season_year is
    select f1.season
    from f1_data.v_f1_season f1;

    --inline
    procedure get_races(
      p_in_year in number,
      p_in_url in clob
    )
    is

      lv_count number;

    begin

      -- check if year is already loaded, if then skip
      select count(year) into lv_count
      from f1_data.f1_race_json
      where year = p_in_year;

      if lv_count = 0 then
        insert into f1_data.f1_race_json(
          year
          ,race
        ) values
        ( p_in_year
         ,apex_web_service.make_rest_request
           (
              p_url => p_in_url,
              p_http_method => 'GET'

           )
         );
        commit;
      end if;
    end get_races;

  begin

    for rec in cur_get_season_year loop
      calling_url := replace(url,'{YEAR}',rec.season);
      get_races(rec.season,calling_url);
    end loop;

  end load_f1_races;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_raceresults
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_raceresults
  -- API: Private not published outside body
  -- Purpose: Fetch all the results of all historic F1 races and save it in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://ergast.com/api/f1/{YEAR}/{ROUND}/results.json';
    tmp clob;
    calling_url clob;
    lv_next_round_nr number;
    lv_max_round number;
    last_season_race_date date;

    cursor cur_get_f1_races is
    select to_number(season) as season
           ,to_number(round) as round
    from f1_data.v_f1_races;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_round in number
         ,p_in_url in clob
        )
    is

      lv_count number;

    begin

      select count(year) into lv_count
      from f1_data.f1_raceresults_json
      where year = p_in_year
        and round = p_in_round;

      if lv_count = 0 then
        insert into f1_data.f1_raceresults_json(
          year
          ,round
          ,result
        ) values
          ( p_in_year
              ,p_in_round
              ,apex_web_service.make_rest_request
               (
                  p_url => p_in_url,
                  p_http_method => 'GET'
               )
          );
        commit;
      end if;

    end insert_results;

  begin

      for rec in cur_get_f1_races loop

        -- check that we have a race that has finished before trying to load results
        if  return_race_date(
               p_in_season => rec.season
               ,p_in_round => to_number(rec.round)) <= trunc(sysdate-2) 
        then
          tmp := replace(url,'{YEAR}',rec.season);
          calling_url := replace(tmp,'{ROUND}',rec.round);
          insert_results(rec.season,rec.round,calling_url);
        end if;
      end loop;

  end load_f1_raceresults;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_constructors
  is
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_constructors
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 constructors ever raced on from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  begin
    delete from f1_data.f1_constructors_json;
    insert into f1_data.f1_constructors_json(
      constructor
    ) values
    ( apex_web_service.make_rest_request
      (
        p_url => 'http://ergast.com/api/f1/constructors.json?limit=1000',
        p_http_method => 'GET'
        --p_wallet_path => 'file:///home/oracle/https_wallet'
      )
    );
    commit;
  end load_f1_constructors;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_driverstandings
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_driverstandings
  -- API: Private not published outside body
  -- Purpose: Fetch the last restults in points for all drivers for historic and current season and save in JSON format
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is
    url clob := 'http://ergast.com/api/f1/{YEAR}/driverStandings.json';
    calling_url clob;

    cursor cur_get_f1_seasons is
    select season
    from f1_data.v_f1_season;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_url in clob
        )
    is
     lv_count number;
    begin

     -- Reload current years driverstandings since it will be updated until end of season.
     if p_in_year = to_number(to_char(trunc(sysdate),'RRRR')) then
       lv_count := 0;
       delete from f1_data.f1_driverstandings_json where year = to_number(to_char(trunc(sysdate),'RRRR'));
     else
       -- check if results for year already loaded. if then skip to load it.
       select count(year) into lv_count
       from f1_data.f1_driverstandings_json
       where year = p_in_year;
     end if;

     if lv_count = 0 then
       insert into f1_data.f1_driverstandings_json(
          year
          ,driverstanding
        ) values
        ( p_in_year
          ,apex_web_service.make_rest_request
           (
              p_url => p_in_url,
              p_http_method => 'GET'

           )
        );
       commit;
     end if;
    end insert_results;

  begin
    for rec in cur_get_f1_seasons loop
      calling_url := replace(url,'{YEAR}',rec.season);
      --dbms_output.put_line(calling_url);
      insert_results(rec.season,calling_url);
    end loop;
  end load_f1_driverstandings;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_constructorstandings
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_constructorstandings
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 historic and current seasons last or final result from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is
    url clob := 'http://ergast.com/api/f1/{YEAR}/constructorStandings.json?limit=100';
    calling_url clob;

    cursor cur_get_f1_seasons is
    select to_number(season) as season
    from f1_data.v_f1_season;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_url in clob
        )
    is
      lv_count number;
    begin

     -- Reload current years constructortandings since the update until end of season.
     if p_in_year = to_number(to_char(trunc(sysdate),'RRRR')) then
       lv_count := 0;
       delete from f1_data.f1_constructorstandings_json where year = to_number(to_char(trunc(sysdate),'RRRR'));
     else
       -- check if results for year already loaded. if then skip to load it.
       select count(year) into lv_count
       from f1_data.f1_constructorstandings_json
       where year = p_in_year;
     end if;

     if lv_count = 0 then
       insert into f1_data.f1_constructorstandings_json(
          year
          ,constructorstandings
        ) values
        ( p_in_year
         ,apex_web_service.make_rest_request
           (
              p_url => p_in_url,
              p_http_method => 'GET'

           )
         );
       commit;
     end if;
    end insert_results;

  begin
    for rec in cur_get_f1_seasons loop
      calling_url := replace(url,'{YEAR}',rec.season);
      insert_results(rec.season,calling_url);
    end loop;
  end load_f1_constructorstandings;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_seasons_racedates
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_tracks
  -- API: Private not published outside body
  -- Purpose: Fetch all racedats for historic and current season ever raced from ergast.com and save in JSON format.
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://ergast.com/api/f1/{YEAR}.json?limit=1000';
    calling_url clob;

    cursor cur_get_f1_seasons is
    select to_number(season) as season
    from f1_data.v_f1_season;

    -- inline
    procedure insert_results
       (
         p_in_year in number
         ,p_in_url in clob
        )
    is
      lv_count number;
    begin

    -- check if racedates already loaded , if then skip
     select count(year) into lv_count
     from f1_data.f1_seasons_race_dates
     where year = p_in_year;

     if lv_count = 0 then
       insert into f1_data.f1_seasons_race_dates(
          year
          ,race_date
        ) values
        ( p_in_year
         ,apex_web_service.make_rest_request
           (
              p_url => p_in_url,
              p_http_method => 'GET'

           )
         );
       commit;
     end if;
    end insert_results;

  begin

    for rec in cur_get_f1_seasons loop
      calling_url := replace(url,'{YEAR}',rec.season);
      insert_results(rec.season,calling_url);
    end loop;

  end load_f1_seasons_racedates;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_qualitimes
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_qualitimes (Heavylifter)
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 qualitimes historicly from 1994 and forward and store in JSON format
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is

    url clob := 'http://ergast.com/api/f1/{YEAR}/{ROUND}/qualifying.json?limit=1000';
    calling_url clob;
    tmp_url clob;
    lv_number_of_races number;
    lv_next_round_nr number;

    cursor cur_get_season_year is
    select to_number(season) as season
    from f1_data.v_f1_season
    where to_number(season) > 1993;

    -- inline
    procedure get_qualitimes
    (
        p_in_year in number
        ,p_in_round in number
        ,p_in_url clob
    )
    is

      lv_count number;

    begin

      -- check if racedates already loaded , if then skip
      select count(year) into lv_count
      from f1_data.f1_qualification_json
      where year = p_in_year
        and round = p_in_round;

     if lv_count = 0 then

      insert into f1_data.f1_qualification_json(
          year
          ,round
          ,qualification
        ) values
        (
          p_in_year
          ,p_in_round
          ,apex_web_service.make_rest_request
          (
              p_url => p_in_url,
              p_http_method => 'GET'

           )
         );
       commit;
     end if;

    end get_qualitimes;

  begin


   for rec in cur_get_season_year loop

      -- Special handling for current season since not all races are done yeat

     select max(to_number(round)) into lv_number_of_races
     from f1_data.v_f1_races
     where season = rec.season;

     if lv_number_of_races > 0 then

        for i in 1..lv_number_of_races loop

          -- Is the race finished ?
          if return_race_date(
               p_in_season => rec.season
               ,p_in_round => i) <= trunc(sysdate-2) -- Let there be some time for ergast to update 
          then
            tmp_url := replace(url,'{YEAR}',rec.season);
            calling_url := replace(tmp_url,'{ROUND}',i);
            get_qualitimes(rec.season,i,calling_url);
          end if;

        end loop; -- round in season

     end if; -- Has the season started yeat?

   end loop;

  end load_f1_qualitimes;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure load_f1_laptimes
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- Procedure: load_f1_laptimes (Heavylifter)
  -- API: Private not published outside body
  -- Purpose: Fetch all F1 laptimes historicly from 1996 and forward and store in JSON format
  -- Author: Ulf Hellstrom, oraminute@gmail.com
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  is
    url clob := 'http://ergast.com/api/f1/{YEAR}/{ROUND}/laps/{LAP}.json?limit=1000';
    calling_url clob;
    tmp_url clob;
    tmp1_url clob;
    lv_number_of_races number;
    lv_number_of_laps number;
    lv_next_round_nr number;

    cursor cur_get_season_year is
    select to_number(season) as season
    from f1_data.v_f1_season
    where to_number(season) > 1995
      and to_number(season) <= to_number(trunc(to_char(sysdate,'RRRR')));

    --inline
    procedure get_laps(
        p_in_year in number,
        p_in_round in number,
        p_in_lap in number,
        p_in_url clob
   )
   is

      lv_count number;

    begin

      select count(lap) into lv_count
      from f1_data.f1_laptimes_json
      where year = p_in_year
        and round = p_in_round
        and lap = p_in_lap;

      if lv_count = 0 then
        insert into f1_data.f1_laptimes_json(
          year
          ,round
          ,lap
          ,laptimes
        ) values
        ( p_in_year,
          p_in_round,
          p_in_lap,
          apex_web_service.make_rest_request
            (
              p_url => p_in_url,
              p_http_method => 'GET'
            )
        );
        commit;
      end if;
     end get_laps;

  begin

    for rec in cur_get_season_year loop

      -- Special handling for current season since not all races are done yeat

      select max(to_number(round)) into lv_number_of_races
      from f1_data.v_f1_races
      where season = rec.season;

      if lv_number_of_races > 0 then

        for i in 1..lv_number_of_races loop

          begin

            select to_number(to_number(laps))
            into lv_number_of_laps
            from f1_data.v_f1_results
            where to_number(position) = 1
              and to_number(season) = rec.season
              and to_number(race) = i;

               -- In current season do not try to load races not yet raced!
            if return_race_date
                   (
                     p_in_season => rec.season
                    ,p_in_round => i) <= trunc(sysdate-2) -- Let there be some time for Ergast to update
            then 
              for j in 1..lv_number_of_laps loop
                  tmp_url := replace(url,'{YEAR}',rec.season);
                  tmp1_url := replace(tmp_url,'{ROUND}',i);
                  calling_url := replace(tmp1_url,'{LAP}',j);
                  get_laps(rec.season,i,j,calling_url);
              end loop;
            end if;  
          exception -- special handling if runned same date as race is and no data loaded on ergast.com yet!
             when no_data_found then
                delete from f1_data.f1_raceresults_json
                where to_number(year) = rec.season
                  and to_number(round) = i;
                  commit;
          end;  

        end loop;
      end if; -- lv_number_of_races 
    end loop; -- cursor

  end load_f1_laptimes;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure refresh_mviews
  is
  begin
    DBMS_SNAPSHOT.REFRESH( '"F1_DATA"."MV_F1_LAP_TIMES"','C');
    DBMS_SNAPSHOT.REFRESH( '"F1_DATA"."MV_F1_QUALIFICATION_TIMES"','C');
    DBMS_SNAPSHOT.REFRESH( '"F1_DATA"."MV_F1_RESULTS"','C');
  end refresh_mviews;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  procedure reset_all_data 
  is
  begin
    delete from f1_data.f1_constructors_json;
    delete from f1_data.f1_constructorstandings_json;
    delete from f1_data.f1_drivers_json;
    delete from f1_data.f1_driverstandings_json;
    delete from f1_data.f1_laptimes_json;
    delete from f1_data.f1_qualification_json;
    delete from f1_data.f1_race_json;
    delete from f1_data.f1_raceresults_json;
    delete from f1_data.f1_seasons_json;
    delete from f1_data.f1_seasons_race_dates;
    delete from f1_data.f1_tracks_json;
    commit;
  end reset_all_data;

  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  procedure reset_race
             (
               p_in_season in number
               ,p_in_race in number
             )
  is
  begin
  
    delete from f1_data.f1_driverstandings_json;
    delete from f1_data.f1_laptimes_json 
    where year = p_in_season 
     and round = p_in_race;
    delete from f1_data.f1_qualification_json
    where year = p_in_season
      and round = p_in_race;
    delete from f1_data.f1_race_json
    where year = p_in_season
     and to_number(race) = p_in_race;
    delete from f1_data.f1_raceresults_json
    where year = p_in_season
     and round = p_in_race;
    commit;
    
  end reset_race;
  
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -- main published API starts here.
  --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  procedure load_json as
  begin
    load_f1_seasons;
    load_f1_seasons_racedates;
    load_f1_drivers;
    load_f1_tracks;
    load_f1_races;  
    load_f1_raceresults;
    load_f1_constructors;
    load_f1_driverstandings;
    load_f1_constructorstandings;
    load_f1_qualitimes;
    load_f1_laptimes;      
    refresh_mviews;
  end load_json;
  
  procedure load_race
             (
               p_in_season in number
               ,p_in_race in number
             )
 is
 begin
   
   reset_race
             (
               p_in_season => p_in_season
               ,p_in_race => p_in_race
             );
  -- load data for one race and one season           
  refresh_mviews;           
   
 end load_race;
 
end f1_init_pkg;
/