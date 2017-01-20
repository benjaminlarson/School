
import numpy as np
import glob, os, sys
from PIL import Image
import argparse
import json
from json import JSONEncoder
import instinct

def Input( ):
	parser = argparse.ArgumentParser()
	parser.add_argument("-i", "--images", dest = 'filenames', 
		help = "Where/what images to use. Put in string if error.")
	parser.add_argument("-f", "--features", dest = 'features', 
		help = "list of feature files from overfeat.")
	parser.add_argument("-j", "--json", dest= "jsonInputName", default = True,
		help = "Don't print status messages to stdout" ) 
	args = parser.parse_args()
	return args

def ReadImages(filenames):
	print "FILENAMES", filenames
	all_image_names = glob.glob(filenames)
	# print "all IMAGES", all_images
	feature_vector = np.zeros( (len(all_image_names), 16) ) #number of images x grayscale bins
	i = 0
	for infile in all_image_names:
		print "infile" , infile
		feature_vector[i] =  instinct.FindFeatures(infile)
		i = i + 1
	return feature_vector, all_image_names

def ReadFeatures(features):
        all_feature_names = glob.glob( features )
        print all_feature_names
        feature_vector = [] # = np.zeros( len(all_feature_names) )
        i = 0
        for infile in all_feature_names:
           print "Reading " + infile
           f = open( infile )
           line = f.readline() # skip the first line
           line = f.readline()
           fv = line.split()
           fv = [float(n) for n in fv]
           feature_vector.append( np.array( fv ) )
           i = i + 1
           f.close()
        feature_vector = np.vstack( feature_vector )
        print feature_vector.shape
        return feature_vector 

def main():
	inputArgs = Input()
	#ignore, ImageFiles = ReadImages(inputArgs.filenames)
        ImageFiles = glob.glob( inputArgs.filenames )
        
        FV = ReadFeatures( inputArgs.features )
	#X_proj = instinct.ComputePCA(FV) 
	X_proj = instinct.ComputeIsomap(FV) 

	if inputArgs.jsonInputName: 
	    instinct.CreateJson(inputArgs.jsonInputName, ImageFiles, FV, X_proj)

        Y_pred = instinct.ComputeKMeans( X_proj )
	instinct.plot_embedding(X_proj, Y_pred, inputArgs.filenames, FV) 


if  __name__ =='__main__':
	main()
