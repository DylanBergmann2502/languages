from PIL import Image, ImageFilter
import os

size_300 = (300,300)

for f in os.listdir('.'):
    if f.endswith('.jpg'):
        i = Image.open(f)
        fn, fext = os.path.splitext(f)
        i.save('pngs/{}.png'.format(fn))

for f in os.listdir('.'):
    if f.endswith('.jpg'):
        i = Image.open(f)
        fn, fext = os.path.splitext(f)

        i.thumbnail(size_300)
        i.save('300/{}_300.{}'.format(fn, fext))

image1 = Image.open('mount1.jpg')
image1.show() #display image on the screen
image1.save('mount1.png')
image1.rotate(90).save('mount1_mod.jpg')
image1.convert(mode='L').save('mount1_mod2.jpg')
image1.filter(ImageFilter.GaussianBlur(15)).save('mount1_mod3.jpg')