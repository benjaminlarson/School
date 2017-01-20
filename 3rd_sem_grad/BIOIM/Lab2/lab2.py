# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np

def cyclinder(matrix,length,width,center):
    
    return matrix 
def sphere(matrix,radius,center):
    print "error",-radius+center[0]
    print center
    box = matrix[(-radius+center[0]):(radius+center[0]), (-radius+center[1]):(radius+center[1]), (-radius+center[2]):(radius+center[2])]
    for i in box:
    	print "i, center",  i, center 
    	iterative_distance = np.sqrt(i - center)
    	if iterative_distance < radius:
    		matrx[i] = 100
    return matrix

def distance(p1, p2):
    #points shoudl be 3d 
    return np.sqrt( (p1[0]-p2[0])^2 +(p1[1]-p2[1])^2 +(p1[2]-p[2])^2 )


print "Begin"
stack = np.zeros([64,64,32], dtype='int8')
stack.shape
sphere(stack,2,[3,3,3])
