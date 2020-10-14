library(ggrepel)
library(ggimage)
library(nflfastR)
library('RPostgreSQL')
library(tidyverse)

data <- readRDS(url('https://raw.githubusercontent.com/guga31bb/nflfastR-data/master/data/play_by_play_2020.rds'))
roster <- fast_scraper_roster(2020)
#roster <- readRDS(url('https://github.com/guga31bb/nflfastR-data/blob/master/roster-data/roster.rds'))

data1 <- decode_player_ids(data)
write.csv(data1 ,"C:\\projects\\sleeper_data\\data\\rdata_pbp2020.csv", row.names = TRUE)
write.csv(roster,"C:\\projects\\sleeper_data\\data\\rdata_roster2020.csv", row.names = TRUE)