f = open('test.txt', 'r') # have to close after being done
f.close()

# read files
with open('test.txt', 'r') as f: # closed automatically after done
    #print(f.name, f.mode)
    f_contents = f.read()
    f_contents = f.readline()
    f_contents = f.readlines()

    size_to_read = 10
    f_contents = f.read(size_to_read)
    print(f_contents, end='')

    f.seek(0)

    size_to_read = 10
    f_contents = f.read(size_to_read)
    print(f_contents, end='')

with open('test2.txt', 'w') as f: # no need to create, just write and the file is auto created
    f.write('Test')
    f.seek(0)
    f.write('R') # => Rest

with open('test.txt', 'r') as rf:
    with open('test_copy.txt', 'w') as wf:
        for line in rf:
            wf.write(line)

with open('ice_kingdom.jpg', 'rb') as rf:
    with open('ice_kingdom_copy.jpg', 'wb') as wf:
        chunk_size = 4096
        rf_chunk = rf.read(chunk_size)
        while len(rf_chunk) > 0:
            wf.write(rf_chunk)
            rf_chunk = rf.read(chunk_size) # avoid infinite loop