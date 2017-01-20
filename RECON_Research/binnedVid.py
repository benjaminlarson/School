import GenVideo
import os
import fnmatch
import re 

from PyCACalebExtras.Common import LoadMHA

def sorted_nicely( l ):
    """ Sorts the given iterable in the way that is expected.
 
    Required arguments:
    l -- The iterable to be sorted.
 
    """
    convert = lambda text: int(text) if text.isdigit() else text
    alphanum_key = lambda key: [convert(c) for c in re.split('([0-9]+)', key)]
    return sorted(l, key = alphanum_key)

# mhalist_ex = []
# mhalist_in = []
print "--------------------------------------------------------------"
# print glob.glob('/home/sci/benl/yaml/p4/outputAmpCUDA_ex_10bins/*.mha')
# for x in glob.glob('/home/sci/benl/yaml/p4/outputAmpCUDA_ex_10bins/*.mha'):
#     y = LoadMHA(x)
#     mhalist_ex.append(y) 

# for x in glob.glob('/home/sci/benl/yaml/p4/outputAmpCUDA_in_10bins/*.mha'):
#     y = LoadMHA(x)
#     mhalist_in.append(y) 

##   ADJUSTED   ## 
# for x in glob.glob('/home/sci/benl/yaml/p4/adjusted/outputAmpCUDA_inAdj_10bins/*.mha'):
#     y = LoadMHA(x)
#     mhalist_in.append(y) 
# GenVideo.MakeVideo('/home/sci/benl/where_ever_output_is', mhalist)


matches = []
mhalist = []
# for root, dirnames, filenames, in os.walk('/home/sci/benl/yaml2/phasebin/PT1/PT1_round2'):
# 	for filename in fnmatch.filter(filenames, '*i.mha'):
# 		print filename
# 		matches.append(os.path.join(root,filename))
for filename in glob.glob(os.path.join('/home/sci/benl/Aa_Soaked_Phantom_Sept22/SoakedPhantom_Sept22_2015_Utah','*i.mha')):
    matches.append(filename)

matches = sorted_nicely(matches)
for x in matches:
    y = LoadMHA(x)
    mhalist.append(y) 
GenVideo.MakeVideo('/home/sci/benl/Aa_Soaked_Phantom_Sept22/SoakedPhantom_Sept22_2015_Utah', mhalist, 
	dim='x', sliceIdx = 200, axis = 'cart') 

#ffmpeg -framerate 1 -pattern_type glob -i '*.png' -c:v libx264 -pix_fmt yuv420p -crf 18 out.mp4
