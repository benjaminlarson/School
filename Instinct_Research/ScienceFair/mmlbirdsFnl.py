import numpy as np
import glob, os, sys
from PIL import Image
import matplotlib.pyplot as plt
from matplotlib import offsetbox
import scipy.io as sio
import re 
import json
from json import JSONEncoder
import instinct

bird_images_show = []

##LOAD IN ALL THE DATA
#---------------------------------------------------------------------------
#Using CSV and text file as feature vector and class 
with open('files.txt') as f:
	birdName = f.readlines()  # birdName = int <space> string

#using numpy csv reader 
birdFeatures = np.loadtxt(open('alpha.csv','rb'),delimiter=',') # matrix of features 
#change this to local, singular, directory that contains all the bird images
str_data_dir = "combined_birds"

birds = np.zeros( [900, 128 * 128 ] )
i = 0
features = birdFeatures 
fnames = birdName
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
# classes_to_use = [17,18,7]
classes_to_use = [17,18,7,20,13,14,16,9,10,6]
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
# print all_images
i = 0
for infile in all_images:
  # print "infile" , infile
  # im = Image.open(infile).convert("L")
  im = Image.open(infile)
  im_data = im.resize( (128,128), Image.NEAREST)
  im_show = im.resize( (64,64), Image.ANTIALIAS)
  bird_images_show.append( im_show )
  i = i + 1


X_proj = instinct.ComputeSVM(exclusiveFeatureArray, bird_images_show) 
# Y_pred = instinct.ComputeKMeans( X_proj )
# instinct.plot_embedding(X_proj[0], X_proj[1],FV) 


