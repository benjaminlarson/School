
import PyCACalebExtras.Common as cc
import PyCA.Core as ca
import PyCA.Common as common 
import numpy as np
import sys
import glob 
import time
import os 


def findS(im):
	I = cc.LoadMHA(im)
	print I
	ca.SetMem(I, 1.0)
	return ca.Sum(I)  


matches = []
for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/','*Fixed.mhd')):
	matches.append(filename)
for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/','*Moving.mhd')):
	matches.append(filename)

s0 = 10e9

for i in matches: 
	# print i 
	s = findS(i)
	# print s, s0
	# if  s < s0:
	# 	s0 = s 
	# 	print "BEST MATCH ----------------------"
	# 	print i 
# print s0 
