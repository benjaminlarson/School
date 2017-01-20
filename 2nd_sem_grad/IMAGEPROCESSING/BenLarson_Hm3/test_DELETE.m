%test mse 
close all; clear all; clc; 

house = double(imread('house.pgm'));
houseNsy2 = double(imread('houseNoisy2.pgm'));

figure('Name','NoisyHouse2 in Spatial and Fourier'); 
subplot(2,2,1); imagesc(house); colormap gray; 
subplot(2,2,2); imagesc(houseNsy2); colormap gray;

fhouse = fft2(house);
fhouseNsy2 = fft2(houseNsy2);

mn = size(house,1)*size(house,2); 
mse = 1./mn.*sum(sum(minus(house,houseNsy2).^2));
HvsNH = sprintf('MSE House vs Noisy2 = %f',mse); 
title(HvsNH);

fhouse = fftshift(fhouse); 
fhouseNsy2 = fftshift(fhouseNsy2); 

subplot(2,2,3); imagesc(log(abs(fhouse)));colormap gray; 
subplot(2,2,4); imagesc(log(abs(fhouseNsy2)));colormap gray;

%filtering 
%ZeroPad 2*M x 2*N
I = ffzeropad(houseNsy2);
N = size(houseNsy2,1); M = size(houseNsy2,2);

fhouseNsy2 = fft2(I);
fhouseNsy2 = fftshift(fhouseNsy2);
rmfhouseNsy2 = ButterworthBandReject(fhouseNsy2,160,1,2);

figure('Name','houseNoisy1');
subplot(2,3,1); imagesc(houseNsy2); colormap gray;
subplot(2,3,2); imagesc(log(abs(fhouseNsy2))); colormap gray;
subplot(2,3,3); imagesc(log(abs(rmfhouseNsy2))); colormap gray;

fhn = fft2(houseNsy2);
fhns = fftshift(fhn);
fhns1 = ButterworthBandReject(fhns,80,25,2); 
fhns1 = ButterworthBandReject(fhns1,55,25,2); 
subplot(2,3,5); imagesc(log(abs(fhns))); colormap gray; 
subplot(2,3,6); imagesc(log(abs(fhns1))); colormap gray; 

inim1 = ifft2(fhns1); 
inim2 = inim1(1:N,1:M);
rmfhouseNsy2 = rmfhouseNsy2(1:N,1:M); 
figure('name','book'); 
subplot(2,1,1);imagesc(houseNsy2); colormap gray; 
subplot(2,1,2);imagesc(abs(inim2)); colormap gray;

mse = 1./mn.*sum(sum(minus(house,real(inim2)).^2));
mse2 = 1./mn.*sum(sum(minus(house,real(rmfhouseNsy2)).^2));
HvsNH = sprintf('%fMSE House vs Noisy1 = %f',mse,mse2); 
title(HvsNH);
