from matplotlib import pyplot as plt
import pandas as pd
data = pd.read_csv('data1.csv')

ages = data['Age']
dev_salaries = data['All_Devs']
py_salaries = data['Python']
js_salaries = data['JavaScript']

plt.plot(ages, dev_salaries,linestyle='--', color='#444444',label='All_Devs')
plt.plot(ages, py_salaries, label='Python')

overall_median = 57287
plt.legend()
'''
plt.fill_between(ages,py_salaries, overall_median,
                 where=(py_salaries>overall_median),
                 interpolate = True, alpha = 0.6)

plt.fill_between(ages,py_salaries, overall_median,
                 where=(py_salaries<overall_median),
                 interpolate = True, color ='green', alpha = 0.6)
'''
plt.fill_between(ages,py_salaries, dev_salaries,
                 where=(py_salaries>dev_salaries),
                 interpolate= True, alpha = 0.6, label ='Above Average')

plt.fill_between(ages,py_salaries, dev_salaries,
                 where=(py_salaries<=dev_salaries),
                 interpolate= True, color ='yellow', alpha = 0.6, label = 'Below Average')


plt.title('Median Salary (USD) by Age')
plt.xlabel('Ages')
plt.ylabel('Median Salary (USD)')
plt.tight_layout()
plt.show()