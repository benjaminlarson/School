%% SHAPE FROM SHADING
clear; clc; close all; 

im1 = imread('im1.png'); 
im2 = imread('im2.png'); 
im3 = imread('im3.png'); 
im4 = imread('im4.png');

real1 = imread('real1.bmp');
real2 = imread('real2.bmp');
real3 = imread('real3.bmp');
real4 = imread('real4.bmp');

for i = 1 : 100
  for j = 1 :100
    im_1(i,j) = double(im1(i,j))/255.0; 
    im_2(i,j) = double(im2(i,j))/255.0;
    im_3(i,j) = double(im3(i,j))/255.0;
    im_4(i,j) = double(im4(i,j))/255.0; 
    
    real_1(i,j) = double(real1(i,j))/255.0;
    real_2(i,j) = double(real2(i,j))/255.0;
    real_3(i,j) = double(real3(i,j))/255.0;
    real_4(i,j) = double(real4(i,j))/255.0;
  end 
end

clearvars im1 im2 im3 im4 real1 real2 real3 real4 i j

%% Gradient 
[px1, qy1] = gradient(im_1);
[px2, qy2] = gradient(im_2);
[px3, qy3] = gradient(im_3);
[px4, qy4] = gradient(im_4);

% figure()
% v = 0.01:0.01:1;
% contour(v,v);
% hold on;
% quiver(v,v,px1,qy1); 
% hold off;
%% Find normal,albedo, p, q
% V = [0, 0.2, 0; 
%      0,   0, 0.2; 
%      1,   1, 1];
V = [0, 0, 1; 
    0.2, 0, 1;
    0, 0.2, 1];
 
for i = 1 : size(im_1)
  for j = 1 : size(im_1)
    vi = [im_1(i,j), im_2(i,j), im_4(i,j)]'; 
    I = diag(vi);%shadow matrix 
    A = I*V;
    b = I*vi; 
    g = linsolve(A,b);
    alb(i,j) = norm(g);
    nIm = g/alb(i,j); %should be a matrix from normals 
    
    n1(i,j) = nIm(1);
    n2(i,j) = nIm(2);
    n3(i,j) = nIm(3);
    
    p(i,j) = nIm(1)/nIm(3);
    q(i,j) = nIm(2)/nIm(3);
  end
end
hv = zeros(size(im_1)); 
%% Height Map

for i = 2:size(im_1)
  hv(i,1) = hv(i-1,1)+q(i,1); 
end

for i = 1:size(im_1)
  for j = 2:size(im_1)
    hv(i,j) = hv(i,j-1)+p(i,j); 
  end
end
figure();
hv = abs(hv/max(max(hv))); 
imshow(hv);

figure();
v = 1:1:size(im_1);
[x,y] = meshgrid(v,v);
[U,V,W] = surfnorm(x,y,hv);
hold on;
quiver3(hv,U,V,W);

C = size(im_1);
R = size(im_1);
[X,Y] = meshgrid (1:C, 1:R);
figure();
surf(X, Y, hv, 'EdgeColor', 'none');
camlight headlight;
lighting phong;

figure(); 
mesh(X, Y, hv );

figure();
imshow(alb); 

