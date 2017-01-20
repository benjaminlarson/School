Instructions for executing plot_images.py

command line flags:

-i
*png image directory. For the bird data this should be the combined bird data. Else this is just a directory of images. Will need to change code for other file formats.

-j
Name of the json file. 

-b
3 classes of birds to look at in bird data. If want to execute bird values. Make sure alpha.csv and files.txt are in the local directory or will not work. 

ex:

plot histogram data

python -i cleanedimages/ 
python -i cleanedimages/ -j myJsonName

python -i combined_birds/ -b 1 2 3 
python -i combined_birds/ -b 5 7 19 -j myBirdJson 