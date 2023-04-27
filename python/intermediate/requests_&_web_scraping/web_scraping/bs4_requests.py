from bs4 import BeautifulSoup
import requests
import csv

source = requests.get('https://coreyms.com/').text
soup = BeautifulSoup(source, 'lxml')

csv_file = open('cms_scrape.csv')
csv_writer = csv.writer(csv_file)
csv_writer.writerow(['header', 'description', 'video_link'])

for article in soup.find_all('article'):
    headline = article.find('a', class_='entry-title-link').text
    print(headline)

    description = article.find('div', class_='entry-content').p.text
    print(description)

    # vid_src = article.find('iframe', class_='youtube-player') # get the text
    try:
        vid_src = article.find('iframe', class_='youtube-player')['src'] # to access attribute inside a tag, use dictionary []

        vid_id = vid_src.split('/')[4]
        vid_id = vid_id.split('?')[0]

        utube_link = f'http://youtube.com/watch?v={vid_id}'
    except Exception as e:
        utube_link = None

    print(utube_link)
    print()

    csv_writer.writerow([headline, description, utube_link])

csv_file.close()


