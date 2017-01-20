%real
%% SHAPE FROM SHADING
clear; clc; close all; 

real1 = imread('real1.bmp');
real2 = imread('real2.bmp');
real3 = imread('real3.bmp');
real4 = imread('real4.bmp');
[d1,d2] = size(real1); 

for i = 1 : d1
  for j = 1 : d2
    im_1(i,j) = double(real1(i,j))/255.0;
    im_2(i,j) = double(real2(i,j))/255.0;
    im_3(i,j) = double(real3(i,j))/255.0;
    im_4(i,j) = double(real4(i,j))/255.0;
  end 
end

clearvars im1 im2 im3 im4 real1 real2 real3 real4 i j

%% Gradient 
% [px1, qy1] = gradient(im_1);
% [px2, qy2] = gradient(im_2);
% [px3, qy3] = gradient(im_3);
% [px4, qy4] = gradient(im_4);
% 
% v = 0.01:0.01:1;
% contour(v,v);
% hold on;
% quiver(v,v,px1,qy1); 

%% Find normal,albedo, p, q
V = [-0.38359, -0.236647, 0.892668;
    -0.372825,  0.303914, 0.87672;
     0.203844, -0.096308, 0.974255]; 
 
for i = 1 : d2
  for j = 1 : d2
    vi = [im_1(i,j), im_2(i,j), im_4(i,j)]'; 
    I = diag(vi);%shadow matrix 
    A = I*V;
    b = I*vi; 
    g = linsolve(A,b);
    if isnan(g)
       g = [0; 0; 0];
       nIm = [0; 0; 0];
      else
       nIm = g / norm(g);
      end
      alb(i,j) = norm(g);
      %nIm = g/alb(i,j); %should be a matrix from normals 

      n1(i,j) = nIm(1);
      n2(i,j) = nIm(2);
      n3(i,j) = nIm(3);

      p(i,j) = nIm(1)/nIm(3);
      if isnan(p(i,j))
        p(i,j)=0; 
      end
      q(i,j) = nIm(2)/nIm(3);
      if isnan(q(i,j))
        q(i,j) = 0; 
      end
  end
end
hv = zeros(size(im_1)); 
%% Height Map
figure('name','contour')
v = 1:5:d1;
meshgrid(v,v);
hold on;
quiver(v,v,p(1:5:d1,1:5:d1),q(1:5:d1,1:5:d1));

for i = 2:d1
  hv(i,1) = hv(i-1,1)+q(i,1);
end

for i = 1:d2
  for j = 2:d1
    hv(i,j) = hv(i,j-1)+p(i,j); 
  end
end
hv = abs(hv/norm(hv)); 
figure('name','hv');
imshow(hv);

C = d2;
R = d1;
[X,Y] = meshgrid (1:C, 1:R);
figure('name','surf hv');
surf(X, Y, hv, 'EdgeColor', 'none');
camlight left;
lighting phong;

figure('name','mesh x,y,hv'); 
mesh(X, Y, hv );

figure('name','alb');
imshow(alb); 

