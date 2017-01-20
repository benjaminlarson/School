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
	
	plt.scatter(v1,d1,c='k')
	plt.scatter(v2,d2,c='k') 
	# plt.plot(v1,d1,'r')
	# plt.plot(v2,d2,'b')
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
# # user_dir = os.path.join('/home/sci/benl/Data_DIR/Density500NoAlpha')
# user_dir = os.path.join('/home/sci/benl/Data_DIR/Density_500/Best')
# for root,dirs,files, in  os.walk(user_dir):
# 	print "dir,file",dirs, files
# 	for file in files:
# 		print"name", file
# 		if file.endswith('pt.pkl'):
# 			matches_i.append(os.path.join(root, file)) 

# # for filename in glob.glob(os.path.join('/home/sci/benl/Data_DIR/Density/*','*.pkl')):
# # 	matches_i.append(filename)

# print matches_i
# slope = []

# plt.figure() 
# for i in matches_i:
# 	# plt.figure(i) 
# 	s = logprocess(i)
# 	slope.append(s)
# 	d = all_floats = re.findall(r"[-+]?\d*\.\d+|\d+",i)
# 	plt.savefig('/home/sci/benl/Data_DIR/AlphaImages/Alpha/'+d[1]+'.png') 
# 	plt.hold(True) 

# fig = plt.figure()
# ax = fig.add_subplot(111) 
# # print slope 
# # plt.hist(slope, bins = 10, color = 'b')
# # plt.xlabel('Slope, vol vs density')
# # plt.ylabel('Frequency')

# ax.scatter(slope,np.ones(len(slope)), alpha=1.0)
# ax.hold(True)
# ax.boxplot(slope,vert=False)
# ax.get_yaxis().set_ticks([]) 
# ax.set_xlim([-1.2,-0.3])


matches_i = []
# user_dir = os.path.join('/home/sci/benl/Data_DIR/Density500NoAlpha')
# user_dir = os.path.join('/home/sci/benl/Data_DIR/Density_500/Best')
# user_dir = os.path.join('/home/sci/benl/Data_Empire_Amit/Alpha')

user_dir = os.path.join('/home/sci/benl/Data_DIR/snakeThreshold')
for root,dirs,files, in  os.walk(user_dir):
	# print "dir,file",dirs, files
	for file in files:
		# print"name", file
		if file.endswith('.pkl'):
			matches_i.append(os.path.join(root, file)) 

print matches_i
slope = []
fig = plt.figure() 

for i in matches_i:
	# plt.figure(i) 
	s = logprocess(i)
	slope.append(s)
	d = all_floats = re.findall(r"[-+]?\d*\.\d+|\d+",i)
	# plt.savefig('/home/sci/benl/Data_DIR/AlphaImages/Alpha/'+d[2]+'.png') 
	plt.hold(True) 

fig = plt.figure()
ax = fig.add_subplot(111) 
# print slope 
# plt.hist(slope, bins = 10, color = 'b')
# plt.xlabel('Slope, vol vs density')
# plt.ylabel('Frequency')

ax.scatter(slope,np.ones(len(slope)), alpha=1.0)
ax.hold(True)
ax.boxplot(slope,vert=False)
ax.get_yaxis().set_ticks([]) 
# ax.set_xlim([-1.2,-0.3])
# process('/home/sci/benl/Aa_HumanSub/6')
# histo_analysis('/home/sci/benl/Aa_HumanSub/6')
