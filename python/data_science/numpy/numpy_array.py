import numpy as np 

a = np.arange(2,8.5,1.5)
#print ("1d shape:", a.shape)
#fromlist = np.array([[1,2,3],[4,5,6]], dtype=np.int8)
b = np.array((np.arange(0,8,2), np.arange(1,8,2)))
b2 = b.reshape((4,2))
#b[b == 3 ] = 2
#print(b)
#print ("2D shape:", b.shape)
c = np.zeros((3,3))
c1 = np.ones((4,4))
c2 = np.eye(4, k=2)
# [] is filter
c2[c2 == 0 ] = 3 
c2[c2 < 2 ] = 7
c2[0] = 4
c2[1:] = 5
c2[3:] = 3
c2[:, -1] = 6
c2[2:, :2] = 8 
print (c2, "\n")
#sorted_c2 = np.sort(c2)
sorted_c2 = np.sort(c2, axis = 0)
#print(sorted_c2)
view_c2 = c2.view()
copy_c2 = c2.copy()
view_c2[2:] = 9
copy_c2[2:] = 7
print (copy_c2)
