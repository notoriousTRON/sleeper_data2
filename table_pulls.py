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
    insert_query = """INSERT INTO sleeper_raw.players_tbl(player_id,position,depth_chart_position,fantasy_positions,
                                                first_name,last_name,full_name,years_exp,status,birth_date,
                                                college,height,weight,age) 
                    VALUES (%s, %s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s, %s)
                    ON CONFLICT (player_id) 
                    DO UPDATE SET 
                        position=players_tbl.position,
                        depth_chart_position=players_tbl.depth_chart_position,
                        fantasy_positions=players_tbl.fantasy_positions,
                        first_name=players_tbl.first_name,
                        last_name=players_tbl.last_name,
                        full_name=players_tbl.full_name,
                        years_exp=players_tbl.years_exp,
                        status=players_tbl.status,
                        birth_date=players_tbl.birth_date,
                        college=players_tbl.college,
                        height=players_tbl.height,
                        weight=players_tbl.weight,
                        age=players_tbl.age
                    """
    cursor.execute(insert_query, (player_id,position,depth_chart_position,fantasy_positions,first_name,last_name,full_name,years_exp,status,birth_date,college,height,weight,age))
    db.commit()
    cursor.close()
    db.close()
    return

def pull_players(year):
    #enter sleeper league ID here
    #l_id = ref.league_id()
    l_id = references.league_id(year)

    players = requests.get("https://api.sleeper.app/v1/players/nfl")
    players_json = players.json()
    players_data = pd.DataFrame(players_json)

    # #### #leauge_data = pd.read_json(leauge_data_json)
    # roster_data = pd.DataFrame(rosters_json)
    # #pd.read_json(_, orient='split')
    # print(roster_data)
    truncate_table("sleeper_raw.players_tbl")
    '''
    drop_table("sleeper_raw.players_tbl")
    players_create = """
        CREATE TABLE sleeper_raw.players_tbl
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
		
def pull_roster_data(year):
	l_id = references.league_id(year)
	rost = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/rosters")
	rosters_json = rost.json()
	#print(rosters_json)
	roster_data = pd.DataFrame(rosters_json)

	# #### #leauge_data = pd.read_json(leauge_data_json)
	# roster_data = pd.DataFrame(rosters_json)
	# #pd.read_json(_, orient='split')
	# print(roster_data)
	drop_table("sleeper_raw.rosters_tbl")
	roster_create = """
	CREATE TABLE sleeper_raw.rosters_tbl
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

	for i in range(0,len(rosters_json)):
		User_ID = rosters_json[i]['owner_id']
		roster_id = rosters_json[i]['roster_id']
		for j in rosters_json[i]['players']:
			Player_id = j
			refresh_roster_data(User_ID,roster_id,Player_id)

def add_transaction_data(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
                         year,week,status_date,create_date,
                         waiver_bid_ammount,transaction_status,
                         roster_id,player_id,add_drop,asset_type,faab_ammount):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO 
                            sleeper_raw.transactions_tbl(tn_rost_plyr_id,transaction_id,creater_user_id,transaction_type,
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

#l_id = "470255783251013632"
#year = 2019
#week = 1

#only use the next block if you plan to reset the entire table
'''
drop_table("sleeper_raw.transactions_tbl")
transaction_create = """
    CREATE TABLE sleeper_raw.transactions_tbl
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
def pull_transactions(year,week):
#if len(str(week))<2:
#    wk = '0'+str(week)
#else:
#    wk = str(week)
    l_id = references.league_id(year)
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
		
def add_draft_data(draft_player_key,draft_year,draft_type,round,pick_no,overall_pick_no,user_id,roster_id,player_id):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO 
                            sleeper_raw.draft_tbl(draft_player_key,draft_year,draft_type,round,pick_no,
                                            overall_pick_no,user_id,roster_id,player_id) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                            ON CONFLICT (draft_player_key) 
                            DO NOTHING
                                """
    cursor.execute(insert_query, (draft_player_key,draft_year,draft_type,round,pick_no,overall_pick_no,user_id,roster_id,player_id))
    db.commit()
    cursor.close()
    db.close()
    return

#only use the next block if you plan to reset the entire table
'''
drop_table("sleeper_raw.draft_tbl")
draft_create = """
    CREATE TABLE sleeper_raw.draft_tbl
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
def pull_draft_data(year):
    l_id = references.league_id(year)
    
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
		
def add_matchup_data(matchup_rost_key,year,week,matchup_id,roster_id,players,starters,points):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO sleeper_raw.matchups_tbl(matchup_rost_key,year,week,matchup_id,
                                                roster_id,players,starters,points) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                            ON CONFLICT (matchup_rost_key)
                            DO UPDATE SET
                                points = Excluded.points,
                                starters = Excluded.starters,
                                players = Excluded.players
                            """
    cursor.execute(insert_query, (matchup_rost_key,year,week,matchup_id,roster_id,players,starters,points))
    db.commit()
    cursor.close()
    db.close()
    return

def add_matchup_player_data(matchup_rost_plr_key,matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter,player_points):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO sleeper_raw.matchups_plr_tbl(matchup_rost_plr_key, matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter,player_points) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                            ON CONFLICT (matchup_rost_plr_key) 
                            DO UPDATE SET
                                player_points = Excluded.player_points,
                                is_starter = Excluded.is_starter,
                                roster_id = Excluded.roster_id
                            """
    cursor.execute(insert_query, (matchup_rost_plr_key,matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter,player_points))
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
def pull_matchups(year,week):
    l_id = references.league_id(year)
    
    matchup = requests.get("https://api.sleeper.app/v1/league/"+l_id+"/matchups/"+str(week))
    matchup_json = matchup.json()
    matchup_data = pd.DataFrame(matchup_json)
    
    for i in range(0,len(matchup_json)):
        roster_id = matchup_json[i]['roster_id']
        matchup_id = matchup_json[i]['matchup_id']
        players = matchup_json[i]['players']
        starters = matchup_json[i]['starters']
        points = matchup_json[i]['points']
        player_points_dict = matchup_json[i]['players_points']
        
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
        add_matchup_data(matchup_rost_key,year,week,matchup_id,roster_id,players,starters,points)
        for j in matchup_json[i]['players']:
            Player_id = j
            player_points = player_points_dict[Player_id]
            is_starter = j in matchup_json[i]['starters']
            matchup_rost_plr_key = str(matchup_rost_key) + '_' +str(Player_id)
            add_matchup_player_data(matchup_rost_plr_key, matchup_rost_key,year,week,matchup_id,roster_id,Player_id,is_starter,player_points)