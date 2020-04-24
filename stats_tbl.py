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

def add_stats_data(week_player_id,year,week,
                    player_id,pass_att,pass_cmp,
                    pass_int,pass_td,pass_yd,pass_2pt,
                    rush_att,rush_yd,rush_td,rush_2pt,fum,fum_lost,
                    rec,rec_tgt,rec_yd,rec_td,rec_2pt,
                    def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,safe,blk_kick,def_st_td,st_td,
                    fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr,any_pts):
    db = open_connection.open_connection()
    cursor = db.cursor()
    insert_query = """INSERT INTO stats_tbl(week_player_id,year,week,
                                            player_id,pass_att,pass_cmp,
                                            pass_int,pass_td,pass_yd,pass_2pt,
                                            rush_att,rush_yd,rush_td,rush_2pt,fum,fum_lost,
                                            rec,rec_tgt,rec_yd,rec_td,rec_2pt,
                                            def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,safe,blk_kick,def_st_td,st_td,
                                            fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr, any_pts) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                                   ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                                   ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                                   ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s
                                   ,%s, %s, %s, %s, %s, %s)"""
    cursor.execute(insert_query, (
                                week_player_id,year,week,
                                player_id,pass_att,pass_cmp,
                                pass_int,pass_td,pass_yd,pass_2pt,
                                rush_att,rush_yd,rush_td,rush_2pt,fum,fum_lost,
                                rec,rec_tgt,rec_yd,rec_td,rec_2pt,
                                def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,safe,blk_kick,def_st_td,st_td,
                                fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr,any_pts))
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
    fgm_0_19 = int(fgm or 0)- int(fgm_50p or 0) - int(fgm_40_49 or 0) - int(fgm_30_39 or 0) - int(fgm_20_29 or 0)
    xp_missed = int(xpa or 0) - int(xpm or 0)
    fg_missed = int(fga or 0) - int(fgm or 0)
    kick_pts = (fg_0_19_pts * int(fgm_0_19 or 0) +
                fg_20_29_pts * int(fgm_20_29 or 0) +
                fg_30_39_pts * int(fgm_30_39 or 0) +
                fg_40_49_pts * int(fgm_40_49 or 0) +
                fg_50_pts * int(fgm_50p or 0)+
                xp_pts * int(xpm or 0)+
                xpm_pts * int(xp_missed or 0)+
                fgm_pts * int(fg_missed or 0))
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
    kicker_points = kick_scoring(fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29)
    #kicker_proj_points = int(pts_half_ppr or 0)
    pass_pts = pass_scoring(pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt)
    rush_pts = rush_scoring(rush_att,rush_yd,rush_td,rush_2pt, fum_lost)
    rec_pts = rec_scoring(rec,rec_td,rec_2pt,rec_tgt,rec_yd)
    #f_p = def_points + pass_pts + rush_pts + rec_pts + kicker_points
    try:
        is_def = int(player_id)
        is_def = False
    except:
        is_def = True
    if is_def == True:
        f_p = def_points
    else:
        f_p = pass_pts + rush_pts + rec_pts + kicker_points
    #if int(pts_half_ppr or 0) > 0 and f_p == 0:
    #    f_p = f_p #+ kicker_proj_points
    return f_p


l_id = references.league_id()

year = 2019
week = 16
'''
drop_table("stats_tbl")
stats_create = """
    CREATE TABLE stats_tbl
    (
    week_player_id character(50),
    year character(4), 
    week character(2),
    player_id character(255),
    pass_att int,
    pass_cmp int,
    pass_int int,
    pass_td int,
    pass_yd int,
    pass_2pt int,
    rush_att int,
    rush_yd int,
    rush_td int,
    rush_2pt int,
    fum int,
    fum_lost int,
    rec int,
    rec_tgt int,
    rec_yd int,
    rec_td int,
    rec_2pt int,
    def_td int,
    ff int,
    fum_rec int,
    def_int int,
    pts_allow int,
    qb_hit int,
    sack int,
    tkl_ast int,
    tkl_loss int,
    tkl_solo int,
    yds_allow int,
    safe int,
    blk_kick int,
    def_st_td int,
    fga int,
    fgm int,
    xpa int,
    xpm int,
    st_td int,
    fgm_50p int,
    fgm_40_49 int,
    fgm_30_39 int,
    fgm_20_29 int,
    pts_half_ppr float,
    any_pts float,

    
    primary key(week_player_id)
    )
    """
db = open_connection.open_connection()
cursor = db.cursor()
cursor.execute(stats_create)
db.commit()
cursor.close()
db.close()
'''
w_stats = requests.get("https://api.sleeper.app/v1/stats/nfl/regular/"+str(year)+"/"+str(week))
w_stats_json = w_stats.json()
for i in w_stats_json.keys():
    player_id= i
    try:
        pass_att = int(w_stats_json[i]['pass_att'])
    except:
        pass_att = None
    try:
        pass_cmp = int(w_stats_json[i]['pass_cmp'])
    except:
        pass_cmp = None
    try:
        pass_int = int(w_stats_json[i]['pass_int'])
    except:
        pass_int = None
    try:
        pass_td = int(w_stats_json[i]['pass_td'])
    except:
        pass_td = None
    try:
        pass_yd = int(w_stats_json[i]['pass_yd'])
    except:
        pass_yd = None
    try:
        pass_2pt = int(w_stats_json[i]['pass_2pt'])
    except:
        pass_2pt = None
    try:
        rush_att = int(w_stats_json[i]['rush_att'])
    except:
        rush_att = None
    try:
        rush_yd = int(w_stats_json[i]['rush_yd'])
    except:
        rush_yd = None
    try:
        rush_td = int(w_stats_json[i]['rush_td'])
    except:
        rush_td = None
    try:
        rush_2pt = int(w_stats_json[i]['rush_2pt'])
    except:
        rush_2pt = None
    try:
        fum = int(w_stats_json[i]['fum'])
    except:
        fum = None
    try:
        fum_lost = int(w_stats_json[i]['fum_lost'])
    except:
        fum_lost = None
    try:
        rec = int(w_stats_json[i]['rec'])
    except:
        rec = None
    try:
        rec_tgt = int(w_stats_json[i]['rec_tgt'])
    except:
        rec_tgt = None
    try:
        rec_yd = int(w_stats_json[i]['rec_yd'])
    except:
        rec_yd = None
    try:
        rec_td = int(w_stats_json[i]['rec_td'])
    except:
        rec_td = None
    try:
        rec_2pt = int(w_stats_json[i]['rec_2pt'])
    except:
        rec_2pt = None
    try:
        def_td = int(w_stats_json[i]['def_td'])
    except:
        def_td = None
    try:
        ff = int(w_stats_json[i]['ff'])
    except:
        ff = None
    try:
        fum_rec = int(w_stats_json[i]['fum_rec'])
    except:
        fum_rec = None
    try:
        def_int = int(w_stats_json[i]['int'])
    except:
        def_int = None
    try:
        pts_allow = int(w_stats_json[i]['pts_allow'])
    except:
        pts_allow = None
    try:
        qb_hit = int(w_stats_json[i]['qb_hit'])
    except:
        qb_hit = None
    try:
        sack = int(w_stats_json[i]['sack'])
    except:
        sack = None
    try:
        tkl_ast = int(w_stats_json[i]['tkl_ast'])
    except:
        tkl_ast = None
    try:
        tkl_loss = int(w_stats_json[i]['tkl_loss'])
    except:
        tkl_loss = None
    try:
        tkl_solo = int(w_stats_json[i]['tkl_solo'])
    except:
        tkl_solo = None
    try:
        yds_allow = int(w_stats_json[i]['yds_allow'])
    except:
        yds_allow = None
    try:
        safe = int(w_stats_json[i]['safe'])
    except:
        safe = None
    try:
        blk_kick = int(w_stats_json[i]['blk_kick'])
    except:
        blk_kick = None
    try:
        def_st_td = int(w_stats_json[i]['def_st_td'])
    except:
        def_st_td = None
    try:
        fga = int(w_stats_json[i]['fga'])
    except:
        fga = None
    try:
        fgm = int(w_stats_json[i]['fgm'])
    except:
        fgm = None
    try:
        xpa = int(w_stats_json[i]['xpa'])
    except:
        xpa = None
    try:
        xpm = int(w_stats_json[i]['xpm'])
    except:
        xpm = None
    try:
        st_td = int(w_stats_json[i]['st_td'])
    except:
        st_td = None
    try:
        fgm_50p = int(w_stats_json[i]['fgm_50p'])
    except:
        fgm_50p = None
    try:
        fgm_40_49 = int(w_stats_json[i]['fgm_40_49'])
    except:
        fgm_40_49 = None
    try:
        fgm_30_39 = int(w_stats_json[i]['fgm_30_39'])
    except:
        fgm_30_39 = None
    try:
        fgm_20_29 = int(w_stats_json[i]['fgm_20_29'])
    except:
        fgm_20_29 = None
    try:
        pts_half_ppr = w_stats_json[i]['pts_half_ppr']
    except:
        pts_half_ppr = None
    
    if len(str(week))<2:
        wk = '0'+str(week)
    else:
        wk = str(week)
    week_player_id = str(year)+str(wk)+str(player_id)
    any_pts = fantasy_points(player_id,pass_att,pass_cmp,pass_int,pass_td,pass_yd,pass_2pt,rush_att,rush_yd,rush_td,rush_2pt,
                         fum,fum_lost,rec,rec_td,rec_2pt,
                         rec_tgt,rec_yd,def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,
                         safe,blk_kick,def_st_td,fga,fgm,xpa,xpm,st_td,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr)
    add_stats_data(
                    week_player_id,year,week,
                    player_id,pass_att,pass_cmp,
                    pass_int,pass_td,pass_yd,pass_2pt,
                    rush_att,rush_yd,rush_td,rush_2pt,fum,fum_lost,
                    rec,rec_tgt,rec_yd,rec_td,rec_2pt,
                    def_td,ff,fum_rec,def_int,pts_allow,qb_hit,sack,tkl_ast,tkl_loss,tkl_solo,yds_allow,safe,blk_kick,def_st_td,st_td,
                    fga,fgm,xpa,xpm,fgm_50p,fgm_40_49,fgm_30_39,fgm_20_29,pts_half_ppr,any_pts
                  )
    