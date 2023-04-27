import requests

r = requests.get('https://xkcd.com/353/')
print(r)
print(r.text) # in html

r = requests.get('https://imgs.xkcd.com/comics/python.png')
print(r.content) # in byte
with open('comic.png', 'wb') as f: # wb = write byte
    f.write(r.content)
print(r.status_code)
print(r.ok) # status code <400 (200 = 0k, 300 = redirect, 400 = client error, 500 = server error)
print(r.headers)

payload1 = {'page':2, 'count':  25}
r = requests.get('https://httpbin.org/get', params=payload1)
print(r.text)
print(r.url)

payload2 = {'username':'corey','password':'testing'}
r = requests.post('https://httpbin.org/post', data=payload2)
print(r.text)
print(r.json())
r_dict = r.json()
print(r_dict['form'])

r = requests.get('http://httpbin.org/basic-auth/dylan/bergmann', auth=('dylan', 'bergmann'))
print(r)
print(r.text)
r = requests.get('http://httpbin.org/basic-auth/dylan/bergmann', auth=('dylanb', 'bergmann'))
print(r)
print(r.text)

r1 = requests.get('http://httpbin.org/delay/1', timeout=3)
r2 = requests.get('http://httpbin.org/delay/3', timeout=3)
r3 = requests.get('http://httpbin.org/delay/6', timeout=3)
print(r1, r2, r3)