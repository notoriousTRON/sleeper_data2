library(ggrepel)
library(ggimage)
library(nflfastR)
library('RPostgreSQL')

data <- readRDS(url('https://raw.githubusercontent.com/guga31bb/nflfastR-data/master/data/play_by_play_2020.rds'))

#rushing stats
rushing_stats <- data %>%
  filter(posteam != "<NA>", name != "<NA>", rush_attempt == 1) %>%
  group_by(game_id, posteam, id, name) %>%
	summarize(sum(rush_attempt), sum(yards_gained), sum(touchdown),
			sum(fumble_forced+fumble_not_forced+fumble_out_of_bounds), 
			sum(fumble_lost),sum((two_point_conv_result == 'success')*two_point_attempt))

#passing stats
passing_stats <- data %>%
  filter(posteam != "<NA>", name != "<NA>", passer != "<NA>", pass_attempt == 1) %>%
  group_by(game_id, posteam, passer_id, name) %>%
	summarize(sum(pass_attempt), sum(complete_pass), sum(complete_pass * yards_gained),
	sum(touchdown), sum(interception),sum(fumble_forced+fumble_not_forced+fumble_out_of_bounds), 
	sum(fumble_lost),	sum((two_point_conv_result == 'success')*two_point_attempt))

#receiver stats
receiving_stats <- data %>%
  filter(posteam != "<NA>", name != "<NA>", receiver != "<NA>", pass_attempt == 1) %>%
  group_by(game_id, posteam, receiver_id, receiver) %>%
	summarize(sum(pass_attempt), sum(complete_pass), sum(complete_pass * yards_gained),
	sum(touchdown), sum(fumble_forced+fumble_not_forced+fumble_out_of_bounds), 
	sum(fumble_lost),	sum((two_point_conv_result == 'success')*two_point_attempt))


data %>%
  filter(sack == 1, fumble_forced==1) %>%
#  group_by(game_id, posteam, name) %>%
#	summarize(sum((two_point_conv_result == 'success')*two_point_attempt))
  select(passer, fumble_forced, sack, rush_attempt, pass_attempt, fumble_lost, two_point_attempt, two_point_conv_result)

#data %>%
#  filter(game_id == "2020_01_ARI_SF", posteam != "<NA>") %>%
#  select(rush, name, rusher, pass, passer, receiver, 
#		rush_attempt, pass_attempt,
#		complete_pass,yards_gained,
#		touchdown)