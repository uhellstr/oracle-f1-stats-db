\ \      / /_ _| |/ /_ _| |  ___/ | |  _ \|  _ \|_ _\ \   / / ____|  _ \ 
 \ \ /\ / / | || ' / | |  | |_  | | | | | | |_) || | \ \ / /|  _| | |_) |
  \ V  V /  | || . \ | |  |  _| | | | |_| |  _ < | |  \ V / | |___|  _ < 
   \_/\_/  |___|_|\_\___| |_|   |_| |____/|_| \_\___|  \_/  |_____|_| \_\
                                                                         
 ___ __  __    _    ____ _____ ____  
|_ _|  \/  |  / \  / ___| ____/ ___| 
 | || |\/| | / _ \| |  _|  _| \___ \ 
 | || |  | |/ ___ \ |_| | |___ ___) |
|___|_|  |_/_/   \_\____|_____|____/ 

This catalog includes a extra tool written in python 3
and some python scripts and a Jupyter Notebook to demonstrate how to fetch
data from a Oracle Database over ORDS to python.

The utility will scrape wikipedia pages for images (where there exists one) for
the F1 drivers and track images from wikipedia pages as downloaded from ergast.com

To use this utiltiy you first need to have installed the f1_data schema and
downloaded the data using the provided pl/sql package F1_INIT_PKG.LOAD_JSON

When everyting is in place make sure you have installed python 3 and
cx_Oracle and a supported Oracle client (12c or higher ) and then run
the wikif1data.py in the wikif1data catalog to download images and insert them
into the database. They can after downloaded be used by quering the table
f1_data_driver_images table in your own application. You also will get
the images downloaded as files in wikif1data/images catalog.

See the source file for other python libraries you might need to install with pip.

Example how to run:

python3 wikif1data.py
Pleas give hostname or scan-listener name: localhost
Give the TNS-string for DB to connect to: PDBUTV1
Oracle Username: sys
Please give sys password:
Give Listener port default (1521): 1522

