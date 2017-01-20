import glob
import argparse
from PIL import Image
import numpy as np

np.set_printoptions(threshold=np.nan)

#
#  Read in command line options (use argparse instead)
#
def setup_options():

   parser = argparse.ArgumentParser()
   parser.add_argument('-i', 
                     action='store',
		     dest='imagedir',
                     help='image dir')
   return parser
 
#
# Read in the image data
#  
def read_images( path, ds ):

   image_names = glob.glob( path )
   image_names.sort()
   print image_names

   i = 0
   for infile in image_names:
     print "reading ", infile
     im = Image.open(infile).convert("L")
     im_data = im.resize( (ds,ds), Image.NEAREST)
     #im_show = im.resize( (32,32), Image.ANTIALIAS)
     #bird_images_show.append( im_show )
     pixels = np.array(im_data).flatten().astype('float')
     pixels /= np.sum(pixels) # normalize 
     #print pixels
     #print i
     #image_pixels[i,:] = pixels
     if i == 0:  # initialize the array
        image_pixels = pixels[None,:]
     else:
        image_pixels = np.vstack((image_pixels, pixels[None,:]))
     #print pixels 
     i = i + 1

   return image_pixels


#
#  compute distances
#
def compute_distance( p, q ):
   dist = 0
   dist = np.sqrt(np.sum((np.sqrt(p) - np.sqrt(q)) ** 2)) / np.sqrt(2)
   return dist

#
#  main
#
parser = setup_options( )
parser_args = parser.parse_args()

images_path = parser_args.imagedir 
print images_path

all_images = read_images( images_path, 128 )
print "shape: " + str( all_images.shape )

#
# compute distances
#
all_dist = np.zeros( [all_images.shape[0], all_images.shape[0]] )
for i in range(0, all_images.shape[0]):
   for j in range(0, all_images.shape[0]):
     image_i = all_images[i,:]
     image_j = all_images[j,:]
     dist = compute_distance( image_i, image_j )
     all_dist[i,j] = dist

print all_dist


