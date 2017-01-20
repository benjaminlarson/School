import numpy as np
import scipy.linalg as linalg
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3

plt.close('all')

ncomp=2
noise = 0.5

# create data points
p = 100
s=np.random.rand(1,p)
t=np.random.rand(1,p)
x= s + t + noise*np.random.rand(1,p)
y= s + -2*t + noise*np.random.rand(1,p)
z=-2*s + 0.5*t + noise*np.random.rand(1,p)
A = np.vstack((x,y,z))


def scatter3(figid, xcoords, ycoords, zcoords, c):
    if type(figid) is p3.Axes3D:
        ax = figid
    else:
        fig = plt.figure(figid) 
        ax = p3.Axes3D(fig)
    ax.scatter3D(xcoords,ycoords,zcoords, c=c)
    plt.axis('equal')
    return ax

def plot3(figid, xcoords, ycoords, zcoords, c):
    if type(figid) is p3.Axes3D:
        ax = figid
    else:
        fig = plt.figure(figid) 
        ax = p3.Axes3D(fig)
    ax.plot3D(xcoords,ycoords,zcoords, c=c)

plt.figure(1) 
plt.hold(False)
plt.figure(2)
plt.hold(False)

# plot original data
ax1 = scatter3(1, A[0,:],A[1,:],A[2,:], c='b')
plt.hold(True)

# center data
c = np.atleast_2d(np.array([np.mean(x), np.mean(y), np.mean(z)])).T
Ac = A-np.tile(c,(1,p))
xcrange = np.array([np.min(Ac[0,:]),np.max(Ac[0,:])])

# plot centered data
ax2 = scatter3(2, Ac[0,:], Ac[1,:], Ac[2,:], c='b')
plt.hold(True)

# Create projected data
U,S,V = linalg.svd(Ac, full_matrices=False)
S = np.diag(S)
proj = np.dot(U[:,:ncomp],np.dot(S[:ncomp,:ncomp],V[:ncomp,:]))

# plot projected data and connecting lines
scatter3(ax2, proj[0,:], proj[1,:], proj[2,:], c='m')

connX = np.vstack((np.atleast_2d(Ac[0,:]), np.atleast_2d(proj[0,:])))
connY = np.vstack((np.atleast_2d(Ac[1,:]), np.atleast_2d(proj[1,:])))
connZ = np.vstack((np.atleast_2d(Ac[2,:]), np.atleast_2d(proj[2,:])))

for idx in range(connX.shape[1]):
    plot3(ax2, connX[:,idx], connY[:,idx], connZ[:,idx], c='r')

# compute and plot axes
for comp in range(ncomp):
    dir = U[:,comp]
    if dir[1] < 0:
        dir = -dir
    p1 = xcrange[0]/dir[0] * dir
    p2 = xcrange[1]/dir[0] * dir
    # plt.figure(2)
    # plt.plot3([p1[0] p2[0]],[p1[1] p2[1]], [p1[2] p2[2]], 'k', 'LineWidth', 2)
    plot3(ax2, [p1[0], p2[0]],[p1[1], p2[1]], [p1[2], p2[2]], c='k')

# plot projected data in original space
proj=proj+np.tile(c,(1,p))
scatter3(ax1, proj[0,:], proj[1,:], proj[2,:], c='m')

# plot data in projected space
coords = np.dot(U[:,:ncomp].T,A)
plt.figure(3)
plt.scatter(coords[0,:],coords[1,:], c='b')

plt.figure(1)
plt.hold(False)
plt.show()
plt.figure(2)
plt.hold(False)
plt.show()
