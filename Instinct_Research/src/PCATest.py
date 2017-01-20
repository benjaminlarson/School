import numpy as np
import scipy.linalg as linalg
import matplotlib.pyplot as plt

plt.close('all')

ncomp=2
noise = 0.15
p = 100
t=np.random.rand(1,p)
x=t + noise*np.random.rand(1,p)
y=-2*t + noise*np.random.rand(1,p)

plt.figure('original space')
plt.scatter(x,y,c='b')
plt.axis('equal')
plt.hold(True)
c = np.atleast_2d(np.array([np.mean(x),np.mean(y)])).T
xc=x-c[0]
yc=y-c[1]
xcrange = np.array([np.min(xc),np.max(xc)])
plt.figure('centered space')
plt.scatter(xc,yc)
plt.axis('equal')
plt.hold(True)

A=np.concatenate((xc,yc),0)
U,S,V = linalg.svd(A)
for comp in range(ncomp):
    dir = np.atleast_2d(U[:,comp]).T
    if dir[1] < 0:
        dir = -dir
    plt.figure('centered space')
    p1 = xcrange[0]/dir[1] * dir
    p2 = xcrange[1]/dir[1] * dir
    # plt.plot([p1[0], p2[0]],[p1[1], p2[1]], LineWidth=2)
    plt.plot([p1[0], p2[0]],[p1[1], p2[1]])
    coords = np.atleast_2d(np.dot(dir.T,A))
    proj = np.dot(dir,coords)
    # TEST
    #proj = np.dot(U[:,0],np.dot(S[0],V[0,:]))
    # END TEST
    plt.scatter(proj[0,:],proj[1,:])
    plt.figure('original space')
    proj = proj + np.tile(c,(1,p))
    plt.hold(True)
    plt.scatter(proj[0,:],proj[1,:],c='r')

plt.figure('original space')
plt.hold(False)
plt.show()
plt.figure('centered space')
plt.hold(False)
plt.show()
