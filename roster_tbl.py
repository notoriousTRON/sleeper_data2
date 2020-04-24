# coding: utf-8

#boiler plate & imports
import os
os.chdir('P:\Projects\Sleeper_data\modules')
import requests
import pandas as pd
import psycopg2 as ps
from pandas.io.json import json_normalize
import open_connection
import references

def drop_table(tbl_name):
    db = open_connection.open_connection()
    cursor = db.cursor()
    drop = "DROP TABLE IF EXISTS "+tbl_name
    cursor.execute(drop)
    db.commit()
    cursor.close()
    db.close()
    return

def refresh_roster_data(User_ID,roster_id,Player_id):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = "INSERT INTO rosters_tbl(User_ID,roster_id,Player_id) VALUES (%s, %s, %s)"
    cursor.execute(insert_query, (User_ID,roster_id,Player_id))
    db.commit()
    cursor.close()
    db.close()
    return


#enter sleeper league ID here
l_id = references.league_id()

rost = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/rosters")
rosters_json = rost.json()
#print(rosters_json)
roster_data = pd.DataFrame(rosters_json)

# #### #leauge_data = pd.read_json(leauge_data_json)
# roster_data = pd.DataFrame(rosters_json)
# #pd.read_json(_, orient='split')
# print(roster_data)
drop_table("rosters_tbl")
roster_create = """
CREATE TABLE rosters_tbl
    (
    User_Id character(255),
    roster_id character(2),
    Player_id character(255),

    primary key(Player_id)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(roster_create)
db.commit()
cursor.close()
db.close()

#roster_tbl = pd.DataFrame(columns=['User_ID', 'Player_id'])
#DataFrameName.insert(loc, column, value, allow_duplicates = False)
for i in range(0,len(rosters_json)):
    User_ID = rosters_json[i]['owner_id']
    roster_id = rosters_json[i]['roster_id']
    for j in rosters_json[i]['players']:
        Player_id = j
        refresh_roster_data(User_ID,roster_id,Player_id)
