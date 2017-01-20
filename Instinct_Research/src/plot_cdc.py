
import numpy as np
import glob, os, sys
from PIL import Image
from scipy.ndimage import filters
import matplotlib.pyplot as plt
import pylab as P 
import matplotlib.cm as cm
from matplotlib import offsetbox
from sklearn import (manifold, datasets, decomposition, ensemble, lda,
                     random_projection)
from sklearn.cluster import KMeans
import re 
import argparse
import json
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
	args = parser.parse_args()
	return args

def ReadImages(fvn, fv):
	with open(fvn) as f:
		fileName = f.readlines()  
	#using numpy csv reader 
	features = np.loadtxt(open(fv,'rb'))#,delimiter=',') # matrix of features 
	fnames = [] 
	# get the filename from the pathname 
	for i in  range (0 ,len(fileName)):
		str_basename =  os.path.basename( fileName[i] )
		fnames.append( str_basename)
	return features, fnames

def main():
	inputArgs = Input()
	print "fvn", inputArgs.fvnames
	FV, ImageFiles = ReadImages(inputArgs.fvnames, inputArgs.fv)
	X = instinct.ComputePCA(FV, inputArgs.filenames)

	if inputArgs.json_name: 
		instinct.CreateJson(inputArgs.json_name, ImageFiles, FV, X)

if  __name__ =='__main__':
	main()

