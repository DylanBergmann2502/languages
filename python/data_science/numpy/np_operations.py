import numpy as np 
a = np.zeros((3,3), dtype = np.int64)
#line 4 = 5
a[:] = 2
#a.fill(8)
#a += 4
#a /= 3
#print(a)
b = np.arange(1,10).reshape((3,3))
sumb, proda, mean = b.sum(1), b.prod(1), b.mean(1)
print (b)
#print (sumb, proda, mean)
bmax, bmin = b.max(1), b.min(0)
#print (bmin, bmax)
b_max_pos, b_min_pos = b.argmax(1), b.argmin()
#print (b_max_pos, b_min_pos)
ptp = b.ptp(1)
#ptp = b.max() - b.min()
#print (ptp)
b1d = b.flatten()
#b1d = b.ravel()
b1d +=1
print(b1d)

