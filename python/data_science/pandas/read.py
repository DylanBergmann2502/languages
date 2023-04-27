import pandas as pd
#import sqlite3
table = pd.read_csv("bmi.csv", sep = "\t")
#connection = sqlite3.connect("gta.db")
#gta_dta = pd.read_sql("select * from gta", connection)
#print(gta_dta)
print (table)
print("********************")
filt = table[table["height"] == 1.8 ]
replaced_table = table.replace(1.8, 1.9)
drop = table.drop(["age", "name"], 1)
row = {
    "name" : "Katherine",
    "age" : 400,
    "height" : 1.65,
    "weight": 60
}
new_row = table.append(row, ignore_index= True)
drop_dup = table.drop_duplicates(subset=["name"])
print (filt)
