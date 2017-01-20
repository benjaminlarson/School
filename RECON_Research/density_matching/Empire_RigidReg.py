import matplotlib.pyplot as plt 
import PyCA.Core as ca
import PyCAApps as ap 
import PyCACalebExtras.Common as cc
import PyCACalebExtras.Display as cd
import sys
import time
import glob
import os 
from PyCAApps.PrintInfo import printinfo

import numpy as np
from numpy.linalg import inv
from scipy.stats.mstats import gmean

print "starting"

def _matToVec(Ainv):
    '''Takes a square affine matrix and returns the affine 'vector'
    '''
    if Ainv.shape[0] == 3:         # 2D affine
        a_v = np.zeros(6)
        a_v[0:2] = Ainv[0, 0:2]
        a_v[2:4] = Ainv[1, 0:2]
        a_v[4:6] = Ainv[0:2, 2]
    elif Ainv.shape[0] == 4:         # 3D affine
        a_v = np.zeros(12)
        a_v[0:3] = Ainv[0, 0:3]
        a_v[3:6] = Ainv[1, 0:3]
        a_v[6:9] = Ainv[2, 0:3]
        a_v[9:12] = Ainv[0:3, 3]
    else:
        raise Exception("_matToVec: Ainv needs to be 3x3 or 4x4!")
    return a_v


def _vecToMat(a_v):
    '''Takes an affine 'vector' and returns the square affine matrix
    '''
    if a_v.shape[0] == 6:        # 2D affine
        Ainv = np.identity(3)
        Ainv[0, 0:2] = a_v[0:2]
        Ainv[1, 0:2] = a_v[2:4]
        Ainv[0:2, 2] = a_v[4:6]
    elif a_v.shape[0] == 12:        # 3D affine
        Ainv = np.identity(4)
        Ainv[0, 0:3] = a_v[0:3]
        Ainv[1, 0:3] = a_v[3:6]
        Ainv[2, 0:3] = a_v[6:9]
        Ainv[0:3, 3] = a_v[9:12]
    else:
        raise Exception("_vecToMat: a_v needs to be length 6 or 12!")
    return Ainv

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

# print printimgprint

for f,m in zip(imgroup[0::2],imgroup[1::2]):
	plt.close('all')
	# f = "/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/02_Fixed.mhd"
	# m = "/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/02_Moving.mhd"

	f = f[0]
	m = m[0] 
	print f, m

	s = cc.LoadMHA(f)
	t = cc.LoadMHA(m)
	# s1 = cc.LoadMHA(f[0])
	# t1 = cc.LoadMHA(m[0])
	# s = cc.Downsample(s1,2)
	# t = cc.Downsample(t1,2)
	diff = ca.Image3D(s.grid(), s.memType())


	[Idef, inv, energy] = ap.AffineReg(t,s,constraint='rigid')
	
	'''Plot ----------------------------------------------------------------------------'''
	newpathim = os.path.split(f) 
	newdirim = os.path.split(newpathim[0]) #first of tuple

	newpaths = os.path.split(m) 
	newdirs = os.path.split(newpaths[0]) #first of tuple
	
	print newpathim
	print newdirim
	print newpaths
	print newdirs 

	path = '/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Rigid/'
	if not os.path.exists(path+newpathim[1]):
		os.makedirs(path+newpathim[1])

	A = inv
	cc.ApplyAffineReal(Idef, t, A)
	ca.Sub(diff, t, Idef)

	cd.DispImage(diff, title='Affine registered diff')
	plt.savefig(path+newpathim[1]+'/'+"Rigid_Diff")
	ca.Sub(diff, t, s)
	cd.DispImage(diff, title='Unregistered diff (affine)')
	plt.savefig(path+newpathim[1]+'/'+"Unreg_Diff")
	cd.DispImage(Idef)
	cd.EnergyPlot(energy, title='Affine Energy')
	plt.savefig(path+newpathim[1]+'/'+"Energy")

	cc.WriteMHA(Idef,path+newpathim[1]+'_defIm')
