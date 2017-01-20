
import numpy as np
import matplotlib.pyplot as plt
import glob, os, sys
from PIL import Image
import argparse
import json
from json import JSONEncoder
import instinct
import pylab 
import scipy.io
import scipy.misc 
import ipdb

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
	birdsImA = glob.glob('images/003.Sooty_Albatross/*.jpg')
	birdsImC = glob.glob('images/018.Spotted_Catbird/*.jpg')
	birdsImF = glob.glob('images/120.Fox_Sparrow/*.jpg')
	birdsImB = glob.glob('images/012.Yellow_headed_Blackbird/*.jpg')
	birdsImD = glob.glob('images/040.Olive_sided_Flycatcher/*.jpg')
	birdsImE = glob.glob('images/052.Pied_billed_Grebe/*.jpg')
	birdsImH = glob.glob('images/057.Rose_breasted_Grosbeak/*.jpg')
	birdsImG = glob.glob('images/060.Glaucous_winged_Gull/*.jpg')
	birdsImI = glob.glob('images/070.Green_Violetear/*.jpg')
	birdsImJ = glob.glob('images/076.Dark_eyed_Junco/*.jpg')

	birdsIm = birdsImA + birdsImC + birdsImF +birdsImB+birdsImD+birdsImE+birdsImH+birdsImG+birdsImI+birdsImJ
	# print "birdsA, birdsB, birdsC", len(birdsImA), len(birdsImC), len(birdsImF)
	# print "checkA", birdsIm[57], birdsIm[58],
	# print ""
	# print "checkA", birdsIm[102], birdsIm[103],
	# print "", len(birdsIm),
	# print "checkA", birdsIm[162],
	print "Images", len(birdsIm) 
	maskImA = glob.glob('annotations/annotations-mat/003.Sooty_Albatross/*.jpeg') 
	maskImC = glob.glob('annotations/annotations-mat/018.Spotted_Catbird/*.jpeg') 
	maskImF = glob.glob('annotations/annotations-mat/120.Fox_Sparrow/*.jpeg')
	maskImB = glob.glob('annotations/annotations-mat/012.Yellow_headed_Blackbird/*.jpeg')
	maskImD = glob.glob('annotations/annotations-mat/040.Olive_sided_Flycatcher/*.jpeg')
	maskImE = glob.glob('annotations/annotations-mat/052.Pied_billed_Grebe/*.jpeg')
	maskImH = glob.glob('annotations/annotations-mat/057.Rose_breasted_Grosbeak/*.jpeg')
	maskImG = glob.glob('annotations/annotations-mat/060.Glaucous_winged_Gull/*.jpeg')
	maskImI = glob.glob('annotations/annotations-mat/070.Green_Violetear/*.jpeg')
	maskImJ = glob.glob('annotations/annotations-mat/076.Dark_eyed_Junco/*.jpeg')
	maskIm = maskImA + maskImC + maskImF+maskImB+maskImD +maskImE+maskImH+maskImG+maskImI+maskImJ
	print "mask", len(maskIm) 
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

def saveoutjpeg():
	A = glob.glob('annotations/annotations-mat/003.Sooty_Albatross/*.mat') 
	C = glob.glob('annotations/annotations-mat/018.Spotted_Catbird/*.mat') 
	F = glob.glob('annotations/annotations-mat/120.Fox_Sparrow/*.mat')
	B = glob.glob('annotations/annotations-mat/012.Yellow_headed_Blackbird/*.mat')
	D = glob.glob('annotations/annotations-mat/040.Olive_sided_Flycatcher/*.mat')
	E = glob.glob('annotations/annotations-mat/052.Pied_billed_Grebe/*.mat')
	H = glob.glob('annotations/annotations-mat/057.Rose_breasted_Grosbeak/*.mat')
	G = glob.glob('annotations/annotations-mat/060.Glaucous_winged_Gull/*.mat')
	I = glob.glob('annotations/annotations-mat/070.Green_Violetear/*.mat')
	J = glob.glob('annotations/annotations-mat/076.Dark_eyed_Junco/*.mat')
	segIms = [A,C,F,B,D,E,H,G,I,J]

	for folder in segIms:
		for im in folder:
			# print "full path:", im 
			dir_name = os.path.splitext(im)[0]
			# print "dir name", dir_name
			# dir_name = os.path.dirname(dir_name) 
			# print "dir name", dir_name
			# fileNameToSave = os.path.splitext( os.path.basename(im) )[0]
			# print 'Filename', fileNameToSave
			# ipdb.set_trace()
			mat = scipy.io.loadmat(im)
			s = mat['seg']

			# plt.imshow(s, extent=[0,1,0,1] )
			# print "FINAL Save to:", dir_name+'.jpeg'
			scipy.misc.imsave(dir_name+'.jpeg',s)
			# segim = Image.open()
			# segim.save(segim,"jpeg")
			# im1 = Image.open('Users/Benjamin/Documents/1ST_SEM_GRAD/Instinct/ScienceFair/'+fileNameToSave+'.jpeg') 
			# im1 = Image.open(fileNameToSave+'.jpeg') 
			# print (im1) 

def main():
	print "MAIN"
	saveoutjpeg() 
	maskedBird = ReturnMask()
	FV = ComputeImages(maskedBird)
	X_proj = instinct.ComputeSVM(FV, maskedBird) 

	# Y_pred = instinct.ComputeKMeans( X_proj )
	# instinct.plot_embedding(X_proj[0], X_proj[1],FV) 


if  __name__ =='__main__':
	main()
