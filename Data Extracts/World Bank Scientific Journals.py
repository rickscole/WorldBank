## import libraries
import wbgapi as wb
import pyodbc
import pandas as pd
from pandas import DataFrame


## create connection
connection = ## contact for connection
cursor = connection.cursor()


## create lists
ScienceJournal = []
Economy = []
Time = []


## get data from World Bank
for row in wb.data.fetch('IP.JRN.ARTC.SC'):
    ScienceJournal.append(str(row['value']))
    Economy.append(str(row['economy']))
    Time.append(str(row['time']))


## write data to db
df = DataFrame({'ScienceJournal': ScienceJournal, 'Economy' : Economy, 'Time' : Time })
for index, row in df.iterrows():
    print(row)
    cursor.execute("INSERT INTO [Grant].[STG].[TBL_ScienceJournal]([ScienceJournal],[economy],[time]) values (?,?,?)"
                   ,row['ScienceJournal'],row['Economy'],row['Time'])
    connection.commit()


## transfer from stg to actual
sql = "{call [Grant].[WB].[SP_InsertInto_ScienceJournal]}"
cursor.execute(sql)
connection.commit()
  

## close connection
cursor.close();
connection.close();
