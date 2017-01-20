import matplotlib.pyplot as plt

x = [1e-1,1e1,1e2,1e3]
y = [9.045,1.498,2.42,3.67]


plt.figure()
plt.scatter(x,y) 
plt.xlabel('sigma penalty')  
plt.ylabel('mean error')
plt.show() 