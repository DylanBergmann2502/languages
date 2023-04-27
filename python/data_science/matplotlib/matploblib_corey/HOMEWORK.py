import matplotlib.pyplot as plt
plt.style.use('seaborn')
plt.xkcd
ages_x = [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]
dev_y = [38496, 42000, 46752, 49320, 53200,
         56000, 62316, 64928, 67317, 68748, 73752]
py_dev_y = [45372, 48876, 53850, 57287, 63016,
            65998, 70003, 70000, 71496, 75370, 83640]
js_dev_y = [37810, 43515, 46823, 49293, 53437,
            56373, 62375, 66674, 68745, 68746, 74583]
fig, ax1 = plt.subplots()
ax1.plot(ages_x, py_dev_y, label = 'Python Users')
ax1.plot(ages_x, js_dev_y, label = 'JavaScript Users')
ax1.plot(ages_x, dev_y, linestyle = '--', label = 'All Devs')
ax1.legend()

ax1.set_title('Median Salary (USD) by Age')
ax1.set_xlabel('Ages')
ax1.set_ylabel('Median Salary')

#########################################
import numpy as np
fig, ax2 = plt.subplots()
indexes = np.arange(len(ages_x))
width = 0.25
ax2.bar(indexes - width, dev_y, width = width, label = 'All Devs')
ax2.bar(indexes, py_dev_y, width = width, label = 'Python Users')
ax2.bar(indexes + width, js_dev_y,width = width, label = 'JavaScript Users')

ax2.legend()
ax2.set_xticks(ticks = indexes, labels = ages_x)
ax2.set_title('Median Salary (USD) by Age')
ax2.set_xlabel('Ages')
ax2.set_ylabel('Median Salary')
#########################################
from collections import Counter
import csv
import pandas as pd

with open ('data5.csv') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    language_counter = Counter()
    for row in csv_reader:
        language_counter.update(row['LanguageHaveWorkedWith'].split(';'))
#print(language_counter.most_common(15))
'''
data = pd.read_csv('data4.csv')
lang_responses = data['LanguagesWorkedWith']
language_counter = Counter()
for response in lang_responses:
        language_counter.update(response)
'''
languages = []
popularity = []
for item in language_counter.most_common(15):
        languages.append(item[0])
        popularity.append(item[1])

languages.reverse()
popularity.reverse()
fig, ax3 = plt.subplots()
for index, value in enumerate(popularity):
    ax3.text(value + 3 , index -.15,
             str(value))
ax3.barh(languages,popularity)
ax3.set_title('The Most Popular Programming Language (2022)')
ax3.set_xlabel('Number of Users')
#ax3.set_ylabel('Languges')
ax3.grid(False)
plt.tight_layout()
plt.show()
