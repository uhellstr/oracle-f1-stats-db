#!/usr/bin/env python

r"""
 _____ _
|  ___/ |
| |_  | |
|  _| | |
|_|   |_| official timing data for practice,qualification and races

This python script is a verificatoin test to use with f1_timingdata
It was written due to a problem to insert data into Oracle db
due to fastf1 suddenly changed the order of columns in the data
they download from formula 1

So to avoid getting problems in the future this code is written
to test a cvs file and re-arrange that file so it matches
the order of the columns the f1_timingdata python code uses.

This code is mainly part of the f1_timingdata code.
"""


def get_f1_header_columns(FILE_PATH):
    """Load csv file and get the headers from the header row"""
    with open(FILE_PATH, "r") as f:
        header = f.readline().strip()
        columns = header.split(",")
        return columns


def get_f1_data_lines(FILE_PATH):
    """Get the comma separated data"""
    with open(FILE_PATH, "r") as f:
        header = f.readline()
        lines = f.readlines()
        return lines


def get_f1_data_row_values(data_lines, headers):
    """get all the data with headers and values"""
    row_values = []
    for line in data_lines:
        if line.strip():  # check if line is not empty
            values = line.strip().split(",")
            for i in range(len(headers)):
                row_values.append(headers[i].lower())
                row_values.append(values[i])
    return row_values


def main(FILE_PATH):
    """
    Main method starts here.
    We load a Forumala timing csv file and re-arrange the headers
    and data in the order the database table layout is.

    This is just a verigfy/test code for the purpose when
    fastf1 changes it's download format and change order of columns
    so we do not have to re-arrange the data ourselves.
    """

    # Print the data record, by record
    header_columns = get_f1_header_columns(FILE_PATH)
    print(header_columns)
    data_lines = get_f1_data_lines(FILE_PATH)
    for i in range(len(data_lines)):
        row_values = get_f1_data_row_values([data_lines[i]], header_columns)
        sorted_row_values = []
        # Always sort the f1data data in the order the db table has the data.
        for j in [
            "year",
            "race",
            "racetype",
            "datapoint",
            "time",
            "drivernumber",
            "laptime",
            "lapnumber",
            "stint",
            "pitouttime",
            "pitintime",
            "sector1time",
            "sector2time",
            "sector3time",
            "sector1sessiontime",
            "sector2sessiontime",
            "sector3sessiontime",
            "speedi1",
            "speedi2",
            "speedfl",
            "speedst",
            "ispersonalbest",
            "compound",
            "tyrelife",
            "freshtyre",
            "lapstarttime",
            "team",
            "driver",
            "trackstatus",
            "isaccurate",
        ]:
            for k in range(len(row_values)):
                if row_values[k] == j:
                    sorted_row_values.append(row_values[k])
                    sorted_row_values.append(row_values[k + 1])
        for j in range(0, len(sorted_row_values), 2):
            print(sorted_row_values[j], ":", sorted_row_values[j + 1])
    """
    # The same data but as comma separated values without the headers
    header_columns = get_f1_header_columns(FILE_PATH)
    data_lines = get_f1_data_lines(FILE_PATH)
    for i in range(len(data_lines)):
        row_values = get_f1_data_row_values([data_lines[i]], header_columns)
        sorted_row_values = []
        # Always sort the data in same order as the table columes in the database.
        for j in [
            "year",
            "race",
            "racetype",
            "datapoint",
            "time",
            "drivernumber",
            "laptime",
            "lapnumber",
            "stint",
            "pitouttime",
            "pitintime",
            "sector1time",
            "sector2time",
            "sector3time",
            "sector1sessiontime",
            "sector2sessiontime",
            "sector3sessiontime",
            "speedi1",
            "speedi2",
            "speedfl",
            "speedst",
            "ispersonalbest",
            "compound",
            "tyrelife",
            "freshtyre",
            "lapstarttime",
            "team",
            "driver",
            "trackstatus",
            "isaccurate",
        ]:
            for k in range(len(row_values)):
                if row_values[k] == j:
                    sorted_row_values.append(row_values[k + 1])
        print(",".join(sorted_row_values))
    """
    
    # The same data but as comma separated values without the headers
    header_columns = get_f1_header_columns(FILE_PATH)
    data_lines = get_f1_data_lines(FILE_PATH)
    with open("ulftestar.csv", "w") as f:
        for i in range(len(data_lines)):
            row_values = get_f1_data_row_values([data_lines[i]], header_columns)
            sorted_row_values = []
            # Always sort the data in same order as the table columes in the database.
            for j in [
                "year",
                "race",
                "racetype",
                "datapoint",
                "time",
                "drivernumber",
                "laptime",
                "lapnumber",
                "stint",
                "pitouttime",
                "pitintime",
                "sector1time",
                "sector2time",
                "sector3time",
                "sector1sessiontime",
                "sector2sessiontime",
                "sector3sessiontime",
                "speedi1",
                "speedi2",
                "speedfl",
                "speedst",
                "ispersonalbest",
                "compound",
                "tyrelife",
                "freshtyre",
                "lapstarttime",
                "team",
                "driver",
                "trackstatus",
                "isaccurate",
            ]:
                for k in range(len(row_values)):
                    if row_values[k] == j:
                        sorted_row_values.append(row_values[k + 1])
            f.write(",".join(sorted_row_values) + "\n")

if __name__ == "__main__":
    FILE_PATH = "/home/uhellstr/orascript/f1_official/middlefile.csv"
    main(FILE_PATH)
