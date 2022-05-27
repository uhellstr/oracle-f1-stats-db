set serveroutput on
declare
  --c_sel_stmt     constant varchar2(400) := 'select version, schema, status from sys.dba_registry where comp_id = ''APEX''';
  -- There is some kind of bug not updating dba_registry when installing APEX 20 into 19c Application Container
  -- Thats why changed sql to the one below!!
  c_sel_stmt     constant varchar2(1000) := q'#select (select version_no as version from apex_release) as version
                                                     ,username as schema
                                                     ,'VALID' as status
                                              from dba_users
                                              where regexp_like(username,'APEX_[[:digit:]]')
                                              order by to_number(substr(username,-6)) desc
                                              fetch first row only#';
  c_grant_select constant varchar2(100) := 'grant select on ';
  c_to_user      constant varchar2(400) := ' to ' || dbms_assert.enquote_name('^ADMINUSER') || ' with grant option';
  l_apex_schema  varchar2(255) := null;
  l_apex_version   varchar2(100) := '';
  l_status         varchar2(100) := null;
  l_tmp_str        varchar2(100) := null;
  l_ver_no         number;
  l_ndx            number;
  l_count          number := 0;

begin
  begin
      execute immediate c_sel_stmt into l_apex_version, l_apex_schema, l_status;
  exception
     when no_data_found then
       dbms_output.put_line('Please install APEX first and then rerun this script!!');
        null;  -- APEX doesn't exist
  end;

  if (l_status is not null) and (l_status = 'VALID') and
      (l_apex_version is not null) and (l_apex_schema is not null) then

     l_ndx := instr(l_apex_version, '.');
     l_ndx := l_ndx - 1;
     l_tmp_str := substr(l_apex_version,1,l_ndx);

     l_ver_no := to_number(l_tmp_str);
     dbms_output.put_line('APEX version: '||l_tmp_str);
     dbms_output.put_line('APEX schema: '||l_apex_schema);
     
     -- Check if ACL already exists in that case remove it first
     select count(*) into l_count 
     from dba_network_acls
     where acl = '/sys/acls/f1_data.xml';
     
     if l_count > 0 then -- We have ACL setup remove it
     
       DBMS_NETWORK_ACL_ADMIN.DROP_ACL(
         acl => 'f1_data.xml'
       );
       commit;
     end if;

     DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
       acl => 'f1_data.xml',
       description => 'Permissions to access internet',
       principal => l_apex_schema,
       is_grant => TRUE,
       privilege => 'connect',
       start_date => SYSTIMESTAMP,
       end_date => NULL
     );
     COMMIT;
     DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
       acl => 'f1_data.xml',
       principal => l_apex_schema,
       is_grant => true,
       privilege => 'resolve',
       start_date => SYSTIMESTAMP,
       end_date => NULL
     );
     COMMIT;
     DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
       acl => 'f1_data.xml',
       principal => 'F1_LOGIK',
       is_grant => true,
       privilege => 'connect',
       start_date => SYSTIMESTAMP,
       end_date => NULL
     );
     COMMIT;
     DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
       acl => 'f1_data.xml',
       principal => 'F1_LOGIK',
       is_grant => true,
       privilege => 'resolve',
       start_date => SYSTIMESTAMP,
       end_date => NULL
     );
     COMMIT;
     DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
       acl => 'f1_data.xml',
       host => 'localhost'
     );
     COMMIT;
     --l_principal VARCHAR2(20) := 'APEX_190200';
     DBMS_NETWORK_ACL_ADMIN.append_host_ace (
       host       => '*', 
       lower_port => 80,
       upper_port => 8888,
       ace        => xs$ace_type(privilege_list => xs$name_list('http'),
                                 principal_name => l_apex_schema,
                                 principal_type => xs_acl.ptype_db)
     ); 
     COMMIT;
   else
     dbms_output.put_line('Please install APEX first and then rerun this script!!');
   end if;
   
   for rec in (SELECT acl
                     ,principal
                     ,privilege
                     ,start_date
                     ,acl_owner
               FROM dba_network_acl_privileges
               where acl = '/sys/acls/f1_data.xml'
               order by principal)
  loop
    dbms_output.put_line('ACL:       '||rec.acl);
    dbms_output.put_line('PRINCIPAL: '||rec.principal);
    dbms_output.put_line('PRIVILEGE: '||rec.privilege);
    dbms_output.put_line('ACL_OWNER: '||rec.acl_owner);
  end loop;
end;
/

