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

def add_matchup_data(matchup_rost_key,year,week,matchup_id,roster_id,players,starters,points,matchup_start_date):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO sleeper_raw.matchups_tbl(matchup_rost_key,year,week,matchup_id,
                                                roster_id,players,starters,points,matchup_start_date) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                            ON CONFLICT (matchup_rost_key)
                            DO UPDATE SET
                                points = Excluded.points,
                                matchup_start_date = Excluded.matchup_start_date,
                                starters = Excluded.starters,
                                players = Excluded.players
                            """
    cursor.execute(insert_query, (matchup_rost_key,year,week,matchup_id,roster_id,players,starters,points,matchup_start_date))
    db.commit()
    cursor.close()
    db.close()
    return

def add_matchup_player_data(matchup_rost_plr_key,matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO sleeper_raw.matchups_plr_tbl(matchup_rost_plr_key, matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                            ON CONFLICT (matchup_rost_plr_key) 
                            DO NOTHING
                            """
    cursor.execute(insert_query, (matchup_rost_plr_key,matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter))
    db.commit()
    cursor.close()
    db.close()
    return

'''
drop_table("sleeper_raw.matchups_tbl")
drop_table("sleeper_raw.matchups_plr_tbl")
matchup_create = """
    CREATE TABLE sleeper_raw.matchups_tbl
    (
    matchup_rost_key character(20),
    year character(4),
    week character(2),
    matchup_id character(2),
    roster_id character(2),
    players character(255) ARRAY,
    starters character(255) ARRAY,
    points float(1),
    matchup_start_date date,
    primary key(matchup_rost_key)
    )
    """
matchup_plr_create = """
    CREATE TABLE sleeper_raw.matchups_plr_tbl
    (
    matchup_rost_plr_key character(30),
    matchup_rost_key character(20),
    year character(4),
    week character(2),
    matchup_id character(2),
    roster_id character(2),
    Player_id character(255),
    is_starter BOOLEAN,
    
    primary key(matchup_rost_plr_key)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(matchup_create)
cursor.execute(matchup_plr_create)
db.commit()
cursor.close()
db.close()
'''
def pull_matchups(year,week,tnf_date):
    l_id = references.league_id(year)
    
    matchup = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/matchups/"+str(week))
    matchup_json = matchup.json()
    matchup_data = pd.DataFrame(matchup_json)
    matchup_start_date = tnf_date
    
    for i in range(0,len(matchup_json)):
        roster_id = matchup_json[i]['roster_id']
        matchup_id = matchup_json[i]['matchup_id']
        players = matchup_json[i]['players']
        starters = matchup_json[i]['starters']
        points = matchup_json[i]['points']
        if len(str(week))<2:
            wk = '0'+str(week)
        else:
            wk = str(week)
        if len(str(matchup_id))<2:
            m_id = '0'+str(matchup_id)
        else:
            m_id = str(matchup_id)
        if len(str(roster_id))<2:
            r_id = '0'+str(roster_id)
        else:
            r_id = str(roster_id)
        matchup_rost_key = str(year)+wk+m_id+r_id
        add_matchup_data(matchup_rost_key,year,week,matchup_id,roster_id,players,starters,points,tnf_date)
        for j in matchup_json[i]['players']:
            Player_id = j
            is_starter = j in matchup_json[i]['starters']
            matchup_rost_plr_key = str(matchup_rost_key) + '_' +str(Player_id)
            add_matchup_player_data(matchup_rost_plr_key, matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter)