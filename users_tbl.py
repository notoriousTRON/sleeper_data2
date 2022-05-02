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

#year = '2022'

def drop_table(tbl_name):
    db = open_connection.open_connection()
    cursor = db.cursor()
    drop = "DROP TABLE IF EXISTS "+tbl_name
    cursor.execute(drop)
    db.commit()
    cursor.close()
    db.close()
    return

def refresh_user_data(display_name,league_id,user_id,team_name):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO sleeper_raw.users_tbl(display_name, league_id, user_id, team_name) 
                            VALUES (%s, %s, %s, %s)
                            ON CONFLICT (user_id) DO UPDATE SET display_name=users_tbl.display_name, team_name=users_tbl.team_name"""
    cursor.execute(insert_query, (display_name, league_id, user_id, team_name))
    db.commit()
    cursor.close()
    db.close()
    return


#roster_tbl = pd.DataFrame(columns=['User_ID', 'Player_id'])
#DataFrameName.insert(loc, column, value, allow_duplicates = False)
def pull_user_data(year):
	l_id = references.league_id(year)
	usrs = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/users")
	usrs_json = usrs.json()
	users_data = pd.DataFrame(usrs_json)

	# #### #leauge_data = pd.read_json(leauge_data_json)
	# roster_data = pd.DataFrame(rosters_json)
	# #pd.read_json(_, orient='split')
	# print(roster_data)
	drop_table("sleeper_raw.users_tbl")
	user_create = """
	CREATE TABLE sleeper_raw.users_tbl
		(
		display_name character(255),
		league_id character(255),
		user_id character(255),
		team_name character(255),

		primary key(user_id)
		)
		"""
	db = open_connection.open_connection()
	cursor = db.cursor()
	cursor.execute(user_create)
	db.commit()
	cursor.close()
	db.close()

	for i in range(0,len(usrs_json)):
		display_name = usrs_json[i]['display_name']
		league_id = usrs_json[i]['league_id']
		user_id = usrs_json[i]['user_id']
		try:
			team_name = usrs_json[i]['metadata']['team_name']
		except:
			team_name = None
		refresh_user_data(display_name,league_id,user_id,team_name)
