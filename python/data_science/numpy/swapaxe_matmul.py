import numpy as np
a = np.zeros((3,3), dtype = np.int64)
a[:] = 2
b = np.arange(1,10).reshape((3,3))
print (b, "\n")
#c = np.swapaxes(b, 0, 1)
#c = b.transpose(1,0)
c = b.T
#print (c)
fl_dv = b // a #gives integer
fl_dv = np.floor(b/a) #gives floats
print (fl_dv.astype('int64'))
matmul = c @ a 
print (matmul)