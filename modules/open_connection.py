import os
os.chdir(r'C:\Users\Dave\Desktop\projects\sleeper_data\modules')
import crds
import psycopg2 as ps

usr = crds.get_usr()
pwd = crds.get_pwd()

def open_connection():
    db = ps.connect(database="dynasty", user="postgres", password="cotton2", host="127.0.0.1",port="5432")
    return db