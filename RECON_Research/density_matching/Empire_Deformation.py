# import matplotlib
# matplotlib.use('TkAgg',warn=False)
import matplotlib.pyplot as plt
import newHDMI as hdmi 
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
	I_0 = cc.LoadMHA(im1)
	I_1 = cc.LoadMHA(im2)
	print I_0
	print I_1


	print "-----------------------------------"
	# I_0 = filterIm(I_0) 
	# I_1 = filterIm(I_1)

	I_0 = cc.Downsample(I_0,2) 
	I_1 = cc.Downsample(I_1,2) 
	print "-----------------------------------"
	print "after ds,filter", I_0
	print "after ds,filter", I_1

	ca.Sqrt_I(I_0)
	ca.Sqrt_I(I_1)

	inx = [100,170,170] # index for slice viewing 

	grid = I_1.grid()
	mType = ca.MEM_DEVICE
	I_0.toType(ca.MEM_DEVICE)
	I_1.toType(ca.MEM_DEVICE)


	# diffOp = ca.FluidKernelFFTGPU()
	# diffOp.setGrid(grid)


	tmpIn  = ca.Image3D(grid,mType)
	tmpYval = [0.1,10.0]
	ca.SetMem(tmpIn,1.0)
	hdmi.sig_threshold(tmpIn, I_0, 0.33,0.01,tmpYval) 
	print "WHERE ARE NANS", ca.MinMax(I_0)
	print "WHERE ARE NANS", ca.MinMax(I_1)

	phi, Idef, energy, detDphi, scratchI, diff \
		 = hdmi.HalfDenMatch(I_0, I_1, tmpIn, nIters=1000, step=0.1, sigma=0.1, plot=True, im1=im1,im2=im2,path1=path1,path2=path2)

	# plotjacdiff(scratchI, diff,detDphi, tmpIn, inx, tmpYval)

	# ax_tmpIn = cd.Disp3Pane(tmpIn,colorbar=True, sliceIdx=inx, disp = False) 
	# cd.DispImage(ax_tmpIn, rng=tmpYval, title = "Weighted Image5", cmap='jet',
	# 	colorbar = True, sliceIdx = 80, newFig = False)

# i1 = '/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/01_Fixed.mhd'
# i2 = '/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/01_Moving.mhd'
# path1 ='/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Phi/'
# path2 ='/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Phi/'
# startAlgBatch(i1,i2,path1,path2) 
# sys.exit("done with single image") 

print "starting"

matches_i = []
matches_seg = []

for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/','*Fixed.mhd')):
	matches_i.append(filename)
for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/','*Moving.mhd')):
	matches_i.append(filename)

for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Masks','*Fixed.mhd')):
	matches_seg.append(filename)
for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Masks','*Moving.mhd')):
	matches_seg.append(filename)

matches_i.sort()
matches_seg.sort()  

imgroup = []
pat_group =[]

[imgroup.append(i) for i in zip(matches_i,matches_seg)]

# print imgroup

for f,m in zip(imgroup[0::2],imgroup[1::2]):
	im  = f[0]
	im2 = m[0] 
	path = os.path.split(im)
	path2 = os.path.split(im2)

	print f
	print m 
	print im,im2
	print path, path2
	
	startAlgBatch(im2,im, 
		'/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Results'+path[1],
		'/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Results'+path2[1])