import numpy as np
import glob, os, sys
from PIL import Image
from scipy.ndimage import filters
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from matplotlib import offsetbox
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--images", dest = 'iFilenames', 
	help = "path to the input images directory(1 dir only)")
parser.add_argument("-o", "--output", dest= 'oFilenames', 
	help = "path to the output image directory" ) 

args = parser.parse_args()

inDirectory = args.iFilenames
outDirectory = args.oFilenames

all_images = glob.glob("%s/*.png" %inDirectory)

for infile in all_images:
	print 'infile', infile
	im = np.array(Image.open(str(infile)).convert('L'))

	#ORIGINAL IMAGE HISTOGRAM 
	plt.hist(im.flatten(), 16, normed = 1, fc = 'k', ec = 'k')
	fileID = os.path.basename( str(infile) )
	fn, ext = os.path.splitext(fileID)
	plt.savefig("%s/%s_histogram.png"%(outDirectory, fn))
	plt.clf()

	## GRADIENT 
	imx = np.zeros( im.shape ) 
	filters.sobel( im, 1, imx )
	imy = np.zeros( im.shape )
	filters.sobel( im, 0, imy )
	magnitude = np.sqrt ( imx**2 + imy**2 )

	plt.imshow(magnitude, cmap=cm.Greys_r) 
	plt.savefig("%s/%s_gradient.png"%(outDirectory, fn))
	plt.clf()

	## FILTER OUT ZEROS
	magnitude = magnitude[np.where(magnitude > 1.0e-3)]

	## HISTOGRAM
	n, bins, patches = plt.hist(magnitude, 16,  normed = 1)
	plt.savefig("%s/%s_histogram_gradient.png"%(outDirectory, fn))
	plt.clf()

