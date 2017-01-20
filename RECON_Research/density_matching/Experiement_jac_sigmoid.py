##jac determinant and sigmoid penalty test 
import HalfDenMatchImage as hdmi 
import matplotlib
matplotlib.use('TkAgg')
import fire as fyr 
import PyCACalebExtras.Common as cc
import PyCACalebExtras.Display as cd
import PyCA.Core as ca
import PyCA.Common as common 
import PyCA.Display as display 
import matplotlib.pyplot as plt
import numpy as np
import sys
import time

def plotjacdiff(scratchI, diff, detDphi, tmpIn, inx, yval):
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

def FreeMemFilter(Im):
    grid = Im.grid()
    mType = ca.MEM_DEVICE
    scratch = ca.Image3D(grid, mType)
    g = ca.GaussianFilterGPU()
    g.updateParams(grid.size(), ca.Vec3Df(.7, .7, 0.0), ca.Vec3Di(2, 2, 1))
    g.filter(scratch, Im, scratch)
    ca.Copy(Im, scratch)
    ca.Sqrt_I(Im)
    return Im 

def main():
    #PEAK INHALE 
    I_0 = cc.LoadMHA('/home/sci/benl/Anonymized-ForUtah-Aug18-2015/EndExhaleCT/endExhale_la_i.mha')
    # orig0 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT1/PT1_round2/images_lacoeff/1la.mha')
    # orig0 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT2/PT2/lacoeff/1la.mha')
    # orig0 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT3/PT3/lacoeff/1la.mha')

    # #PEAK EXHALE 

    # orig1 = cc.LoadMHA('/home/sci/benl/Anonymized-ForUtah-Aug18-2015/FreeBreathingCT/freebreathing_la_i.mha')
    I_1 = cc.LoadMHA('/home/sci/benl/Anonymized-ForUtah-Aug18-2015/Sept3_bh_ex/breathHold_la_i.mha')
    # orig1 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT1/PT1_round2/images_lacoeff/6la.mha')
    # orig1 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT2/PT2/lacoeff/6la.mha')
    # orig1 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT3/PT3/lacoeff/6la.mha')

    # I0 = cc.Downsample(orig0,2)
    # I1 = cc.Downsample(orig1,2)

    # I0 = cc.Downsample(I0,2)
    # I1 = cc.Downsample(I1,2)
    """FOR Anonymized-ForUtah-Aug18-2015 ONLY"""

    # I0 = fyr.crop_im(orig0,36,472,147,400,1,145, plot=False) 
    # I1 = fyr.crop_im(orig1,36,472,147,400,1,145, plot=False)

    # sys.exit("stop")

    """FOR PATIENT 1 ONLY"""
    # I0 = fyr.crop_im(orig0,80,430,33,349,1,138, plot=False) 
    # I1 = fyr.crop_im(orig1,80,430,33,349,1,138, plot=False)
    """FOR PATIENT 2 ONLY"""
    # I0 = fyr.crop_im(orig0,83,440,100,370,1,216, plot=False) 
    # I1 = fyr.crop_im(orig1,83,440,100,370,1,216, plot=False)
    """FOR PATIENT 3 ONLY"""
    # I0 = fyr.crop_im(orig0,66,430,94,349,1,216, plot=False) 
    # I1 = fyr.crop_im(orig1,66,430,94,349,1,216, plot=False)

  	## pt 1
    inx = [60,170,170]
    #pt1downsampled
    # inx = [68/2,226/2,316/2]
    ## pt 2
    # inx = [83,100,136]
    ##pt3
    # inx = [110,135,238]

    grid = I_1.grid()
    mType = ca.MEM_DEVICE
    I1 = FreeMemFilter(I_1)
    I0 = FreeMemFilter(I_0)

###########################
    # grid = I0.grid()
    # mType = ca.MEM_DEVICE
    # scratch1 = ca.Image3D(grid, mType)
    # scratch2 = ca.Image3D(grid, mType)
    # g = ca.GaussianFilterGPU()
    # g.updateParams(grid.size(), ca.Vec3Df(.7, .7, 0.0), ca.Vec3Di(2, 2, 1))
    # g.filter(scratch1, I0, scratch1)
    # ca.Copy(I0, scratch1)
    # g.filter(scratch2, I1, scratch2)
    # ca.Copy(I1, scratch2)
    # print 'full density'
    # print ca.Sum(I0)
    # print ca.Sum(I1)
    # ca.Sqrt_I(I0)
    # ca.Sqrt_I(I1)
    # print 'half density'
    # print ca.Sum(I0)
    # print ca.Sum(I1)
#########################
    tmpIn  = ca.Image3D(grid,mType)

    # tmpIn2 = ca.Image3D(grid,mType)
    tm2yval = [0.1,10.0]
    # hdmi.sig_threshold(tmpIn2, I0, 0.4,0.01,tm2yval) 

    ca.SetMem(tmpIn,1.0)

    phi, Idef, energy, detDphi, scratchI, diff \
    	 = hdmi.HalfDenMatch(I0, I1, None, nIters=10, step=.01, sigma=0.1)
    plotjacdiff(scratchI, diff,detDphi, tmpIn, inx, tm2yval)

    # df1 =  fyr.Histogram(diff,rng=None, bins = 10)
    # scI1 = fyr.Histogram(scratchI,rng=None, bins = 10)
    # plt.figure()
    # plt.semilogy(df[1],df[0],color='b',label=('newdiff'))
    # plt.plot(hold =True) 
    # plt.semilogy(scI[1],scI[0],color= 'r',label=('orgdiff'))
    # plt.legend(loc = 'upper right', prop = {'size':'10'}) 
    # plt.show(block= True) 

##########################
    # phi, Idef, energy, detDphi, scratchI, diff \
    # 	 = hdmi.HalfDenMatch(I0, I1, tmpIn2, nIters=10, step=.01, sigma=0.1)
    # plotjacdiff(scratchI, diff,detDphi, tmpIn2, inx, tm2yval)
########################
    # phi, Idef, energy, detDphi, scratchI, diff \
    # 	 = hdmi.HalfDenMatch(I0, I1, tmpIn3, nIters=500, step=.01, sigma=.1)
    # plotjacdiff(scratchI, diff,detDphi, tmpIn3, inx, tm3yval)

    # phi, Idef, energy, detDphi, scratchI, diff \
    # 	 = hdmi.HalfDenMatch(I0, I1, tmpIn4, nIters=500, step=.01, sigma=.1)
    # plotjacdiff(scratchI, diff,detDphi, tmpIn4, inx, tm2yval)

    # phi, Idef, energy, detDphi, scratchI, diff \
    # 	 = hdmi.HalfDenMatch(I0, I1, tmpIn5, nIters=500, step=.01, sigma=.1)
    # plotjacdiff(scratchI, diff,detDphi, tmpIn5, inx, tm5yval)

    # phi, Idef, energy, detDphi, scratchI, diff \
    # 	= hdmi.HalfDenMatch(I0, I1, tmpIn6, nIters=500, step=.01, sigma=.1)
    # plotjacdiff(scratchI, diff,detDphi, tmpIn6, inx, tm6yval)

 
    # cd.EnergyPlot(energy, legend=['Regularization', 'Data Match', 'Total'])
    # df =  fyr.Histogram(diff,rng=None, bins = 10)
    # scI = fyr.Histogram(scratchI,rng=None, bins = 10)
    # plt.figure()
    # plt.semilogy(df[1],df[0],color='b',label=('newdiff'))
    # plt.semilogy(df1[1],df1[0],color='b--',label=('newdiff_penalty'))
    # plt.plot(hold =True) 
    # plt.semilogy(scI[1],scI[0],color= 'r',label=('orgdiff'))
    # plt.semilogy(scI1[1],scI1[0],color= 'r--',label=('orgdiff_penalty'))
    # plt.legend(loc = 'upper right', prop = {'size':'10'}) 
    # plt.show(block= True) 

if __name__ == '__main__':

    print "Half Den Matching"
    main()