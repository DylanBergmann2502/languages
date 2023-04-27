from bs4 import BeautifulSoup

with open('simple_bs4.html') as html_file:
    soup = BeautifulSoup(html_file, 'lxml')  # lxml is a python lib for working with html

print(soup.prettify())  # prettify to indent

match1 = soup.title # access tags like attribute
match2 = soup.title.text # access the text of the tag
print(match1, match2)

# find => first tag, find_all => all tags
match3 = soup.find('div', class_='footer') # class is special => class_, otherwise just use id=
print(match3)

# article = soup.find('div', class_='article')
for article in soup.find_all('div', class_='article'):
    headline = article.h2.a.text
    print(headline)

    summary = article.p.text
    print(summary)

    print()

