%% Assignment 5

 %% part 1 & 2 segmentation 
clear; clc; close all; 
I = imread('brain.png');
I(I >= 60) = 0;
I(I ~= 0) = 1; 
figure();imagesc(I);colormap gray;colorbar; 
Imseg(76,130) = 1; 
seed   = [76,130]; 
Imseg = Find_Ventricle(I,seed); 
figure('Name','Ventricle');imagesc(Imseg); colormap gray; colorbar; 

%% Part 3 Noise 
I = imread('brain.png');
I = double(I) + 30*randn(256); 
I(I >= 60) = 0;
I(I ~= 0) = 1;
subplot(2,2,1);imagesc(I);colormap gray;colorbar; 

Imseg(76,130) = 1;
seed   = [76,130];

Imseg = Find_Ventricle(I,seed);
subplot(2,2,2);imagesc(Imseg); colormap gray; colorbar;

for i = 1:1
  Imfixd = Dilation(Imseg);
end
subplot(2,2,3);imagesc(Imfixd);colormap gray; colorbar;

Imfixe = Erosion(Imfixd);
subplot(2,2,4); imagesc(Imfixe);colormap gray; colorbar;
