#
# imports
#

from time import time
import numpy as np
import glob, os, sys
from PIL import Image
import matplotlib.pyplot as plt
from matplotlib import offsetbox
from sklearn import (manifold, datasets, decomposition, ensemble, lda,
										 random_projection)
import scipy.io as sio
import re 
import json
import argparse
from json import JSONEncoder
import instinct 

# customize output w/ this custom serialization 
class MyEncoder(JSONEncoder):
	def default(self, obj) :
		if isinstance(obj, np.ndarray) and obj.ndim ==1:
			return obj.tolist()
		return json.JSONEnconder.default(self,obj)

def Input( ):
	parser = argparse.ArgumentParser()
	parser.add_argument("-i", "--images", dest = 'filenames', 
		help = "this is the path to the images(1 dir only)")
	parser.add_argument("-j", "--json", dest= "verbose", default = True,
		help = "Don't print status messages to stdout" ) 
	parser.add_argument("-fv", "--feature_vector", dest = 'fv', default = False, 
		help = "feature vector")
	parser.add_argument("-fvn", "--filename_fv", dest = "fvnames", default = False, 
		help = "list of feature vector names (txt)") 
	parser.add_argument("-c", "--classes", metavar = 'N', type=int, nargs= '+', 
		help = "bird class nubmers should be 3") 
	args = parser.parse_args()
	return args

bird_images_show = []

def ReadImages(filenames, c1,c2,c3, fvn, fv):
	##LOAD IN ALL THE DATA
	#---------------------------------------------------------------------------
	#Using CSV and text file as feature vector and class 
	with open(fvn) as f:
		fnames = f.readlines()  # birdName = int <space> string

	#using numpy csv reader 
	birdFeatures = np.loadtxt(open(fv,'rb'),delimiter=',') # matrix of features 
	#change this to local, singular, directory that contains all the bird images
	# str_data_dir = "combined_birds"

	str_data_dir = os.path.dirname( filenames )
	print "stdatadir", str_data_dir 

	birds = np.zeros( [900, 128 * 128 ] )
	i = 0
	features = birdFeatures 
	modFnames = [] 

	for i in  range (0 ,len(features)):
		# split the string because of string numbering x[0] = class x[1] = imagename
		namePart_x = fnames[i].split()  
		str_basename =  os.path.basename( str( namePart_x[1] ) )
		# combine the path with the image name 
		str_image_filename = "%s/%s" % (str_data_dir, str_basename )
		modFnames.append( str_image_filename )


	## WHICH CLASS TO USE, SELECT A SUBSET OF CLASSES TO PLOT 
	#---------------------------------------------------------------------------
	#choose class here (1-20): 
	classes_to_use = [c1, c2, c3]
	## initialize data structures
	#this is a guess, and is later resized may need to be read in from file? 
	exclusiveFeatureArray  = np.zeros( [900,1024] )
	exclusiveFnames = []
	birdClass = []

	# track where we are in all features/images (0 - 900)
	counter = 0 
	#track where we are in new exclusive data structures (0- ? )
	exclusiveArrayPlacement = 0 

	## create the data structure for a class 
	# go through the entire set of images (features, names) 
	for e in fnames:
		x = e.split() 

		if   int(x[0])   in   classes_to_use:  
			# place images that match the class into seperate arrays / lists 
			exclusiveFnames.append( modFnames[counter] )
			#check that the correct name is being placed into the exclusive array 
			if x[1] not in modFnames[counter] :
				print "filenames not matching "
				break 
			if features[counter,:] not in birdFeatures[counter,:]:
				print "features not matching"
				break 
			exclusiveFeatureArray[exclusiveArrayPlacement,:] = features[counter,:]
			exclusiveArrayPlacement = exclusiveArrayPlacement + 1
			# create a tuple that stores the new class
			if x[1] in modFnames[counter]:
				birdClass = birdClass + ([ int(x[0]), x[1], features[counter,:] ])
		counter = counter + 1

	#we now have our list of features and their corresponding File names: 
	#resize so not a bunch of zeros at end of matrix 
	exclusiveFeatureArray = np.resize(exclusiveFeatureArray,(exclusiveArrayPlacement,1024))
	all_images = exclusiveFnames #names w/filename
	
	return exclusiveFeatureArray, all_images	

def main():
	inputArgs = Input()
	print "fvn", inputArgs.fvnames
	FV, ImageFiles = ReadImages(inputArgs.filenames,
		inputArgs.classes[0],inputArgs.classes[1],inputArgs.classes[2], 
		inputArgs.fvnames, 
		inputArgs.fv)
	X = instinct.ComputePCA(FV)
	y = instinct.ComputeKMeans(X) 
	
	instinct.plot_embedding(X,y, inputArgs.filenames, FV)

	if inputArgs.json_name: 
		instinct.CreateJson(inputArgs.json_name, ImageFiles, FV, X)

if  __name__ =='__main__':
	main()




