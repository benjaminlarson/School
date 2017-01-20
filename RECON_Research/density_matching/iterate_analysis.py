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
import sys

def sorted_nicely( l ):
	# Alpha numeric sorting 
	""" Sorts the given iterable in the way that is expected.
	Required arguments:
	l -- The iterable to be sorted.
	"""
	convert = lambda text: int(text) if text.isdigit() else text
	alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
	return sorted(l, key = alphanum_key)

def process(path_with_mha): 
	mvd_pt = open(path_with_mha,'rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	m = data['mass']
	d = data['den']
	v = data['vol']

	# v[:] =[(x-minV)/(maxV-minV)for x in v] 
	# print path_with_mha, v 
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
	plt.plot(v,2**a/v, label = path_with_mha)
	
	plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
		  fancybox=True,mode="expand", shadow=True, ncol=3)
	plt.xlabel('volume')
	plt.ylabel('density') 
	plt.hold(True)

def logprocess(path_with_mha):
	mvd_pt = open(path_with_mha,'rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	m = data['mass']
	d = data['den']
	v = data['vol']

	# print path_with_mha, v 
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

# matches_i = []
# # user_dir = os.path.join('/home/sci/benl/Data_DIR/Density_500')
# user_dir = os.path.join('/home/sci/benl/Data_DIR/snakeThreshold')
# # user_dir = os.path.join('/home/sci/benl/Data_DIR/Density_500/alpha')
# print user_dir
# # for alpha in np.arange(0.3,1,0.01):
# for root,dirs,files, in os.walk(user_dir):
# 	for file in files:
# 		if file.endswith('.pkl'):
# 			matches_i.append(os.path.join(root, file)) 


# for filename in glob.glob(os.path.join('/home/sci/benl/Data_DIR/Density/*','*.pkl')):
# 	matches_i.append(filename)
# matches_i = sorted_nicely(matches_i) 
# print len(matches_i)  

# # path = '/home/sci/benl/Data_DIR/Density_500/alpha/'
# path = '/home/sci/benl/Data_DIR/snakeThreshold'
# if not os.path.isfile(path+'DataPickle.pkl'):
# 	PatientList=[]
# 	slope = []
# 	for alpha in np.arange(0.3,1.0,0.01):
# 		PatientList.append(slope) 
# 		slope = []
# 		# print alpha
# 		for item in matches_i:
# 			d = os.path.split(item)[0]
# 			d = os.path.split(d)
# 			# print d[1] 
# 			all_floats = re.findall(r"[-+]?\d*\.\d+|\d+",d[1])
# 			print str(all_floats[0]) == str(alpha), all_floats[0], alpha  
# 			if str(all_floats[0]) == str(alpha):
# 				print alpha, all_floats[0] 
# 				s = logprocess(item)
# 				slope.append(s)
# 				plt.hold(True)
# 		data = {'data':PatientList}
# 	output = open(path+'DataPickle.pkl','wb')
# 	pickle.dump(data,output)
# 	output.close()

# mvd_pt = open(path+'DataPickle.pkl','rb')
# data = pickle.load(mvd_pt)
# mvd_pt.close() 
# # print len(PatientList)
# PatientList = data['data'][1:] 
# # print PatientList[0]
# # print PatientList[1]
# y = [np.mean(i) for i in PatientList]
# sd = [np.std(i) for i in PatientList]

# print "Y = ", len(y) 
# x = np.arange(30,99,1) 
# print "x = ", len(x) 
# plt.figure() 
# plt.scatter(x,y)
# plt.errorbar(x,y,yerr=sd,linestyle="None" )

matches_i = []
user_dir = os.path.join('/home/sci/benl/Data_Empire_Amit/DropOutliers_threshold_Alpha')
# user_dir = os.path.join('/home/sci/benl/Data_Empire_Amit/Alpha_all')
path = user_dir 

# user_dir = '/home/sci/benl/Data_Empire_Amit/Alpha_all'
print user_dir
# for alpha in np.arange(0.3,1,0.01):
for root,dirs,files, in os.walk(user_dir):
	for file in files:
		if file.endswith('.pkl'):
			matches_i.append(os.path.join(root, file)) 


# for filename in glob.glob(os.path.join('/home/sci/benl/Data_DIR/Density/*','*.pkl')):
# 	matches_i.append(filename)
matches_i = sorted_nicely(matches_i) 
# print len(matches_i)  
# path = '/home/sci/benl/Data_Empire_Amit/Diff_threshold_Alpha/'
# path = '/home/sci/benl/Data_Empire_Amit/Alpha_all/'
# path = '/home/sci/benl/Data_Empire_Amit/DropOutliers_threshold_Alpha'
if not os.path.isfile(path+'DataPickle.pkl'):
	PatientList=[]
	slope = []
	for alpha in np.arange(0.3,1.0,0.01):
		PatientList.append(slope) 
		slope = []
		# print alpha
		for item in matches_i:
			d = os.path.split(item)[0]
			d = os.path.split(d)
			# print d[1] 
			all_floats = re.findall(r"[-+]?\d*\.\d+|\d+",d[1])
			# print str(all_floats[0]) == str(alpha), all_floats[0], alpha
			print all_floats, item
			# if str(all_floats[1]) in ['3','4','5','6','7','8','10','14','15','17','18','19','20','21','22','23','25','27','28']:  
			if str(all_floats[-1]) in ['3','4','5','6','7','8','10','14','15','17','18','19','20','21','22','25','27','28']:	
				if str(all_floats[0]) == str(alpha):
					# print alpha, all_floats[0] 
					s = logprocess(item)
					slope.append(s)
					plt.hold(True)
		data = {'data':PatientList}
	output = open(path+'DataPickle.pkl','wb')
	pickle.dump(data,output)
	output.close()

mvd_pt = open(path+'DataPickle.pkl','rb')
data = pickle.load(mvd_pt)
mvd_pt.close() 
# print len(PatientList)
PatientList = data['data'][1:] 
# print PatientList[0]
# print PatientList[1]
y = [np.mean(i) for i in PatientList]
sd = [np.std(i) for i in PatientList]

print "Y = ", len(y) 
x = np.arange(30,99,1) 
print "x = ", len(x) 
plt.figure() 
plt.hlines(-1,30,100)
plt.hold(True)
plt.scatter(x,y)
plt.errorbar(x,y,yerr=sd,linestyle="None" )	
