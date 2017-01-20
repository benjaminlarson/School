# import matplotlib
# matplotlib.use('TkAgg',warn=False)
import matplotlib.pyplot as plt
import PyCAApps as apps 
import PyCACalebExtras.Common as cc
import PyCACalebExtras.Display as cd
import PyCA.Core as ca
import PyCA.Common as common 
import numpy as np
import sys
import time
import glob
import os 

def plotjacdiff(scratchI, diff, detDphi, tmpIn, inx, yval):
	print "PlotJacDiff"
	rng = ca.MinMax(scratchI)
	ax_scratch = cd.Disp3Pane(scratchI, title='orig diff', rng=rng,sliceIdx=inx, disp=False) 
	ax_diff = cd.Disp3Pane(diff, title='New Diff', rng=rng, sliceIdx=inx, disp = False)
	ax_detDphi= cd.Disp3Pane(detDphi,rng = [0.5,1.5], title='Jacobian Determinant', cmap='jet', 
		colorbar=True, sliceIdx=inx, bgval=1.0, disp = False)
	ax_tmpIn = cd.Disp3Pane(tmpIn,colorbar=True, sliceIdx=inx, disp = False) 
	
	plt.subplot(2,2,1)
	cd.DispImage(ax_scratch, rng = [-0.5, 0.5],title='Orig Diff', colorbar=True, newFig=False)
	plt.hold(True)
	plt.subplot(2,2,2)
	cd.DispImage(ax_diff, rng = [-0.5, 0.5],title='newDiff', colorbar=True, newFig=False)
	plt.subplot(2,2,3)
	cd.DispImage(ax_detDphi,title= 'jacdet', cmap='jet', colorbar=True, newFig=False) 	
	plt.subplot(2,2,4)
	cd.DispImage(ax_tmpIn, rng=yval, title = "Weighted Image5", cmap='jet',
		colorbar = True, sliceIdx = 80, newFig = False)
	# plt.subplot(2,3,4)
	# fyr.GridPlot(phi, I0, sliceIdx= inx[0],
	#     plotBase = False, every =2, isVF=False)
	plt.show(block = True) 


def filterIm(i1): 
	print "BFILTER", i1
	cd.DispImage(i1,dim='y') 
	g = ca.GaussianFilterGPU()
	grid = i1.grid() 

	scratch = ca.Image3D(grid, ca.MEM_DEVICE) 
	# g.updateParams(grid.size(), ca.Vec3Df(.7, .7, 0.0), ca.Vec3Di(2, 2, 1))
	print "GRID", grid 
	g.updateParams(grid.size(), ca.Vec3Df(.7,.7,.7), ca.Vec3Di(2,2,2))#self, size, sig, kRad
	g.filter(scratch, i1, scratch)
	ca.Copy(i1, scratch)
	cd.DispImage(i1,dim='y') 
	print "AFILTER", i1 
	return i1

def startAlgBatch(im1,im2,path1,path2):
	#PEAK INHALE 
	print "Main" 
	cc.SelectPyCAGPU(1) 
	I_0 = cc.LoadMHA(im1)
	I_1 = cc.LoadMHA(im2)

	# I_0.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	# I_1.setSpacing(ca.Vec3Df(1.0,1.0,1.0))

	ca.DivC_I(I_0,1000)
	ca.DivC_I(I_1,1000) 
	print I_0
	print I_1
	print "-----------------------------------"

	# ca.Sqrt_I(I_0)
	# ca.Sqrt_I(I_1)


	grid = I_1.grid()
	mType = ca.MEM_DEVICE


	I_0.toType(ca.MEM_DEVICE)
	I_1.toType(ca.MEM_DEVICE)

	showWhere = [int(round(I_0.size().z/2)),int(round(I_0.size().y/2)),int(round(I_0.size().x/3))]
	print showWhere

	tmpIn  = ca.Image3D(grid,mType)
	tmpYval = [1.0,10.0]
	ca.SetMem(tmpIn,1.0)
	apps.sig_threshold(tmpIn, I_0, 0.8, 0.005,tmpYval) 
	print "WHERE ARE NANS", ca.MinMax(I_0)
	print "WHERE ARE NANS", ca.MinMax(I_1)
	print "TMPIN ", ca.MinMax(tmpIn)
	# cd.DispImage(I_0,   cmap='jet',colorbar=True,dim='y', sliceIdx=70)
	# cd.DispImage(tmpIn, cmap='jet',colorbar=True,dim='y', sliceIdx=70)

	# I_0 = cc.Downsample(I_0,2) 
	# I_1 = cc.Downsample(I_1,2)
	# tmpIn=cc.Downsample(tmpIn,2)
	# I_0.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	# I_1.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	I_0=cc.ResampleToSize(I_0,ca.Vec3Di(248,248,235))
	I_1=cc.ResampleToSize(I_1,ca.Vec3Di(248,248,235))
	tmpIn=cc.ResampleToSize(tmpIn,ca.Vec3Di(248,248,235)) 

	cd.DispImage(I_0,   cmap='jet',colorbar=True,dim='x', sliceIdx=70)
	cd.DispImage(tmpIn, cmap='jet',colorbar=True,dim='x', sliceIdx=70)
	print "-----------------------------------"
	print "after ds,filter", I_0, ca.MinMax(I_0)
	print "after ds,filter", I_1, ca.MinMax(I_1)


	sys.exit()
	st = 5e-3
	sig = 0.5
	Idef,phi ,energy,detDphi,diff,scratchI \
		 = apps.HalfDenMatch(I_0, I_1, tmpIn, nIters=100, step=st, sigma=sig, plot=False)

	newpathim = os.path.split(im1) 
	newdirim = os.path.split(newpathim[0]) #first of tuple
	newpaths = os.path.split(im2) 
	newdirs = os.path.split(newpaths[0]) #first of tuple

	# print newpathim, newpaths[1] 
	# print newdirim, newdirim[1][:-4] #scans
	# print newpaths, newpaths[1]
	# print newdirs , newdirs[1][:-4]

	path = '/home/sci/benl/Data_DIR/one_five/Results/' + 'step_'+'%e'%st + 'sig_'+'%e'%sig

	plt.close('all')
	if not os.path.exists(path+newpathim[1][:-4]):
		os.makedirs(path+newpathim[1][:-4])
	if not os.path.exists(path+newpathim[1][:-4]+'Images/'):
		os.makedirs(path+newpathim[1][:-4]+'Images/')

	cc.WriteMHA(phi, path+newpathim[1][:-4]+'Images/phi'+os.path.split(im1)[1])
	cc.WriteMHA(detDphi, path+newpathim[1][:-4]+'Images/detPhi'+os.path.split(im1)[1])
	cc.WriteMHA(diff, path+newpathim[1][:-4]+'Images/diff'+os.path.split(im1)[1])
	cc.WriteMHA(scratchI, path+newpathim[1][:-4]+'Images/scratchI'+os.path.split(im1)[1])
	cc.WriteMHA(Idef, path+newpathim[1][:-4]+'Images/Idef'+os.path.split(im1)[1])
	
	cd.Disp3Pane(tmpIn,title = "penalty",rng=[0,10],cmap ='jet',colorbar=True, sliceIdx=showWhere)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'penalty')

	cd.EnergyPlot(energy, legend=['Regularization', 'Data Match', 'Total'])
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'energy')

	ca.Sub(scratchI, I_0, I_1)
	rng = ca.MinMax(scratchI)
	cd.Disp3Pane(scratchI, title='Orig Diff',colorbar=True, sliceIdx=showWhere, rng=rng)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'origDiff')
	
	cd.Disp3Pane(diff,title='NewDiff',colorbar=True,  sliceIdx=showWhere, rng = rng)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'newDiff')

	cd.Disp3Pane(detDphi, title='Jacobian Determinant', cmap='jet', colorbar=True, bgval=1.0, sliceIdx=showWhere)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'jacDet')

	cd.DispHGrid(phi, dim = 'y',splat=False,sliceIdx = phi.size().y/2)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'phi')
	
	landmarks0 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T00_corr.npy')
	landmarks5 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T05_corr.npy')
	
	phi.toType(ca.MEM_HOST) 

	plt.figure() 
	diff_def = []

	for lm, lm5 in zip(landmarks0, landmarks5):
		print "in for"
		print lm
		print lm5 
		print phi 
		print I_0.spacing().x, I_0.spacing().y, I_0.spacing().z 
		InPhi = phi.get(lm[0],lm[1],lm[2])
		print InPhi
		d = np.sqrt((I_0.spacing().x*(round(InPhi.x) - lm5[0]))**2 + \
					(I_0.spacing().y*(round(InPhi.y) - lm5[1]))**2 + \
					(I_0.spacing().z*(round(InPhi.z) - lm5[2]))**2) 
		diff_def.append(np.array(d,dtype=float)) 
		print "end for" 
	x = range(0,len(diff_def))
	print "plot error"
	plt.figure() 

	plt.scatter(x,diff_def,c='g')
	plt.title('Phi(landmark0) vs landmark5, in millimeters')
	plt.axhline(np.mean(diff_def),label='Mean = %s std = %s'%(np.mean(diff_def),np.std(diff_def)))
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	          fancybox=True, shadow=True, ncol=5) 
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'Error')
	print "Diff Landmarks", np.mean(diff_def, dtype=np.float64),np.std(diff_def,dtype=np.float64) 

# i1 = '/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/01_Fixed.mhd'
# i2 = '/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/01_Moving.mhd'
# path1 ='/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Phi/'
# path2 ='/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Phi/'
# startAlgBatch(i1,i2,path1,path2) 
# sys.exit("done with single image") 

# print "starting"

# matches_i = []
# matches_seg = []

# path = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images' 
# for filename in glob.glob(os.path.join(path,'*.mha')):
# 	matches_i.append(filename)

# matches_i.sort()
# matches_seg.sort()  

# imgroup = []
# pat_group =[]

# [imgroup.append(i) for i in zip(matches_i,matches_seg)]

# print imgroup

# for f,m in zip(matches_i[0:],matches_i[1:]):
# 	im  = f
# 	im2 = m 
# 	path = os.path.split(im)
# 	path2 = os.path.split(im2)

# 	print f
# 	print m 
# 	print im,im2
# 	print path, path2
	
# 	# sys.exit() 
# 	plt.close('all') 
# 	# im2= source, im = target 
# 	startAlgBatch(im2,im, 
# 		'/home/sci/benl/Data_DIR/First/Results'+path[1],
# 		'/home/sci/benl/Data_DIR/First/Results'+path2[1])

im  = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T00.mha'
im2 = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T05.mha'
path = os.path.split(im)
path2 = os.path.split(im2)

startAlgBatch(im2,im,
	'/home/sci/benl/Data_DIR/one_five/Results'+path[1],
	'/home/sci/benl/Data_DIR/one_five/Results'+path2[1])
