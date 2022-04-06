

## import libraries
import wbgapi as wb
import pyodbc
import pandas as pd
from pandas import DataFrame


## create connection
connection = ## contact for connection
cursor = connection.cursor()


## create lists
Population = []
Economy = []
Time = []


## get data from World Bank
for row in wb.data.fetch('SP.POP.TOTL'):
    Population.append(str(row['value']))
    Economy.append(str(row['economy']))
    Time.append(str(row['time']))


## write data to db
df = DataFrame({'Population': Population, 'Economy' : Economy, 'Time' : Time })
for index, row in df.iterrows():
    cursor.execute("INSERT INTO [Grant].[STG].[TBL_Population]([Population],[economy],[time]) values (?,?,?)"
                   ,row['Population'],row['Economy'],row['Time'])
    connection.commit()


## transfer from stg to actual
sql = "{call [Grant].[WB].[SP_InsertInto_Population]}"
cursor.execute(sql)
connection.commit()


## close connection
cursor.close();
connection.close();