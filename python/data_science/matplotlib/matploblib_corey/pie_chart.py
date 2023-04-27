from matplotlib import pyplot as plt
plt.style.use('fivethirtyeight')
slices = [59219, 55466, 47544, 36443, 35917]
labels = ['JavaScript', 'HTML/CSS', 'SQL', 'Python', 'Java']
explode = [0,0,0,0.1,0]
#colors = ['#008fd5', '#fc4f40', '#e5ae37', '#6d904f']
plt.pie(slices, explode = explode, labels = labels, shadow = True,
        startangle=90, autopct = '%1.1f%%',wedgeprops={'edgecolor': 'black'})
plt.title('The Most popular Programming Languages')
plt.show()