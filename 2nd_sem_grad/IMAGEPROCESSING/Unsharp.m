clear; close all; clc; 
I = zeros(4,4);
I(1:2,1:4) = 1;
% imagesc(I);colormap gray; 

Ilp = [0,1,0;1,-4,1;0,1,0];

im = conv2(Ilp,I);
im = I-im(2:5,2:5); 
imagesc(im); colormap gray; 

