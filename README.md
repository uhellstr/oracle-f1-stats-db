
# Oracle Formula 1 database.

Note: This data CANNOT be used in any kind of commercial application due to how ergast licensing its data.
      You are however free to use this data for your own personal fun and personal development!

This is a demo of Oracle's functionality of using and creating Rest Based services and how to parse JSON documents.

- How to consume REST based F1 service from ergast.com and how to parse json to relation data to be able to query all stats thru SQL.
- SQL demo script show how to use SQL to analyze the F1 data
- python API for downloading additional images like public track images and public driver images from wikipedia
- python API for downloading data from official Formula 1 using the fastf1 python api
- Additional SQL script for rest enabling the local data for further analyze using example python jupyter notebook graphing data.

# Consuming public REST api pre-requirements.

Requirements:

* Linux environment supported like Oracle unbreakable linux or a docker container with an oracle database.
* Oracle 11g or higher. (For a non licensed environment I strongly recommend to use Oracle 18c Express Edition or higher)
* Java 8 or Java 11 LTS or higher where you install Oracle Rest Data Services. 
* Oracle Application Express version 20 or higher.
* Latest version of Oracle Rest Data services (ORDS)

All the installation kits can be downloaded from https://www.oracle.com/technical-resources/

You must have APEX v5 (Recommend the latest version of APEX) or newer installed due to PL/SQL packaged code is used in the demo code to publish data as a REST enabled service in JSON format. I like to hide logic in code and even if you can publish tables or views in a Oracle schema directly i suggest you hide all logic in code to minimize and control exactly what you want to publish to your audience.

You also need ORDS installed and configured (see example below) to be able to call the service. In this example we make i easy and use normal http calls. In a production environemnt you would never do that. There you always should use https calls to secure your environment as much as possible. I recommend to look at Tim Hall's excelent introduction to Oracle Rest Data Services (ORDS) for more indepth information about setting up and configuring ORDS.

Tim Hall's excelent site:
https://oracle-base.com

You can use a browser like Chromium, Safari, Firefox to call the published services but the demo also includes som examples made with the python jupyter notebooks to show that you can call Oracle Rest enabled services from any language supporting JSON and REST calls. You could easy create a client in any language like python, ruby or even in C. See your platform for how to install python or simply install anaconda that I personally think is the fastest way to get started.

## Configuring ORDS (Oracle Rest Data Services):

a) Install Oracle Application Express (APEX) if not installed in the datbase you intend to run this demo against.

Installing APEX normally done as SYS by running the following scripts from the catalog where you unzipped the downloaded apex zip file. Use sqlplus or sqlcl against either a pluggable database if you run this demo against 12c or higher or a normal database if below 12c. (Recommend atleast 11g as a minimum) If you don't have a database you will need to setup that first. For a perfect introduction into Oracle i suggest 21c Express Editoin (XE) that is completly free. 21c XE is where I run my own Formula 1 database on. It has all the power you need to start to dig into the statistics around Formula 1.

1. SQL>@apexins SYSAUX SYSAUX TEMP /i/
2. SQL>@apex_rest_config (To setup APEX_LISTENER, APEX_REST_PUBLIC_USER that is a MUST for ORDS to work correctly)
3. SQL>@apxchpwd (Setup the password for the internal workspace admin user)

In this example we have installed Oracle 21c Express Edition as a demonstration environment. Since Oracle 21c XE uses multitenant by default
we have a containerdatabase XE and atleast one pluggable database XEPDB1 by default setup after installation. All configuration
and installation is done against the pluggable database XEPDB1

Even if there is no intent to use APEX i recommend you setup ORDS for APEX that will also make sure you have a working ORDS environment and minimize any problem solving:

After the installation of APEX the i highly recommend you try to connect to the following schemas to make sure you can connect to them

4. APEX_LISTENER
5. APEX_REST_PUBLIC_USER

You also need to enable APEX_PUBLIC_USER as:

6. SQL> alter user APEX_PUBLIC_USER identified by "your secret password" account unlock;

Also verify you can connect to the APEX_PUBLIC_USER.

b) Create a catalog (you don't need to be the Oracle O/S user as long as you can run java) called ords and the following subcatalogs. In this example we have downloaded ORDS version 18. In this example we use the O/S user test that has it's home catalog in /home/test. I recommend you download as late version as possible. If you however go for the 22.1 version or newer you really have to read the documentation since the installation for that version is different then ORDS version 18-21.

1. $ mkdir ords
2. $ cd ords
3. $ mkdir ords181
4. $ mkdir scripts
5. $ mkdir logs
6. $ mkdir configdir

Also copy over the subcatalog images from your APEX installation. This is done by

Wherever you have APEX unziped

1. $ cd /../apex
2. $ zip -r images.zip ./images/*

Move the images.zip file to /home/test/ords and 
3. $ unzip images.zip

You should now have a images catalog also in /home/test/ords 

Put the downloaded zip file with the latest ORDS version in the ords191 catalong and unzip it.
1. $ cd ords181
2. $ unzip ords-18.10.0.092.1545.zip (Your file might have another name depending on version)

c) Then we need to setup where ORDS is storing it's configuration files

1. $ cd /ords/ords181
2. $ java -jar ords.war configdir /home/test/ords/configdir (You need to alter the path to where the configdir is created)

Then we setup a path for our database. In our example we use 18c Express Edition and the pluggable database xepdb1.
You will understand how the path is used when calling the service below

3. $ java -jar ords.war map-url --type base-path /xepdb1 xepdb1

Then we run the configuration to enable ORDS in the xepdb1 database. You must configure all steps and the script will ask you for
the administrator user or SYS for the installation to complete. For more details in depth please see references on how to setup
ORDS on Tim Hall's site as stated above.

4. $ java -jar ords.war setup --database xepdb1

Don't skip any steps more then the last that asks if you want to start ORDS in standalone mode. We do it manually below.

When you are finished with the ORDS configuration you can startup the ORDS listener in a standalone mode from your terminal to
check that things works as intended. (Remember the step with "base-path" setup "/xepdb1". This will now uniqly identify what
resource we call

5. $ java -jar ords.war standalone

Running this will ask about using http or https. For demo purpose use HTTP , default port (Normally 8080) and where to find APEX images catalog in the example /home/test/ords/images

The issue with starting ORDS in the way above is that we have to let the terminal window to be open. If we close it or
press Ctrl+C we will force quit ORDS. If you want you can put the following shellscripts as executables in the 
scripts subfolder and then add the path to that folder to your environemnt to allow stop/start ORDS in the background.
You ofcause needs to edit the paths below if you have another user then test setup in your environment.

startords:

```
#!/bin/bash
export PATH=/usr/sbin:/usr/local/bin:/usr/bin:/usr/local/sbin:$PATH
LOGFILE=/home/test/ords/logs/ords-`date +"%Y""%m""%d"`.log
cd /home/test/ords/ords181
export JAVA_OPTIONS="-Dorg.eclipse.jetty.server.Request.maxFormContentSize=3000000"
nohup java ${JAVA_OPTIONS} -jar ords.war standalone >> $LOGFILE 2>&1 &
echo "View log file with : tail -f $LOGFILE"
```

stopords:

```
#!/bin/bash
export PATH=/usr/sbin:/usr/local/bin:/usr/bin:/usr/local/sbin:$PATH
kill `ps -ef | grep ords.war | awk '{print $2}'` >/dev/null 2>&1stopords:
```

d) Now you can try out to see if APEX and ORDS works as intended by using a browser and a URL like:

http://<you host where ords is installed>:8080/ords/xepdb1/apex_admin

Example:
http://localhost:8080/ords/xepdb1/apex_admin

If everything works you should see the login page for Oracle Application Express.

# How to consume a Formula 1 REST service and transform JSON to Relational data for SQL analysis ?

Note: ergast is used only for non commercial applications. You cannot use this data and build any kind of commercial applications as per there license.

I'm a huge fan of Formula 1. I've been following it since i was a kid and the "Superswede" Ronnie Peterson was my absolute hero. I still belive the "Lotus 72D" is one of the most beatiful oneseater cars ever built. As a "datanerd". i'm more into analysing data then the database technology itself. So having a lot of F1 data for historical Formula 1 races, season, laptimes etc would be great to help me better understand how the teams differs from each others, how drivers perform during a season, what enginges seems to have
more problems then others etc.

Now, thanks to https://ergast.com/mrd/ I finally found a way to be able to get hold of data and do some analysis of my favorite motorsport besides Indycar. This site publish allot of statistical data in form of REST services and you can download the raw JSON document and store them in a Oracle database (Oracle supports JSON storage in tables) and the parse and query the data as if it is a normal relational table.

If you want to setup this demo yourself be warned. You will download 10 000's of relative small JSON documents and the volume of races are huge. The first official Formula 1 race was done in the 1950's. Not all years have the full statistics, it was not until around 1996 the technology was there to get lot of more data that is now public for publishing. But in anycase this will take some time to get your tables loaded before you can start to analyze. On a medium to good internet connection assume it will take around 4-5 hours to get the data in place. The data is loaded thru a scheduled job so you do not need to sit around and wait for it to be finished. 

When everything is in place you will have information about all F1 seasons, all races, qualification times , lap times , constructors and drivers.

## How to install the basetables and start load the data from ergast ?

1. First you need to run the "setup_schema.sql" script as SYS.

Now before running it look at the ACL part and change the password for the F1_DATA schema if not in a private demo environment. 

You must have APEX installed before attempting to run the script. The script will automaticly find out the latest installed version of APEX and add it to the ACL list.


You also have to look at the DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL where you set the hostname for the server where the Oracle database is installed.

In the example it is set to 'localhost'. You need to change that to match your environment if necessary.

The ACL part (Access Control List) is where we tell the Oracle database that we allow for doing http calls from inside the database and to a website outside our protected environment. It is quite complex configuration so I refer to the official Oracle documentation for you to read more about ACL's in Oracle.

When done with the necessary changes you can run the script as SYS.

When it is done you could try to do a call to ergast thru the SQL below to see if it works. If not you need to start to check for any errors in the setup for ACL, firewall issues etc that could cause the callout to fail.

```
select apex_web_service.make_rest_request(
    p_url         => 'http://ergast.com/api/f1/seasons.json?limit=1000', 
    p_http_method => 'GET' 
) as result from dual;
```

2. When, and only when the query above works it is time to setup the schema and initiate tables, views and setup scheduled jobs
for downloading data from ergast

As the SYS user runt the following scripts

```
SQL> conn sys@<TNS-ALIAS> as sysdba 
SQL> @setup_schemas.sql
SQL> @setup_objs.sql
```
 
You will get some errors due to way the scripts where generated som indexes are duplicated. You can however just ignore them.

# How to download the ergast data and built the database.
      
Check the F1_LOGIK schema it will have a scheduled job called 'AUTO_ERGAST_LOAD_JOB'
You can run this manually to download the data and it will be called using dbms_scheduler once per day
to check for new data or if the database is empty download all the historical races.

## How to use the data for analysis ?


I have provided a SQL script called "queries.sql" you can use for start analysing the data. I also provided a number of materialized views that speeds up some queries due to minimize parsing time when joining different tables with each others.

There is also som additional script for handling ORDS AutoRest written in python and python jupyter notebooks (E.g publish back the relational data as REST services). Scripts for allowing other users then F1_ACCESS to access data thru views and som python scripts for loading images of drivers,tracks etc and Jupyter Notebook examples on how to plot graphs using pandas and mathplotlib for the Formula 1 2021 season. See the included README_FIRST.txt for more information.
      
Enjoy and don't forget to travel to a formula 1 race. It will change your life forever!
      
