import PyCA.Core as ca


print "Begin Test" 
grid = ca.GridInfo(ca.Vec3Di(20, 20, 20), ca.Vec3Df(1.0, 1.0, 1.0), ca.Vec3Df(0.0, 0.0, 0.0))
grid = ca.GridInfo(ca.Vec3Di(20, 20, 20)) #equivalent
memType = ca.MEM_DEVICE #for GPU Memory

Im1 = ca.Image3D(grid, memType)
Im2 = ca.Image3D(20, 20, 20, memType)  # also equivalent
print Im1
print Im2

VF1 = ca.Field3D(Im1.grid(), Im1.memType())
VF2 = ca.Field3D(20, 20, 20, Im1.memType())  # again, also equivalent
print VF1


grid2 = ca.GridInfo(ca.Vec3Di(20, 20, 20), ca.Vec3Df(.5, .5, .5), ca.Vec3Df(-19.0, -19.0, -19.0))
memTypeCPU = ca.MEM_HOST

Im1.setGrid(grid2)

Im1.toType(memTypeCPU)
print Im1
Im1.setGrid(grid) #Change back
Im1.toType(ca.MEM_DEVICE)






import numpy as np
import PyCA.Common as common

np_arr = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) #create sample 3x3 numpy array
Im2 = common.ImFromNPArr(np_arr, ca.MEM_DEVICE) #create Image3D from the numpy array
print Im2.grid()