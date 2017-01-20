import os
import fnmatch
import re
import glob  

from PyCACalebExtras.Common import LoadMHA, GenVideo

def sorted_nicely( l ):
    """ Sorts the given iterable in the way that is expected.
 
    Required arguments:
    l -- The iterable to be sorted.
 
    """
    convert = lambda text: int(text) if text.isdigit() else text
    alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
    return sorted(l, key = alphanum_key)


matches = [] 
mhalist = [] 
for filename in glob.glob(os.path.join('/home/sci/benl/Data_DIR/Circular/InBetween/','*.mha')):
    matches.append(filename)
matches.append('/home/sci/benl/Data_DIR/Circular/finalImage0.mha') 

matches = sorted_nicely(matches)
print matches
for x in matches:
    y = LoadMHA(x)
    mhalist.append(y) 
GenVideo.MakeVideo('/home/sci/benl/Data_DIR/Circular/movie', mhalist, 
	dim='y', sliceIdx = 147, axis = 'cart',fps =1) 