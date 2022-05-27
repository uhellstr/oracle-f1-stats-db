begin
  dbms_scheduler.create_schedule
    (
      schedule_name => 'F1_LOGIK.AUTO_LOAD_JSON_SCHEDULE'   
      , start_date => sysdate
      , repeat_interval =>'FREQ=DAILY;BYHOUR=20;BYMINUTE=0;BYSECOND=0;'
      , comments => 'Autoload any new ergast data'
    );
end;
/

begin
  dbms_scheduler.create_program
    (
      program_name => 'F1_LOGIK.AUTO_LOAD_NEW_F1_DATA'
      ,program_type => 'STORED_PROCEDURE'
      ,program_action => 'f1_init_pkg.load_json'
      ,enabled => true
      ,comments => 'Call stored packaged procedure'
    );
end;
/

begin
  dbms_scheduler.create_job
    (
      job_name => 'F1_LOGIK.AUTO_ERGAST_LOAD_JOB'
      , program_name => 'AUTO_LOAD_NEW_F1_DATA'
      , schedule_name =>'AUTO_LOAD_JSON_SCHEDULE'
      , enabled => true
      , auto_drop => true
      , comments => 'Job to automagicly load new data from ERGAST F1'
    );
end;
/