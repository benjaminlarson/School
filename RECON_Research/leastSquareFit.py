# LSF 
import numpy as np
import matplotlib.pyplot as plt 


################ Multiple regression

# x1 = np.array([3,2,4,2,3,2,5,4])
# x2 = np.array([2,1,3,1,2,2,3,2])
# y = np.array([78800, 74300, 83800, 74200,79700,74900,88400,82900])

# x1s = np.sum(x1)
# x12 = np.sum(x1**2)
# x2s = np.sum(x2)
# x22 = np.sum((x2**2)) 
# sum_y = np.sum(y) 
# print x22
# x1x2 = np.sum(x1*x2)

# A = np.array( [[8,x1s,x2s],
#     [x1s,x12,x1x2],
#     [x2s,x1x2,x22]] )

# b = np.array( [[np.sum(y)], 
#     [np.sum(y*x1) ], 
#     [np.sum(y*x2) ]] )

# # b = np.transpose(b)

# print A
# print b
# x = np.linalg.solve(A,b)  
# print "x is: ", x 

################ Least Squares

h = np.array([4,9,10,14,4,7,12,22,1,17])
y = np.array([31,58,65,73,37,44,60,91,21,84])

print np.sum(h)
print np.sum(y) 
sx = np.sum(h)
sy = np.sum(y)
xx = np.sum(h*h)
xy = np.sum(h*y) 

b = (10.*np.sum(h*y) - np.sum(h)*np.sum(y))/(10*np.sum(h**2)-np.sum(h)**2)
a = (np.sum(y) - b*np.sum(h))/10.
print b 
print a 
nh = []
for i in h:
	new_h = i*a+b 
	nh.append(nh)  
plt.plot(h,y)
plt.hold(True)
plt.plot(nh,y)
plt.show() 
