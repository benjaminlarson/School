import numpy as np 
import matplotlib.pyplot as plt 
#Find the fibonacci sequence 
def fib(n):
	cur = 1
	old = 1
	i =1 
	while( i< n):
		cur, old, i = cur+old, cur, i+1
	return cur

# returns the smallest fib number less than L 
# while your fib number is less than L stack C 
def findSmallestFib(L):
	# print "find smallest", L 
	j = 0 
	C = fib(j) 
	while (C < L):
		j = j+1  
		C = fib(j) 
	return j-1

def f1(x):
	return(-1*(-0.2*x**4 +x**2 -x) )
def f2(x):
	return(-1*(1- np.exp(-x**2)) )
def f3(x):
	return(-1*(np.sqrt(x**2 +0.3))  )
def f_(x):
	return(-x**2+21.6*x+3) 

# Find a maximum solution to a given function f(x) on the interval 
# [a,b] where the funciton is unimodal. 

def fibSearch(a, b, f, tolerance = 0.001):
	# print "fibsearch", a, b 
	#step 1, initialize 
	#step 2/3, calculate 
	results = []
	p = []
	L = abs(round(float(b-a)/tolerance) )
	n = findSmallestFib(L) 
	# print "smallest j from find", n, fib(n) 
	x1 = a + (float(fib(n -2))/fib(n))*(b-a) 
	x2 = a + (float(fib(n -1))/fib(n))*(b-a)
	fx1 = f(x1)
	fx2 = f(x2) 
	p.append(x1) 
	results.append(fx1) 
	for j in range(n) :
		# print j, x1, x2, f(x1), f(x2) , [a,b]
		#step 4 compare 
		fx1 = f(x1)
		fx2 = f(x2) 
		results.append(fx1)
		p.append(x1) 
		if (fx1 <= fx2):
		 	a = x1
		 	x1 = x2 
		 	n = n-1 
		 	x2 = a+(float(fib(n-1))/fib(n))*(b-a) 
		else:
		 	b = x2
		 	x2 = x1
		 	n = n-1 
		 	x1 = a+(float(fib(n-2))/fib(n))*(b-a) 
	return [a,b], f((a+b)/2.), results, p 



# win, mid, res, p= fibSearch(0,20, f_)
print ("---------")
win, mid, res, p = fibSearch(-1,1,f1) 
y = [f1(x) *-1 for x in np.linspace(-1,1,len(res))]
res = [-1*x for x in res] 
x =np.linspace(-1,1,len(res))
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res, cmap = 'Jet')
plt.axis([-1,1,-2,2])
plt.title('Fibonnaci Search, f(x) = -0.2x^4+x^2-x')
p = ['%.2f' %elem for elem in p]
res = ['%.2f' %elem for elem in res] 
tabl = plt.table(cellText = [p,res], 
	loc = 'top',
	colWidths = [0.1]*len(res), colLoc = 'bottom', 
	rowLabels = ['p', 'f(p)'], rowLoc = 'left',
	bbox = [0,-0.2,1,0.1] )
tabl.auto_set_font_size(False) 
tabl.set_fontsize(10)
tabl.scale(1.1, 1.1)
plt.hold(False) 
print("----------")

plt.figure() 
print ("---------")
win, mid, res, p = fibSearch(-1,1,f2) 
y = [f2(x)*-1 for x in np.linspace(-3,3,len(res))]
res = [-1*x for x in res] 
x =np.linspace(-3,3,len(res))
# print y
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res)
plt.axis([-3,3,-2,2])
plt.title('Fibonnaci Search, 1-exp(-x^2)') 
p = ['%.2f' %elem for elem in p]
res = ['%.2f' %elem for elem in res] 
tabl = plt.table(cellText = [p,res], 
	loc = 'top',
	colWidths = [0.1]*len(res), colLoc = 'bottom', 
	rowLabels = ['p', 'f(p)'], rowLoc = 'left',
	bbox = [0,-0.2,1,0.1] )
tabl.auto_set_font_size(False) 
tabl.set_fontsize(10)
tabl.scale(1.1, 1.1)
plt.hold(False) 
print("----------")

plt.figure() 
print ("---------")
win, mid, res, p = fibSearch(-1,1,f3) 
y = [f3(x)*-1 for x in np.linspace(-1,1,len(res))]
res = [-1*x for x in res] 
x =np.linspace(-1,1,len(res))
# print y
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res)
plt.title('Fibonnaci Search, (x^2+3)^(1/2)')
plt.axis([-1,1,0,3])
p = ['%.2f' %elem for elem in p]
res = ['%.2f' %elem for elem in res] 
tabl = plt.table(cellText = [p,res], 
	loc = 'top',
	colWidths = [10.6]*len(res), colLoc = 'bottom', 
	rowLabels = ['p', 'f(p)'], rowLoc = 'left',
	bbox = [0,-0.2,1,0.1] )
tabl.auto_set_font_size(False) 
tabl.set_fontsize(10)
tabl.scale(1, 1)
plt.hold(False) 
plt.show() 
print("----------")
