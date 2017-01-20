
import numpy as np
import random
import glob, os, sys
from PIL import Image
from scipy.ndimage import filters
import matplotlib.pyplot as plt
import pylab as P 
import matplotlib.cm as cm
from matplotlib import offsetbox
from sklearn import (manifold, datasets, decomposition, ensemble, lda,
                     random_projection, cross_validation, svm)
from sklearn.cluster import KMeans
import re 
import argparse
import json
from json import JSONEncoder
# import bird_plot

filenames = [] #for JSON access

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
	parser.add_argument("-j", "--json", dest= "json_name", default = False,
		help = "Don't print status messages to stdout" ) 
	parser.add_argument("-fv", "--feature_vector", dest = 'input_feature_vector', default = False,
		help = "feature vector")
	parser.add_argument("-b", "--birdplot",  dest = "classes", default = False,
		help = "Plot bird data. CSV feature vector and combined image dir assumed to be in this dir")
	args = parser.parse_args()
	return args

def ReadImages(dir):
	all_images = glob.glob("%s/*.png" %dir)
	feature_vector = np.zeros( (len(all_images), 16) ) #number of images x grayscale bins
	i = 0
	for infile in all_images:
		# print "infile" , infile
		filenames.append(infile)
		feature_vector[i] =  FindFeatures(infile)
		i = i + 1
	return feature_vector, filenames

def FindFeatures(infile):
	# im = np.array(Image.open(infile))
	im = infile.astype(np.float)
	histlist = []
	print "imshape", im.shape
	imderivatives = []
	for i in xrange(0,3):
		imTemp = im[:,:,i]
		print "imTemp", imTemp.shape
		imx = np.zeros( imTemp.shape ) 
		filters.sobel( imTemp, 1, imx )
		imy = np.zeros( imTemp.shape )
		filters.sobel( imTemp, 0, imy )
		magnitude = np.sqrt ( imx**2 + imy**2 )
		# magnitude = magnitude[np.where(magnitude > 1.0e-3)]
		imderivatives.append(magnitude)
		print "magshape", magnitude.shape
	print "len ImageDir", len(imderivatives)
	im = np.dstack((imderivatives))
	print "imderivatives Finished", im.shape 
	# magnitude = im
	## FILTER OUT ZEROS 
	# print "mag shape", magnitude.shape
	# print "magnitude", magnitude
	# print "im", np.max(im)
	# print "IMSHAPE", im.shape
	nc = im.shape #should be 3
	hist = [np.histogram(im[:,chan],
			bins = 16,
			range = (0., 255.),
			density = True)
		for chan in range(0,3)]
	# print "hist", len(hist)
	# print "hist", hist
	hist = np.hstack((hist[0][0],hist[1][0], hist[2][0]))
	# hist = np.hstack(hist[:][:])
	# print "New hist", hist
	# print "vsthist", np.hstack(hist)
	return hist

def plot_embedding(plt, X, y, DOI, FV, title=None):
	# all_images = glob.glob("%s/*.png"%DOI) 
	i = 0
	bird_images_show = []
	for infile in DOI:
	# 	im = Image.open(infile).convert("L")
		im_show = infile.resize( (64,64), Image.ANTIALIAS)
		bird_images_show.append( im_show )
	# 	i = i + 1
	 
	# x_min, x_max = np.min(X, 0), np.max(X, 0)
	# X = (X - x_min) / (x_max - x_min)
	ax = plt.subplot(111)
	for i in range(X.shape[0]):
    		plt.text(X[i, 0], X[i, 1], "x", color=plt.cm.Set1(y[i]/10.) ) 

	###Plot the decision boundary. For that, we will assign a color to each
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

def ComputeSVM(FV, DOI):
	print("Computing PCA projection")
	print "FV", FV.shape

	reduced_data = decomposition.TruncatedSVD(n_components=2).fit_transform(FV)
	#----------------------------------------------------------------------
	#Kmeans 
	#Normalize Values 
	x_min, x_max = reduced_data[:, 0].min() , reduced_data[:, 0].max() 
	y_min, y_max = reduced_data[:, 1].min() , reduced_data[:, 1].max() 
	nx = (reduced_data[:,0] - x_min) / (x_max - x_min)
	ny = (reduced_data[:,1] - y_min) / (y_max -y_min)
	q = nx.shape
	for i in xrange(0,q[0]):
		reduced_data[i] = [nx[i], ny[i]]
	# print reduced_data
	X_pca = reduced_data
	dTrain = X_pca[0::2]
	dTest = X_pca[1::2]
	print "KMeans Clustering"
	k_means = KMeans(n_clusters=10, init = 'random', n_init = 15, random_state=0) #fixing the RNG is kmeans
	k_means.fit(dTrain)
	y_pred = k_means.predict(dTest) 
	crt = 0
	fl = 0
	print "lenYpred", len(y_pred) 
	print y_pred
	##### accuracy using histograms
	for x, y in zip (y_pred, y_pred[1:]):
		if (x == y):
			print "correct", x, y 
			crt +=1
		else:
			print "fail", x, y
			fl +=1

	##### accuracy of feature array not from the histogram:
	# for x, y in zip (y_pred, y_pred[10:]):
	# 	if (x == y):
	# 		print "correct", x, y 
	# 		crt +=1
	# 	else:
	# 		print "fail", x
	print "correct", crt,
	print "fail", fl,

	h = 0.001
	x_min, x_max = reduced_data[:, 0].min() , reduced_data[:, 0].max() 
	y_min, y_max = reduced_data[:, 1].min() , reduced_data[:, 1].max() 
	xx, yy = np.meshgrid(np.arange(0,1, h), np.arange(0,1, h))
	Z = k_means.predict(np.c_[xx.ravel(), yy.ravel()])
	Z = Z.reshape(xx.shape)
	plt.imshow(Z, interpolation='nearest',
           		extent=(xx.min(), xx.max(), yy.min(), yy.max()),
           		cmap=plt.cm.Paired,
          		aspect='auto', origin='lower')
	centroids = k_means.cluster_centers_
	plt.scatter(centroids[:, 0], centroids[:, 1],
            marker='x', s=169, linewidths=3,
            color='k', zorder=10)
	plt.hold(True)
	print "DOI", len(DOI)
	plot_embedding(plt, dTest, y_pred, DOI[1::2], FV[1::2]) 
	plt.show()
	return X_pca, y_pred

def CreateJson(name_json, filename, FV, X):
	## CREATE JSON 
	data = {}
	for i in range(X.shape[0]):
		d = {
		'id' : os.path.basename(filename[i]),
		'filename' : filename[i],
		'feature' : FV[i,:],
		'x,y' : [X[i,0], X[i,1]]
		}
		data[os.path.basename(filename[i])] = d

	j = json.dumps(data, cls = MyEncoder)
	jsonName = ("%s.json")%name_json
	f = open(jsonName, "w") 
	f.write(j)
	f.close()

# def main():
# 	inputArgs = Input()
# 	if inputArgs.classes:
# 		classNum = re.findall(r'\b\d+\b', inputArgs.classes) 
# 		print classNum
# 		classNum = map(int, classNum)
# 		print classNum
# 		X, ImageFiles, FV = bird_plot.bp(classNum[0], classNum[1], classNum[2])
# 	else:
# 		FV, ImageFiles = ReadImages(inputArgs.filenames)
# 		X = ComputeSVM(FV, inputArgs.filenames)

# 	if inputArgs.json_name: 
# 		CreateJson(inputArgs.json_name, ImageFiles, FV, X)

# if  __name__ =='__main__':
# 	main()
