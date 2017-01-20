%% Morph Image Processing 
clear; clc; close all; 
%% test im
% im1 = imread('morph_shape1.tiff'); 
% im1 = double(im1); 
% im2 = imread('morph_shape2.tiff');
% im2 = double(im2); 
im1 = rgb2gray(imread('mind.jpg')); 
im1 = double(im1); 
im2 = rgb2gray(imread('mind.jpg'));
im2 = double(im2); 
data = [181.0 163.0
70.0 97.0
259.0 267.0
75.0 71.0 
269.0 278.0 
120.0 110.0 
261.0 289.0 
167.0 154.0
185.0 193.0 
177.0 180.0 
102.0  84.0 
170.0 206.0 
91.0 75.0 
123.0 167.0 
99.0 63.0 
81.0 123.0]; 

d1x = data(1:2:end,1);
d1y = data(2:2:end,1);
d2x = data(1:2:end,2);
d2y = data(2:2:end,2);

x1 = [d1x,d1y]; 
x2 = [d2x,d2y]; 
%% my data 
% im1 = rgb2gray(imread('mind.jpg')); 
% im1 = double(im1); 
% im2 = rgb2gray(imread('mind.jpg'));
% im2 = double(im2); 

% imagesc(im1); 
% [d1x,d1y]= ginput(8); 
% [d2x,d2y]=ginput(8); 
% x1 = [d1x,d1y]; 
% x2 = [d2x,d2y]; 

%% Morph/interp code
figure(); 
scatter(x1(:,1),x1(:,2),'k'); 
hold on 
scatter(x2(:,1),x2(:,2),'g'); hold on; 

data = x1; constraint = x2; 
b2 = devkernelWarp(x1,x1);
b1 = [data(:,1)';data(:,2)';ones(size(data(:,1)))';]; 
b3 = [zeros(3,3)]; 
B = [b1,b3;b2,b1'];
z = zeros(size(B)); 
A = [B,z;z,B]; 
b = [0;0;0;constraint(:,1);0;0;0;constraint(:,2);]; 
px = A\b; 

cx = px(1:11); 
cy = px(12:22); 
for i= 1:8
    rx = [b2(:,i);x1(i,1);x1(i,2);1]; 
    nx(i) = cx'*rx;
    ry = [b2(:,i);x1(i,1);x1(i,2);1];
    ny(i) = cy'*ry; 
    scatter(nx,ny,'xb'); 
end 
% ginput(1); 
close all; 
warpim = zeros(2*size(im1)); 
for i = 1:size(im1,1)
    for j = 1:size(im1,2)
        u = [x1(:,1)-i, x1(:,2)-j];
        u = sqrt(sum(u.^2,2));
        r = u.^2.*log(u+1e-6);
        rx = [ r; i; j; 1];
        warpx(i,j) = cx'*rx;
        warpy(i,j) = cy'*rx;
        wx = warpx(i,j); 
        wy = warpy(i,j); 
        warpim(round(wx+500),round(wy+500)) = im1(i,j);
    end 
end 

wi = zeros(size(warpim)); 
source_im = warpim;

sig = 10; 
ux = warpx(:); 
uy = warpy(:); 
x = [ux, uy]; 
for i = 1:size(warpx,1)
    for j = 1:size(warpx,2)
%         wi(i,j) = [1-i, i]*[source_im(i,i), source_im(i,j+1); source_im(i+1,j), source_im(i+1,j+1)]*[1-j; j]; 
%             wi(i,j) = sum([source_im(i,i), source_im(i,j+1),source_im(i+1,j), source_im(i+1,j+1)])/4; 
            xlocal = repmat([i,j],size(x,1),1); 
            w = 1/(2*pi*sig^2).*exp(-(x-xlocal).^2./(2*sig^2));
            wi(i,j) = 1/sum(w(:)).*sum(dot(w,xlocal)); 
    end 
end 
figure(); 
im1 = im1./max(im1(:)); 
im2 = im1; 
warpim = warpim./max(warpim(:)); 
wi = wi./max(wi(:)); 
subplot(3,1,1);
imshow(im1); hold on;
scatter(x1(:,1), x1(:,2),'xw'); hold off; 
subplot(3,1,2);
imshow(im2); hold on;
scatter(x2(:,1),x2(:,2),'xw'); hold off; 
subplot(3,1,3);
figure(); 
imshow(warpim); 
figure();
imshow(wi); 

