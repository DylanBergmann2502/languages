import sqlite3

connection = sqlite3.connect("gta.db")
cursor = connection.cursor()
cursor.execute("create table gta (release_year integer, release_name text, city text)")
release_list = [
    (1997, "GTA", "state of New Guernsey"),
    (1999, "GTA2", "Anywhere, USA"),
    (2001, "GTA III", "Liberty City"),
    (2002, "GTA: Vice City", "Vice City"),
    (2004, "GTA: San Andreas", "state of San Andreas"),
    (2008, "GTA IV", "Liberty City"),
    (2013, "GTA V", "Los Santos")
]
cursor.executemany("insert into gta values (?,?,?)", release_list)
# print rows
for row in cursor.execute("select * from gta"):
    print(row)
# print specific rows
print("****************")
cursor.execute("select * from gta where city=:c", {"c": "Liberty City"})
gta_search = cursor.fetchall()
print(gta_search)

print("****************")
cursor.execute("create table cities (gta_city text, real_city text)")
cursor.execute("insert into cities values (?,?)", ("Liberty City", "New York"))
cursor.execute("select * from cities where gta_city=:c", {"c": "Liberty City"})
cities_search = cursor.fetchall()
print(cities_search)

print("****************")

for i in gta_search:
    adjusted = [cities_search[0][1] if value == cities_search[0][0] else value for value in i]
    print(adjusted)
print (gta_search.head())
connection.close()