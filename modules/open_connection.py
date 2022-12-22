import os
os.chdir(r'C:\projects\sleeper_data\modules')
import crds
import psycopg2 as ps

def open_connection():
    usr = crds.get_usr()
    pwd = crds.get_pwd()
    db = ps.connect(database="dynasty", user="postgres", password=pwd, host="127.0.0.1",port="5432")
    return db

def open_connection_cloud():
    svr = "dynasty1.cchqpfdtasog.us-east-2.rds.amazonaws.com"
    usr = crds.get_usr_cloud()
    pwd = crds.get_pwd_cloud()
    db = ps.connect(database="any_database", user=usr, password=pwd, host=svr,port="5432")
    return db