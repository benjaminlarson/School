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

def startAlgBatch(im2,im1,path1,path2):
	#PEAK INHALE 
	print "Main" 
	I_f = cc.LoadMHA(im1)
	I_m = cc.LoadMHA(im2)
	print I_f
	print I_m

	print "-----------------------------------"
	# I_0 = cc.Downsample(I_0,2)
	I_1 = cc.Downsample(I_f,2)

	print "-----------------------------------"
	print "after ds,filter", I_m
	print "after ds,filter", I_1

	ca.Sqrt_I(I_m)
	ca.Sqrt_I(I_1)

	inx = [100,170,60] # index for slice viewing

	grid = I_m.grid()
	mType = ca.MEM_DEVICE
	I_m.toType(ca.MEM_DEVICE)
	I_1.toType(ca.MEM_DEVICE)

	tmpIn  = ca.Image3D(grid,mType)
	tmpYval = [0.1,10.0]
	ca.SetMem(tmpIn,1.0)
	print "CHECK",I_m
	print "CHECK2",I_1
	print "CHECK3",tmpIn
	hdmi.sig_threshold(tmpIn, I_m, 0.33,0.01,tmpYval)
	# print "WHERE ARE NANS", ca.MinMax(I_m)
	# print "WHERE ARE NANS", ca.MinMax(I_1)
	print "INPUT IMAGES I0", I_m
	print "INPUT IMAGES I1", I_1

	# phi, Idef, energy, detDphi, scratchI, diff \
	# 	 = hdmi.HalfDenMatch(I_m, I_1, tmpIn, nIters=10, step=0.1, sigma=0.1, plot=True, im1=im1,im2=im2,path1=path1,path2=path2)
	phi, Idef, energy, detDphi, diff \
		 = hdmi.HalfDenMatch(I_m, I_1, tmpIn, nIters=500, step=0.1, sigma=0.1, plot=True, im1=im1,im2=im2,path1=path1,path2=path2)

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

matches_f = []
matches_m = []

for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/','*Fixed.mhd')):
	matches_f.append(filename)
for filename in glob.glob(os.path.join('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Rigid/','*Moving.mha.mha')):
	matches_m.append(filename)


matches_f.sort()
matches_m.sort() 

imgroup = []
pat_group =[]

[imgroup.append(i) for i in zip(matches_f,matches_m)]

# print imgroup


for i in imgroup:
	print i 
# sys.exit() 
for im,im2 in zip(matches_f, matches_m):

	path = os.path.split(im)
	path2 = os.path.split(im2)

	print im,im2
	plt.close('all') 
	startAlgBatch(im2,im, 
		'/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/RigidFirst/Results'+path[1],
		'/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/RigidFirst/Results'+path2[1])