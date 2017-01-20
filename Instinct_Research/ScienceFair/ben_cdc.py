
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
	parser.add_argument("-fv", "--feature_vector", dest = 'filenames', default = True,
		help = "feature vector")
	args = parser.parse_args()
	return args.filenames

def ReadImages(dir):
	all_images = glob.glob("%s/*.png" %dir)
	feature_vector = np.zeros( (len(all_images), 16) ) #number of images x grayscale bins
	i = 0
	for infile in all_images:
		print "infile" , infile,
		feature_vector[i] =  FindFeatures(infile)
		i = i + 1
	return feature_vector

def FindFeatures(infile):
	im = np.array(Image.open(infile).convert('L'))
	print 'FindAlphas infile', infile

	## GRADIENT 
	imx = np.zeros( im.shape ) 
	filters.sobel( im, 1, imx )
	imy = np.zeros( im.shape )
	filters.sobel( im, 0, imy )
	magnitude = np.sqrt ( imx**2 + imy**2 )

	## FILTER OUT ZEROS 
	magnitude = magnitude[np.where(magnitude > 1.0e-3)]

	## HISTOGRAM 16 bins/features returned, normed => values sum = 1 
	n, bins, patches = plt.hist(magnitude, 16,  normed = 1)
	plt.close() #close the hist plot before doing thumbnail plot
	return n

def plot_embedding(X, y, DOI, FV, title=None):
	all_images = glob.glob("%s/*.png"%DOI) 
	i = 0
	bird_images_show = []
	filenames = [] #for JSON 
	for infile in all_images:
		print "infile" , infile
		filenames.append(infile)
		im = Image.open(infile).convert("L")
		im_show = im.resize( (64,64), Image.ANTIALIAS)
		bird_images_show.append( im_show )
		i = i + 1
	x_min, x_max = np.min(X, 0), np.max(X, 0)
	X = (X - x_min) / (x_max - x_min)
	plt.figure()
	plt.hold(True)
	ax = plt.subplot(111)
	for i in range(X.shape[0]):
    		plt.text(X[i, 0], X[i, 1], "x", color=plt.cm.Set1(y[i]/10.) ) 
	if hasattr(offsetbox, 'AnnotationBbox'):
		# print "If has Attribute: offsetbox"
		# only print thumbnails with matplotlib > 1.0
		shown_images = np.array([[1., 1.]])  # just something big
		for i in range( len( bird_images_show ) ) : 
			dist = np.sum((X[i] - shown_images) ** 2, 1)
			if np.min(dist) < 4e-3:  #4e-3:
			    	# don't show points that are too close
				continue
			shown_images = np.r_[shown_images, [X[i]]]
			imagebox = offsetbox.AnnotationBbox(
				offsetbox.OffsetImage(bird_images_show[i].convert() , cmap = cm.Greys_r),
				X[i],
				frameon=False,
				pad = 0.2)
			ax.add_artist(imagebox)
	plt.xticks([]), plt.yticks([])
	if title is not None:
		plt.title(title)

	## CREATE JSON 
	data = {}
	for i in range(X.shape[0]):
		d = {
		'id' : os.path.basename(filenames[i]),
		'filename' : filenames[i],
		'feature' : FV[i,:],
		'x,y' : [X[i,0], X[i,1]]
		}
		data[os.path.basename(filenames[i])] = d

	j = json.dumps(data, cls = MyEncoder)
	f = open("imageDictionary.json", "w") 
	f.write(j)
	f.close()

def ComputeSVM(FV, DOI):
	print("Computing PCA projection")
	X_pca       = decomposition.TruncatedSVD(n_components=2).fit_transform(FV)
	#----------------------------------------------------------------------
	#Kmeans 
	print "KMeans Clustering"
	k_means = KMeans(n_clusters=3, random_state=0) #fixing the RNG is kmeans
	k_means.fit(X_pca)
	y_pred = k_means.predict(X_pca) 
	plot_embedding(X_pca, y_pred, DOI, FV) 
	plt.show()

directoryOfImages = Input()
FV = ReadImages(directoryOfImages)
ComputeSVM(FV, directoryOfImages)

