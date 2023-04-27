import numpy as np 
a = np.array((np.arange(1,8),np.arange(8,15),np.arange(15,22),np.arange(22,29)))
#print (a)
#print (a[1:3,1:6])
b = np.array([[[1,2],[3,4]], [[5,6],[7,8]]]) #this is 3d array
#b[:,:,0] = [[11,13],[15,17]]
print (b)
print (b[:,:,0])