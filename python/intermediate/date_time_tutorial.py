import datetime
import pytz
d = datetime.date(2016, 7 , 16)
tday = datetime.date.today()
tdelta = datetime.timedelta(days = 7)

t = datetime.time(9, 40, 45)
print(d.weekday())
dt = datetime.datetime(2022, 9, 12, 9, 30, 55)

#Ask for utc
#dt1 = datetime.datetime(2022, 9, 12, 9, 30, 55, tzinfo=pytz.UTC)
dt_utcnow = datetime.datetime.now(tz=pytz.UTC)
#print(dt_utcnow)

#Turn to a different time zone from utc
#for tz in pytz.all_timezones:
#    print(tz)
utc7 = dt_utcnow.astimezone(pytz.timezone('Etc/GMT-7'))
#print (utc7)

#Turn a naive datetime to an utc
here_tz = pytz.timezone('Etc/GMT-7')
here_time = datetime.datetime.now()
here_time = here_tz.localize(here_time)
#or
here_time = datetime.datetime.now(tz=pytz.timezone('Etc/GMT-7'))

#strftime - Datetime to String
#strptime - String to Datetime
print (here_time.strftime('%B %d, %Y'))
dt_str = 'September 12, 2022'
convert_str_to_dt = datetime.datetime.strptime(dt_str, '%B %d, %Y')
print (convert_str_to_dt)

