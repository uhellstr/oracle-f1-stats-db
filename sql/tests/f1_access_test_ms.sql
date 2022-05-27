set serveroutput on 

prompt test1

with t as
(
  select '00:01:30.423000' as laptime from dual
) 
select f1_logik.to_millis(laptime) from t; --90423

prompt test2
with t as
(
  select '00:01:24' as laptime from dual
) 
select f1_logik.to_millis(laptime) from t; -- 84000

prompt test3

with t as
(
  select '1:30.423' as laptime from dual
) 
select f1_logik.to_millis(laptime) from t;

