import matplotlib
matplotlib.use('TkAgg')

from PyCACalebExtras.Common import LoadNRRD, LoadMHA, GenVideo, WriteMHA
import PyCACalebExtras.Display as cd
import PyCA.Display as display
import PyCA.Common as cm
import matplotlib.pyplot as plt 
import matplotlib.image as mpimg
import PyCA.Core as ca
import fnmatch
import numpy as np
import os
import re
import glob
import pickle, pprint 
import fire.fire as fyr
import sys
import itertools 
import matplotlib.cm as cmlor


matches_i = []
matches_seg = []

for filename in glob.glob(os.path.join('/scratch/Data/scans/','*Fixed.mhd')):
	matches_i.append(filename)
for filename in glob.glob(os.path.join('/scratch/Data/scans/','*Moving.mhd')):
	matches_i.append(filename)


for filename in glob.glob(os.path.join('/scratch/Data/lungMasks/','*Fixed.mhd')):
	matches_seg.append(filename)
for filename in glob.glob(os.path.join('/scratch/Data/lungMasks/','*Moving.mhd')):
	matches_seg.append(filename)

matches_i.sort()
matches_seg.sort()  

imgroup = []
pat_group =[]

[imgroup.append(i) for i in zip(matches_i,matches_seg)]

# [pat_group.append(i) for i in zip(imgroup[0::1],imgroup[2::3])]


for f,m in zip(imgroup[0::2],imgroup[1::2]):
	im  = f[1]
	im2 = m[1] 
	path = os.path.split(im)
	path2 = os.path.split(im2)
	
	print f
	print m 
	print im,im2
	print path, path2
	# sys.exit() 
	fyr.ResizeGrids(im,im2, 
		'/scratch/Data/SameGrid/ResampleWorld/'+path[1],
		'/scratch/Data/SameGrid/ResampleWorld/'+path2[1])

# for seg in matches_seg:

	# fyr.ResizeGrids(seg ) 