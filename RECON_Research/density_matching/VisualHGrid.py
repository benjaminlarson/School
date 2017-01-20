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
import fire # import matplotlib


# def plotd(detDphi, phi, inx):
# 	print "PlotJacDiff"

# 	phi_ax = cd.Disp3Pane(phi, title='New Diff', sliceIdx=inx, disp = False)
# 	cd.DispImage(phi_ax) 
# 	Dphi_ax = cd.Disp3Pane(detDphi,rng = [0.5,1.5], title='Jacobian Determinant', cmap='jet', 
# 		colorbar=True, sliceIdx=inx, bgval=1.0, disp = False)
# 	cd.DispImage(Dphi_ax) 
	
# 	# plt.hold(True)
# 	# plt.subplot(2,3,1)
# 	# cd.DispImage(phi_ax,dim ='x',sliceIdx = i[0],title='x%s'%i[0])
# 	# plt.subplot(2,3,2)
# 	# cd.DispImage(phi_ax,dim='y',sliceIdx = i[1],title='y%s'%i[1])
# 	# plt.subplot(2,3,3)
# 	# cd.DispImage(phi_ax,dim='z',sliceIdx = i[2],title='z%s'%i[2])
# 	# plt.subplot(2,3,4)
# 	# cd.DispImage(dphi_ax,dim ='x',sliceIdx = i[0],title='x%s'%i[0],cmap='jet')
# 	# plt.subplot(2,3,5)
# 	# cd.DispImage(dphi_ax,dim='y',sliceIdx = i[1],title='y%s'%i[1],cmap='jet')
# 	# plt.subplot(2,3,6) 
# 	# cd.DispImage(dphi_ax,dim='z',sliceIdx = i[2],title='z%s'%i[2],cmap='jet')
	
# 	cd.Disp3Pane(phi, title='New Diff', sliceIdx=inx, disp = False)
# 	cd.Disp3Pane(detDphi,rng = [0.5,1.5], title='Jacobian Determinant', cmap='jet', 
# 		colorbar=True, sliceIdx=inx, bgval=1.0, disp = False)
# 	plt.show() 

# i = [192,148,90]
# path = '/home/sci/benl/Data_DIR/Circular/'

# phiList = reversed(['T01','T02','T03','T04','T05','T06','T07','T08','T09'])
# ### Phi 
# for f in phiList:
# 	phi = cc.LoadMHA(path+'case01_'+f+'Images/phicase01_'+f)

# 	cd.DispHGrid(phi,dim ='x',sliceIdx = i[0],title='x%s'%i[0])
# 	plt.savefig(path+'dispGrids/phicase01_'+f+'_x')

# 	cd.DispHGrid(phi,dim='y',sliceIdx = i[1],title='y%s'%i[1])
# 	plt.savefig(path+'dispGrids/phicase01_'+f+'_y')

# 	cd.DispHGrid(phi,dim='z',sliceIdx = i[2],title='z%s'%i[2])
# 	plt.savefig(path+'dispGrids/phicase01_'+f+'_z')

# ### Determinant of Jacobian 
# dphi = cc.LoadMHA(path+'detPhicase01_T09')
# cd.DispImage(dphi,dim ='x',sliceIdx = i[0],title='x%s'%i[0],cmap='jet',colorbar=True)
# cd.DispImage(dphi,dim='y',sliceIdx = i[1],title='y%s'%i[1],cmap='jet',colorbar=True)
# cd.DispImage(dphi,dim='z',sliceIdx = i[2],title='z%s'%i[2],cmap='jet',colorbar=True)

fire.GenVideo.MakeVideoFromFiles('/home/sci/benl/Data_DIR/Circular/dispGrids/z/phi_z',
								'/home/sci/benl/Data_DIR/Circular/dispGrids/z/', fps = 1)