# coding: utf-8

#boiler plate & imports
import os
os.chdir(r'C:\projects\sleeper_data')
from players_tbl import *
from matchup_tbl import *
from transactions_tbl import *
from concurrent.futures import ThreadPoolExecutor

def run_io_tasks_in_parallel(tasks):
    with ThreadPoolExecutor() as executor:
        running_tasks = [executor.submit(task) for task in tasks]
        for running_task in running_tasks:
            running_task.result()

def pull_weekly_data(year,week,tnf_date):
    run_io_tasks_in_parallel([
        #lambda: pull_players(year),
        lambda: pull_matchups(year,week,tnf_date),
        lambda: pull_transactions(year,week),
    ])

pull_weekly_data('2021','1','2021-9-9')