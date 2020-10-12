INSERT INTO data.scoring_rules (year,pass_yd_pts,pass_td_pts,pass_2pt_pts,int_pts,
			rush_yds_pts, rush_td_pts,rush_2pt_pts,
			rec_pts,rec_yds_pts,rec_td_pts,rec_2pt_pts,
			fg_0_19_pts,fg_20_29_pts,fg_30_39_pts,fg_40_49_pts,fg_50_pts,pat_pts,fg_missed_pts,pat_missed_pts,
			def_td_pts,def_pa_0_pts,def_pa_1_6_pts,def_pa_7_13_pts,def_pa_14_20_pts,def_pa_21_27_pts,
			def_pa_28_34_pts,def_pa_35_pts,def_sacks_pts,def_int_pts,def_fr_pts,def_saf_pts,def_blocked_kick_pts,
			def_st_td_pts,def_st_fr_pts,st_td_pts,st_ft_pts,fum_lost_pts_pts)
VALUES (
	'2020',0.04,4,2,-1,
	0.1,6,2,
	.5,.1,6,2,
	3,3,3,4,5,1,-1,-1,
	6,10,7,4,1,0,-1,-4,1,
	2,2,2,2,6,2,6,2,-2
	)
ON CONFLICT DO NOTHING