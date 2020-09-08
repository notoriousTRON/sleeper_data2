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

def add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                         year,week,status_date,create_date,
                         waiver_bid_ammount,transaction_status,
                         roster_id,player_id,add_drop,asset_type,faab_ammount):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO 
                            transactions_tbl(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                            year,week,status_date,create_date,
                                            waiver_bid_ammount,transaction_status,
                                            roster_id,player_id,add_drop,asset_type,faab_ammount) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                            ON CONFLICT (tn_rost_plyr_id) DO NOTHING
                            ;"""
    cursor.execute(insert_query, (tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                    year,week,status_date,create_date,
                                    waiver_bid_ammount,transaction_status,
                                    roster_id,player_id,add_drop,asset_type,faab_ammount))
    db.commit()
    cursor.close()
    db.close()
    return

l_id = references.league_id()
#l_id = "470255783251013632"
#year = 2019
#week = 1

#only use the next block if you plan to reset the entire table
'''
drop_table("transactions_tbl")
transaction_create = """
    CREATE TABLE transactions_tbl
    (
    tn_rost_plyr_id character(255),
    transaction_id character(255),
    creater_user_id character(255),
    transaction_type character(255),
    year character(4),
    week character(4),
    status_date timestamp,
    create_date timestamp,
    waiver_bid_ammount character(4),
    transaction_status character(20),
    roster_id character(255),
    player_id character(255),
    add_drop character(10),
    asset_type character(10),
    faab_ammount character(3),
    
    primary key(tn_rost_plyr_id)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(transaction_create)
db.commit()
cursor.close()
db.close()
'''
def process_it(year,week):
#if len(str(week))<2:
#    wk = '0'+str(week)
#else:
#    wk = str(week)
    wk = str(week)
    w_transactions = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/transactions/"+str(week))
    w_transactions_json = w_transactions.json()
    for i in range(0,len(w_transactions_json)):
        status_date = datetime.fromtimestamp(w_transactions_json[i]['status_updated']/1000)
        create_date = datetime.fromtimestamp(w_transactions_json[i]['created']/1000)
        transaction_id = w_transactions_json[i]['transaction_id']
        creater_user_id = w_transactions_json[i]['creator']
        transaction_type = w_transactions_json[i]['type']
        try:
            waiver_bid_ammount = w_transactions_json[i]['settings']['waiver_bid']
        except:
            waiver_bid_ammount = None
        transaction_status = w_transactions_json[i]['status']
        if w_transactions_json[i]['adds'] != None:
            for a in w_transactions_json[i]['adds']:
                faab_ammount = None
                player_id = a
                roster_id = w_transactions_json[i]['adds'][a]
                tn_rost_plyr_id = str(transaction_id)+str(roster_id)+str(player_id)
                add_drop = 'add'
                asset_type = 'player'

                add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                     year,wk,status_date,create_date,
                                     waiver_bid_ammount,transaction_status,
                                     roster_id,player_id,add_drop,asset_type,faab_ammount)
        if w_transactions_json[i]['drops'] != None:
            for d in w_transactions_json[i]['drops']:
                faab_ammount = None
                player_id = d
                roster_id = w_transactions_json[i]['drops'][d]
                tn_rost_plyr_id = str(transaction_id)+str(roster_id)+str(player_id)
                add_drop = 'drop'
                asset_type = 'player'

                add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                     year,wk,status_date,create_date,
                                     waiver_bid_ammount,transaction_status,
                                     roster_id,player_id,add_drop,asset_type,faab_ammount)
        if w_transactions_json[i]['draft_picks'] != None:
            for p in w_transactions_json[i]['draft_picks']:
                faab_ammount = None
                pick_yr = p['season']
                pick_rd = p['round']
                original_pk_owner = p['roster_id']
                player_id = str(original_pk_owner)+'pk'+'_'+str(pick_rd)+'_'+str(pick_yr)
                roster_id = p['owner_id']
                tn_rost_plyr_id = str(transaction_id)+str(roster_id)+str(player_id)
                asset_type = 'pick'
                add_drop = 'add'

                add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                     year,wk,status_date,create_date,
                                     waiver_bid_ammount,transaction_status,
                                     roster_id,player_id,add_drop,asset_type,faab_ammount)
                roster_id = p['previous_owner_id']
                tn_rost_plyr_id = str(transaction_id)+str(roster_id)+str(player_id)
                add_drop = 'drop'

                add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                     year,wk,status_date,create_date,
                                     waiver_bid_ammount,transaction_status,
                                     roster_id,player_id,add_drop,asset_type,faab_ammount)
        if w_transactions_json[i]['waiver_budget'] != None:
            for w in w_transactions_json[i]['waiver_budget']:
                waiver_ammount = w['amount']
                tn_rost_plyr_id = str(transaction_id)+str(roster_id)+'faab'
                player_id = str(year)+'_faab'
                asset_type = 'faab'
                add_drop = 'add'
                roster_id = w['sender']

                add_drop = 'drop'
                roster_id = w['receiver']

                add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                                     year,wk,status_date,create_date,
                                     waiver_bid_ammount,transaction_status,
                                     roster_id,player_id,add_drop,asset_type,faab_ammount)