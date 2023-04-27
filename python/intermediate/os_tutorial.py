import os
from datetime import datetime

print(dir(os)) #get all methods of os
print(os.getcwd()) #get current directory
os.chdir('C:/Users/locdu/OneDrive/Desktop/') #change directory

os.mkdir('DylanBerg') #create only main directory
os.makedirs('DylanBergmann2/item-1') #create main directory with optional sub-directory

os.rmdir('DylanBerg')
os.removedirs('DylanBergmann2/item-1')

os.rename('InterviewQuestions.DOCX', 'Nah.DOCX') # (current name, new name)

print(os.stat('Nah.DOCX'))
mod_time = os.stat('Nah.DOCX').st_mtime
print(datetime.fromtimestamp(mod_time))

for dirpath, dirnames, filenames in os.walk('C:/Users/locdu/OneDrive/Desktop/'):
    #display the tree structure of the path
    print('Current Path:', dirpath)
    print('Directories:', dirnames)
    print('Files:', filenames)
    print()

print(os.listdir()) #list all items in current directory

print(os.environ.get('HOME'))
file_path = os.getcwd() + '/test.txt'
file_path = os.path.join(os.getcwd(),'test.txt')
print(file_path)

print(os.path.basename('/tmp/test.txt'))
print(os.path.dirname('/tmp/test.txt'))
print(os.path.split('/tmp/test.txt'))
print(os.path.exists('/tmp/test.txt'))
print(os.path.isdir('/tmp/test.txt'))
print(os.path.isfile('/tmp/test.txt'))
print(os.path.splitext('/tmp/test.txt'))



