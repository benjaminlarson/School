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
def read_images_as_data( path, ds ):

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
     if i == 0:  # initialize the array
        im_data_list = list( im_data )
     else:
        im_data_list.append( im_data )
     #print pixels 
     i = i + 1

   return im_data_list 

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

#all_images_data = read_images_as_data( images_path, 128 )
all_images = read_images( images_path, 128 )
print "shape: " + str( all_images.shape )


#
# compute distances
#
all_dist = np.zeros( [all_images.shape[0], all_images.shape[0]] )

for i in range(0, 1 ): #all_images.shape[0]):

   all_images_align = allign_images ( i, all_images ) 
   all_images_data = covert_to_data( all_images_align )

   for j in range(0, all_images_data.shape[0]):
     image_i = all_images_data[i,:]
     image_j = all_images_data[j,:]
     dist = compute_distance( image_i, image_j )
     all_dist[i,j] = dist

print all_dist

#SVD on each image (PCA)
#get the first two vectors
#two axis are the transformation (columns in the matrix)
#multiply the image by the transform

