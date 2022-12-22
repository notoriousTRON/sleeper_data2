# coding: utf-8

#boiler plate & imports
import os
os.chdir(r'C:\projects\sleeper_data')
from table_pulls import *
from concurrent.futures import ThreadPoolExecutor

storage = 'aws' #'aws' or 'local'

def run_io_tasks_in_parallel(tasks):
    with ThreadPoolExecutor() as executor:
        running_tasks = [executor.submit(task) for task in tasks]
        for running_task in running_tasks:
            running_task.result()

def pull_weekly_data(year,week):
    run_io_tasks_in_parallel([
        #lambda: pull_user_data(year,storage),  #if anyone has left the league and been replaced
        #lambda: pull_players(year,storage),
        #lambda: pull_draft_data(year,storage),
        #lambda: pull_roster_data(year,storage),
        lambda: pull_matchups(year,week,storage),
        lambda: pull_transactions(year,week,storage),
    ])
    
weeks = ['15']

for wk in weeks:
    pull_weekly_data('2022',wk)