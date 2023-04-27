import random
from sty import fg

def gen_rgb():
    red = random.randint(0, 256)
    green = random.randint(0, 256)
    blue = random.randint(0, 256)
    return red, green, blue

def gen_cl(red, green, blue):
    return fg (red, green, blue)
red, green, blue = gen_rgb()
