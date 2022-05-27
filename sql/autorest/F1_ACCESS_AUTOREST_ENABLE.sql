REM
REM Script should be runned as F1_ACCESS if planned to use AutoRest
REM
REM Get all objects with AutoRest enabled
REM Metadata:
REM http://<host>:<Port>:/ords/<Databaseurl>/<url mapping>/metadata-catalog/<object alias>/
REM http://localhost:8080/ords/pdbutv1/f1_access/metadata-catalog/
REM
REM Below we have all views AutoRest enabled and some examples on how to query
REM

prompt V_F1_CONSTRUCTORS

REM Get metadata for constructors
REM http://localhost:8080/ords/pdbutv1/f1_access/metadata-catalog/constructors/
REM Query constructors and fetch all rows (limit)
REM http://localhost:8080/ords/pdbutv1/f1_access/constructors/?limit=500
REM Query data for constructor ferrari
REM http://localhost:8080/ords/pdbutv1/f1_access/constructors/?q={"constructorid":"ferrari"}
BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_CONSTRUCTORS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'constructors'
  );
    
  COMMIT;
END;
/

prompt V_F1_CONSTRUCTORSTANDINGS

REM Metadata query
REM http://localhost:8080/ords/pdbutv1/f1_access/metadata-catalog/constructorstandings/
REM Get data from constructorstandings 
REM http://localhost:8080/ords/pdbutv1/f1_access/constructorstandings/?limit=500
REM Query the standings after race 21 in season 2019
REM http://localhost:8080/ords/pdbutv1/f1_access/constructorstandings/?q={"season":"2019","race":"21","$orderby":{"position":"asc"}}

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_CONSTRUCTORSTANDINGS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'constructorstandings'
  );
    
  COMMIT;
END;
/

prompt V_F1_DRIVERS

REM Metadata query
REM http://localhost:8080/ords/pdbutv1/f1_access/metadata-catalog/drivers/
REM Get data for F1 drivers thru the history
REM http://localhost:8080/ords/pdbutv1/f1_access/drivers/?limit=500
REM Query all swedish drivers
REM http://localhost:8080/ords/pdbutv1/f1_access/drivers/?q={"nationality":"Swedish"}

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DRIVERS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'drivers'
  );
    
  COMMIT;
END;
/

prompt V_F1_DRIVERSTANDINGS

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DRIVERSTANDINGS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'driverstandings'
  );
    
  COMMIT;
END;
/

prompt V_F1_LAST_RACE_RESULTS

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_LAST_RACE_RESULTS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'lastraceresults'
  );
    
  COMMIT;
END;
/

prompt V_F1_RACES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_RACES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'races'
  );
    
  COMMIT;
END;
/

prompt V_F1_SEASON

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_SEASON',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'seasons'
  );
    
  COMMIT;
END;
/

prompt V_F1_SEASONS_RACE_DATES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_SEASONS_RACE_DATES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'racedates'
  );
    
  COMMIT;
END;
/

prompt V_F1_TRACKS

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_TRACKS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'tracks'
  );
    
  COMMIT;
END;
/

prompt V_F1_UPCOMING_RACES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_UPCOMING_RACES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'upcomingraces'
  );
    
  COMMIT;
END;
/

prompt V_MV_F1_LAP_TIMES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_MV_F1_LAP_TIMES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'laptimes'
  );
    
  COMMIT;
END;
/

prompt V_MV_F1_QUALIFICATION_TIMES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_MV_F1_QUALIFICATION_TIMES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'qualification'
  );
    
  COMMIT;
END;
/

prompt V_MV_F1_RESULTS

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_MV_F1_RESULTS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'results'
  );
    
  COMMIT;
END;
/

prompt V_F1_DATA_DRIVER_IMAGES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DATA_DRIVER_IMAGES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'driverimages'
  );
    
  COMMIT;
END;
/

prompt V_F1_DATA_TRACK_IMAGES

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DATA_TRACK_IMAGES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'trackimages'
  );
    
  COMMIT;
END;
/

prompt V_F1_OFFICIAL_TIMEDATA

BEGIN
  ORDS.enable_object (
    p_enabled      => TRUE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_OFFICIAL_TIMEDATA',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'f1trackdata'
  );
    
  COMMIT;
END;
/