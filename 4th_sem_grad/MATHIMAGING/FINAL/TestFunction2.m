%% Testing functions
clear; clc; close all; 
% figure('units','normalized','outerposition',[0 0 1 0.5]); 

% Change this to 0 to not save images. 
% Plots not saved, just images to improve quantization
%(clean images have psudeo staircase effect w/ colormaps)
saveimages = 0; 
cm = gray(256); 
%% Original test image 
u = double(rgb2gray(imread('test.jpeg'))); 
n = randn(size(u)); 
im = double(u + 20.*n);
u0= im; 

%% Younes 
iter = 1000; 
lambda = 2e-2; 
stepsize = 5e-2; 
[dim, e] = youne(im, iter,lambda, stepsize); 
figure(); plot(e); 
d_im = figure(); imagesc(dim);colormap(cm); 
if saveimages == 1 
   print(d_im,'YounnesdenoisedIm','-dpng'); 
end 

%% Lysaker, MRI paper, partial pde 
%parameters
clc; 
lam1 = 2e-2; 
lam2 = 1e-1;
%step size for gradient descent 
stepU =1e-2; 
stepV = 1e-2; %MAKE THIS LESS THAN .01!!!
E1iter = 2000;
E2iter = 2000; 
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
lam1 = 1e-4; 
lam2 = 5e-4;
%step size for gradient descent 
stepU =1e-2; 
stepV = 1e-2;  
iter = 2000; 
% Combination of u+v 
theta = 1/2.*ones(size(u)); 
c = 1/15; 
[imd,e1,e2] = highPDEConvex(im,lam1,lam2,stepU,stepV,iter,theta,c); 
figure(); imagesc(imd); colormap(cm); 
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
%% Chan, Esedogu, Park L2Norm
% "A fourth order dual method for staircase reduction in 
% texture extraction and Image Restoration Problems" 
alpha = 1; 
lambda = 17; 
iter = 1500; 
tau1 = 1/180;
tau2 = 1/24; 
[im_l2,~,~,~,~ ]= L2PrimalDual(im,alpha,lambda,tau1,tau2,iter, saveimages);
figure(); imagesc(im_l2);colormap(gray(256)); 
%% Chan, Esdogu, Park Gnorm
% "A fourth order dual method for staircase reduction in 
% texture extraction and Image Restoration Problems" 
alpha = 1; 
lambda = 17; 
mu = 15; 
tau1 = 1/180;
tau2 = 1/24; 
iter = 1500; 
[im_g,~,~,~,~] = GnormPrimalDual(im,alpha,lambda,tau1,tau2,mu,iter,saveimages);
figure(); imagesc(im_g); colormap(cm); 

%% final comparison of all methods: 
figure(); 
subplot(2,3,1);imagesc(im); colormap(cm);title('NoisyImage');
subplot(2,3,2);imagesc(dim);colormap(cm);title('Younes');
subplot(2,3,3);imagesc(dim1);colormap(cm);title('Lysaker');
subplot(2,3,4);imagesc(imd); colormap(cm);title('Lysaker,Combo');
subplot(2,3,5);imagesc(im_l2);colormap(cm);title('Chan, L2Dual');
subplot(2,3,6);imagesc(im_g); colormap(cm);title('Chan, GnormDual'); 