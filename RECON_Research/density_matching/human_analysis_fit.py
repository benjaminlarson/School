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
from pprint import pprint 

def HistogramX(x,y, bins=10, rng=None, normed=False,
			  weights=None, density=None):
	'''Displays a numpy histogram of an Image3D '''
	print "hist-im:", x 
		
	Im = LoadMHA(x,ca.MEM_DEVICE)
	# print ca.MinMax(Im)
	Seg = LoadMHA(y,ca.MEM_DEVICE) 
	res = ca.Image3D(Im.grid(), ca.MEM_DEVICE)
	ca.Mul(res,Im,Seg)

	Im.toType(ca.MEM_DEVICE)
	ca.DivC_I(res,1000)
	ca.MulC_I(res,0.2)
	ca.AddC_I(res,0.2)
	ca.Ramp(res,res)
	sumIm = ca.Sum(res)

	np_im = cm.AsNPCopy(res)

	bin, edges = np.histogram(np_im, bins, rng,
						normed, weights, density)
  
	# bincenters = 0.5*(edges[1:]+edges[:-1])
	print "here"
	return bin, edges,sumIm

def createData(x,seg, HighT, fit_fn):
	## x is the image, fit_fn is the function to fit the points in the data(mass), and bc is the 
	## list of box coordinates that are to be sampled. 
	# grid = ca.GridInfo(ca.Vec3Di(512, 512, 63), ca.Vec3Df(0.6992,0.6992,3),ca.Vec3Df(-177.0, -80.0, -991.0))
	
	im = LoadMHA(x,ca.MEM_DEVICE)
	grid = im.grid()

	s = LoadMHA(seg,ca.MEM_DEVICE)

	# ## SEGMENT 
	MnMx = ca.MinMax(im) 
	se = cm.AsNPCopy(s)     
	npim = cm.AsNPCopy(im) 
	# segHoles = np.where( npim > MnMx[0] , 1, 0)
	# total_seg = np.logical_and(se,segHoles)
	print "old", MnMx
	incompressible = np.where( npim < HighT, 1, 0)
	total_seg1 = np.logical_and(se,incompressible)
	s = cm.ImFromNPArr(total_seg1,ca.MEM_DEVICE)
	s.setGrid(grid)
	print "new", ca.MinMax(s)     
	# cd.DispImage(s, dim = 'z', sliceIdx = 50)
	# cd.DispImage(im, dim= 'z', sliceIdx = 50)
	vol = ca.Sum(s)
	im.toType(ca.MEM_DEVICE) 
	# sys.exit("no error")
	## solve for attenuation, rather than Hounsfield units
	ca.DivC_I(im,1000)
	ca.MulC_I(im,0.2)
	ca.AddC_I(im,0.2)
	
	print "before fit", ca.MinMax(im) 
	imfit = cm.AsNPCopy(im)
	print fit_fn 
	imfit = fit_fn(imfit)
	im = cm.ImFromNPArr(imfit) 
	im.setGrid(grid) 
	im.toType(ca.MEM_DEVICE)
	print "after fit", ca.MinMax(im) 
	# sys.exit ('fit') 
        
	ca.Ramp(im,im)
	res = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	print s.memType()
	print im.memType()
	print res.memType() 
	ca.Mul(res,s,im)
	#im fit ### FIND LUNGS ONLY FOR FIT ###

	print "MINMAX Image ", ca.MinMax(im)
	print "VOL IMAGE/seg", vol

	massFit = []
	denFit = []

	np_im = cm.AsNPCopy(res) 
	std = np.std(np_im, ddof = 1)
	mean = np.sum(np_im)
	print np_im.shape

	sqr = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	ca.Copy(sqr, im) 
	ca.Sqr_I(sqr)
	massSqr = ca.Sum(sqr)
	
	mass = ca.Sum(res) 
	
	den = mass/vol  
	denSqr = massSqr/vol

	a = im.spacing().x
	b = im.spacing().y
	c = im.spacing().z 

	voxel_mm_ratio = float(a*b*c)
	vol = vol*voxel_mm_ratio

	return mass,massSqr,massFit,den,denSqr,denFit,vol, std, mean

############################ Begin Main 
def process(path_with_mha, path, highT, fit_fn): 

	matches_i = []
	matches_seg = []
	for filename in glob.glob(os.path.join(path_with_mha,'*%.mha')):
		matches_i.append(filename)
		print "IM", filename
	for filename in glob.glob(os.path.join(path_with_mha,'*seg.mha')):
		matches_seg.append(filename)
		print "SEG", filename

	matches_i= fyr.sorted_nicely(matches_i) 
	matches_seg = fyr.sorted_nicely(matches_seg)


	#split off Aa_Human sub so can have 2 sets of pkl files 



	pprint(matches_i)
	pprint(matches_seg)	
	if not os.path.isfile(path+'mvd_pt.pkl'):
		im3dseg = []
		im3di = []
		im3diSqr = []
		mass_ = []
		massSqr_ = []
		massFit_= []
		massVid = []
		vol_ = []
		den_ = []
		denSqr_ = []
		denFit_ = []
		hist_bin = []
		hist_binc =[]
		hist_bsqr = []
		hist_bcsqr = []
		list_mass_ = []
		list_mass_total_ = []
		list_std_total_ = []
		list_mean_total_ = []
		std_ = []
		mean_ = []
		
		for x,y in zip(matches_i,matches_seg): 

			mass,massSqr,massFit,den,denSqr,denFit,vol,std,mean = createData (x,y,highT,fit_fn)

			denSqr_.append(denSqr) 
			vol_.append(vol)
			massSqr_.append(massSqr) 
			den_.append(den) 
			mass_.append(mass)
			massFit_.append(massFit)
			denFit_.append(denFit)
			list_mass_.append(mass)
			std_.append(std) 
			mean_.append(mean) 
			list_mass_total_.append(list_mass_)
			list_std_total_.append(std_)
			list_mean_total_.append(mean_)

		mvd = {
			'hist':hist_bin,
			'hist_bc':hist_binc,
			'histsqr':hist_bsqr,
			'hist_bcsqr':hist_bcsqr,
			'mass':mass_,
			'massSqr':massSqr_, 
			'massFit':massFit_,
			'vol':vol_,
			'den':den_,
			'denSqr': denSqr_,
			'denFit':denFit_,
			'listMass':list_mass_total_,
			'listStd':list_std_total_,
			'listMean':list_mean_total_ 
		}
		output = open(path+'mvd_pt.pkl','wb')
		pickle.dump(mvd, output) 
		output.close()
		print "done Pickle"

	##Plots
	#-------------------------------------------------------------------------
	#----------------Log Model------------------------------------------------

	mvd_pt = open(path+'mvd_pt.pkl','rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	m = data['mass']
	d = data['den']
	v = data['vol']

	plt.figure()
	y = np.log2(d)
	x = np.log2(v)
	a = np.mean(y) + np.mean(x)

	v1 = x[:len(x)/2]
	v2 = x[len(x)/2:]
	d1 = y[:len(y)/2]
	d2 = y[len(y)/2:]
	plt.scatter(v1,d1,c='r',label = '->')
	plt.scatter(v2,d2,c='b',label = '->') 
	plt.plot(v1,d1,'r')
	plt.plot(v2,d2,'b')

	plt.plot(x, a-x ,'--k',label = '-1*x + %s'%(a))
	plt.hold(True)
	# plt.scatter(x,y,cmap=plt.cm.Oranges)
	# plt.plot(x,y,'r')
	plt.title("") 
	plt.xlabel('log_2(vol)')
	plt.ylabel('log_2(density)')

	plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
	      fancybox=True,mode="expand", shadow=True, ncol=3)
	plt.savefig(path+'log.png')
	plt.show()


	#----------------MEAN, Std err--------------------------------------------
	plt.figure()
	x = v
	y = d

	v1 = v[:len(v)/2]
	v2 = v[len(v)/2:]
	d1 = d[:len(d)/2]
	d2 = d[len(d)/2:]
	plt.scatter(v1,d1,c='r',label = '->')
	plt.scatter(v2,d2,c='b',label = '->') 
	plt.plot(v1,d1,'r')
	plt.plot(v2,d2,'b')

	v = np.asarray(v)

	plt.plot(v,2**a/v,'--k',label = '2**%s/v'%a)
	plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
	      fancybox=True,mode="expand", shadow=True, ncol=3)
	plt.xlabel('volume')
	plt.ylabel('density') 
	plt.savefig(path_with_mha+'not_log.png')

	plt.figure()
	plt.title('Sum of intensities in segmented region ')
	std = data['listStd'][0]
	mean = data['listMean'][0] 
	# plt.scatter(np.arange(3,len(mean)+3),mean)
	plt.scatter(np.arange(0,len(mean)),mean) 
	plt.hold(True) 

	# plt.plot(np.arange(3,len(mean)+3),mean,'r')
	plt.plot(np.arange(0,len(mean)),mean,'r')
	plt.savefig(path_with_mha+'mass.png')

	plt.errorbar(np.arange(0,len(mean)),mean,yerr=std,linestyle="None")
        plt.close('all') 

# def histo_analysis(path_with_mha):
# 	#----------------HISTOGRAMS--------------------------------------------
# 	matches_i = []
# 	matches_seg = []
# 	for filename in glob.glob(os.path.join(path_with_mha,'*%.mha')):
# 		matches_i.append(filename)
# 		print "IM", filename
# 	for filename in glob.glob(os.path.join(path_with_mha,'*seg.mha')):
# 		matches_seg.append(filename)
# 		print "SEG", filename

# 	matches_i= fyr.sorted_nicely(matches_i) 
# 	matches_seg = fyr.sorted_nicely(matches_seg)
	
# 	if not os.path.isfile(path_with_mha+'/histoPickle.pkl'):
# 		hist=[]
# 		# for x in matches_i: 
# 		# 	# print x 
# 		# 	# h = HistogramX(x, bins = 100, rng = [0,0.3]) 
# 		# 	h = HistogramX(x, bins = 100) 
# 		# 	hist.append(h)
# 		# 	histogramData = {'hist':hist}
# 		for x,y in zip(matches_i, matches_seg):
			
# 			h = HistogramX(x, y, bins= 100)
# 			hist.append(h)
# 			histogramData = {'hist':hist}
# 		output = open('/scratch/Aa_Human_Sub_Linear/mvd_pt.pkl','wb')
# 		pickle.dump(histogramData,output)
# 		output.close()
# 	mvd_pt = open('/scratch/Aa_Human_Sub_Linear/mvd_pt.pkl','rb')
# 	data1 = pickle.load(mvd_pt)
# 	mvd_pt.close()

	# hist = data1['hist']
	# ## center points of bins. 
	# bincenters = 0.5*(hist[0][1][1:]+hist[0][1][:-1])
	# width = hist[0][1][0] - hist[0][1][1] 

	# fig1 = plt.figure()
	# ax2= fig1.add_subplot(111)
	# count = 0
	# colors = plt.cm.rainbow(np.linspace(0, 1, len(matches_i)))

	# for m,x,c in zip(matches_i, hist,colors):
	# 	ax2.plot(bincenters,x[0],label='file:%s Sum=%s'%(m[-8:-5],x[2]),color=c)
	# 	ax2.hold(True)
	# 	ax2.set_yscale('log')
	# 	ax2.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	#           fancybox=True, shadow=True, ncol=5)
	# ax2.set_title('Exhale, total image histogram')
	# plt.savefig(path_with_mha+'h.png')
	# fig = plt.figure()
	# ax = fig.add_subplot(111)
	# ax.bar(bincenters,hist[0][0],width, alpha = 0.1, color= 'b',label='peak exhale')
	# ax.bar(bincenters,hist[-1][0],width, alpha = 0.1, color= 'r',label='peak inhale')

	# ax.set_yscale('log')
	# plt.show()

def linefit(path):

	mvd_pt = open(path+'mvd_pt.pkl','rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close()

	m = data['mass']
	d = data['den']
	v = data['vol']

	plt.figure()
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

	plt.plot(x,a-x,label = '-log(v)')
	plt.hold(True)
	plt.plot(x,fit_fn(x),'--k',label='%s \nR^2=%s'%(fit_fn,R))
	# plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
          # fancybox=True, shadow=True, ncol=4) 
	plt.legend()
	plt.scatter(x,y,cmap=plt.cm.Oranges)
	plt.xlabel('log_2(vol)')
	plt.ylabel('log_2(den)')
	plt.savefig(path_with_mha+'fit.png')
	# plt.errorbar(x,y, yerr = j,linestyle="None") 
	# plt.set_ylabel('linear atenuatoin')
	# plt.set_xlabel('breathing cycle, during exhale')
	# ma = max(max(data['listMean']))+max(max(data['listStd']))xf = x[:,np.newaxis]

def plotFitDataMC():
	fitMU = np.genfromtxt('/home/sci/benl/Aa_Soaked_Phantom/mu_avg.csv',delimiter=',')
	fitD = fitMU.transpose()
	print fitD
	fitMU = fitD[2,:]
	fitMU = fitMU[0:10] 
	# fitMU = np.hstack(([0],fitMU))

	fitDEN= fitD[0,:]
	fitDEN = fitDEN[0:10]
	# fitDEN = np.hstack(([0],fitDEN))

	fitDEN= fitDEN[~np.isnan(fitDEN)]
	fitMU = fitMU[~np.isnan(fitMU)]
	print "------------------------" 
	# print fitMU
	# print fitDEN
	print "--------------------------------------"
	y = fitDEN
	x = fitMU
	## Linear
	xf = x[:,np.newaxis]
	linearfit1,_,_,_ = np.linalg.lstsq(xf,y)
	linearfit = np.array([linearfit1[0],0])
	# plt.plot(x,y,'bo')
	# plt.plot(x,a*x,'-r')
	# print "LFIT", linearfit
	## Quadratic
	x2 = xf**2 
	# print x2 
	n = len(xf) 
	A = np.array([[x2[i], xf[i],0] for i in range(n)]) 
	# print "A", A.shape
	# print A
	quadfit,_,RQ,_ = np.linalg.lstsq(A,y)
	# print X
	# plt.plot(x,X[0]*(x**2)+X[1]*x+X[2],'-b')

	# fit = np.polyfit(x,y,1)
	# fit[1] = 0
	fit = linearfit 
	fit_fn = np.poly1d(fit)
	yhat = fit_fn(x)
	ybar = np.sum(y)/len(y)
	ssreg = np.sum(( yhat - ybar )**2)
	sstot = np.sum(( y - ybar )**2)
	R1 = ssreg/sstot

	# fit2 = np.polyfit(x,y,2)
	# print "FIT2", fit2
	# fit2[2] = 0
	fit2 = quadfit
	fit_fn2 = np.poly1d(fit2)
	yhat = fit_fn2(x)
	ybar = np.sum(y)/len(y)
	ssreg = np.sum(( yhat - ybar )**2)
	sstot = np.sum(( y - ybar )**2)
	R2 = ssreg/sstot 
	## Plot Data
	plt.hold(True)
	plt.title('Fit model : Coefficients: linear%s quadratic%s'%(fit,fit2)) 
	plt.xlabel('Mu')
	plt.ylabel('Den')
	plt.scatter(x,y,label='Data')
	plt.plot(x,fit_fn2(x),'--k',label='quadratic %s'%R2)
	plt.plot(hold=True) 
	plt.plot(x,fit_fn(x),'--b',label='linear %s'%R1)
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	          fancybox=True, shadow=True, ncol=5) 
	return fit_fn, fit_fn2

imgs = [2,3,4,5,6,7,8,9,10,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
highThreshold = [
-500,#2
-500,#3
-400,#4
-400,#5
-500,#6
-500,#7
-500,#8
-400,#9
-600,#10 
-500,#14
-600,#15
-500,#16
-400,#17
-500,#18
-300,#19
-500,#20
-200,#21
-500,#22
-400,#23
-500,#24
-400,#25
-600,#26
-500,#27
-400,#28
-400,#29
-400#30
 ] 
# for i,j in zip(imgs, highThreshold):
#         print i,j 
#         process('/scratch/Aa_HumanSub/'+str(i), j)
	# print "DONE", i  

# for i in im:
#     linefit('/home/sci/benl/Aa_HumanSub/'+str(i))
#     histo_analysis('/home/sci/benl/Aa_HumanSub/'+str(i))	

# process('/home/sci/benl/Aa_HumanSub/10')
# linefit('/home/sci/benl/Aa_HumanSub/10')
# histo_analysis('/home/sci/benl/Aa_HumanSub/25')

'''Find fit function, linar and quadratic, run through the human data'''
fit_fn, fit_fn2 = plotFitDataMC()

for i,j in zip(imgs, highThreshold):
	print i,j 
    process('/scratch/Aa_HumanSub/'+str(i),'/scratch/Aa_HumanSub_Linear/'+str(i), j, fit_fn2)
    linefit('/scratch/Aa_HumanSub_Linear/'+str(i))