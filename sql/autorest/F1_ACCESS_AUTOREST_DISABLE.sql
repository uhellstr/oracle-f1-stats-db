REM
REM Script should be runned as F1_ACCESS if planned to use AutoRest
REM
REM Turn off Autorest on all objects in F1_ACCESS schema

prompt DISABLE V_F1_CONSTRUCTORS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_CONSTRUCTORS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'constructors'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_CONSTRUCTORSTANDINGS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_CONSTRUCTORSTANDINGS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'constructorstandings'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_DRIVERS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DRIVERS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'drivers'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_DRIVERSTANDINGS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DRIVERSTANDINGS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'driverstandings'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_LAST_RACE_RESULTS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_LAST_RACE_RESULTS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'lastraceresults'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_RACES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_RACES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'races'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_SEASON

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_SEASON',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'seasons'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_SEASONS_RACE_DATES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_SEASONS_RACE_DATES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'racedates'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_TRACKS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_TRACKS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'tracks'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_UPCOMING_RACES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_UPCOMING_RACES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'upcomingraces'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_MV_F1_LAP_TIMES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_MV_F1_LAP_TIMES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'laptimes'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_MV_F1_QUALIFICATION_TIMES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_MV_F1_QUALIFICATION_TIMES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'qualification'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_MV_F1_RESULTS

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_MV_F1_RESULTS',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'results'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_DATA_DRIVER_IMAGES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DATA_DRIVER_IMAGES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'driverimages'
  );
    
  COMMIT;
END;
/

prompt DISABLE V_F1_DATA_TRACK_IMAGES

BEGIN
  ORDS.enable_object (
    p_enabled      => FALSE, -- Default  { TRUE | FALSE }
    p_schema       => 'F1_ACCESS',
    p_object       => 'V_F1_DATA_TRACK_IMAGES',
    p_object_type  => 'VIEW', -- Default  { TABLE | VIEW }
    p_object_alias => 'trackimages'
  );
    
  COMMIT;
END;
/