
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
	birdsImB = glob.glob('BIRDS/bin0/012.Yellow_headed_Blackbird/*.jpg')
	birdsImD = glob.glob('BIRDS/bin0/040.Olive_sided_Flycatcher/*.jpg')
	birdsImE = glob.glob('BIRDS/bin0/052.Pied_billed_Grebe/*.jpg')
	birdsImH = glob.glob('BIRDS/bin0/057.Rose_breasted_Grosbeak/*.jpg')
	birdsImG = glob.glob('BIRDS/bin0/060.Glaucous_winged_Gull/*.jpg')
	birdsImI = glob.glob('BIRDS/bin0/070.Green_Violetear/*.jpg')
	birdsImJ = glob.glob('BIRDS/bin0/076.Dark_eyed_Junco/*.jpg')

	birdsIm = birdsImA + birdsImC + birdsImF +birdsImB+birdsImD+birdsImE+birdsImH+birdsImG+birdsImI+birdsImJ
	# print "birdsA, birdsB, birdsC", len(birdsImA), len(birdsImC), len(birdsImF)
	# print "checkA", birdsIm[57], birdsIm[58],
	# print ""
	# print "checkA", birdsIm[102], birdsIm[103],
	# print "", len(birdsIm),
	# print "checkA", birdsIm[162],
	# print birdsIm
	maskImA = glob.glob('BIRDS/bin0_color/003.Sooty_Albatross/*.jpg') 
	maskImC = glob.glob('BIRDS/bin0_color/018.Spotted_Catbird/*.jpg') 
	maskImF = glob.glob('BIRDS/bin0_color/120.Fox_Sparrow/*.jpg')
	maskImB = glob.glob('BIRDS/bin0_color/012.Yellow_headed_Blackbird/*.jpg')
	maskImD = glob.glob('BIRDS/bin0_color/040.Olive_sided_Flycatcher/*.jpg')
	maskImE = glob.glob('BIRDS/bin0_color/052.Pied_billed_Grebe/*.jpg')
	maskImH = glob.glob('BIRDS/bin0_color/057.Rose_breasted_Grosbeak/*.jpg')
	maskImG = glob.glob('BIRDS/bin0_color/060.Glaucous_winged_Gull/*.jpg')
	maskImI = glob.glob('BIRDS/bin0_color/070.Green_Violetear/*.jpg')
	maskImJ = glob.glob('BIRDS/bin0_color/076.Dark_eyed_Junco/*.jpg')
	maskIm = maskImA + maskImC + maskImF+maskImB+maskImD +maskImE+maskImH+maskImG+maskImI+maskImJ
	# print "mask", len(maskIm) 
	for x in xrange(0, len(birdsIm)):
		print "x",birdsIm[x]
		print " "
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
