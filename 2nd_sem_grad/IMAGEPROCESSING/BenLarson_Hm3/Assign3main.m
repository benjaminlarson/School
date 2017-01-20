% %% Assignment 3
% %%learn fminsearch, handle functions 
% clear; clc; close all; 
house = double(imread('house.pgm'));
houseNsy2 = double(imread('houseNoisy2.pgm'));
% houseNsy = double(imread('houseNoisy1.pgm'));
% 
% figure('Name','Image in Spatial and Fourier'); 
% subplot(2,2,1); imagesc(house); colormap gray; 
% subplot(2,2,2); imagesc(houseNsy); colormap gray;
% 
% %% S->F then shift 
% fhouse = fft2(house);
% fhouseNsy = fft2(houseNsy);
% 
% mn = size(house,1)*size(house,2); 
% mse = 1./mn.*sum(sum(minus(house,houseNsy).^2));
% HvsNH = sprintf('MSE House vs Noisy1 = %f',mse); 
% title(HvsNH);
% 
% fhouse = fftshift(fhouse);
% fhouseNsy = fftshift(fhouseNsy);
% 
% subplot(2,2,3); imagesc(log(abs(fhouse)));colormap gray; 
% subplot(2,2,4); imagesc(log(abs(fhouseNsy)));colormap gray;
% 
% %% Butterworth
% % I = input image
% % Do = distance of middle of the band to be rejected
% % W = width of the rejection band 
% % n = order of butterworth filter 
% 
% %ZeroPad 2*M x 2*N
% I = ffzeropad(houseNsy);
% N = size(houseNsy,1); M = size(houseNsy,2);
% 
% fhouseNsy1 = fft2(I);
% fhouseNsy = fftshift(fhouseNsy1);
% rmfhouseNsy = ButterworthBandReject(fhouseNsy,160,25,2);
% rmfhouseNsy1 = fftshift(rmfhouseNsy); 
% figure()
% subplot(2,1,1);imagesc(log(abs(fhouseNsy)));colormap gray;
% subplot(2,1,2);imagesc(log(abs(rmfhouseNsy)));colormap gray; 
% 
% figure('Name','houseNoisy1');
% subplot(2,3,1); imagesc(houseNsy); colormap gray;
% subplot(2,3,2); imagesc(log(abs(fhouseNsy))); colormap gray;
% subplot(2,3,3); imagesc(abs(rmfhouseNsy1)); colormap gray;
% subplot(2,3,4); imagesc(houseNsy); colormap gray;
% 
% fhn = fft2(houseNsy);
% fhns = fftshift(fhn); 
% fhns1 = ButterworthBandReject(fhns,80,25,2);
% subplot(2,3,5); imagesc(log(abs(fhn))); colormap gray;
% subplot(2,3,6); imagesc(log(abs(fhns1))); colormap gray;
% %%Shifting after plotting 
% % inim = ifft2(fhns1); 
% % figure('name','matlab'); 
% % subplot(2,1,1);imagesc(houseNsy); colormap gray; 
% % subplot(2,1,2);imagesc(real(inim)); colormap gray; 
% 
% inim1 = ifft2(rmfhouseNsy);
% inim2 = inim1(1:N,1:M); 
% figure('name','book'); 
% subplot(2,1,1);imagesc(houseNsy); colormap gray; 
% subplot(2,1,2);imagesc((abs(inim2))); colormap gray; 
% 
% mse = 1./mn.*sum(sum(minus(house,real(inim2)).^2));
% HvsNH = sprintf('MSE House vs Noisy1 = %f',mse); 
% title(HvsNH);
% 
% %% Butterworth 2
% house = double(imread('house.pgm'));
% 
% figure('Name','NoisyHouse2 in Spatial and Fourier'); 
% subplot(2,2,1); imagesc(house); colormap gray; 
% subplot(2,2,2); imagesc(houseNsy2); colormap gray;
% 
% fhouse = fft2(house);
% fhouseNsy2 = fft2(houseNsy2);
% 
% mn = size(house,1)*size(house,2); 
% mse = 1./mn.*sum(sum(minus(house,houseNsy2).^2));
% HvsNH = sprintf('MSE House vs Noisy2 = %f',mse); 
% title(HvsNH);
% 
% fhouse = fftshift(fhouse); 
% fhouseNsy2 = fftshift(fhouseNsy2); 
% 
% subplot(2,2,3); imagesc(log(abs(fhouse)));colormap gray; 
% subplot(2,2,4); imagesc(log(abs(fhouseNsy2)));colormap gray;
% 
% %filtering 
% %ZeroPad 2*M x 2*N
I = ffzeropad(houseNsy2);
N = size(houseNsy2,1); M = size(houseNsy2,2);

fhouseNsy2 = fft2(I);
fhouseNsy2 = fftshift(fhouseNsy2);
rmfhouseNsy2 = ButterworthBandReject(fhouseNsy2,160,5,2);
fhouseNsy2 = fftshift(fhouseNsy2);
% figure('Name','houseNoisy1');
% subplot(2,3,1); imagesc(houseNsy2); colormap gray;
% subplot(2,3,2); imagesc(log(abs(fhouseNsy2))); colormap gray;
% subplot(2,3,3); imagesc(log(abs(rmfhouseNsy2))); colormap gray;
% % subplot(2,3,4); imagesc(houseNsy2); colormap gray;
% 
fhn = fft2(houseNsy2);
fhns = fftshift(fhn);
fhns1 = ButterworthBandReject(fhns,82,5,2);
fhns1 = ButterworthBandReject(fhns1,53,5,2);
% subplot(2,3,5); imagesc(log(abs(fhns))); colormap gray; 
% subplot(2,3,6); imagesc(log(abs(fhns1))); colormap gray; 
figure()
subplot(1,3,1);imagesc(houseNsy2); colormap gray;
subplot(1,3,2); imagesc(log(abs(fhns))); colormap gray;
subplot(1,3,3);imagesc(log(abs(fhns1))); colormap gray; 
%%Shifting after plotting
fhns1 = fftshift(fhns1);
inim = ifft2(fhns1);
inim = inim(1:N,1:M); 
inim1 = ifft2(rmfhouseNsy2); 
inim2 = inim1(1:N,1:M); 
figure('name','book'); 
subplot(2,1,1);imagesc(houseNsy2); colormap gray; 
subplot(2,1,2);imagesc(abs(inim)); colormap gray;

mse = 1./mn.*sum(sum(minus(house,real(inim)).^2));
HvsNH = sprintf('MSE House vs Noisy1 = %f',mse); 
title(HvsNH);
