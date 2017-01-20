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



highThreshold = [
-500,#3
-400,#4
-400,#5
-500,#6
-500,#7
-500,#8
-600,#10 
-500,#14
-600,#15
-400,#17
-500,#18
-300,#19
-500,#20
-200,#21
-500,#22
-400,#23
-400,#25
-500,#27
-400,#28
 ] 
highThreshold = [i/1000.0*0.17+0.17 for i in highThreshold] 

for num, thresh in zip(['3','4','5','6','7','8','10','14','15','17','18','19','20','21','22','23','25','27','28'],highThreshold):
# for num in ['06']:
	matches_i = []
	matches_seg = []
	for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Human_Amit_Lin_Attn/'+num+'/','*%.mha')):
		matches_i.append(filename)
	for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Human_Amit_Lin_Attn/'+num+'/','*seg.mha')):
		matches_seg.append(filename)

	matches_i = Fire.sorted_nicely(matches_i) 
	matches_seg = Fire.sorted_nicely(matches_seg) 
	print matches_i

	for i,j in zip(matches_i,matches_seg):
		d = os.path.split(i)
		all_floats = re.findall(r"[-+]?\d*\.\d+|\d+",d[1]) 
		print d , all_floats

		if not os.path.exists('/home/sci/benl/Data_Empire_Amit/Saved_Hard_Segmentation/'+num+'/'):
			os.makedirs('/home/sci/benl/Data_Empire_Amit/Saved_Hard_Segmentation/'+num+'/')
		
		Fire.SaveHardThreshold(i,j,
			'/home/sci/benl/Data_Empire_Amit/Saved_Hard_Segmentation/'+num+'/'+d[1],
			None,
			thresh) 
