import numpy as np
import matplotlib.pyplot as plt 

res=[]
p = [] 
def f1(x):
	return((-0.2*x**4 +x**2 -x) )
def f2(x):
	return((1- np.exp(-x**2)) )
def f3(x):
	return((np.sqrt(x**2 +0.3))  )
def f_(x):
	return(-x**2+21.6*x+3) 

def golden ( f, a, b, eps, N): 
	res = []
	p = []
	c = (-1+np.sqrt(5))/2
	x1 = c*a +(1-c)*b
	fx1 = f(x1)
	x2 = (1-c)*a + c*b 
	fx2 = f(x2)
	# print x1, x2, fx1, fx2, b-a
	res.append(fx1)
	p.append(x1) 
	for i in range(0,N-2):
		if fx1 < fx2:
			b = x2
			x2 = x1
			fx2 = fx1
			x1 = c*a + (1-c)*b
			fx1 = f(x1) 
			res.append(fx1)
			p.append(x1) 
		else:
			a = x1 
			x1 = x2
			fx1 = fx2
			x2 = (1-c)*a + c*b 
			fx2 = f(x2) 
			res.append(fx2)
			p.append(x2) 

		if (abs(b-a) < eps) :
			return res, p 
		# print x1, x2, fx1, fx2, b-a
	print (res, p)

# golden(f1, 0, 1, 0.01, 20)
eps = 0.01
N = 20 

print ("---------")
res, p = golden(f1,-1,1,eps,N) 
y = [f1(x)  for x in np.linspace(-1,1,len(res))]
res = [x for x in res] 
x =np.linspace(-1,1,len(res))
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res, cmap = 'Jet')
plt.axis([-1,1,-2,2])
plt.title('GoldenR search, f(x) = -0.2x^4+x^2-x')
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
print("----------")

plt.figure() 
print ("---------")
res, p = golden(f2,-1,1,eps, N) 
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
plt.title('GoldenR search, 1-exp(-x^2)') 
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
print("----------")

plt.figure() 
print ("---------")
res, p = golden(f3,-1,1,eps,N) 
y = [f3(x) for x in np.linspace(-1,1,len(res))]
res = [x for x in res] 
x =np.linspace(-1,1,len(res))
# print y
# print len(x), len(y)
# print len(p), len(res) 
plt.plot(x,y)
plt.hold(True) 
plt.scatter(p, res)
plt.title('GoldenR search, (x^2+3)^(1/2)')
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
plt.axis([-1,1,0,3])
plt.hold(False) 
plt.show() 
print("----------")