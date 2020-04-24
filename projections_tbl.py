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
#from references import *


def drop_table(tbl_name):
    db = open_connection.open_connection()
    cursor = db.cursor()
    drop = "DROP TABLE IF EXISTS "+tbl_name
    cursor.execute(drop)
    db.commit()
    cursor.close()
    db.close()
    return

def refresh_projections_data(player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                             fum,fum_lost,rec,rec_td,rec_2pt,
                             rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                             safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,
                             pts_half_ppr,any_pts):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO projections_tbl(player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                             fum,fum_lost,rec,rec_td,rec_2pt,
                             rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                             safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,
                             pts_half_ppr,any_pts) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
                                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
                                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                                    %s, %s, %s)"""
    cursor.execute(insert_query, (player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                                 fum,fum_lost,rec,rec_td,rec_2pt,
                                 rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                                 safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,
                                 pts_half_ppr,any_pts))
    db.commit()
    cursor.close()
    db.close()
    return

def def_scoring(def_td,ff,fum_rec,def_int,pts_allow,sack,safe,blk_kick,def_st_td,pts_half_ppr):
    d_td_pts = 6
    pts_allow_0_pts = 10
    pts_allow_1_6_pts = 7
    pts_allow_7_13_pts = 4
    pts_allow_14_20_pts = 1
    pts_allow_28_34_pts = -1
    pts_allow_35_pts = -4
    sacks_pts = 1
    def_int_pts = 2
    fr_pts = 2
    safety_pts = 2
    bk_pts = 2
    def_fantasy_pts = (d_td_pts*int(def_td or 0)+ 
                        pts_allow_0_pts*int(int(pts_allow or 0) == 0)+
                        pts_allow_1_6_pts*int(int(pts_allow or 0) >= 1 and int(pts_allow or 0) <= 6)+ 
                        pts_allow_7_13_pts*int(int(pts_allow or 0) >= 7 and int(pts_allow or 0) <= 13)+ 
                        pts_allow_14_20_pts*int(int(pts_allow or 0) >= 14 and int(pts_allow or 0) <= 20)+  
                        pts_allow_28_34_pts*int(int(pts_allow or 0) >= 28 and int(pts_allow or 0) <= 34)+ 
                        pts_allow_35_pts*int(int(pts_allow or 0) >= 35)+ 
                        sacks_pts*int(sack or 0)+ 
                        def_int_pts*int(def_int or 0)+ 
                        fr_pts*int(fum_rec or 0)+ 
                        safety_pts*int(safe or 0)+ 
                        bk_pts*int(blk_kick or 0))
    return def_fantasy_pts

def kick_scoring(fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29):
    fg_0_19_pts = 3
    fg_20_29_pts = 3
    fg_30_39_pts = 3
    fg_40_49_pts = 4
    fg_50_pts = 5
    xp_pts = 1
    xpm_pts = -1
    fgm_pts = -1
    fgm_0_19 = fgm - fgm_50p - fgm_40_49 - fgm_30_39 - fgm_20_29
    xp_missed = xpa - xpm
    fg_missed = fga - fgm
    kick_pts = (fg_0_19_pts * fgm_0_19 +
                fg_20_29_pts * fgm_20_29 +
                fg_30_39_pts * fgm_30_39 +
                fg_40_49_pts * fgm_40_49 +
                fg_50_pts * fgm_50p)
    return kick_pts

def pass_scoring(pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt):
    pass_yds_pts = 0.04
    pass_td_pts = 4
    pass_2pt_pts = 2
    pass_int_pts = -1
    pass_pts = (pass_yds_pts * int(pass_yd or 0) + 
                pass_td_pts * int(pass_td or 0) + 
                pass_2pt_pts * int(pass_2pt or 0) + 
                pass_int_pts * int(pass_int or 0))
    return pass_pts

def rush_scoring(rush_att,rush_yd,rush_td,rush_2pt, fum_lost):
    rush_yds_pts = 0.1
    rush_td_pts = 6
    rush_2pt_pts = 2
    rush_fum_pts = -2
    rush_pts = (rush_yds_pts * int(rush_yd or 0) + 
                rush_td_pts * int(rush_td or 0) + 
                rush_2pt_pts * int(rush_2pt or 0) + 
                rush_fum_pts * int(fum_lost or 0))
    return rush_pts

def rec_scoring(rec,rec_td,rec_2pt,rec_tgt,rec_yd):
    rec_yds_pts = 0.1
    rec_td_pts = 6
    rec_2pt_pts = 2
    recp_pts = 0.5
    rec_pts = (recp_pts * int(rec or 0) + 
               rec_yds_pts * int(rec_yd or 0) + 
               rec_td_pts * int(rec_td or 0) + 
               rec_2pt_pts * int(rec_2pt or 0))
    return rec_pts
    
def fantasy_points(player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                 fum,fum_lost,rec,rec_td,rec_2pt,
                 rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                 safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr):
    def_points = def_scoring(def_td,ff,fum_rec,def_int,pts_allow,sack,safe,blk_kick,def_st_td,pts_half_ppr)
    #kicker_points = kick_scoring(fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29)
    kicker_proj_points = int(pts_half_ppr or 0)
    pass_pts = pass_scoring(pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt)
    rush_pts = rush_scoring(rush_att,rush_yd,rush_td,rush_2pt, fum_lost)
    rec_pts = rec_scoring(rec,rec_td,rec_2pt,rec_tgt,rec_yd)
    #f_p = def_points + pass_pts + rush_pts + rec_pts + kicker_points
    try:
        is_def = int(player_id)
    except:
        is_def = True
    if is_def == True:
        f_p = def_points
    else:
        f_p = pass_pts + rush_pts + rec_pts #+ kicker_points
    if int(pts_half_ppr or 0) > 0 and f_p == 0:
        f_p = f_p + kicker_proj_points
    return f_p

#enter sleeper league ID here
#l_id = ref.league_id()
l_id = references.league_id()

projections = requests.get("https://api.sleeper.app/v1/projections/nfl/regular/2019")
projections_json = projections.json()
projections_data = pd.DataFrame(projections_json)

# #### #leauge_data = pd.read_json(leauge_data_json)
# roster_data = pd.DataFrame(rosters_json)
# #pd.read_json(_, orient='split')
# print(roster_data)
drop_table("projections_tbl")
projections_create = """
    CREATE TABLE projections_tbl
    (
    player_id character(255),
    pass_att float(1),
    pass_cmp float(1),
    pass_int float(1),
    pass_td float(1),
    pass_yd float(1),
    pass_2pt float(1),
    rush_att float(1),
    rush_yd float(1),
    rush_td float(1),
    rush_2pt float(1),
    fum float(1),
    fum_lost float(1),
    rec float(1),
    rec_td float(1),
    rec_2pt float(1),
    rec_tgt float(1),
    rec_yd float(1),
    def_td float(1),
    ff float(1),
    fum_rec float(1),
    def_int float(1),
    pts_allow float(1),
    qb_hit float(1),
    sack float(1),
    tkl_ast float(1),
    tkl_loss float(1),
    tkl_solo float(1),
    yds_allow float(1),
    safe float(1),
    blk_kick float(1),
    def_st_td float(1),
    fga float(1),
    fgm float(1),
    xpa float(1),
    xpm float(1),
    st_td float(1),
    fgm_50p float(1),
    fgm_40_49 float(1),
    fgm_30_39 float(1),
    fgm_20_29 float(1),
    pts_half_ppr float,
    any_pts float,

    primary key(player_id)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(projections_create)
db.commit()
cursor.close()
db.close()

for i in projections_json.keys():
    player_id = i
    proj_json = json_normalize(projections_json[i])
    try:
        pass_att = int(round(proj_json.loc[0,'pass_att']))
    except:
        pass_att = None
    try:
        pass_cmp = int(round(proj_json.loc[0,'pass_cmp']))
    except:
        pass_cmp = None
    try:
        pass_int = int(round(proj_json.loc[0,'pass_int']))
    except:
        pass_int = None
    try:
        pass_td = int(round(proj_json.loc[0,'pass_td']))
    except:
        pass_td = None
    try:
        pass_yd = int(round(proj_json.loc[0,'pass_yd']))
    except:
        pass_yd = None
    try:
        pass_2pt = int(round(proj_json.loc[0,'pass_2pt']))
    except:
        pass_2pt = None
    try:
        rush_att = int(round(proj_json.loc[0,'rush_att']))
    except:
        rush_att = None
    try:
        rush_yd = int(round(proj_json.loc[0,'rush_yd']))
    except:
        rush_yd = None
    try:
        rush_td = int(round(proj_json.loc[0,'rush_td']))
    except:
        rush_td = None
    try:
        rush_2pt = int(round(proj_json.loc[0,'rush_2pt']))
    except:
        rush_2pt = None
    try:
        fum = int(round(proj_json.loc[0,'fum']))
    except:
        fum = None
    try:
        fum_lost = int(round(proj_json.loc[0,'fum_lost']))
    except:
        fum_lost = None
    try:
        rec = int(round(proj_json.loc[0,'rec']))
    except:
        rec = None
    try:
        rec_td = int(round(proj_json.loc[0,'rec_td']))
    except:
        rec_td = None
    try:
        rec_2pt = int(round(proj_json.loc[0,'rec_2pt']))
    except:
        rec_2pt = None
    try:
        rec_tgt = int(round(proj_json.loc[0,'rec_tgt']))
    except:
        rec_tgt = None
    try:
        rec_yd = int(round(proj_json.loc[0,'rec_yd']))
    except:
        rec_yd = None
    try:
        def_td = int(round(proj_json.loc[0,'def_td']))
    except:
        def_td = None
    try:
        ff = int(round(proj_json.loc[0,'ff']))
    except:
        ff = None
    try:
        fum_rec = int(round(proj_json.loc[0,'fum_rec']))
    except:
        fum_rec = None
    try:
        def_int = int(round(proj_json.loc[0,'int']))
    except:
        def_int = None
    try:
        pts_allow = int(round(proj_json.loc[0,'ff']))
    except:
        pts_allow = None
    try:
        qb_hit = int(round(proj_json.loc[0,'fum_rec']))
    except:
        qb_hit = None
    try:
        sack = int(round(proj_json.loc[0,'sack']))
    except:
        sack = None
    try:
        tkl_ast = int(round(proj_json.loc[0,'tkl_ast']))
    except:
        tkl_ast = None
    try:
        tkl_loss = int(round(proj_json.loc[0,'tkl_loss']))
    except:
        tkl_loss = None
    try:
        tkl_solo = int(round(proj_json.loc[0,'tkl_solo']))
    except:
        tkl_solo = None
    try:
        yds_allow = int(round(proj_json.loc[0,'yds_allow']))
    except:
        yds_allow = None
    try:
        safe = int(round(proj_json.loc[0,'safe']))
    except:
        safe = None
    try:
        blk_kick = int(round(proj_json.loc[0,'blk_kick']))
    except:
        blk_kick = None
    try:
        def_st_td = int(round(proj_json.loc[0,'def_st_td']))
    except:
        def_st_td = None
    try:
        fga = int(round(proj_json.loc[0,'fga']))
    except:
        fga = None
    try:
        fgm = int(round(proj_json.loc[0,'fgm']))
    except:
        fgm = None
    try:
        xpa = int(round(proj_json.loc[0,'xpa']))
    except:
        xpa = None
    try:
        xpm = int(round(proj_json.loc[0,'xpm']))
    except:
        xpm = None
    try:
        st_td = int(round(proj_json.loc[0,'st_td']))
    except:
        st_td = None
    try:
        fgm_50p = int(round(proj_json.loc[0,'fgm_50p']))
    except:
        fgm_50p = None
    try:
        fgm_40_49 = int(round(proj_json.loc[0,'fgm_40_49']))
    except:
        fgm_40_49 = None
    try:
        fgm_30_39 = int(round(proj_json.loc[0,'fgm_30_39']))
    except:
        fgm_30_39 = None
    try:
        fgm_20_29 = int(round(proj_json.loc[0,'fgm_20_29']))
    except:
        fgm_20_29 = None
    try:
        pts_half_ppr = proj_json.loc[0,'pts_half_ppr']
    except:
        pts_half_ppr = None
    any_pts = fantasy_points(player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                             fum,fum_lost,rec,rec_td,rec_2pt,
                             rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                             safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr)
    refresh_projections_data(player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                             fum,fum_lost,rec,rec_td,rec_2pt,
                             rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                             safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr,any_pts)
    