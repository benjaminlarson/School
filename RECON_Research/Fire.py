import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np 

import PyCA.Core as ca
import PyCA.Common as common 
import PyCA.Display as display 

import PyCACalebExtras.Common as cc
import PyCACalebExtras.Display as cd
from PyCACalebExtras.Common import LoadNRRD, LoadMHA, GenVideo, WriteMHA

import re 
import fnmatch
import os
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

def GridPlot(vf,im,sliceIm=[0,0,0],every=1,isVF=True,color='r',plotBase=True,colorbase=None,dispAxis='default'):

	'''This is a change to the display grid plot in PyCA'''
	'''Disp axis. 'cart' or 'default' cart is for bottom right origin
				'default' is for top left origin'''
	colorbase = '#A0A0FF'
	# if sliceInZ == None:
	# 	sliceInZ = 1
	# 	print "change sliceInZ to a mid Z slice number"
	lineW = 0.3
	plt.figure('z') 
	slz = sliceIm[0]
	sliceArr = np.squeeze(common.ExtractSliceArrVF(vf, slz,'z'))
	sz = sliceArr.shape
	hID = np.mgrid[0:sz[0], 0:sz[1]]
	d1 = np.squeeze(hID[1, ::every, ::every])
	d2 = np.squeeze(hID[0, ::every, ::every])
	sliceArr = sliceArr[::every, ::every, :]
	if plotBase:
		plt.plot(d1, d2, colorbase)
		plt.hold(True)
		plt.plot(d1.T, d2.T, colorbase)
	if not isVF:
		d1 = np.zeros(d1.shape)
		d2 = np.zeros(d2.shape)
	plt.plot(d1+np.squeeze(sliceArr[:,:,1]),
			 d2+np.squeeze(sliceArr[:,:,0]), color, linewidth = lineW)
	plt.hold(True)
	plt.plot((d1+np.squeeze(sliceArr[:,:,1])).T,
			 (d2+np.squeeze(sliceArr[:,:,0])).T, color, linewidth = lineW)
	print "slz", slz 
	cd.DispImage(im, title= 'I0',sliceIdx = slz, newFig=False, dim='z', axis = dispAxis)

	# change axes to match image axes
	if not plt.gca().yaxis_inverted():
		plt.gca().invert_yaxis()
		# force redraw
		plt.draw()

	plt.figure("y")
	# sly = int(np.floor(sliceInZ*1.88 )) 
	sly = sliceIm[1]
	sliceArr = np.squeeze(common.ExtractSliceArrVF(vf, sly, 'y'))
	sz = sliceArr.shape
	hID = np.mgrid[0:sz[0], 0:sz[1]]
	d1 = np.squeeze(hID[1, ::every, ::every])
	d2 = np.squeeze(hID[0, ::every, ::every])
	sliceArr = sliceArr[::every, ::every, :]
	if plotBase:
		plt.plot(d1, d2, colorbase)
		plt.hold(True)
		plt.plot(d1.T, d2.T, colorbase)
	if not isVF:
		d1 = np.zeros(d1.shape)
		d2 = np.zeros(d2.shape)
	plt.plot(d1+np.squeeze(sliceArr[:,:,2]),
			 d2+np.squeeze(sliceArr[:,:,0]), color, linewidth =lineW)
	plt.hold(True)
	plt.plot((d1+np.squeeze(sliceArr[:,:,2])).T,
			 (d2+np.squeeze(sliceArr[:,:,0])).T, color, linewidth =lineW)
	# change axes to match image axes
	print "sly", sly
	cd.DispImage(im, title='I0',sliceIdx = sly, newFig=False, dim='y',axis = dispAxis)
	if not plt.gca().yaxis_inverted():
		plt.gca().invert_yaxis()
		# force redraw
		plt.draw()

	plt.figure("x")
	# slx = int(np.floor(sliceInZ*1.45)) 
	slx = sliceIm[2]
	sliceArr = np.squeeze(common.ExtractSliceArrVF(vf, slx, 'x'))
	sz = sliceArr.shape
	hID = np.mgrid[0:sz[0], 0:sz[1]]
	d1 = np.squeeze(hID[1, ::every, ::every])
	d2 = np.squeeze(hID[0, ::every, ::every])
	sliceArr = sliceArr[::every, ::every, :]
	if plotBase:
		plt.plot(d1, d2, colorbase)
		plt.hold(True)
		plt.plot(d1.T, d2.T, colorbase)
	if not isVF:
		d1 = np.zeros(d1.shape)
		d2 = np.zeros(d2.shape)
	plt.plot(d1+np.squeeze(sliceArr[:,:,2]),
			 d2+np.squeeze(sliceArr[:,:,1]), color, linewidth = lineW)
	plt.hold(True)
	plt.plot((d1+np.squeeze(sliceArr[:,:,2])).T,
			 (d2+np.squeeze(sliceArr[:,:,1])).T, color, linewidth = lineW)
	print "slx", slx 
	cd.DispImage(im, title='I0',sliceIdx = slx, newFig=False, dim='x',axis = dispAxis)
	# change axes to match image axes
	if not plt.gca().yaxis_inverted():
		plt.gca().invert_yaxis()
		# force redraw
		plt.draw()    

def crop_im(volume =None, x=0, x2=0, y=0, y2=0, z=0, z2=0, plot =True, sliceInd = None):
	'''crops an image3D by the specified dimensions'''
	#TODO put in check for grid smaller or equal to the new grid. 
	vg = volume.grid()
	np_ia = common.AsNPCopy(volume)
	# print 'grid',volume.grid()
	# print 'space',volume.spacing()
	# print 'orign',volume.origin()
	# print 'size',volume.size()
	if (z == 0 and z2 == 0):
		np_ic = np_ia[x:x2,y:y2,:]
		np_ic = common.ImFromNPArr(np_ic, ca.MEM_DEVICE)
		np_ic.setGrid(
			ca.gridInfo(ca.Vec3Di(x2-x,y2-y,z2-z),
			volume.grid().origin(),
			volume.grid().spacing())) 
	else:
		# print np_ia.shape
		np_ic = np_ia[x:x2, y:y2, z:z2] 
		# print np_ic.shape
		np_ic = common.ImFromNPArr(np_ic, ca.MEM_DEVICE)
		# print "npic im", np_ic
		# print "vol.spacing", volume.grid().spacing()
		# print "vol.origin", volume.grid().origin()
		np_ic.setGrid(ca.GridInfo(
			ca.Vec3Di(x2-x,y2-y,z2-z),
			volume.grid().spacing(),
			ca.Vec3Df(x,y,z) ))
			# volume.grid().origin()))
		
	if plot:
		plt.figure('Plot') 
		plt.subplot(1,3,1) 
		display.DispImage(np_ic, sliceIdx = None, dim = 'x', newFig = False)
		plt.hold(True)
		plt.subplot(1,3,2) 
		display.DispImage(np_ic, sliceIdx = None, dim = 'y', newFig = False) 
		plt.subplot(1,3,3) 
		display.DispImage(np_ic, sliceIdx = None, dim = 'z', newFig = False)  
		plt.show(block=True) 
	return np_ic

def Histogram(Im, bins=10, rng=None, normed=False,weights=None, density=None):
	'''Displays a numpy histogram of an Image3D '''

	print "++++++++++++++++++++++++++++++++"
	oldType = Im.memType()
	Im.toType(ca.MEM_HOST)
	bin, edges = np.histogram(Im.asnp().copy(), bins, rng,
						normed, weights, density)
  
	bincenters = 0.5*(edges[1:]+edges[:-1])

	# remove zeros from plot 
	percentile = np.percentile(bin,99.9)

	for i in xrange(0,len(bin)):
		if abs(bin[i]) > percentile:
			bin[i] = 0
	plt.figure()
	print "++++++++++++++++++++++++++++++++"
	print len(bincenters), len(bin) 
	plt.plot(bincenters,bin)   
	plt.show(block = True) 
	return bin, bincenters 

def ds (inIm, g):
	y1 = cc.LoadMHA(inIm)
	y1.toType(ca.MEM_DEVICE)
	bh_i =  ca.Image3D(g, y1.memType())
	ca.ResampleWorld(bh_i, y1, ca.BACKGROUND_STRATEGY_PARTIAL_ZERO)
	# ca.ResampleWorld(bh_i,y1,ca.BACKGROUND_STRATEGY_PARTIAL_ZERO, ca.INTERP_CUBIC)
	# ca.ResampleWorld(bh_i,y1,ca.BACKGROUND_STRATEGY_CLAMP,ca.INTERP_CUBIC) 
	# ca.Resample(bh_i,y1,ca.BACKGROUND_STRATEGY_PARTIAL_ZERO)
	# ca.Resample(bh_i,y1,ca.BACKGROUND_STRATEGY_PARTIAL_ZERO, ca.INTERP_CUBIC)
	# WriteMHA(bh_i, path_with_mha+"downsampled")
	return bh_i

def Filter3D(Im):
	grid = Im.grid()
	mType = ca.MEM_DEVICE
	scratch = ca.Image3D(grid, mType)
	g = ca.GaussianFilterGPU()
	g.updateParams(grid.size(), ca.Vec3Df(.7, .7, 0.0), ca.Vec3Di(2, 2, 1))
	g.filter(scratch, Im, scratch)
	ca.Copy(Im, scratch)
 
	return Im 

def ConvertHoun(im_path):
	print "Imagepath",im_path
	im = cc.LoadMHA(im_path)
	im.toType(ca.MEM_HOST) 
	## solve for attenuation, rather than Hounsfield units
	ca.DivC_I(im,1000)
	ca.MulC_I(im,0.02)
	ca.AddC_I(im,0.02)
	ca.Ramp_I(im)
	cc.WriteMHA(im, im_path)

def createData(x,seg,HighT=None,LowT=None, La_Water = 0.2, power = None, fit_fn = None):

	##
	## x is the image, 
	## fit_fn is the function to fit the points in the data(mass)
	## LowT min of image in Hounsfield ~~ [-1024] 
	## HighT max of image in Hounsfield ~~ [-200] or  [0]
	## 

	im = LoadMHA(x,ca.MEM_DEVICE)
	grid = im.grid()

	s = LoadMHA(seg,ca.MEM_DEVICE)
	sum_before = ca.Sum(s) 

	# ## SEGMENT 
	MnMx = ca.MinMax(im) 
	if not LowT:
		LowT = MnMx[0]
	if not HighT:
		HighT = MnMx[1] 

	if HighT or LowT: 
		se = common.AsNPCopy(s)     
		npim = common.AsNPCopy(im) 
		segHoles = np.where( npim < HighT , 1, 0)
		total_seg = np.logical_and(se,segHoles)
		incompressible = np.where( npim > LowT, 1, 0)
		total_seg1 = np.logical_and(total_seg,incompressible)

		newseg = common.ImFromNPArr(total_seg1,ca.MEM_DEVICE)
		newseg.setGrid(grid)
		vol_vox = ca.Sum(newseg)
	else:
		vol_vox = ca.Sum(s)
		newseg = s
		
	a = im.spacing().x
	b = im.spacing().y
	c = im.spacing().z 
	voxel_mm_ratio = float(a*b*c)
	vol = vol_vox*voxel_mm_ratio

	im.toType(ca.MEM_DEVICE) 

	# sys.exit("no error")
	## solve for attenuation, rather than Hounsfield units
	ca.DivC_I(im,1000)
	print "LAWATER", La_Water
	LAW = float(La_Water)
	print LAW 
	ca.MulC_I(im,LAW)
	ca.AddC_I(im,LAW)


	print "------------------------------------------------------------"
	# power = 2.0 
	if power: 
		ca.PowC_I(im,power)
		ca.MulC_I(im,3.5)

	ca.Ramp(im,im)

	np_i = common.AsNPCopy(im) 
	if fit_fn:
		print "eqn of fit",  fit_fn 
		np_im = fit_fn(np_i)
	else: 
		np_im = np_i
	# """Mass before"""
	# tmp = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	# ca.Mul(tmp,s,im)
	# mass_before = ca.Sum(tmp) 
	# """Mass after"""
	#im fit ### FIND LUNGS ONLY FOR FIT ###

	massFit = []
	denFit = []

	std = np.std(np_im, ddof = 1)
	mean = np.sum(np_im)	

	sqr = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	ca.Copy(sqr, im) 
	ca.Sqr_I(sqr)
	massSqr = ca.Sum(sqr)
	
	## INTEGRATE 
	res = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	ca.Mul(res,newseg,im)
	ca.MulC_I(res,voxel_mm_ratio)

	mass = ca.Sum(res)
	
	den = mass/vol
	
	denSqr = massSqr/vol

	# amount_removed = sum_before - vol_vox
	amount_removed = 0 
	# mass_incompressible = mass_before - mass
	mass_incompressible = 0
	newpathim = os.path.split(x) 
	newdirim = os.path.split(newpathim[0]) #first of tuple


	newpaths = os.path.split(seg) 
	newdirs = os.path.split(newpaths[0]) #first of tuple

	if not os.path.exists('/scratch/Human_Amit_Lin_Attn/'+newdirim[1]):
		os.makedirs('/scratch/Human_Amit_Lin_Attn/'+newdirim[1])
	if not os.path.exists('/scratch/Human_Amit_Lin_Attn/'+newdirs[1]):
		os.makedirs('/scratch/Human_Amit_Lin_Attn/'+newdirs[1])
	
	WriteMHA(im,'/scratch/Human_Amit_Lin_Attn/'+newdirim[1]+'/'+newpathim[1])
	WriteMHA(s,'/scratch/Human_Amit_Lin_Attn/'+newdirs[1]+'/'+newpaths[1])

	return mass,massSqr,massFit,den,denSqr,denFit,vol, std, mean, amount_removed, sum_before, vol_vox, mass_incompressible 

def Create_Pkl(group, path, HighT=None, LowT = None, La_Water = 0.2, power = None, fit_fn = None): 
	## Path_with_mha is exlusive path to directory of images 
	# listDir = os.listdir(path_with_mha) 
	path_with_mha = group 
	# print os.path.join(path_with_mha,'*%.mhd') 
	matches_i = []
	matches_seg = []
	for filename in glob.glob(os.path.join(path_with_mha,'*%.mha')):
		matches_i.append(filename)
	for filename in glob.glob(os.path.join(path_with_mha,'*seg.mha')):
		matches_seg.append(filename)

	# matches_i = [path_with_mha+"_Fixed_i.mhd", path_with_mha+"_Moving_i.mhd"]
	# matches_seg = [path_with_mha+"_Fixed_seg.mha", path_with_mha+"_Moving_seg.mhd"] 	
	
	# print matches_i
	# print matches_seg

	matches_i= sorted_nicely(matches_i) 
	matches_seg = sorted_nicely(matches_seg)

	# matches_i = []
	# matches_seg = []
	# matches_i.append(group[0][0])
	# matches_i.append(group[1][0])
	# matches_seg.append(group[0][1])
	# matches_seg.append(group[1][1])
	print "path is :", path + 'mvd_pt.pkl' 
	if not os.path.isfile(path+'mvd_pt.pkl'):
		print "found",path+"mvd_pt.pkl"
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
		list_amount_rem_ = []
		list_sum_before_ = []
		list_vol_vox_ = []
		list_mass_comp_ = []

		
		for x,y in zip(matches_i,matches_seg): 
			print "in Pkl", La_Water 
			#(x,seg,HighT,LowT=None, La_Water = 0.2, power = None, fit_fn = None)
			mass,massSqr,massFit,den,denSqr,denFit,vol,std,mean,amount_removed, sum_before, vol_vox, mass_incompressible = createData(x,y,None,None,La_Water,power,fit_fn)

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
			list_amount_rem_.append(amount_removed)
			list_sum_before_.append(sum_before) 
			list_vol_vox_.append(vol_vox)
			list_mass_comp_.append(mass_incompressible)


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
			'listMean':list_mean_total_,
			'amountRm':list_amount_rem_,
			'sum_before':list_sum_before_,
			'vol_vox':list_vol_vox_,
			'mass_incompressible':list_mass_comp_
		}
		output = open(path+'mvd_pt.pkl','wb')
		pickle.dump(mvd, output) 
		output.close()
		print "done Pickle"

def HistogramX(x,seg,HighT=None,LowT=None, La_Water = 0.2, power = None, fit_fn = None, bins=10, rng=None, normed=False, weights=None, density=None):
	
	'''Returns bins,edges of a numpy histogram of an Image3D '''
	''' Call Histogram_Analysis Insted of this function'''
	print "hist-im:", x 
		
	im = LoadMHA(x,ca.MEM_DEVICE)
	grid = im.grid()

	s = LoadMHA(seg,ca.MEM_DEVICE)
	sum_before = ca.Sum(s) 

	# ## SEGMENT 
	MnMx = ca.MinMax(im) 
	if not LowT:
		LowT = MnMx[0]
	if not HighT:
		HighT = MnMx[1] 

	if HighT or LowT: 
		se = common.AsNPCopy(s)     
		npim = common.AsNPCopy(im) 
		segHoles = np.where( npim < HighT , 1, 0)
		total_seg = np.logical_and(se,segHoles)
		incompressible = np.where( npim > LowT, 1, 0)
		total_seg1 = np.logical_and(total_seg,incompressible)

		newseg = common.ImFromNPArr(total_seg1,ca.MEM_DEVICE)
		newseg.setGrid(grid)
		vol_vox = ca.Sum(newseg)
	else:
		vol_vox = ca.Sum(s)
		newseg = s 
		
	a = im.spacing().x
	b = im.spacing().y
	c = im.spacing().z 
	voxel_mm_ratio = float(a*b*c)
	vol = vol_vox*voxel_mm_ratio

	im.toType(ca.MEM_DEVICE) 

	# sys.exit("no error")
	# ## solve for attenuation, rather than Hounsfield units
	ca.DivC_I(im,1000)
	print "LAWATER", La_Water
	print "----------------------------------------------"
	LAW = float(La_Water)
	print LAW 
	ca.MulC_I(im,LAW)
	ca.AddC_I(im,LAW)

	# power = 2.0
	if power: 
		ca.PowC_I(im,power)
		# ca.MulC_I(im,3.5)
	ca.Ramp(im,im)


	np_i = common.AsNPCopy(im) 
	if fit_fn:
		print "eqn of fit",  fit_fn 
		np_im = fit_fn(np_i)
	else: 
		np_im = np_i

	res = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	ca.Mul(res,newseg,im)
	#im fit ### FIND LUNGS ONLY FOR FIT ###

	massFit = []
	denFit = []

	std = np.std(np_im, ddof = 1)
	mean = np.sum(np_im)	

	sqr = ca.Image3D(im.grid(), ca.MEM_DEVICE)
	ca.Copy(sqr, im) 
	ca.Sqr_I(sqr)
	massSqr = ca.Sum(sqr)
	
	mass = ca.Sum(res) 

	np_im = common.AsNPCopy(res)
	print "MinMax4",ca.MinMax(res) 
	bin, edges = np.histogram(np_im, bins, rng, normed, weights, density)
  	
	# bincenters = 0.5*(edges[1:]+edges[:-1])
	print "here"
	return bin, edges

def Histogram_Pkl(group,path,HighT=None,LowT=None,La_Water = 0.2, power = None, fit_fn = None):
	#----------------HISTOGRAMS--------------------------------------------
	path_with_mha = group 
	matches_i = []
	matches_seg = []
	print group, path_with_mha
	for filename in glob.glob(os.path.join(path_with_mha,'*%.mha')):
		matches_i.append(filename)
	for filename in glob.glob(os.path.join(path_with_mha,'*seg.mha')):
		matches_seg.append(filename)

	# matches_i = [path_with_mha+"_Fixed_i.mhd", path_with_mha+"_Moving_i.mhd"]
	# matches_seg = [path_with_mha+"_Fixed_seg.mha", path_with_mha+"_Moving_seg.mhd"] 	
	
	print matches_i
	print matches_seg

	matches_i= sorted_nicely(matches_i) 
	matches_seg = sorted_nicely(matches_seg)

	# matches_i = []
	# matches_seg = []
	# matches_i.append(group[0][0])
	# matches_i.append(group[1][0])
	# matches_seg.append(group[0][1])
	# matches_seg.append(group[1][1]) 
	

	# print matches_i
	# print matches_seg 
	# print "found images",len(matches_i)
	# print "found segs", len(matches_seg)

	# matches_i= sorted_nicely(matches_i) 
	# matches_seg = sorted_nicely(matches_seg)
	
	if not os.path.isfile(path+'histoPickle.pkl'):
		hist=[]
		for x,y in zip(matches_i, matches_seg):
			rng = [0,0.4]
			bins = 100
			h = HistogramX(x, y, HighT, LowT,La_Water,power,fit_fn, bins, rng)
			hist.append(h)
		histogramData = {'hist':hist}
		output = open(path+'histoPickle.pkl','wb')
		pickle.dump(histogramData,output)
		output.close()
	mvd_pt = open(path+'histoPickle.pkl','rb')
	
	data1 = pickle.load(mvd_pt)
	mvd_pt.close()

	hist = data1['hist']
	## center points of bins. 
	bincenters = []
	for i in hist: 
		center = []
		for j in range(0,len(i[1])-1): 
			c = 0.5*(i[1][j]+i[1][j+1])
			print c, i[1][j], i[1][j+1] 
			center.append(c) 	
		bincenters.append(center)
	# print "bincenter", len(bincenters), len(bincenters[0])  
		# center = 0.5*(hist[i][1][1:]+hist[i][1][:-1])
		# bincenter.append(center)
	
	# print "HISTOGRAM BIN CENTERS", bincenters
	fig1 = plt.figure()
	ax2= fig1.add_subplot(111)
	count = 0
	colors = plt.cm.rainbow(np.linspace(0, 1, len(matches_i)))
	for m,b,x,c in zip(matches_i, bincenters, hist, colors):
		# print b
		# print x[0]
		print len(b), len(x[0])
		# ax2.plot(bincenters,x[0],label='file:%s Sum=%s'%(m[-8:-5],x[2]),color=c)
		ax2.plot(b,x[0],label='file:%s'%(m[-8:-5]),color = c)
		ax2.hold(True)
		ax2.set_yscale('log')
		ax2.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	          fancybox=True, shadow=True, ncol=5)
	ax2.set_title('histogram')
	plt.savefig(path + 'h.png')

	# fig = plt.figure()

	# width = hist[0][1][0] - hist[0][1][1]
	# print len(hist[1][1]), len(hist[1][0]) 
	# plt.bar(bincenters[1], hist[1][0], width =width, log = True)
	# plt.figure()
	# plt.plot(bincenters[1], hist[1][0] )
	# plt.yscale('log') 

	# plt.xlim(min(bin_edges), max(bin_edges))
	# plt.yscale('log') 
	# plt.show(block=True) 
	# ax = fig.add_subplot(111)
	# ax.bar(bincenters,hist[0][0],width, alpha = 0.1, color= 'b',label='peak exhale')
	# ax.bar(bincenters,hist[-1][0],width, alpha = 0.1, color= 'r',label='peak inhale')

	# ax.set_yscale('log')
	# plt.show()

def Linefit_LogData(path):

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
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
          fancybox=True, shadow=True, ncol=4) 
	plt.legend()
	plt.scatter(x,y,cmap=plt.cm.Oranges)
	plt.xlabel('log_2(vol)')
	plt.ylabel('log_2(den)')
	plt.savefig(path+'fit.png')
	
	# plt.errorbar(x,y, yerr = j,linestyle="None") 
	# plt.set_ylabel('linear atenuatoin')
	# plt.set_xlabel('breathing cycle, during exhale')
	# ma = max(max(data['listMean']))+max(max(data['listStd']))xf = x[:,np.newaxis]

def plotFitDataMC():
	fitMU = np.genfromtxt('/home/sci/benl/Aa_Soaked_Phantom/mu_avg.csv',delimiter=',')
	fitN = fitMU.transpose()
	# print fitN
	fitMU = fitN[2,:-1]
	# fitMU = fitMU[0:10] 
	# fitMU = np.hstack(([0],fitMU))

	fitNIST= fitN[3,:-1]
	# fitDEN = fitDEN[0:10]
	# fitDEN = np.hstack(([0],fitDEN))

	fitNIST= fitNIST[~np.isnan(fitNIST)]
	fitMU = fitMU[~np.isnan(fitMU)]
	y = fitNIST
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
	fit2 = quadfit[0]
	print fit2
	fit_fn2 = np.poly1d(fit2)
	print fit_fn2 
	yhat = fit_fn2(x)
	ybar = np.sum(y)/len(y)
	ssreg = np.sum(( yhat - ybar )**2)
	sstot = np.sum(( y - ybar )**2)
	R2 = ssreg/sstot 
	## Plot Data
	plt.hold(True)
	plt.title('Fit model : Coefficients: linear%s quadratic%s'%(fit,fit2)) 
	plt.xlabel('Mu')
	plt.ylabel('NIST')
	plt.scatter(x,y,label='Data')
	plt.plot(x,fit_fn2(x),'--k',label='quadratic %s'%R2)
	plt.plot(hold=True) 
	plt.plot(x,fit_fn(x),'--b',label='linear %s'%R1)
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	          fancybox=True, shadow=True, ncol=5) 
	return fit_fn, fit_fn2

def MissingMassVolume(path):
	mvd_pt = open(path+'mvd_pt.pkl','rb')
	data = pickle.load(mvd_pt)
	mvd_pt.close() 
	plt.figure()
	plt.ylabel('sum voxels')
	x = np.arange(0,len(data['amountRm']))
	plt.scatter(x,data['amountRm'],c = 'r', label='Vol voxels removed')
	plt.hold(True)
	plt.scatter(x,data['sum_before'], c='b',label='original seg Vol') 
	plt.scatter(x,data['vol_vox'], c = 'k',label='Final volume')

	m = np.mean(data['amountRm'])
	print m 
	plt.hlines(m,0,len(data['amountRm']))
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
      fancybox=True, shadow=True, ncol=5) 
	plt.savefig(path+'MissingVol.png')
	plt.figure()
	plt.ylabel('sum Linear Attenuation')
	plt.scatter(x,data['mass'], c = 'k', label= 'Final mass')  
	plt.scatter(x,data['mass_incompressible'], c= 'g',label='Mass "incompressible" removed') 
	plt.hlines(np.mean(data['mass_incompressible']),0,len(data['amountRm']))
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
      fancybox=True, shadow=True, ncol=5) 
	plt.savefig(path+'Missing.png')

def whichWhich(x,y,path,slope):
	print path 
	i = int(filter(str.isdigit,path))
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
	plt.plot(x,y,linestyle=linestyle, label = '%s path %s' %(path,slope) )
	# plt.legend(loc='upper center', bbox_to_anchor=(0., 1.02, 1., .102),
	#       fancybox=True,mode="expand", shadow=True, ncol=3)

def ResizeGrids(im_name,im2,save_path1, save_path2):
	print "im1", im_name
	print "im2", im2 
	print "save", save_path1, save_path2 

	mtype = ca.MEM_DEVICE

	im_diff = LoadMHA(im_name)
	im2_new = LoadMHA(im2)  
	
	newIm = ca.Image3D(im_diff.grid(),mtype)
	ca.ResampleWorld(newIm, im2_new)
	print save_path2
	print save_path1 
	WriteMHA(newIm, save_path2)
	WriteMHA(im_diff,save_path1) 

def SaveHardThreshold(Image, In_seg,Out_seg, LowT = None, HighT = None):
	'''Image = image to segment on, In_seg =input seg path, Out_seg = outputh seg path'''
	
	im = LoadMHA(Image,ca.MEM_DEVICE)
	grid = im.grid()
	
	s = LoadMHA(In_seg,ca.MEM_DEVICE)
	MnMx = ca.MinMax(im) 
	
	if not LowT:
		LowT = MnMx[0]
	if not HighT:
		HighT = MnMx[1] 

	if HighT or LowT: 
		se = common.AsNPCopy(s)
		npim = common.AsNPCopy(im) 
		segHoles = np.where( npim < HighT , 1, 0)
		total_seg = np.logical_and(se,segHoles)
		incompressible = np.where( npim > LowT, 1, 0)
		total_seg1 = np.logical_and(total_seg,incompressible)

		newseg = common.ImFromNPArr(total_seg1,ca.MEM_DEVICE)
		newseg.setGrid(grid)
	else:
		newseg = s

	WriteMHA(newseg,Out_seg)