
import numpy as np
import matplotlib.pyplot as plt
import glob, os, sys
from PIL import Image
import argparse
import json
from json import JSONEncoder
import instinctColor
import pylab 

#read in mask and image... compute result 
def ComputeImages(filenames):
	# print "all IMAGES", all_images
	feature_vector = np.zeros( (len(filenames), 48) ) #number of images x grayscale bins
	i = 0
	for infile in filenames:
		# print "infile" , infile
		# print "FF", len(instinct.FindFeatures(infile)) 
		feature_vector[i] =  instinctColor.FindFeatures(infile)
		i = i + 1
	return feature_vector
# def toGREY(im):
# 	return np.dot(im[..,:3], [0.299, 0.587, 0.144]) 
def ReturnMask():
	masked =[]
	sendToPlot = []
	birdsImA = glob.glob('BIRDS/bin0_color/003.Sooty_Albatross/*.jpg')
	birdsImC = glob.glob('BIRDS/bin0_color/018.Spotted_Catbird/*.jpg')
	birdsImF = glob.glob('BIRDS/bin0_color/120.Fox_Sparrow/*.jpg')

	birdsIm = birdsImA + birdsImC + birdsImF
	# print "birdsA, birdsB, birdsC", len(birdsImA), len(birdsImC), len(birdsImF)
	# print "checkA", birdsIm[57], birdsIm[58],
	# print ""
	# print "checkA", birdsIm[102], birdsIm[103],
	# print "", len(birdsIm),
	# print "checkA", birdsIm[162],
	
	maskImA = glob.glob('BIRDS/bin0/003.Sooty_Albatross/*.jpg') 
	maskImC = glob.glob('BIRDS/bin0/018.Spotted_Catbird/*.jpg') 
	maskImF = glob.glob('BIRDS/bin0/120.Fox_Sparrow/*.jpg')
	maskIm = maskImA + maskImC + maskImF
	# print "mask", len(maskIm) 
	for x in xrange(0, len(birdsIm)):
		# print "x",x 
		imb = np.array(Image.open(birdsIm[x]))

		imm = np.array(Image.open(maskIm[x]))
		x,y = imm.shape
		im = np.array(Image.new("RGB", (y,x), "black") )
		idx = (imm != 0) 
		
		# print "imm", imm.shape
		# print "imb", imb.shape
		# print "im", im.shape
		im[idx] = imb[idx] 
		# print "maskshape", mask.shape
		
		y = Image.fromarray(im) 
		# print "Y", y
		sendToPlot.append(y)
		masked.append(imb) 
	# print "mC", len(maskedColor)

	# plt.imshow(sendToPlot[0])
	# plt.show()
	# print "birdsIM", birdsIm
	# print "birds", maskIm
	return masked, sendToPlot

def main():
	maskedBird, images = ReturnMask()
	FV = ComputeImages(maskedBird)
	# print "images", images
	X_proj = instinctColor.ComputeSVM(FV, images) 
	# Y_pred = instinct.ComputeKMeans( X_proj )
	# instinct.plot_embedding(X_proj[0], X_proj[1],FV) 


if  __name__ =='__main__':
	main()
