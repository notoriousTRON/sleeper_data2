# coding: utf-8
​
#boiler plate & imports
import requests
import pandas as pd
import psycopg2 as ps
​
def open_connection():
    db = ps.connect(database="dynasty", user="postgres", password="cotton2", host="127.0.0.1",port="5432")
    return db
​
def drop_table(tbl_name):
    db = open_connection()
    cursor = db.cursor()
    drop = "DROP TABLE IF EXISTS "+tbl_name
    cursor.execute(drop)
    db.commit()
    cursor.close()
    db.close()
    return
​
def refresh_roster_data(User_ID,Player_id):
    db = open_connection()
    cursor = db.cursor()
    insert_query = "INSERT INTO rosters_tbl(User_ID, Player_id) VALUES (%s, %s)"
    cursor.execute(insert_query, (User_ID, Player_id))
    db.commit()
    cursor.close()
    db.close()
    return
​
​
#enter sleeper league ID here
l_id = "470255783251013632"
​
league = requests.get("https://api.sleeper.app/v1/league/"+l_id)
leauge_data_json = league.json()
#print(leauge_data_json)
#leauge_data = pd.DataFrame(leauge_data_json)
​
rost = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/rosters")
rosters_json = rost.json()
#print(rosters_json)
roster_data = pd.DataFrame(rosters_json)
​
usrs = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/users")
usrs_json = usrs.json()
users_data = pd.DataFrame(usrs_json)
roster_data.head()
​
# #### #leauge_data = pd.read_json(leauge_data_json)
# roster_data = pd.DataFrame(rosters_json)
# #pd.read_json(_, orient='split')
# print(roster_data)
drop_table("rosters_tbl")
roster_create = """
CREATE TABLE rosters_tbl
    (
    User_Id character(255),
    Player_id character(255),
​
    primary key(Player_id)
    )
    """
db = open_connection()
cursor = db.cursor()
cursor.execute(roster_create)
db.commit()
cursor.close()
db.close()
​
#roster_tbl = pd.DataFrame(columns=['User_ID', 'Player_id'])
#DataFrameName.insert(loc, column, value, allow_duplicates = False)
for i in range(0,len(rosters_json)):
    User_ID = rosters_json[i]['owner_id']
    for j in rosters_json[i]['players']:
        Player_id = j
        refresh_roster_data(User_ID,Player_id)
​
​
