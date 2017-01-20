# import sys
# reload(sys)
# sys.setdefaultencoding('utf8')
import numpy as np
import matplotlib.pyplot as plt 

def f1 (x):
	return (-0.2*x**4+x**2 -x)
def f1p(x):
	return(-0.8*x**3+2*x-1) 
def f1pp(x):
	return(-0.24*x**2+2)

def f2(x):
	return(1-np.exp(-x**2) )
def f2p(x):
	return(-2*x*np.exp(-x**2) )
def f2pp(x):
	return(np.exp(-x**2)*(-2+4*x**2) )

def f3(x):
	return( (x**2+0.3)**(1./2) )
def f3p(x):
	return( x/(x**2+0.3)**(1./2) )
def f3pp(x):
	return(3/(x**2+0.3)**(3./2) ) 

def newtonMethod(x0, f, fp, fpp): 
	tolerance = 10**(-7)
	eps = 10**(-14) 
	p = []
	res = []

	maxIt = 10
	haveSol = False 

	for i in range(maxIt): 
		y = f(x0)
		yp = fp(x0) 
		ypp = fpp(x0) 
		print (i, x0, y, "###", yp, ypp)
		if (abs(ypp) < eps):
			print ("denominator too small" )
			break
		x1 = x0 - yp/ypp 
		p.append(x0) 
		res.append(y) 
		if (abs(x1-x0) <= tolerance * abs(x1)):
			haveSol = True
			print ("Found Solution")
			break
		x0 = x1
		# print i, x0, y
	# print x1-x0,  f(x1), f(x0) 
	return res, p 

# newtonMethod(-1, f1,f1p, f1pp) 
# print "-----"
# newtonMethod(-0.1, f2, f2p, f2pp) 
# newtonMethod(-2.5, f2, f2p, f2pp) 
# print "-----"
# newtonMethod(-2,f3,f3p,f3pp) 

print ("---------")
res, p = newtonMethod(-1,f1,f1p, f1pp) 
y = [f1(x)  for x in np.linspace(-1,1,len(res))]
res = [x for x in res] 
x =np.linspace(-1,1,len(res))
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res)
plt.axis([-1,1,-2,2])
plt.title('Newton search, f(x) = -0.2x^4+x^2-x')

p = ['%.2f' %elem for elem in p]
res = ['%.2f' %elem for elem in res] 
tabl = plt.table(cellText = [p,res], 
	loc = 'top',
	colWidths = [0.1]*len(res), colLoc = 'bottom', 
	rowLabels = ['p', 'f(p)'], rowLoc = 'left',
	bbox = [0,-0.2,1,0.1] )
tabl.auto_set_font_size(False) 
tabl.set_fontsize(12)
tabl.scale(1, 1)
plt.hold(False) 
# plt.savefig('f1newt')
print("----------")

plt.figure() 
print ("---------")
res, p = newtonMethod(-2.5,f2,f2p,f2pp)  
y = [f2(x) for x in np.linspace(-3,3,len(res))]
res = [x for x in res] 
x =np.linspace(-3,3,len(res))
# print y
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res)
plt.axis([-3,3,-2,2])
plt.title('Newton search, 1-exp(-x^2)') 
p = ['%.2f' %elem for elem in p]
res = ['%.2f' %elem for elem in res] 
tabl = plt.table(cellText = [p,res], 
	loc = 'top',
	colWidths = [0.1]*len(res), colLoc = 'center', 
	rowLabels = ['p', 'f(p)'], rowLoc = 'left',
	bbox = [0,-0.2,1,0.1] )
tabl.auto_set_font_size(False) 
tabl.set_fontsize(12)
tabl.scale(1, 1)
plt.hold(False) 
print("----------")

plt.figure() 
print ("---------")
res, p = newtonMethod(-2,f3,f3p,f3pp)  
y = [f3(x) for x in np.linspace(-1,1,len(res))]
res = [x for x in res] 
x =np.linspace(-1,1,len(res))
# print y
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res)
plt.title('Newton search, (x^2+3)^(1/2)')
plt.axis([-1,1,0,3])
p = ['%.2f' %elem for elem in p]
res = ['%.2f' %elem for elem in res] 
tabl = plt.table(cellText = [p,res], 
	loc = 'top',
	colWidths = [0.1]*len(res), colLoc = 'center', 
	rowLabels = ['p', 'f(p)'], rowLoc = 'left',
	bbox = [0,-0.2,1,0.1] )
tabl.auto_set_font_size(False) 
tabl.set_fontsize(12)
tabl.scale(1, 1)
plt.hold(False) 
plt.show(block = False) 
plt.show() 
print("----------")