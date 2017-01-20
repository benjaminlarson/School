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
import fire 

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

def startAlgBatch(imS,imT,imSpath, imTpath,path1,path2):
	#PEAK INHALE 
	print "Main" 
	# cc.SelectPyCAGPU(1) 
	# imS = cc.LoadMHA(imSp)
	# imT = cc.LoadMHA(imTp)
	# imS.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	# imT.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	# ca.DivC_I(imS,1000)

	# ca.Sqrt_I(imS)
	# ca.Sqrt_I(imT)

	grid = imT.grid()
	mType = ca.MEM_DEVICE

	imS.toType(ca.MEM_DEVICE)
	imT.toType(ca.MEM_DEVICE)

	showWhere = [int(round(imS.size().z/2)),int(round(imS.size().y/2)),int(round(imS.size().x/3))]
	# print showWhere

	tmpIn  = ca.Image3D(grid,mType)
	tmpYval = [0.2,8.0]
	ca.SetMem(tmpIn,1.0)
	apps.sig_threshold(tmpIn, imS, 0.8, 0.005,tmpYval) 
	# print "WHERE ARE NANS", ca.MinMax(imS)
	# print "WHERE ARE NANS", ca.MinMax(imT)
	# print "TMPIN ", ca.MinMax(tmpIn)
	cd.DispImage(imS,   cmap='jet',colorbar=True,dim='y', sliceIdx=70)
	cd.DispImage(tmpIn, cmap='jet',colorbar=True,dim='y', sliceIdx=70)
	
	# imS = cc.Downsample(imS,2) 
	# imT = cc.Downsample(imT,2)
	# tmpIn=cc.Downsample(tmpIn,2)
	# imS.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	# imT.setSpacing(ca.Vec3Df(1.0,1.0,1.0))
	# imS=cc.ResampleToSize(imS,ca.Vec3Di(248,248,235))
	# imT=cc.ResampleToSize(imT,ca.Vec3Di(248,248,235))
	# tmpIn=cc.ResampleToSize(tmpIn,ca.Vec3Di(248,248,235)) 

	# cd.DispImage(imS,   cmap='jet',colorbar=True,dim='x', sliceIdx=70)
	# cd.DispImage(tmpIn, cmap='jet',colorbar=True,dim='x', sliceIdx=70)
	# print "-----------------------------------"
	# print "after ds,filter", imS, ca.MinMax(imS)
	# print "after ds,filter", imT, ca.MinMax(imT)


	st = 5e-3
	sig = 1.0
	Idef,phi ,energy,detDphi,diff,scratchI \
		 = apps.HalfDenMatch(imS, imT, tmpIn, nIters=1000, step=st, sigma=sig, plot=False)

	newpathim = os.path.split(imTpath) 
	newdirim = os.path.split(newpathim[0]) #first of tuple
	newpaths = os.path.split(imSpath) 
	newdirs = os.path.split(newpaths[0]) #first of tuple

	# print"121", newpathim, newpaths[1] 
	# print"122", newdirim, newdirim[1][:-4] #scans
	# print"123", newpaths, newpaths[1]
	# print"124", newdirs , newdirs[1][:-4]

	savepath = os.path.split(path1) 
	# print "savepath_127", savepath[0], savepath[1]
	path = savepath[0]+'/'
	# print "path_127", path 

	plt.close('all')
	if not os.path.exists(path+newpathim[1][:-4]):
		os.makedirs(path+newpathim[1][:-4])
	if not os.path.exists(path+newpathim[1][:-4]+'Images/'):
		os.makedirs(path+newpathim[1][:-4]+'Images/')

	cc.WriteMHA(imT, path+newpathim[1][:-4]+'Images/target'+os.path.split(imTpath)[1])
	cc.WriteMHA(phi, path+newpathim[1][:-4]+'Images/phi'+os.path.split(imTpath)[1])
	cc.WriteMHA(detDphi, path+newpathim[1][:-4]+'Images/detPhi'+os.path.split(imTpath)[1])
	cc.WriteMHA(diff, path+newpathim[1][:-4]+'Images/diff'+os.path.split(imTpath)[1])
	cc.WriteMHA(scratchI, path+newpathim[1][:-4]+'Images/scratchI'+os.path.split(imTpath)[1])
	cc.WriteMHA(Idef, path+newpathim[1][:-4]+'Images/Idef'+os.path.split(imTpath)[1])
	
	cd.Disp3Pane(tmpIn,title = "penalty",rng=[0,10],cmap ='jet',colorbar=True, sliceIdx=showWhere)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'penalty')

	cd.EnergyPlot(energy, legend=['Regularization', 'Data Match', 'Total'])
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'energy')

	ca.Sub(scratchI, imS, imT)
	rng = ca.MinMax(scratchI)
	cd.Disp3Pane(scratchI, title='Orig Diff',colorbar=True, sliceIdx=showWhere, rng=rng)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'origDiff')
	
	cd.Disp3Pane(diff,title='NewDiff',colorbar=True,  sliceIdx=showWhere, rng = rng)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'newDiff')

	cd.Disp3Pane(detDphi, title='Jacobian Determinant', cmap='jet', colorbar=True, bgval=1.0, sliceIdx=showWhere)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'jacDet')

	cd.DispHGrid(phi, dim = 'y',splat=False,sliceIdx = phi.size().y/2)
	plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'phi')
	return phi, detDphi
	# landmarks0 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T00_corr.npy')
	# landmarks5 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T05_corr.npy')
	
	# phi.toType(ca.MEM_HOST) 

	# plt.figure() 
	# diff_def = []

	# for lm, lm5 in zip(landmarks0, landmarks5):
	# 	print "in for"
	# 	print lm
	# 	print lm5 
	# 	print phi 
	# 	print I_0.spacing().x, I_0.spacing().y, I_0.spacing().z 
	# 	InPhi = phi.get(lm[0],lm[1],lm[2])
	# 	print InPhi
	# 	d = np.sqrt((I_0.spacing().x*(round(InPhi.x) - lm5[0]))**2 + \
	# 				(I_0.spacing().y*(round(InPhi.y) - lm5[1]))**2 + \
	# 				(I_0.spacing().z*(round(InPhi.z) - lm5[2]))**2) 
	# 	diff_def.append(np.array(d,dtype=float)) 
	# 	print "end for" 
	# x = range(0,len(diff_def))
	# print "plot error"
	# plt.figure() 

	# plt.scatter(x,diff_def,c='g')
	# plt.title('Phi(landmark0) vs landmark5, in millimeters')
	# plt.axhline(np.mean(diff_def),label='Mean = %s std = %s'%(np.mean(diff_def),np.std(diff_def)))
	# plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	#           fancybox=True, shadow=True, ncol=5) 
	# plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'Error')
	# print "Diff Landmarks", np.mean(diff_def, dtype=np.float64),np.std(diff_def,dtype=np.float64) 

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

def composeListPhi(phi):
	# Phi is a list  
	grid = phi[0].grid()
	mType = phi[0].memType()
	scratchF = ca.Field3D(grid,mType)
	h = ca.Field3D(grid, mType)
	ca.SetToIdentity(h)
	for p in phi:
		ca.ComposeHH(scratchF, h, p)
		h.swap(scratchF)
	return h 

	################## im1->im2->im3->im4->im5->im6->im7->im8->im9 
def find_I_def(S_im, phiList, detPhiList): 
	#detPhiList must be in sequential order.. im1,im2,im3,... 
	# S_im is the source
	grid = S_im.grid() 
	mType = S_im.memType() 
	tmpS = ca.Image3D(grid, mType)

	#### find I deformed ####
	phi = composeListPhi(phiList) 
	ca.ApplyH(tmpS, S_im, phi, ca.BACKGROUND_STRATEGY_CLAMP)
	
	#### find jacDet #### [-1], remove last element from list 
	det_f = detPhiList[-1]  
	detPhiList = detPhiList[0:-1]
	tmpD = ca.Image3D(grid,mType)
	total_det = ca.Image3D(grid,mType) 

	for det_i in detPhiList:
		p = composeListPhi(phiList)
		ca.ApplyH(tmpD, det_i, p, ca.BACKGROUND_STRATEGY_CLAMP)
		ca.Mul_I(tmpS,tmpD)
		phiList = phiList[0:-1]
		ca.Mul_I(total_det,tmpD) 

	return [tmpS,total_det]

def find_Det_composed(det, phiList, detPhiList): 
	#detPhiList must be in sequential order.. im1,im2,im3,... 
	# S_im is the source
	grid = S_im.grid() 
	mType = S_im.memType() 
	tmpS = ca.Image3D(grid, mType)

	#### find I deformed ####
	phi = composeListPhi(phiList) 
	ca.ApplyH(tmpS, S_im, phi, ca.BACKGROUND_STRATEGY_CLAMP)
	
	#### find jacDet #### [-1], remove last element from list
	det_f = detPhiList[-1]  
	detPhiList = detPhiList[0:-1]
	tmpD = ca.Image3D(grid,mType)

	grid = phi[0].grid()
	mType = phi[0].memType()
	scratchF = ca.Field3D(grid,mType)
	h = ca.Field3D(grid, mType)
	ca.SetToIdentity(h)
	for p in phi:
		ca.ComposeHH(scratchF, h, p)
		h.swap(scratchF)

	for det_i in detPhiList:
		p = composeListPhi(phiList)
		ca.ApplyH(tmpD, det_i, p, ca.BACKGROUND_STRATEGY_CLAMP)
		ca.Mul_I(tmpS,tmpD)
		phiList = phiList[0:-1]	

	return tmpS

"""-----------------------------------------------------------------------------------------------------------------------"""
landmarks = 0 
deform = 1
identity = 1

if (deform):
	matches_i = []
	path = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images' 
	for filename in glob.glob(os.path.join(path,'*.mha')):
		matches_i.append(filename)
	matches_i = fire.sorted_nicely(matches_i)
	# im  = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T00.mha'
	# im2 = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T05.mha'

	################## IM0->IM1
	imS0 = cc.LoadMHA(matches_i[0],ca.MEM_HOST)
	imT = cc.LoadMHA(matches_i[1],ca.MEM_HOST)
	# All images should be divided by 1000. This is done after loading target, but not source in startalgbatch.
	# Make sure all images are divided correctly. 
	ca.DivC_I(imS0,1000) 
	ca.DivC_I(imT,1000)
	
	grid = imS0.grid()
	mType = imS0.memType()

	path = os.path.split(matches_i[0])
	path2 = os.path.split(matches_i[1])

	phi,detDphi = startAlgBatch(imS0,imT,matches_i[0],matches_i[1],
		'/home/sci/benl/Data_DIR/Circular/'+path[1],
		'/home/sci/benl/Data_DIR/Circular/'+path2[1])
	phi.toType(ca.MEM_HOST)
	detDphi.toType(ca.MEM_HOST)
	imS0.toType(ca.MEM_HOST)

	phiList = []
	detPhiList = []
	
	phiList.append(phi)
	detPhiList.append(detDphi)

	im_det = find_I_def(imS0, phiList,detPhiList) 
	imS = im_det[0]
	totalDet = im_det[1]
	# imS,totalDet = find_I_def(imS0,phiList,detPhiList)
	cc.WriteMHA(totalDet,'/home/sci/benl/Data_DIR/Circular/Total_determinant/first') 
	cc.WriteMHA(imS,'/home/sci/benl/Data_DIR/Circular/InBetween/First_I01')

	for imSpath, imTpath in zip(matches_i[1:],matches_i[2:]): #iterate every 2nd item
		path = os.path.split(imSpath)
		path2 = os.path.split(imTpath)
		imT = cc.LoadMHA(imTpath,ca.MEM_HOST)
		ca.DivC_I(imT,1000)
		# im2 exhale im inhale1
		# im2 source, im is target
		plt.close('all') 
		print "imS->imT"
		phi, detDphi = startAlgBatch(imS,imT, imSpath, imTpath,
			'/home/sci/benl/Data_DIR/Circular/',
			'/home/sci/benl/Data_DIR/Circular/')
		#change to host, denMatch uses device 
		phi.toType(ca.MEM_HOST)
		detDphi.toType(ca.MEM_HOST)
		imS.toType(ca.MEM_HOST) 
		phiList.append(phi)
		detPhiList.append(detDphi)

		im_det = find_I_def(imS0, phiList,detPhiList) 
		imS = im_det[0]
		totalDet = im_det[1]
		## SOURCE IMAGE AKA DEFORMED AT EACH STEP 
		cc.WriteMHA(imS,'/home/sci/benl/Data_DIR/Circular/InBetween/'+path[1])
		cc.WriteMHA(totalDet,'/home/sci/benl/Data_DIR/Circular/Total_determinant/'+path[1]) 

	imTpath  = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T00.mha'
	imSpath = '/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T09.mha'
	path = os.path.split(imTpath)
	path2 = os.path.split(imSpath)
	
	imT = cc.LoadMHA(imTpath,ca.MEM_HOST)
	ca.DivC_I(imT,1000)
	
	grid = imS.grid()
	mType = imS.memType()

	path = os.path.split(imSpath)
	path2 = os.path.split(imTpath)

	## FIND LAST DEFORMED IMAGE  
	print "-----------Are there 10?----------"
	print len(phiList)
	print "-----------"
	print len(detPhiList)
	# imS = find_I_def(imS,phiList,detPhiList)
	
	phi, detDphi = startAlgBatch(imS,imT,imTpath, imSpath,
		'/home/sci/benl/Data_DIR/Circular/final1/',
		'/home/sci/benl/Data_DIR/Circular/final2/')
	
	phi.toType(ca.MEM_HOST)
	detDphi.toType(ca.MEM_HOST)
	imS.toType(ca.MEM_HOST) 
	grid = imS.grid()
	mType = imS.memType()
	phiList.append(phi) 
	detPhiList.append(detDphi) 	

	im_det = find_I_def(imS0, phiList,detPhiList) 
	imS = im_det[0]
	totalDet = im_det[1]

	cc.WriteMHA(totalDet,'/home/sci/benl/Data_DIR/Circular/Total_determinant/final') 
	cc.WriteMHA(imS,'/home/sci/benl/Data_DIR/Circular/InBetween/case01_T90.mha')

'''---------- LANDMARKS ---------------'''
if (landmarks):
	landmarks0 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T00_corr.npy')
	landmarks5 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T05_corr.npy')


	plt.figure() 

	# sys.exit("find phi path then do this") 
	'''Image Source'''
	iS = cc.LoadMHA('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T04.mha',mType = ca.MEM_HOST)

	# phi.toType(ca.MEM_HOST)
	print "is spacing_333", iS.spacing().x, iS.spacing().y, iS.spacing().z
	#get all phi's from im0:im5
	phi_mactches = []

	phi4 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T04Images/phicase01_T04.mha',mType = ca.MEM_HOST)
	phi3 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T03Images/phicase01_T03.mha',mType = ca.MEM_HOST)
	phi2 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T02Images/phicase01_T02.mha',mType = ca.MEM_HOST)
	phi1 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T01Images/phicase01_T01.mha',mType = ca.MEM_HOST)
	grid = phi1.grid()
	mType = phi1.memType() 

	scratchF = ca.Field3D(grid,mType)
	h = ca.Field3D(grid, mType)
	ca.SetToIdentity(h) 

	for p in reversed([phi1,phi2,phi3,phi4]):
		ca.ComposeHH(scratchF, h, p)
		h.swap(scratchF) 

	diff_def = []
	diff_def0= []
	for lmT, lmS in zip(landmarks5, landmarks0):
		InPhi = h.get(lmT[0],lmT[1],lmT[2])
		d = np.sqrt((iS.spacing().x*(round(InPhi.x) - lmS[0]))**2 + \
					(iS.spacing().y*(round(InPhi.y) - lmS[1]))**2 + \
					(iS.spacing().z*(round(InPhi.z) - lmS[2]))**2) 
		diff_def.append(np.array(d,dtype=float))

		dOrig = np.sqrt((iS.spacing().x*(lmT[0] - lmS[0]))**2 + \
						(iS.spacing().y*(lmT[1] - lmS[1]))**2 + \
						(iS.spacing().z*(lmT[2] - lmS[2]))**2) 
		diff_def.append(np.array(d,dtype=float))
		diff_def0.append(np.array(dOrig,dtype=float)) 
	x = range(0,len(diff_def))
	plt.figure()

	plt.scatter(x,diff_def,c='g')
	plt.title('Phi(landmark0) vs landmark5, in millimeters')
	plt.axhline(np.mean(diff_def),label='Mean = %s std = %s'%(np.mean(diff_def),np.std(diff_def)))
	plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
	          fancybox=True, shadow=True, ncol=5)
	# plt.savefig(path+newpathim[1][:-4]+'/'+newpathim[1][:-4]+'Error')
	print "Diff Landmarks_350", np.mean(diff_def, dtype=np.float64),np.std(diff_def,dtype=np.float64) 
	print "diff origLand", np.mean(diff_def0,dtype=np.float64) 


'''--------------- IDENTITY----------------------'''
if(identity): 
	phiF = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/final1/case01_T09Images/phicase01_T09.mha',mType = ca.MEM_HOST) 
	phi9 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T09Images/phicase01_T09.mha',mType = ca.MEM_HOST)
	phi8 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T08Images/phicase01_T08.mha',mType = ca.MEM_HOST)
	phi7 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T07Images/phicase01_T07.mha',mType = ca.MEM_HOST)
	phi6 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T06Images/phicase01_T06.mha',mType = ca.MEM_HOST)
	phi5 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T05Images/phicase01_T05.mha',mType = ca.MEM_HOST)
	phi4 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T04Images/phicase01_T04.mha',mType = ca.MEM_HOST)
	phi3 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T03Images/phicase01_T03.mha',mType = ca.MEM_HOST)
	phi2 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T02Images/phicase01_T02.mha',mType = ca.MEM_HOST)
	phi1 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/case01_T01Images/phicase01_T01.mha',mType = ca.MEM_HOST)
	grid = phi1.grid()
	mType = phi1.memType() 

	name = 0 
	phiList = list(reversed([phi1,phi2,phi3,phi4,phi5,phi6,phi7,phi8,phi9,phiF]))
	l2_phi = []
	tmp_i = ca.Image3D(grid,mType)
	p = ca.Field3D(grid,mType) 
	iden = ca.Field3D(grid,mType)
	scratch= ca.Field3D(grid,mType) 
	ca.SetToIdentity(iden) 

	for p in phiList:
		ca.Sub(scratch,p,iden)
		ca.SetMem(tmp_i,0.0)
		ca.Magnitude(tmp_i,scratch)
		ca.Sqr_I(tmp_i)
		
		l2 = ca.Sum(tmp_i)
		l2 = np.sqrt(l2)
		l2_phi.append(l2)
		cc.WriteMHA(tmp_i,'/home/sci/benl/Data_DIR/Circular/Diff_Phi/diffPhi_'+str(name)+'.mha')
		name = name+1


	''' Difference between all composed Phi and identity '''

def composeListPhi(phi):
	scratchF = ca.Field3D(grid,mType)
	h = ca.Field3D(grid, mType)
	ca.SetToIdentity(h)

	for p in phi:
		ca.ComposeHH(scratchF, h, p)
		h.swap(scratchF)

	iden = ca.Field3D(grid, mType)
	final = ca.Field3D(grid, mType)
	ca.SetToIdentity(iden)

	ca.Sub(final, h, iden) 
	ca.SetMem(tmp_i,0.0) 
	ca.Magnitude(tmp_i,final)
	# ca.Sqr_I(tmp_i) 
	l2_i = ca.Sum(tmp_i)
	l2_identity = np.sqrt(l2_i)
	
	return tmp_i, l2_identity

	tmpS = ca.Image3D(grid,mType) 
	imS0 = cc.LoadMHA('/home/sci/benl/Data_DIR/MHAImages/Case01/Images/case01_T00.mha') 

	comp1 = composeListPhi(reversed([phi1]))

	# ca.ApplyH(tmpS,imS0,comp1[0],ca.BACKGROUND_STRATEGY_CLAMP) 
	# d1 = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/step_5.000000e-03sig_5.000000e-01case01_T01Images/detPhicase01_T01.mha')
	# ca.Mul_I(tmpS,detDphi)
	# cc.WriteMHA(comp1[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_1.mha')

	# comp2 = composeListPhi(reversed([phi1,phi2]))
	# cc.WriteMHA(comp2[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_2.mha')

	# comp3 = composeListPhi(reversed([phi1,phi2,phi3]))
	# cc.WriteMHA(comp3[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_3.mha')

	# comp4 = composeListPhi(reversed([phi1,phi2,phi3,phi4]))
	# cc.WriteMHA(comp4[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_4.mha')

	# comp5 = composeListPhi(reversed([phi1,phi2,phi3,phi4,phi5]))
	# cc.WriteMHA(comp5[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_5.mha')

	# comp6 = composeListPhi(reversed([phi1,phi2,phi3,phi4,phi5,phi6]))
	# cc.WriteMHA(comp6[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_6.mha')

	# comp7 = composeListPhi(reversed([phi1,phi2,phi3,phi4,phi5,phi6,phi7]))
	# cc.WriteMHA(comp7[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_7.mha')

	# comp8 = composeListPhi(reversed([phi1,phi2,phi3,phi4,phi5,phi6,phi7,phi8]))
	# cc.WriteMHA(comp8[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_8.mha')

	# comp9 = composeListPhi(reversed([phi1,phi2,phi3,phi4,phi5,phi6,phi7,phi8,phi9]))
	# cc.WriteMHA(comp9[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_9.mha')

	# compF = composeListPhi(reversed([phi1,phi2,phi3,phi4,phi5,phi6,phi7,phi8,phi9,phiF]))
	# cc.WriteMHA(compF[0],'/home/sci/benl/Data_DIR/Circular/Diff_Phi/comp_F.mha')
