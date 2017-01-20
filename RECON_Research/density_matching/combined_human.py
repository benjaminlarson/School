import matplotlib
matplotlib.use('TkAgg')

from PyCACalebExtras.Common import LoadNRRD, LoadMHA, GenVideo, WriteMHA
import PyCACalebExtras.Display as cd
import PyCA.Display as display
import PyCA.Common as cm
import matplotlib.pyplot as plt 
import matplotlib.image as mpimg
from PIL import Image 
import PyCA.Core as ca
import fnmatch
import numpy as np
import os
import re
import glob
import pickle, pprint 
import fire.fire as fyr
import sys



def findMinMax(path_with_mha, maxV, minV): 
	
	return minV, maxV

def process(path, minV, maxV, i): 
	mvd_pt = open(path,'rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	m = data['mass']
	d = data['den']
	v = data['vol']

	# v[:] =[(x-minV)/(maxV-minV)for x in v] 
	# plt.figure()
	y = np.log2(d)
	x = np.log2(v)
	a = np.mean(y) + np.mean(x)
	x = v
	y = d

	v1 = v[:len(v)/2]
	v2 = v[len(v)/2:]
	d1 = d[:len(d)/2]
	d2 = d[len(d)/2:]
	# plt.scatter(v1,d1,c='r')
	# plt.scatter(v2,d2,c='b') 
	# plt.plot(v1,d1,'r')
	# plt.plot(v2,d2,'b')

	v = np.asarray(v)

	# plt.plot(v,2**a/v,'--k',label = '2**%s/v'%a)
	if i%4 == 0:
		linestyle = '-' 	
		marker = '+'
	elif i%4 == 1:
		linestyle = '--'
		marker = ','
	elif i%4 == 2:
		linestyle = ':'
		marker = '.'
	else:
		linestyle = '-.'
		marker = '1' 
	plt.plot(v,2**a/v,linestyle=linestyle, label = path)
	# 
	plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
	      fancybox=True,mode="expand", shadow=True, ncol=3)
	plt.xlabel('volume')
	plt.ylabel('density') 
	plt.hold(True)

def logprocess(path, minV,max):
	mvd_pt = open(path,'rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	m = data['mass']
	d = data['den']
	v = data['vol']

	# v[:] =[(x-minV)/(maxV-minV)for x in v] 
	# plt.figure()
	y = np.log2(d)
	x = np.log2(v)
	a = np.mean(y) + np.mean(x)


	linearfit = np.polyfit(x,y,1)
	fit_fn = np.poly1d(linearfit)
	yhat = fit_fn(x)
	ybar = np.sum(y)/len(y)
	ssreg = np.sum(( yhat - ybar )**2)
	sstot = np.sum(( y - ybar )**2)
	R = ssreg/sstot
	
	v1 = x[:len(x)/2]
	v2 = x[len(x)/2:]
	d1 = y[:len(y)/2]
	d2 = y[len(y)/2:]
	
	plt.scatter(v1,d1,c='r')
	plt.scatter(v2,d2,c='b') 
	plt.plot(v1,d1,'r')
	plt.plot(v2,d2,'b')
	plt.plot(x,fit_fn(x),'g',label = '%s'%(fit_fn))
	plt.plot(x, a-x ,'k')
	plt.hold(True)
	# plt.scatter(x,y,cmap=plt.cm.Oranges)
	# plt.plot(x,y,'r')
	plt.title("") 
	plt.xlabel('log_2(vol)')
	plt.ylabel('log_2(density)')

	# plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
	#       fancybox=True,mode="expand", shadow=True, ncol=3)
	
	return fit_fn[1]	

minV = 1000000
maxV = 0
#exclude 17
for i in[2,3,4,5,6,7,8,9,10,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]:
# for i in [3,10,20,27]: 

	mvd_pt = open('/scratch/Aa_HumanSub_Quad/'+str(i)+'mvd_pt.pkl','rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	v = data['vol']
	if max(v)> maxV:
		maxV = max(v) 
		print "changemax", max(v), maxV
	if min(v)< minV:
		minV = min(v) 
		print "changemin" ,min(v), minV 


print "min", minV
print "max", maxV 

for i in  [2,3,4,5,6,7,8,9,10,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]:
# for i in [3,10,20,27]: 
	process('/scratch/Aa_HumanSub_Quad/'+str(i)+'mvd_pt.pkl', minV, maxV, i)
	print "DONE", i  
plt.figure()
slope = []
for i in  [2,3,4,5,6,7,8,9,10,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]:
# for i in [3,10,20,27]: 
	s = logprocess('/scratch/Aa_HumanSub_Quad/'+str(i)+'mvd_pt.pkl', minV, maxV)
	slope.append(s) 
	print "DONE", i 

plt.figure() 
print slope 
plt.hist(slope, bins = 10)

plt.figure()
plt.boxplot(slope)
x1,x2,y1,y2 = plt.axis()
plt.axis((x1,x2,-1.0,1.0))
# process('/home/sci/benl/Aa_HumanSub/6')
# histo_analysis('/home/sci/benl/Aa_HumanSub/6')

	# plt.figure()
	# x = v
	# y = d

	# v1 = v[:len(v)/2]
	# v2 = v[len(v)/2:]
	# d1 = d[:len(d)/2]
	# d2 = d[len(d)/2:]
	# plt.scatter(v1,d1,c='r',label = '->')
	# plt.scatter(v2,d2,c='b',label = '->') 
	# plt.plot(v1,d1,'r')
	# plt.plot(v2,d2,'b')

	# v = np.asarray(v)

	# plt.plot(v,2**a/v,'--k',label = '2**%s/v'%a)
	# plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
	#       fancybox=True,mode="expand", shadow=True, ncol=3)
	# plt.xlabel('volume')
	# plt.ylabel('density') 