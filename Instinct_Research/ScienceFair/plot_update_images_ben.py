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
from optparse import OptionParser
import re 

#
#  Read in command line options
#
"""
parser = OptionParser()
parser.add_option("-i", "--images", dest="image filenames",
                  help="where all the images are located")
parser.add_option("-j", "--json", dest="verbose", default=True,
                  help="don't print status messages to stdout")

(options, args) = parser.parse_args()
"""

##LOAD IN ALL THE DATA
#---------------------------------------------------------------------------
i = 0
#birds = np.zeros( [59, 64 * 64 ] )
birds = np.zeros( [169, 128 * 128 ] )
birds = np.zeros( [900, 128 * 128 ] )
bird_images_show = []
#all_images = glob.glob("*.png")
#all_images = glob.glob("/usr/sci/projects/cbir/data/CUB_200_2011_crop/bin9/124.Le_Conte_Sparrow/*.jpg")
#all_images = glob.glob("/Users/d3k084/PNNL 2/CBIR/data/CUB/images/10*/*.jpg")


#Using CSV and text file as feature vector and class 
with open('files.txt') as f:
  birdName = f.readlines()  # birdName = int <space> string

#using numpy csv reader 
birdFeatures = np.loadtxt(open('alpha.csv','rb'),delimiter=',') # matrix of features 
# print "birdFeaturesSize: ", birdFeatures.shape
# for i in birdFeatures:
#   print i 
#change this to local, singular, directory that contains all the bird images
str_data_dir = "combined_birds"


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
  # FeatureArray[i,:] = features[i,:]

## WHICH CLASS TO USE, SELECT A SUBSET OF CLASSES TO PLOT 
#---------------------------------------------------------------------------
#choose class here (1-20): 
classes_to_use = [11,13,15]

## initialize data structures
#this is a guess, and is later resized may need to be read in from file? 
exclusiveFeatureArray  = np.zeros( [900,1024] )
exclusiveFnames = []
birdClass = []

# print "eFA shape = ", exclusiveFeatureArray.shape
# print "featureA = ", features.shape
# track where we are in all features/images (0 - 900)
counter = 0 
#track where we are in new exclusive data structures (0- ? )
exclusiveArrayPlacement = 0 

## create the data structure for a class 
# go through the entire set of images (features, names) 
for e in fnames:
  x = e.split() 
  if   int(x[0])   in   classes_to_use:  
    # print "class nubmer, x[0] = ", x[0] 
    # print "counter ", counter
    # print "exAP ", exclusiveArrayPlacement
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
    # exclusiveFeatureArray[exclusiveArrayPlacement] = 1  
    # exclusiveFeatureArray.append( features[counter] ) # has no attribute append
    exclusiveArrayPlacement = exclusiveArrayPlacement + 1

    # make a list: class=int, filename=string, feature=array
    # create a tuple that stores the new class
    if x[1] in modFnames[counter]:
      birdClass = birdClass + ([ int(x[0]), x[1], features[counter,:] ])
  counter = counter + 1

#we now have our list of features and their corresponding File names: 
#resize so not a bunch of zeros at end of matrix 
# print "eAP = " , exclusiveArrayPlacement
exclusiveFeatureArray = np.resize(exclusiveFeatureArray,(exclusiveArrayPlacement,1024))
all_images = exclusiveFnames #names w/filename
# print "exclusiveCounter: ", exclusiveFeatureArray.shape
i = 0
for infile in all_images:
    # print "infile" , infile
    im = Image.open(infile).convert("L")
    im_data = im.resize( (128,128), Image.NEAREST)
    im_show = im.resize( (64,64), Image.ANTIALIAS)
    bird_images_show.append( im_show )
    pixels = list( im_data.getdata() )
    birds[i,:] = pixels
    i = i + 1

#----------------------------------------------------------------------

# Scale and visualize the embedding vectors
def plot_embedding(X, y, title=None):
    x_min, x_max = np.min(X, 0), np.max(X, 0)
    X = (X - x_min) / (x_max - x_min)

    plt.figure()
    ax = plt.subplot(111)

    for i in range(X.shape[0]):
        plt.text(X[i, 0], X[i, 1], "x", color=plt.cm.Set1(y[i]/10.) ) 
        

    if hasattr(offsetbox, 'AnnotationBbox'):
        # only print thumbnails with matplotlib > 1.0
        shown_images = np.array([[1., 1.]])  # just something big
        for i in range( len( bird_images_show ) ) : #digits.data.shape[0]):
            dist = np.sum((X[i] - shown_images) ** 2, 1)
            if np.min(dist) < 4e-3:  #4e-3:
                # don't show points that are too close
                continue
            shown_images = np.r_[shown_images, [X[i]]]
            imagebox = offsetbox.AnnotationBbox(
                offsetbox.OffsetImage(bird_images_show[i], cmap=plt.cm.gray),
                # offsetbox.OffsetImage(bird_images_show[i]) ,
                X[i],
                frameon=False,
                pad = 0.2)
            ax.add_artist(imagebox)
    plt.xticks([]), plt.yticks([])
    if title is not None:
        plt.title(title)

    # CREATE DICTIONARY  ----------------------------------------------------
    data = {}

    for i in range(X.shape[0]):
      d = {
        'id' : os.path.basename(modFnames[i]),
        'filename' : modFnames[i],
        'feature' : features[i,:],
        'x,y' : [X[i,0], X[i,1]]
      }
      data[os.path.basename(modFnames[i])] = d

    import json
    from json import JSONEncoder

    # customize output w/ this custom serialization 
    class MyEncoder(JSONEncoder):
      def default(self, obj) :
        if isinstance(obj, np.ndarray) and obj.ndim ==1:
          return obj.tolist()
        return json.JSONEnconder.default(self,obj)

    j = json.dumps(data, cls = MyEncoder)
    f = open("imageDictionary_hooded_olive_red.json", "w") 
    f.write(j)
    f.close()

#----------------------------------------------------------------------
# Projection on to the first 2 principal components

print("Computing PCA projection")

BirdsX = exclusiveFeatureArray
print "birdsX: ", BirdsX.shape
for i in BirdsX:
  print i
X_pca_M = decomposition.TruncatedSVD(n_components=2).fit_transform(BirdsX)
X_pca      = decomposition.TruncatedSVD(n_components=2).fit_transform(BirdsX)

#----------------------------------------------------------------------
#Kmeans 
print "KMeans Clustering"
from sklearn.cluster import KMeans

k_means = KMeans(n_clusters=3, random_state=0) #fixing the RNG is kmeans
# k_means.fit(notBirdsX)
# y_pred = k_means.predict(notBirdsX)
k_means.fit(X_pca_M)
y_pred = k_means.predict(X_pca_M) 
# print y_pred
plot_embedding(X_pca, y_pred,
    "Principal Components projection of Feature Vectors")

plt.show()


