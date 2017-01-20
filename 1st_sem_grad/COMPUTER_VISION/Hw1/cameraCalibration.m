% Computer Vision, Camera Calibration

%read in the images

ImageMatrix = imread('maxresdefault.jpg'); 
figure(1);
imagesc(ImageMatrix); 

xinput=ginput(8);
