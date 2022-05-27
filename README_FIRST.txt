Requirements:

Apex 18.2 or higher must be installed first!!
setup_schema default to APEX 19.1 if you use a lower or higher  version then you MUST update the script!!

Run in the following order as SYS

1. setup_schema.sql
2. setup_objs.sql

This will create 3 schemas

* F1_DATA This will hold all JSON and relational data tables + Materialized views
* F1_LOGIK This schema will hold PL/SQL code to download and insert new data into F1_DATA schema + Scheduler to run
           job automaticly every day to try to download races not already downloaded
* F1_ACCESS This is the primary schema to access downloaded data. Do never let users access F1_DATA directly.

If you want to grant priviliges to select data to other schemas then F1_ACCESS use the script

  OTHER_SCHEMA_ACCESS.sql to grant necessary priviliges and create views for direct access.
  Example: Personal accounts that access data thru SQL*Developer Web or SQL*Developer client or SQLcl.

*** AUTOREST ***

A very easy but not the most secure way to enable json queries on tables and views is using AutoRest.
Below is two example scripts on how to enable json query from 3rd Party like node,python,LiveCode,VisualBasic or whatever that supports JSON

If you want to enable AutoRest for F1_ACCESS schema then run and have a look at
F1_ACCESS_AUTOREST_ENABLE.sql
To disable AUTOREST for views in F1_ACCESS schema use the script
F1_ACCESS_AUTOREST_DISABLE.sql

In ./python/AutoRest there is an Python3 based example on how to make a call to ORDS Autorest published view
