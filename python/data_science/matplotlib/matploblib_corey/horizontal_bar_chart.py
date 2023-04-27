from matplotlib import pyplot as plt
import pandas as pd
import csv
from collections import Counter
plt.style.use('fivethirtyeight')
''' 
with open('data4.csv') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        language_counter = Counter()
        for row in csv_reader:
                language_counter.update(row['LanguagesWorkedWith'].split(';'))
print(language_counter.most_common(15))
'''
data = pd.read_csv('data4.csv')
lang_responses = data['LanguagesWorkedWith']
language_counter = Counter()
for response in lang_responses:
        language_counter.update(response.split(';'))

languages = []
popularity = []
for item in language_counter.most_common(15):
        languages.append(item[0])
        popularity.append(item[1])

languages.reverse()
popularity.reverse()
plt.barh(languages,popularity)
for index, value in enumerate(popularity):
    plt.text(value, index -.25,
             str(value))
plt.title('Top Popular Languages')
plt.xlabel('Number of Users')
plt.grid(False)
#plt.ylabel('Programming Languages')
plt.tight_layout()
plt.show()