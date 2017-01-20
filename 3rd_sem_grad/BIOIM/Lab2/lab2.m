%% Ben Larson Lab 2


clear; clc; close all; 
%% Create Shapes
stack = meshgrid(1:64,1:64,1:32);
stack = stack.*0; 

cylinder_1_center = [15,32,5]; 
c1 = cylinder(stack,cylinder_1_center,3.5,24,'z',100);
cylinder_2_center = [25,50,16]; 
c2 = cylinder(stack,cylinder_2_center,3.5,24,'x',100);
cylinder_3_center = [30,32,5]; 
c3 = cylinder(stack,cylinder_3_center,1.5,24,'z',100);
cylinder_4_center = [30,20,16]; 
c4 = cylinder(stack,cylinder_4_center,1.5,24,'x',100);

sphere_1_center = [45,32,16]; 
s1 = sphere(stack,sphere_1_center,3.5,100);
sphere_2_center = [55,32,16]; 
s2 = sphere(stack,sphere_2_center,1.5,100);

m = (s1+s2+c1+c2+c3+c4);

%% PSFs
%convert to micrometers
s1 = 0.2*10;
s2 = 1*10; 
w = 3 %left+right = sigma * this 
psfx = ones(w*s1+1,w*s1+1,w*s1+1);
psfy = ones(w*s2+1,w*s2+1,w*s2+1);
g02 = fspecial('gaussian',[w*s1+1,w*s1+1],s1);
g1 = fspecial('gaussian',[w*s2+1,w*s2+1],s2);
psf1 = psf(psfx,g02,s1);
psf2 = psf(psfy,g1,s2);

psf3 = psf(psfy,g1,s1);

%% FULL WIDTH HALF MAX 
clc;
aacenter = max(max(psf1(:)));
r = ceil(size(psf1,1)/2); 
aa1= find(psf1(:,r,r) >= aacenter/2);
FullWidthHalfMax(1) = max(size(aa1))*0.1

aacenter = max(max(psf2(:)));
r = ceil(size(psf2,1)/2); 
aa1= find(psf2(:,r,r) >= aacenter/2);
FullWidthHalfMax(2) = max(size(aa1))*0.1

%% nconv

im1 = convn(m, psf1,'same');
im2 = convn(m, psf2,'same');
im3 = convn(m, psf3,'same');

%% dconv 
iter = [5,10,20];
rms_result = zeros(3,4); 
mse_result = zeros(3,3); 
for i=1:3
  dim1{i} = deconvlucy(im1,psf1,iter(i)); 
  rms_result(i,1) = rms(dim1{i}(:));
  mse_result(i,1) = mse_3d(m,dim1{i}); 
  dim2{i} = deconvlucy(im2,psf2,iter(i));
  rms_result(i,2) = rms(dim2{i}(:));
  mse_result(i,2) = mse_3d(m,dim2{i}); 
  dim3{i} = deconvlucy(im3,psf3,iter(i)); 
  rms_result(i,3) = rms(dim3{i}(:));
  mse_result(i,3) = mse_3d(m,dim3{i}); 
end 
rms_result(1,4) = rms(m(:)); 

dimw = deconvlucy(im1,psf2,10); 


%% plotting 
close all; 
%SHAPES 
vname = @(var)inputname(1);
s = vname(m);
plot_f(m,s,32,45,15,0);

%PSF 
vname = @(var)inputname(1);
s = vname(psf1);
plot_f(psf1,s,3,3,3,1);
s = vname(psf2);
plot_f(psf2,s,15,15,15,1);
s = vname(psf3);
plot_f(psf3,s,15,15,3,1); 

%convolution
vname = @(var)inputname(1);
s = vname(im1);
plot_f(im1,s,32,32,15,0);
s = vname(im2);
plot_f(im2,s,32,32,15,0);
s = vname(im3);
plot_f(im3,s,32,32,15,0); 

%deconvolution
for i = 1:3
  vname = @(var)inputname(1);
  s = vname(dim1{i});
  plot_f(dim1{i},s,32,40,15,0);
  s = vname(dim2{i});
  plot_f(dim2{i},s,32,40,15,0);
  s = vname(dim3{i});
  plot_f(dim3{i},s,32,40,15,0); 
end

%wrong deconvolve
s = vname(dimw);
plot_f(dimw,s,32,40,15,0);

%%  Find center value
clc;
slice(im1,32,32,15);
findMax(im1)
% findMax(im2)
% findMax(im3)
% findMax(dim1{3})
% findMax(dim2{3})
% findMax(dim3{3})






