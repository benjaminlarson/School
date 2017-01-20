 
import matplotlib
matplotlib.use('TkAgg')

from PyCACalebExtras.Common import LoadNRRD, LoadMHA, GenVideo, WriteMHA
import PyCACalebExtras.Display as cd
import PyCA.Display as display
import PyCA.Common as common
import matplotlib.pyplot as plt 
import matplotlib.image as mpimg
import PyCA.Core as ca
import fnmatch
import numpy as np
import os
import re
import glob
import pickle, pprint 
import sys
import Fire 



highThreshold = 500
# highThreshold = [i/1000.0*0.17+0.17 for i in highThreshold] 

for num  in ['01','02','03','04','05','06','07','08','09','10']:
# for num in ['06']:
	matches_i = []
	matches_seg = []
	for filename in glob.glob(os.path.join('/home/sci/benl/Data_DIR/MHAImages/Case'+num+'/Images/','*.mha')):
		matches_i.append(filename)
	for filename in glob.glob(os.path.join('/home/sci/benl/Data_DIR/MHAImages/Case'+num+'/Seg/','*seg.mha')):
		matches_seg.append(filename)

	matches_i = Fire.sorted_nicely(matches_i) 
	matches_seg = Fire.sorted_nicely(matches_seg) 
	print matches_i

	for i,j in zip(matches_i,matches_seg):
		d = os.path.split(i)
		all_floats = re.findall(r"[-+]?\d*\.\d+|\d+",d[1]) 
		print d , all_floats

		if not os.path.exists('/home/sci/benl/Data_DIR/Saved_Hard_Segmentation/'+num+'/'):
			os.makedirs('/home/sci/benl/Data_DIR/Saved_Hard_Segmentation/'+num+'/')
		
		Fire.SaveHardThreshold(i,j,
			'/home/sci/benl/Data_DIR/Saved_Hard_Segmentation/'+num+'/'+d[1],
			None,
			highThreshold) 
