
mask = [-ones(32,16) ones(32,16)];
I= zeros(128);
I(64,64)=1;
subplot(2,2,1);
imagesc(I);colormap gray;colorbar;
Icorr = filter2(mask,I,'same');
Iconv = conv2(I,mask,'same');
subplot(2,2,2);
imagesc(mask);colorbar;
subplot(2,2,3);
imagesc(Icorr);colorbar;
subplot(2,2,4);
imagesc(Iconv);colorbar;
%% 
clear;
close all;
I = imread('boat.pgm');
I = double(I);
I = I/255;
Inoisy = I + 0.1*randn(size(I));
mean((I(:)-Inoisy(:)).^2)
subplot(2,2,1);
imagesc(I);colormap gray;
subplot(2,2,2);
imagesc(Inoisy);
mask = Gaussian(1);
Io = conv2(Inoisy,mask,'same');
subplot(2,2,3);
imagesc(Io);
mean((I(:)-Io(:)).^2)
mask = Gaussian(10.5);
Io = conv2(Inoisy,mask,'same');
subplot(2,2,4);
imagesc(Io);
mean((I(:)-Io(:)).^2)
%% 
clear;
close all;
I = imread('house.pgm');
I = double(I);
I = I/255;
I = I + 0.03*randn(size(I));
mask1 = -ones(3);
mask1(2,2) = 8;
mask2 = Gaussian(1);
alpha = 0.2;
subplot(2,2,1);imagesc(I);colormap(gray);
subplot(2,2,2);imagesc((1-alpha)*I+alpha*conv2(I,mask1,'same'));
subplot(2,2,3);imagesc((1-alpha)*I+alpha*conv2(I,conv2(mask2,mask1,'full'),'same'));
subplot(2,2,4);imagesc((1-alpha)*I+alpha*conv2(conv2(I,mask2,'same'),mask1,'same'));

