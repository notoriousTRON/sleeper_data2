# coding: utf-8

#boiler plate & imports
import os
os.chdir(r'C:\projects\sleeper_data\modules')
import requests
import pandas as pd
import psycopg2 as ps
from pandas.io.json import json_normalize
import open_connection
import references
from datetime import datetime

def drop_table(tbl_name):
    db = open_connection.open_connection()
    cursor = db.cursor()
    drop = "DROP TABLE IF EXISTS "+tbl_name
    cursor.execute(drop)
    db.commit()
    cursor.close()
    db.close()
    return

def truncate_table(tbl_name):
    db = open_connection.open_connection()
    cursor = db.cursor()
    drop = "TRUNCATE "+tbl_name
    cursor.execute(drop)
    db.commit()
    cursor.close()
    db.close()
    return

def refresh_player_data(player_id,position,depth_chart_position,fantasy_positions,first_name,last_name,full_name,years_exp,status,birth_date,college,height,weight,age):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = "INSERT INTO players_tbl(player_id,position,depth_chart_position,fantasy_positions,first_name,last_name,full_name,years_exp,status,birth_date,college,height,weight,age) VALUES (%s, %s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s, %s)"
    cursor.execute(insert_query, (player_id,position,depth_chart_position,fantasy_positions,first_name,last_name,full_name,years_exp,status,birth_date,college,height,weight,age))
    db.commit()
    cursor.close()
    db.close()
    return


#enter sleeper league ID here
#l_id = ref.league_id()
l_id = references.league_id()

players = requests.get("https://api.sleeper.app/v1/players/nfl")
players_json = players.json()
players_data = pd.DataFrame(players_json)

# #### #leauge_data = pd.read_json(leauge_data_json)
# roster_data = pd.DataFrame(rosters_json)
# #pd.read_json(_, orient='split')
# print(roster_data)
truncate_table("players_tbl")
'''
drop_table("players_tbl")
players_create = """
    CREATE TABLE players_tbl
    (
    player_id character(255),
    position character(10),
    depth_chart_position character(100),
    fantasy_positions character(100),
    first_name character(50),
    last_name character(50),
    full_name character(50),
    years_exp character(2),
    status character(50),
    birth_date character(10),
    college character(50),
    height character(10),
    weight character(10),
    age character(3),

    primary key(player_id)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(players_create)
db.commit()
cursor.close()
db.close()
'''
for i in players_json.keys():
    player_id = i
    try:
        position = players_json[i]['position']
    except:
        position = None
    try:
        depth_chart_position = players_json[i]['depth_chart_position']
    except:
        depth_chart_position = None
    try:
        fantasy_positions = players_json[i]['fantasy_positions']
    except:
        fantasy_positions = None
    try:
        first_name = players_json[i]['first_name']
    except:
        first_name = None
    try:
        last_name = players_json[i]['last_name']
    except:
        last_name = None
    try:
        full_name = players_json[i]['full_name']
    except:
        full_name = None
    try:
        years_exp = players_json[i]['years_exp']
    except:
        years_exp = None
    try:
        status = players_json[i]['status']
    except:
        status = None
    try:
        birth_date = players_json[i]['birth_date']
    except:
        birth_date = None
    try:
        college = players_json[i]['college']
    except:
        college = None
    try:
        height = players_json[i]['height']
    except:
        height = None
    try:
        weight = players_json[i]['weight']
    except:
        weight = None
    try:
        age = players_json[i]['age']
    except:
        age = None
    refresh_player_data(player_id,position,depth_chart_position,fantasy_positions,first_name,last_name,full_name,years_exp,status,birth_date,college,height,weight,age)