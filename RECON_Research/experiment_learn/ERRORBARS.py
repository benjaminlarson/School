import matplotlib
matplotlib.use('TkAgg')


import matplotlib.pyplot as plt
import numpy as np
a = [1,3,5,7]
b = [11,-2,4,19]
plt.scatter(a,b)
c = [1,3,2,1]
plt.hold(True) 
plt.errorbar(a,b,yerr=c, linestyle="None")
plt.show()

x = np.array([0,1,2,3])
y = np.array([-1,-0.2,-9,-5])

A = np.vstack([x,np.ones(len(x))]).T

m,c = np.linalg.lstsq(A,y)[0]

plt.plot(x,y,'o')
plt.plot(x,m*x+c,'r')
plt.show() 