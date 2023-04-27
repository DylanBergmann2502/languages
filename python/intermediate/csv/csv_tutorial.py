import csv


# read csv
with open ('names.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file)

    for line in csv_reader:
        print(line[2])

# write csv
with open('names.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file)

    # next(csv_file)

    with open('new_names.csv', 'w') as new_file:
        csv_writer = csv.writer(new_file, delimiter='\t') # '-'

        for line in csv_reader:
            csv_writer.writerow(line)

# read csv with another delimiter => must specify it => the result will be in csv
with open ('names.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter='\t')

    for line in csv_reader:
        print(line)

# DictReader and DictWriter
with open ('names.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file) # read csv as py dict => easier to access values using keys

    for line in csv_reader:
        print(line['email']) # use key instead of the column numb

    with open('new_names.csv', 'w') as new_file:
        fieldnames = ['first_name', 'last_name'] # must have with DictWriter, regular writer doesn't need this
        csv_writer = csv.DictWriter(new_file, fieldnames= fieldnames, delimiter='\t')

        csv_writer.writeheader() # have the choice to write field names as first line

        for line in csv_reader:
            del line['email']
            csv_writer.writerow(line)