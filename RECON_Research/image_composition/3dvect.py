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

from mpl_toolkits.mplot3d import Axes3D

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



soa =np.array( [ [0,0,1,1,-2,0], [0,0,2,1,1,0],[0,0,3,2,1,0],[0,0,4,0.5,0.7,0]]) 

X,Y,Z,U,V,W = zip(*soa)
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.quiver(X,Y,Z,U,V,W)
ax.set_xlim([-1,0.5])
ax.set_ylim([-1,1.5])
ax.set_zlim([-1,8])
plt.show()