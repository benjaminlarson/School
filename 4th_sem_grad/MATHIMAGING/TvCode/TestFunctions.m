%% Testing functions
clear; clc; close all; 
% figure('units','normalized','outerposition',[0 0 1 0.5]); 

% Change this to 0 to not save images. 
% Plots not saved, just images to improve quantization
%(clean images have psudeo staircase effect w/ colormaps)
saveimages = 0; 
cm = jet(256); % increase resolution of colormap 
%% Original test image 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
%         u(i,j) = mod(i,40); 
            u(i,j) = i/10.; 
         if i < j
           u(i,j) = 30; 
         end 
    end
end 
n = randn(size(u)); 
im = double(u + n);
u0= im; 

%% Younes 
iter = 500; 
lambda = 0.1; 
stepsize = 1e-2; 
[dim, e] = youne(im, iter,lambda, stepsize); 
figure(); plot(e); 
d_im = figure(); imagesc(dim);colormap(cm); 
if saveimages == 1 
   print(d_im,'YounnesdenoisedIm','-dpng'); 
end 

%% Lysaker, MRI paper, partial pde 
%parameters
clc; 
lam1 = 1e-1; 
lam2 = 1e-1;
%step size for gradient descent 
stepU =1e-2; 
stepV = 1e-2; %MAKE THIS LESS THAN .01!!!
E1iter = 100;
E2iter = 100; 
[dim1,dim2, e1,e2] = dropPartial(im,E1iter,E2iter,lam1,lam2,stepU,stepV); 
figure('name','e1');plot(e1,'r');hold on ;plot(e2,'b');legend('No Partial','Including Partial');  

images = figure('units','normalized','outerposition',[0 0 1 0.5]);  
subplot(1,3,1);
imagesc(im);colormap(cm); 
subplot(1,3,2);
imagesc(dim1);colormap(cm); legend('im1'); 
subplot(1,3,3);
imagesc(dim2); colormap(cm); legend('im2'); 

figure();
subplot(1,2,1); 
plot(im(:,25),'b'); hold on; 
plot(dim2(:,25),'--r'); 
plot(dim1(:,25),'--k'); hold off;
legend('NoiseIm','Nopartial','HighOrder'); 
subplot(1,2,2); 
plot(im(:,200),'b'); hold on; 
plot(dim1(:,200),'--r'); 
plot(dim2(:,200),'--k'); hold off; 
legend('NoiseIm','NoPartial','HigherOrder'); 

if saveimages == 1 
   print(images,'Lysakerpartial','-dpng'); 
end 
%% Lysaker, Convex combination: TV+Higher Order
lam1 = 1e-3; 
lam2 = 1e-3;
%step size for gradient descent 
stepU =1e-2; 
stepV = 1e-2;  
iter = 100; 
% Combination of u+v 
theta = 1/2.*ones(size(u)); 
c = 1/25; 
[imd,e1,e2] = highPDEConvex(im,lam1,lam2,stepU,stepV,iter,theta,c); 
figure(); 
plot(e1,'r'); hold on; plot(e2); legend('e1, u optimized', 'e2, v optimized'); 
images = figure('units','normalized','outerposition',[0 0 1 0.5]) ; 
subplot(1,2,1);
imagesc(u0);colormap(cm); 
subplot(1,2,2);
imagesc(imd);colormap(cm); 
% figure();imagesc(theta); 
figure();
subplot(1,2,1); 
plot(u0(:,25),'b'); 
hold on; 
plot(imd(:,25),'--r'); 
legend('NoiseIm','HighOrder','TV'); 
subplot(1,2,2); 
plot(u0(:,200),'b'); 
hold on; 
plot(imd(:,200),'--r'); 
legend('NoiseIm','HighOrder','TV'); 
if saveimages == 1 
   print(images,'LysakerConvex','-dpng'); 
end 
%% Chan, Esedogu, Park
% "A fourth order dual method for staircase reduction in 
% texture extraction and Image Restoration Problems" 
alpha = 1; 
lambda = 1; 
iter = 100; 
L2PrimalDual(im,alpha,lambda,iter, saveimages); 