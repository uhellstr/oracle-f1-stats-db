DECLARE
  lv_count number := 0;
BEGIN

  SELECT COUNT(*) 
  INTO lv_count
  FROM DBA_USERS
  WHERE USERNAME = 'F1_DATA';

  IF lv_count > 0 THEN      
    EXECUTE IMMEDIATE 'DROP USER F1_DATA CASCADE';
  END IF;

END;
/

DECLARE
  lv_count number := 0;
BEGIN

  SELECT COUNT(*) 
  INTO lv_count
  FROM DBA_USERS
  WHERE USERNAME = 'F1_LOGIK';

  IF lv_count > 0 THEN      
    EXECUTE IMMEDIATE 'DROP USER F1_LOGIK CASCADE';
  END IF;

END;
/

DECLARE
  lv_count number := 0;
BEGIN

  SELECT COUNT(*) 
  INTO lv_count
  FROM DBA_USERS
  WHERE USERNAME = 'F1_REST_ACCESS';

  IF lv_count > 0 THEN      
    EXECUTE IMMEDIATE 'DROP USER F1_REST_ACCESS CASCADE';
  END IF;

END;
/

DECLARE
  lv_count number := 0;
BEGIN

  SELECT COUNT(*) 
  INTO lv_count
  FROM DBA_ROLES
  WHERE ROLE = 'F1_DATA_FORVALT_ROLE';

  IF lv_count > 0 THEN      
    EXECUTE IMMEDIATE 'DROP ROLE F1_DATA_FORVALT_ROLE';
  END IF;

END;
/

DECLARE
  lv_count number := 0;
BEGIN

  SELECT COUNT(*) 
  INTO lv_count
  FROM DBA_USERS
  WHERE USERNAME = 'F1_ACCESS';

  IF lv_count > 0 THEN      
    EXECUTE IMMEDIATE 'DROP USER F1_ACCESS CASCADE';
  END IF;

END;
/

DECLARE
  lv_count number := 0;
BEGIN

  SELECT COUNT(*) 
  INTO lv_count
  FROM DBA_PROFILES
  WHERE PROFILE = 'F1_DEFAULT_PROFILE';

  IF lv_count > 0 THEN      
    EXECUTE IMMEDIATE 'DROP PROFILE F1_DEFAULT_PROFILE';
  END IF;

END;
/

-- USER SQL
CREATE USER "F1_DATA" IDENTIFIED BY "oracle"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER "F1_DATA" QUOTA UNLIMITED ON "USERS";

-- ROLES
GRANT "CONNECT" TO "F1_DATA" ;
ALTER USER "F1_DATA" DEFAULT ROLE "CONNECT";

-- SYSTEM PRIVILEGES
GRANT CREATE TRIGGER TO "F1_DATA" ;
GRANT CREATE VIEW TO "F1_DATA" ;
GRANT CREATE SESSION TO "F1_DATA" ;
GRANT CREATE TABLE TO "F1_DATA" ;
GRANT CREATE SEQUENCE TO "F1_DATA" ;
GRANT CREATE MATERIALIZED VIEW TO "F1_DATA";
GRANT CREATE EVALUATION CONTEXT TO "F1_DATA";


-- USERSCHEMA F1_LOGIK

-- USER SQL
CREATE USER "F1_LOGIK" IDENTIFIED BY "oracle"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER "F1_LOGIK" QUOTA UNLIMITED ON "USERS";

-- ROLES
GRANT "CONNECT" TO "F1_LOGIK" ;
ALTER USER "F1_LOGIK" DEFAULT ROLE "CONNECT";

GRANT CREATE SESSION TO "F1_LOGIK" ;
GRANT CREATE TYPE TO "F1_LOGIK" ;
GRANT EXECUTE ANY PROGRAM TO "F1_LOGIK" ;
GRANT CREATE PROCEDURE TO "F1_LOGIK" ;
GRANT SELECT ON DBA_TABLES TO "F1_LOGIK";
GRANT CREATE JOB TO "F1_LOGIK";
GRANT CREATE RULE TO "F1_LOGIK";
GRANT CREATE RULE SET TO "F1_LOGIK";
GRANT CREATE EVALUATION CONTEXT TO "F1_LOGIK";
grant execute on dbms_refresh to f1_logik;
grant ALTER ANY MATERIALIZED VIEW to f1_logik;

-- USERSCHEMA F1_ACCESS

-- USER SQL
CREATE USER "F1_ACCESS" IDENTIFIED BY "oracle"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER "F1_ACCESS" QUOTA UNLIMITED ON "USERS";

-- ROLES
GRANT "CONNECT" TO "F1_ACCESS" ;
ALTER USER "F1_ACCESS" DEFAULT ROLE "CONNECT";

GRANT CREATE SESSION TO "F1_ACCESS" ;
GRANT CREATE VIEW TO "F1_ACCESS" ;
GRANT CREATE SYNONYM TO "F1_ACCESS" ;

-- USERSCHEMA F1_REST_ACCESS

-- USER SQL
CREATE USER "F1_REST_ACCESS" IDENTIFIED BY "oracle"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER "F1_REST_ACCESS" QUOTA UNLIMITED ON "USERS";

-- ROLES
GRANT "CONNECT" TO "F1_REST_ACCESS" ;
ALTER USER "F1_REST_ACCESS" DEFAULT ROLE "CONNECT";

GRANT CREATE SESSION TO "F1_REST_ACCESS" ;
GRANT CREATE VIEW TO "F1_REST_ACCESS" ;
GRANT CREATE SYNONYM TO "F1_REST_ACCESS" ;

create profile F1_DEFAULT_PROFILE LIMIT PASSWORD_LIFE_TIME UNLIMITED;
alter user F1_ACCESS profile F1_DEFAULT_PROFILE;
alter user F1_LOGIK profile F1_DEFAULT_PROFILE;
alter user F1_DATA profile F1_DEFAULT_PROFILE;
alter user F1_REST_ACCESS profile F1_DEFAULT_PROFILE;

-- ACL must run as SYS -
@F1_ACL_SETUP.sql

--select apex_web_service.make_rest_request(
--    p_url         => 'http://ergast.com/api/f1/seasons.json?limit=1000', 
--    p_http_method => 'GET'
--    --p_wallet_path => 'file:///home/oracle/https_wallet' 
--) as result from dual;
