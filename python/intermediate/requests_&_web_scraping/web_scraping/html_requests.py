from requests_html import HTMLSession
import csv

session = HTMLSession() # similar to requests library
r = session.get('https://coreyms.com/')

# print(r.html)

csv_file = open('cms_scrape.csv', 'w')
csv_writer = csv.writer(csv_file)
csv_writer.writerow(['headline', 'description', 'video'])

articles = r.html.find('article')

for article in articles:
    headline = article.find('.entry-title-link', first=True).text
    print(headline)

    # 'entry-content' is the class of the div, p is the paragraph
    description = article.find('.entry-content p', first=True).text
    print(description)

    try:
        vid_src = article.find('iframe', first=True).attrs['src']
        vid_id = vid_src.split('/')[4]
        vid_id = vid_id.split('?')[0]
        utube_link = f'http://youtube.com/watch?v={vid_id}'
    except Exception as e:
        utube_link = None

    print(utube_link)
    print()

    csv_writer.writerow([headline, description, utube_link])

csv_file.close()


# just simply get all the links inside a webpage
for link in r.html.links: # relative links
    print(link)
for link in r.html.absolute_links: # to get absolute links
    print(link)


