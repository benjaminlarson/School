#This code is written to test PCA/scattering for 3 dimensions

import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
from sklearn import (manifold, datasets, decomposition, ensemble, lda,
                     random_projection)
import re 
import mpl_toolkits.mplot3d.axes3d as p3
from scipy.cluster.vq import *
from numpy.random import *

plt.close('all')


# Create 3 random distributed classes in 3 dimensions 
class1 = 1.5 * randn(100,3)
# print "class1 ", class1.shape
class2 = randn(100,3) + np.array([5,5,5])
# print "class2 ", class2.shape
class3 = randn(100,3)  + np.array([10,10,10])

# 3D PLOTTING --------------------------------------------
# We need to create a figure to handle the 3d plotting. 
# fig = plt.figure()
# ax = p3.Axes3D(fig)
# scatter plot in 3D 
# ax.scatter3D(class1[:,0],class1[:,1],class1[:,2] ,c= 'r')
# plt.hold(True)
# ax.scatter3D(class2[:,0],class2[:,1],class2[:,2], c= 'b')
# ax.scatter3D(class3[:,0],class3[:,1],class3[:,2], c = 'm')
# plt.show()
#--------------------------------------------------------
# stack the classes into a 300x3 array (row = class, column = dimension)
features = np.vstack((class1, class2, class3)) 
# print "features", features.shape
# Scale and visualize the embedding vectors

#----------------------------------------------------------------------
def plot_embedding(X, y, title=None):
    x_min, x_max = np.min(X, 0), np.max(X, 0)
    X = (X - x_min) / (x_max - x_min)

    plt.figure()
    ax = plt.subplot(111)
    name = ''
    for i in range(X.shape[0]):
        plt.text(X[i, 0], X[i, 1], 'x',color=plt.cm.Set1(y[i]/10.) )
        print y[i]

#----------------------------------------------------------------------
# Projection on to the first 2 principal components

print("Computing PCA projection")
X_pca = decomposition.TruncatedSVD(n_components=2).fit_transform(features)

#----------------------------------------------------------------------
#Kmeans 
print "KMeans Clustering"
from sklearn.cluster import KMeans

k_means = KMeans(n_clusters=2, random_state=0) #fixing the RNG is kmeans
# k_means.fit(notBirdsX)
# y_pred = k_means.predict(notBirdsX)
k_means.fit(X_pca)
y_pred = k_means.predict(X_pca) 
# print y_pred
# print birdClass[0]
plot_embedding(X_pca, y_pred,
    "Principal Components projection of Feature Vectors")
plt.show()