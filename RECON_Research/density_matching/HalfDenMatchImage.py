# import fire as fyr 
import PyCACalebExtras.Common as cc
import PyCACalebExtras.Display as cd
import PyCA.Core as ca
import PyCA.Common as common 
import PyCA.Display as display 
import matplotlib.pyplot as plt
import numpy as np
import sys
import time
plt.close('all')
# import time
from PrintInfo import printinfo

def lin_threshold(Im_out, Im_in, xval, yval):
    ''' for 3 threshold values, we set:
    I(x) < xval[0] => yval[0]
    xval[0] < I(x) < xval[1] => lin(yval[0], yval[1]
    xval[1] < I(x) < xval[2] => lin(yval[1], yval[2]
    xval[2] < I(x)  => yval[3]
    '''
    x = xval
    y = yval
    ca.SetMem(Im_out, 1.0)
    # lower linear
    tmp = Im_in.copy()
    m = (y[1]-y[0])/(x[1]-x[0])
    tmp *= m
    tmp += -m*x[0]+y[0]
    cc.SetRegionLTE(Im_out, Im_in, xval[1], tmp)
    # upper linear
    ca.Copy(tmp, Im_in)
    m = (y[2]-y[1])/(x[2]-x[1])
    tmp *= m
    tmp += -m*x[1]+y[1]
    cc.SetRegionGTE(Im_out, Im_in, xval[1], tmp)
    # lower threshold
    cc.SetRegionLTE(Im_out, Im_in, xval[0], yval[0])
    # upper threshold
    cc.SetRegionGTE(Im_out, Im_in, xval[2], yval[2])

def sig_threshold(Im_out, Im_in, xcent, halfwidth, yval):
    ''' does a sigmoid soft-thesholding of Im_in

    yval[0] is the low threshold, yval[1] is the high value
    xcent is the center of the threshold'''
    x = xcent
    k = 1/halfwidth/4
    Imdenom = Im_in.copy()
    L = Im_out.copy()
    ca.SetMem(L, yval[1]-yval[0])
    Imdenom -= xcent
    Imdenom *= -k
    ca.Exp_I(Imdenom)
    Imdenom += 1
    ca.Div(Im_out, L, Imdenom)
    Im_out += yval[0]


def HalfDenMatch(I0, I1, penalty=None, nIters=100, sigma=.1, step=.001, plot=True):
    '''Given two half-densities, register them using image weighted divergence metric
    I0 is the penalty image and also the moving image
    sigma is the regularization term'''
    print "HalfDenMatch" 
    mType = I1.memType()
    grid = I1.grid()

    # returned:
    Idef = ca.Image3D(grid, mType)
    phi = ca.Field3D(grid, mType)
    detDphi = ca.Image3D(grid, mType)

    # Internal
    diff = ca.Image3D(grid, mType)
    sdetDphi = ca.Image3D(grid, mType)
    scratchI = ca.Image3D(grid, mType)
    scratchF = ca.Field3D(grid, mType)
    fdef = ca.Image3D(grid, mType)
    v = ca.Field3D(grid, mType)
    # gradI1 = ca.Field3D(grid, mType)

    f = penalty
    ca.SetToIdentity(phi)
    ca.SetMem(sdetDphi, 1.0)
    ca.SetMem(detDphi, 1.0)
    if penalty is None:
        f = ca.Image3D(grid, mType)
        ca.SetMem(f, 1.0)
    ca.Abs_I(f)
    # ca.Gradient(gradI1, I1)
    ca.SetMem(v, 0.0)

    fluidParams = [1.0, 0.0, 0.0]
    if mType == ca.MEM_HOST:
        diffOp = ca.FluidKernelFFTCPU()
    else:
        diffOp = ca.FluidKernelFFTGPU()
    diffOp.setAlpha(fluidParams[0])
    diffOp.setBeta(fluidParams[1])
    diffOp.setGamma(fluidParams[2])
    diffOp.setDivergenceFree(False)
    diffOp.setGrid(grid)
    sizemax = max(grid.size().x, grid.size().y, grid.size().z)

    energy = [[], [], []]

    t = time.time()
    for it in xrange(nIters):
        bg_im = ca.BACKGROUND_STRATEGY_CLAMP
        bg_field = ca.BACKGROUND_STRATEGY_PARTIAL_ID

        # Half-Density Action
        ca.ApplyH(Idef, I0, phi, bg_im)

        Idef *= sdetDphi
        # Idef /= sdetDphi
        ca.Sub(diff, Idef, I1)
        ca.ApplyH(fdef, f, phi, bg_im)

        # Calculate Energy
        ca.Copy(scratchI, sdetDphi)
        scratchI -= 1.0
        ca.Sqr_I(scratchI)
        scratchI *= fdef
        E1 = sigma * ca.Sum(scratchI)
        E2 = ca.Sum2(diff)
        energy[0].append(E1)
        energy[1].append(E2)
        energy[2].append(E1+E2)
        printinfo(it, nIters, energy, verbose=verbose)

        # Calculate Variation
        # term 1 (regularizer)
        ca.Sub(scratchI, sdetDphi, 1.0)
        ca.Neg_I(scratchI)
        scratchI *= fdef
        ca.Gradient(scratchF, scratchI)
        scratchF *= -1.0 * sigma
        ca.Copy(v, scratchF)

        # term 2
        # ca.Mul(scratchF, gradI1, Idef)
        # calculate gradI1 every time to save mem
        ca.Gradient(scratchF, I1)
        scratchF *= Idef

        v -= scratchF

        # term 3
        ca.Gradient(scratchF, Idef)
        scratchF *= I1
        v += scratchF

        mm = ca.MinMax(v)
        if step*max(abs(mm[0]), abs(mm[1])) > sizemax:
            raise OverflowError('v becoming too large after {} iterations!'.format(it))

        # Calculate Update
        diffOp.applyInverseOperator(v)
        v *= step
        ca.SetToIdentity(scratchF)
        ca.Add_I(v, scratchF)   # toH
        ca.ApplyH(scratchF, phi, v, bg_field)
        ca.Copy(phi, scratchF)
        mm = ca.MinMax(phi)
        if max(mm) > sizemax:
            raise OverflowError('phi becoming too large after {} iterations!'.format(it))

        # Update Determinant
        ca.ApplyH(scratchI, detDphi, v, bg_im)
        ca.Copy(detDphi, scratchI)

        ca.SetToIdentity(scratchF)
        ca.Sub_I(v, scratchF)   # toV
        # v *= -1
        ca.Divergence(scratchI, v)
        ca.Exp_I(scratchI)
        detDphi *= scratchI

        # ca.JacDetH(detDphi, phi)
        ca.Sqrt(sdetDphi, detDphi)

    tt = time.time() - t
    print "Total Time:", tt
    print "Iteratins per minute:", nIters/tt*60
    print "Iteratins per second:", nIters/tt
    print "secons per iteration:", tt/nIters

    if plot:
        # outdir = 'Results/imweight/'
        # outdir = 'Results/results1/'
        cd.EnergyPlot(energy, legend=['Regularization', 'Data Match', 'Total'])
        ca.Sub(scratchI, I0, I1)
        rng = ca.MinMax(scratchI)
        # cd.DispImage(scratchI, title='Orig Diff', rng=[-5,5])
        cd.Disp3Pane(scratchI, title='Orig Diff', rng=rng)
        # cd.DispImage(diff, title='New Diff', rng=[-5,5])
        cd.Disp3Pane(diff, title='New Diff', rng=rng)
        # cd.DispImage(detDphi, title='Jacobian Determinant', cmap='jet', colorbar=True)
        cd.Disp3Pane(detDphi, title='Jacobian Determinant', cmap='jet', colorbar=True,
                     bgval=1.0)
        cd.DispHGrid(phi, splat=False)

     # ax = cd.DispHGrid(phi, newFig=True, dim ='z', splat=False)
    return phi, Idef, energy, detDphi, scratchI, diff

# def main():
#     #PEAK INHALE 
#     orig0 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT1/PT1_round2/images_lacoeff/1la.mha')
#     # orig0 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT2/PT2/lacoeff/1la.mha')
#     # orig0 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT3/PT3/lacoeff/1la.mha')
#     # print orig0.grid()
#     # cd.DispImage(orig0,title='y', dim ='y')
#     # cd.DispImage(orig0,title='x', dim ='x')
#     # cd.DispImage(orig0,title='z', dim ='z')
#     # plt.show(block=True)

#     # print 'MinMax', ca.MinMax(I0) 
#     # # I0 = common.LoadPNGImage('/home/sci/benl/yaml2/phasebin/video_files/movie/LDM/im00.png',mType = ca.MEM_DEVICE)
#     # #PEAK EXHALE 
#     orig1 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT1/PT1_round2/images_lacoeff/6la.mha')
#     # orig1 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT2/PT2/lacoeff/6la.mha')
#     # orig1 = cc.LoadMHA('/home/sci/benl/yaml2/phasebin/PT3/PT3/lacoeff/6la.mha')
#     # print 'MinMax', ca.MinMax(I1) 
#     # I1 = common.LoadPNGImage('/home/sci/benl/yaml2/phasebin/video_files/movie/LDM/im06.png',mType = ca.MEM_DEVICE)
#     # ca.Abs_I(I0)
#     # ca.Abs_I(I1)
# ##ben 
#     # I0 = cc.Downsample(orig0,2)
#     # I1 = cc.Downsample(orig1,2)

#     """FOR PATIENT 1 ONLY"""
#     I0 = fyr.crop_im(orig0,80,430,33,349,1,138, plot=False) 
#     I1 = fyr.crop_im(orig1,80,430,33,349,1,138, plot=False)
#     """FOR PATIENT 2 ONLY"""
#     # I0 = fyr.crop_im(orig0,83,440,100,370,1,216, plot=False) 
#     # I1 = fyr.crop_im(orig1,83,440,100,370,1,216, plot=False)
#     """FOR PATIENT 3 ONLY"""
#     # I0 = fyr.crop_im(orig0,66,430,94,349,1,216, plot=False) 
#     # I1 = fyr.crop_im(orig1,66,430,94,349,1,216, plot=False)
    
#     grid = I0.grid()
#     mType = ca.MEM_DEVICE
#     scratch1 = ca.Image3D(grid, mType)
#     scratch2 = ca.Image3D(grid, mType)
# ##ben 
#     # test images
#     # grid = cc.MakeGrid((100, 100, 1))
#     # mType = ca.MEM_DEVICE
#     # I0 = ca.Image3D(grid, mType)
#     # I1 = ca.Image3D(grid, mType)
#     # scratch1 = ca.Image3D(grid, mType)
#     # scratch2 = ca.Image3D(grid, mType)

#     # ca.SetMem(I0, 0.0)
#     # ca.SetMem(I1, 0.0)
#     # cc.AddRect(I0, (25, 25), (75, 50), 1.0)
#     # cc.AddRect(I0, (25, 50), (75, 75), 5.0)
#     # cc.AddRect(I1, (25, 25), (75, 40), 5.0/3.0)
#     # cc.AddRect(I1, (25, 40), (75, 65), 5.0)

#     g = ca.GaussianFilterGPU()
#     g.updateParams(grid.size(), ca.Vec3Df(.7, .7, 0.0), ca.Vec3Di(2, 2, 1))
#     g.filter(scratch1, I0, scratch1)
#     ca.Copy(I0, scratch1)
#     g.filter(scratch2, I1, scratch2)
#     ca.Copy(I1, scratch2)
#     print 'full density'
#     print ca.Sum(I0)
#     print ca.Sum(I1)
#     ca.Sqrt_I(I0)
#     ca.Sqrt_I(I1)
#     print 'half density'
#     print ca.Sum(I0)
#     print ca.Sum(I1)

#     tmpIn = ca.Image3D(grid,mType)
#     # tmpIn2 = ca.Image3D(grid,mType)
#     # tmpIn3 = ca.Image3D(grid,mType)
#     # tmpIn4 = ca.Image3D(grid,mType)
#     # tmpIn5 = ca.Image3D(grid,mType)
#     # # ca.SetMem(tmpIn,1.0)

#     # cd.DispImage(I0,title = "Original Image", cmap = 'jet',
#     #     colorbar = True,newFig = True, sliceIdx = 80)

#     # tm2yval = [0.1,10.0]
#     # sig_threshold(tmpIn, I0, 0.3,0.01,tm2yval) 
#     # cd.DispImage(tmpIn, tm2yval, title = "Weighted Image1", cmap = 'jet',
#     #     colorbar = True,newFig = True)
#     # tm3yval= [0.01,10]
#     # sig_threshold(tmpIn2, I0, 0.3,0.1,tm3yval) 
#     # cd.DispImage(tmpIn2, rng=tm3yval,title = "Weighted Image2", cmap = 'jet',
#     #     colorbar = True,newFig = True, sliceIdx = 80)
#     # tm4yval=[0.01,100]
#     # sig_threshold(tmpIn3, I0, 0.3,0.01,tm4yval) 
#     # cd.DispImage(tmpIn3, rng=tm4yval,title = "Weighted Image3", cmap = 'jet',
#     #     colorbar = True,newFig = True, sliceIdx = 80)
#     # tm5yval=[0.1,10]
#     # sig_threshold(tmpIn4, I0, 0.3,0.01,tm5yval) 
#     # cd.DispImage(tmpIn4, rng=tm5yval,title = "Weighted Image4", cmap = 'jet',
#     #     colorbar = True,newFig = True, sliceIdx = 80)
#     # tm6yval=[0.01,10]
#     # sig_threshold(tmpIn5, I0, 0.3,0.01,tm5yval) 
#     # cd.DispImage(tmpIn5, rng=tm5yval,title = "Weighted Image5", cmap = 'jet',
#     #     colorbar = True,newFig = True, sliceIdx = 80)

#     # HalfDenMatch(I0, I1, I0, nIters=500, step=.5, sigma=.1)
#     phi, Idef, energy, detDphi,scratchI, diff \
#         = HalfDenMatch(I0, I1, None, nIters=1, step=.01, sigma=.1)

#     # print 'half density deformed'
#     # print ca.Sum(Idef)
#     # print ca.Sum(I1)
#     # ca.Sqr_I(Idef)
#     # ca.Sqr_I(I1)
#     # print 'full density deformed'
#     # print ca.Sum(Idef)
#     # print ca.Sum(I1)
#     # HalfDenMatch(I0, I1, 10, step=.01)
#     # plt.show(block=True)

# if __name__ == '__main__':

#     print "Half Den Matching"
#     main()
