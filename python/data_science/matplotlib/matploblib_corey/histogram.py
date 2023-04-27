import pandas as pd
from matplotlib import pyplot as plt
plt.style.use('seaborn')
'''
ages = [18, 19, 21, 25, 26, 26, 30, 32, 38, 45, 55]
bins = [15,25,35,45,55]
plt.hist(ages, bins = bins, edgecolor = 'black')
'''
data = pd.read_csv('data2.csv')
ids = data['Responder_id']
ages = data['Age']
bins = [10,20,30,40,50,60,70,80,90,100]
plt.hist(ages, bins = bins, edgecolor = 'black', log=True)

median_age = 29
color = '#9acd32'
plt.axvline(median_age, color = color, label = 'Median Age', linewidth = 5)
plt.legend()
plt.title('Ages of Respondents')
plt.xlabel('Ages')
plt.ylabel('Total Respondents')

plt.tight_layout()

plt.show()