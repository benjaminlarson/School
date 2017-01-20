
import numpy as np
import matplotlib.pyplot as plt
import glob, os, sys
from PIL import Image
import argparse
import json
from json import JSONEncoder
import instinct
import pylab 

#read in mask and image... compute result 
def ComputeImages(filenames):
	# print "all IMAGES", all_images
	feature_vector = np.zeros( (len(filenames), 16) ) #number of images x grayscale bins
	i = 0
	for infile in filenames:
		print "infile" , infile
		# print "FF", len(instinct.FindFeatures(infile)) 
		feature_vector[i] =  instinct.FindFeatures(infile)
		i = i + 1
	return feature_vector
# def toGREY(im):
# 	return np.dot(im[..,:3], [0.299, 0.587, 0.144]) 
def ReturnMask():
	masked =[]
	birdsImA = glob.glob('BIRDS/bin0/003.Sooty_Albatross/*.jpg')
	birdsImC = glob.glob('BIRDS/bin0/018.Spotted_Catbird/*.jpg')
	birdsImF = glob.glob('BIRDS/bin0/120.Fox_Sparrow/*.jpg')

	birdsIm = birdsImA + birdsImC + birdsImF
	
	maskImA = glob.glob('BIRDS/bin0_color/003.Sooty_Albatross/*.jpg') 
	maskImC = glob.glob('BIRDS/bin0_color/018.Spotted_Catbird/*.jpg') 
	maskImF = glob.glob('BIRDS/bin0_color/120.Fox_Sparrow/*.jpg')
	maskIm = maskImA + maskImC + maskImF
	# print "mask", len(maskIm) 
	for x in xrange(0, len(birdsIm)):
		# print "x",x 
		imb = Image.open(birdsIm[x]).convert('L')
		# imb = Image.open(birdsIm[x]) 
		imbarr = np.asarray(imb)
		imbarrF = imbarr.astype(float)
		imm = Image.open(maskIm[x]).convert('L')
		# imm = Image.open(maskIm[x])
		imarr = np.asarray(imm)
		imarrF = imarr.astype(float)
		mask = imarrF * imbarrF
		# print "imbarrF", imbarrF.shape
		# print "imarrF", imarrF.shape
		# mask = np.all(imarrF[:,:,:3] )* imbarrF#, axis = -1) 
		# imarrF[mask] = [0,0,0,3] 
		# yu = np.uint8(yF) 
		y = Image.fromarray(mask)
		masked.append(y) 
	# print "mC", len(maskedColor)
	# print "birdsIM", birdsIm
	# print "birds", maskIm
	return masked

def main():
	
	maskedBird = ReturnMask()
	FV = ComputeImages(maskedBird)
	X_proj = instinct.ComputeSVM(FV, maskedBird) 
	# Y_pred = instinct.ComputeKMeans( X_proj )
	# instinct.plot_embedding(X_proj[0], X_proj[1],FV) 


if  __name__ =='__main__':
	main()
