import pandas as pd 
bigtable = {
    "name" : ["dylan", "Vi", "Lillia", "Emerald", "David", "David"],
    "age" : [21, 20, "eternal", 25, 45, 45],
    "height" : [1.68, 1.8, 1.7, 1.75, 1.8, 1.8],
    "weight" : [78, 75, 80, 70, 90, 90]
}
table = pd.DataFrame(bigtable)
by_column = table.age
by_column = table[["age", "name"]][1:4]
by_row = table.loc[[2,5,0], ["name","age"]]
by_row = table.iloc[[2,5,0], [1,3]]
by_row = table.iloc[1:4]["height"]
print(by_row)
print("***********************************************")
bmi = []
for person in range(len(table)):
    bmi_score = table["weight"][person]/(table["height"][person]**2)
    bmi.append(bmi_score)

table["bmi"] = bmi
table.to_csv("bmi.csv", index = False, sep="\t")
'''
count = 0
for everyname in table["name"]:
    if everyname == "David": 
        count +=1 
print("There are " + str(count) + " David")
'''
table.set_index("age", inplace = True)
print (table.index)
table.columns = ["names", "height", "weight", "bmi"]
table.rename(columns =  {'names' : 'name'}, inplace = True)
print (table)
age20 = table.loc[25]["height"]
table.reset_index(inplace = True)
filt = (table["height"] == 1.8) | (table["weight"] >= 75) 
print (table.loc[~filt, "bmi"])