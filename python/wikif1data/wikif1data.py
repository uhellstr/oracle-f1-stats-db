#!/usr/bin/env python

r"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
# _____ _   ____    _  _____  _    
#|  ___/ | |  _ \  / \|_   _|/ \   
#| |_  | | | | | |/ _ \ | | / _ \  Additional wiki url of images of F1 drivers
#|  _| | | | |_| / ___ \| |/ ___ \ 
#|_|   |_| |____/_/   \_\_/_/   \_\
#
# The "r" on row 4 is there to make this comment
# in raw format so that pylint not complains 
# about strange characters within this comment :-)
# Do not remove the leading "r"!!
#
#               Generate csv file with url for image of f1 drivers
#               * Requires Oracle 12c instant client or higher
#               * Python 3.x or higher with cx_Oracle module installed
#               By Ulf Hellstrom,oraminute@gmail.com , EpicoTech 2019
#
#
#               Requires cx_Oracle installed
#               Requires pip install bs4
#               Requires pip install requests
#            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""

from bs4 import BeautifulSoup
from datetime import datetime
import requests
import subprocess
import sys
import getpass
import getopt
import base64
import os
import shutil
import time
import filetype

# Import oraclepackage module
workingdir = os.getcwd()
orapackdir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '')) +"/"
sys.path.append(orapackdir)
from oraclepackage import oramodule

"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Logger()
    Logfunction that logs all output to screen to logfile.
    Author: Ulf Hellstrom, oraminute@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
class Logger(object):
    def __init__(self):
        logfile = datetime.now().strftime('wikif1_%Y_%m_%d_%H_%M.log')
        self.terminal = sys.stdout
        self.log = open(logfile, "a")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)  

    def flush(self):
        #this flush method is needed for python 3 compatibility.
        #this handles the flush command by doing nothing.
        #you might want to specify some extra behavior here.
        pass


"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    check_if_object_exists()
    Check if object exists or not
    Author: Ulf Hellstrom, oraminute@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
def check_if_object_exists(connection):

    retval = False

    sql_stmt = """
select count(*) as antal
from dba_objects
where owner  = 'F1_DATA'
  and  object_name = 'V_F1_DRIVERS'
  and object_type = 'VIEW'
"""
    c1 = connection.cursor()
    c1.execute(sql_stmt)
    # convert tuple to integer
    value = int(c1.fetchone()[0])
    if value > 0:
        retval = True
    c1.close()

    return retval

"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Author: Ulf Hellstrom, oraminute@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
def get_f1_drivers(connection):

    driver_list = []
    sql_stmt =  """
select
    driverid,
    info
from
f1_data.v_f1_drivers
where info is not null
"""
    c1 = connection.cursor()
    c1.execute(sql_stmt)
    res = c1.fetchall()
    for row in res:
        driverid = row[0]
        info = row[1]
        val = str(driverid)+","+str(info)
        driver_list.append(val)

    return driver_list

"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Author: Ulf Hellstrom, oraminute@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
def get_image_from_f1_wiki(driverid,imageurl):

    reload = True
    if imageurl != "null":

        imgextension = ""
        print("Downloading driver image from wikipedia.")

        if imageurl[-4:].lower() == "jpeg":
            imgextension = ".jpg"        
        if imageurl[-4:].lower() == ".jpg":
            imgextension = ".jpg"
        if imageurl[-4:].lower() == ".gif":
            imgextension = ".gif"    
        if imageurl[-4:].lower() == ".png":
            imgextension = ".png"
        
        print(imageurl)
        imagename = workingdir+"/images/"+driverid+imgextension
        print(imagename)
        resp = requests.get(imageurl, stream=True)
        local_file = open(imagename, 'wb')
        resp.raw.decode_content = True
        shutil.copyfileobj(resp.raw, local_file)      
        del resp
        
        if filetype.is_image(imagename):
            print(f"{imagename} is a valid image...")
        else:
            print(f"{imagename} is NOT a valid image...fixing it")
            os.remove(imagename)
            shutil.copy(workingdir+"/"+"avatar.png",workingdir+"/images/"+driverid+".png")
    else:
        shutil.copy(workingdir+"/"+"avatar.png",workingdir+"/images/"+driverid+".png")
 
"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Author: Ulf Hellstrom, oraminute@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
def get_image_urls(driver_list):

    image_list = []
    for val in driver_list:
        imageurl="null"
        driverid = oramodule.split_list(val,',',0)
        print("Fetching wiki data for: "+driverid)
        wikiurl  = oramodule.split_list(val,',',1)
        print(wikiurl)
        r = requests.get(wikiurl)
        soup = BeautifulSoup(r.content,'html.parser')
        covers = soup.select('table.infobox a.image img[src]')
        for cover in covers:
            imageurl = "https:"+ cover['src']
            break
        print("Original image: " + imageurl)
        if imageurl == "null":
            val = str(driverid)+"|"+"null"+"|"+"null"
        else:           
            val = str(driverid)+"|"+str(wikiurl)+"|"+str(imageurl)    
        image_list.append(val)
        get_image_from_f1_wiki(driverid,imageurl)

    return image_list  

"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Author: Ulf Hellstrom, oraminute@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
def insert_image_data(connection,imageinfo):

    imagedir = workingdir+"/images/"
    imagename=""
    driverid = oramodule.split_list(imageinfo,'|',0)
    checkimage = oramodule.split_list(imageinfo,'|',2)
    # Find a file starting with driverid in the image catalog    
    for i in os.listdir(imagedir):
        if os.path.isfile(os.path.join(imagedir,i)) and i.startswith(driverid):
            imagename = imagedir+i
            break
    # Generate extension for image to store together with image
    imageext = imagename[-3:].lower()
    print("imagename is: "+imagename)
    print("image extension is: "+imageext)
    print("Insert into F1_DATA: "+driverid+","+imagename)
    with open(imagename, 'rb') as f:
        imgdata = f.read()
    with open(imagename, "rb") as img_file:
        base64img = base64.b64encode(img_file.read())    
    cursor = connection.cursor()
    cursor.execute("""insert into f1_data.F1_DATA_DRIVER_IMAGES (driverid,image,image_base64,image_type) values (:driverid, :blobdata,:base64data,:type)""",
                   driverid=driverid, blobdata=imgdata,base64data=base64img,type=imageext)
    connection.commit()    
    cursor.close()

"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Main starts here. Eg this is where we run the code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
def main():
    outputfile = workingdir+"/wikidata.csv"
    # Give the hostname or scan-listener
    tns = input("Pleas give hostname or scan-listener name: ")
    # Get the TNS name
    dbname = input("Give the TNS-string for DB to connect to: ")
    # Get oracle user name 
    username = input("Oracle Username: ")
    # Get password and encrypt it
    pwd = getpass.getpass(prompt="Please give "+username +" password: ")
    pwd =  base64.urlsafe_b64encode(pwd.encode('UTF-8)')).decode('ascii')
    os.environ["DB_INFO"] = pwd
    tnsport = input("Give Listener port default (1521): ")
    # Enable logging output to log file
    sys.stdout = Logger()
    if username.lower() == "sys":
        print("Trying to connect to "+username+"/xxxxx@"+dbname+" as sysdba")
    else:     
        print("Trying to connect to "+username+"/xxxxx@"+dbname)
    connection = oramodule.get_oracle_connection(dbname,tns,tnsport,username,base64.urlsafe_b64decode(os.environ["DB_INFO"].encode('UTF-8')).decode('ascii'))
    print("Connection successfull")
    print("Checking for F1_DATA.V_F1_DRIVERS")
    if check_if_object_exists(connection) is True:
        print("F1_DATA.V_F1_DRIVERS exists")
    else:
        print("Missing F1_DATA.V_F1_DRIVERS please install schema...")
    drivers = get_f1_drivers(connection)
    wikilist = get_image_urls(drivers)
    csvfile = open(outputfile,'w')
    for val in wikilist:
        insert_image_data(connection,val)
        csvfile.write(val)
        csvfile.write('\n')
    csvfile.close()
    connection.close()

if __name__ == "__main__":
    main()