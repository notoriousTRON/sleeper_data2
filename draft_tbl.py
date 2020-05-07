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

def add_draft_data(draft_player_key,draft_year,draft_type,round,pick_no,overall_pick_no,user_id,roster_id,player_id):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO 
                            draft_tbl(draft_player_key,draft_year,draft_type,round,pick_no,overall_pick_no,user_id,roster_id,player_id) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    cursor.execute(insert_query, (draft_player_key,draft_year,draft_type,round,pick_no,overall_pick_no,user_id,roster_id,player_id))
    db.commit()
    cursor.close()
    db.close()
    return

l_id = references.league_id()

#only use the next block if you plan to reset the entire table
'''
drop_table("draft_tbl")
draft_create = """
    CREATE TABLE draft_tbl
    (
    draft_player_key character(255),
    draft_year character(255),
    draft_type character(255),
    round character(255),
    pick_no character(255),
    overall_pick_no character(255),
    user_id character(255),
    roster_id character(255),
    player_id character(255),
    
    primary key(draft_player_key)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(draft_create)
db.commit()
cursor.close()
db.close()
'''
def process_it(year):
    #first we need to get the draft id
    w_draft = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/drafts/")
    w_draft_json = w_draft.json()
    '''
    #startup draft [1]
    draft_id = w_draft_json[1]['draft_id']
    draft_type = "startup"
    '''
    #rookie draft [0]
    draft_id = w_draft_json[0]['draft_id']
    draft_type = "rookie"
    
    #then we pull in that specific draft
    draft = requests.get("https://api.sleeper.app/v1/draft/"+draft_id+"/picks/")
    draft_json = draft.json()
    
    for pk in draft_json:
        draft_year = str(year)
        round = pk['round']
        pick_no = pk['draft_slot'],
        overall_pick_no = pk['pick_no']
        user_id = pk['picked_by']
        roster_id = pk['roster_id']
        player_id = pk['player_id']
        draft_player_key = draft_id + "_" + player_id
        
        add_draft_data(draft_player_key,draft_year,draft_type,round,pick_no,overall_pick_no,user_id,roster_id,player_id)