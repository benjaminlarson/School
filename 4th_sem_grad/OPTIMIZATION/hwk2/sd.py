import numpy as np
import numpy.linalg as LA 
import matplotlib.pyplot as plt 

x = np.array( [1**-5.,0.] ) # this should be changed on each iteration 
c1 = 10**(-4) 
c2 = 0.9 

def fi1(a):
	global x 
	# input array, output array 
	# print('find function value', a, (a[0]**4+a[0]**4+a[1]**2+1.2*a[0]*(a[1]+1)**(1.4)+1)**(1.7))
	return ( (a[0]**4+a[0]**4+a[1]**2+1.2*a[0]*(a[1]+1)**(1.4)+1)**(1.7) ) 
def fi1_(a): 
	global x 
	# print ("Finding Derivative",a) 
	# gradient of vector a
	x1 = 0.7*(4*a[0]**3+2*a[0]+1.2*(a[1]+1)**1.4)/ \
		(a[0]**4+a[0]**2+1.2*a[0]*(a[1]+1)**1.4+a[1]**2+1)**0.3
	x2 = (1.176*a[0]*(a[1]+1)**0.4+1.4*a[1])/ \
		(a[0]**4+a[0]**2+1.2*a[0]*(a[1]+1)**1.4+a[1]**2+1)**0.3 
	return ( np.array([x1,x2]) ) 

def zoom(a, b, fi, fi_):
	global x 
	# from book, finds good interval over a,b 
	z = np.array([0,0])
	for j in range(1,10):
		aj = (a+b)/2 
		fi_a = fi(x + aj*fi_(x) ) 
		if LA.norm(fi_a) > LA.norm(fi(x+0)+ c1*aj*fi_(x+0) ) or \
			LA.norm( fi(x+aj*fi_(x)) ) >= LA.norm( fi(x+a*fi_(x)) ):
			b = aj
		else:
			fi_p = fi_(x + aj*fi_(x) ) 
			if LA.norm(fi_p) <= LA.norm(-c2*fi_(x+0)):
				a = aj 
				return(a) 
			if (fi_(x+aj*fi_(x) )*(b-a) >= 0):
				b = a
			a = aj 
	print(a) 
	return(a) 

def ls(x, fi, fi_):
# a is a start point, numpy array 
# p is the gradient 
# fi is the function 
# fi_ is the gradient 
	
	z =  np.array([0,0]) 
	ai = 0 
	a1 = 0 
	a_1 = 0 
	for i in range(10):
		ai = fi( x + ai*fi_(x) )
		print("Suff Decrease",LA.norm(ai) , LA.norm( fi(x+z) + c1*ai*fi_(x+0) ) )
		if LA.norm(ai) > LA.norm( fi(x+z) + c1*ai*fi_(x+0) ):
			a = zoom( a1, ai, fi, fi_ ) 
			print ('first', a) 
			return(a)
		fi_p = fi_(x+ai*fi_(x))
		print("Curvature", LA.norm(abs(fi_p)) ,LA.norm(-c2*fi_(x+z)))
		if LA.norm(abs(fi_p)) <= LA.norm(-c2*fi_(x+z)):
			a = ai 
			print('second',a)
			return(a) 
		print("SPostiveD", fi_p) 
		if fi_p >= 0:
			a = zoom(ai, a_1, fi, fi_)
			print('final',a)  
			return(a) 
		a_1 = ai
		a1 = ai
	return(ai)# this should not return 

for i in range(1,4):
	alpha = ls(x, fi1_, fi1)
	print ("Steepest Descent",x, alpha)
	x = x + alpha*fi1_(x) 
print('minimizer', x) 
