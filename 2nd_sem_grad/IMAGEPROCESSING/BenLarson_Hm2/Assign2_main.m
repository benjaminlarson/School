clear; close all; clc; 
%% Threshhold, Adaptive Equal 
% I = imread('fingerprint.png');
% I = double(I); 
% fingim = otsu(I); 
% figure('Name','Adaptive Equalization, Fingerprint');
% subplot(1,3,1);imagesc(I); title('Original Image'); 
% subplot(1,3,2);imagesc(fingim); colormap gray; title('Otsu Threshold'); 
% adt = AdaptiveEqualize(I);
% otAdt = otsu(adt);
% subplot(1,3,3); imagesc(otAdt);colormap gray; title('Otsu after Adaptive Equalizatoin'); 
% 
%% Gaussain and Bilateral 
% part a,b,c,d
I = imread('lena.png');
I = double(I); 
subplot(2,3,1);imagesc(I); colormap gray; title('Original Im'); 

G = GaussianFilter(I,1);
subplot(2,3,2);imagesc(G); colormap gray; title('GaussianFltr sigma = 3');

B = BilateralFilter(I,3,10);
subplot(2,3,3);imagesc(B); colormap gray; title('BilateralFltr sd = 3 sr = 10');  
 
dG = abs(I-G);
subplot(2,3,5);imagesc(dG); colormap gray; title('Original-Gaussian');

dB = abs(I-B);
sumdb = sum(sum(dB));  
subplot(2,3,6); imagesc(dB); colormap gray;title('Original-Bilateral'); 
%% Part e
I = imread('lena.png');
I = double(I);
figure(); 
subplot(1,3,1);imagesc(I); colormap gray; title('Original Im'); 

B = BilateralFilter(I,3,100);
subplot(1,3,2);imagesc(B); colormap gray; title('BilateralFltr sd = 3 sr = 100');  
 
dB = abs(I-B);
sumdb = sum(sum(dB));  
subplot(1,3,3); imagesc(dB); colormap gray;title('Original-Bilateral'); 
%% part f and g 
% I = imread('lena.png');
% I = double(I); 
% figure(); 
% subplot(1,3,1);imagesc(I); colormap gray; title('Original Im'); 
% 
% B = BilateralFilter(I,1000,10);
% subplot(1,3,2);imagesc(B); colormap gray; title('BilateralFltr sd = 1000 sr = 10');
% 
% B = BilateralFilter(I,3,1000);
% subplot(1,3,3);imagesc(B); colormap gray; title('BilateralFltr sd = 3 sr = 1000');

%% House.png

% f = imread('house.png');
% f = double(f); 
% g = f+20*randn(size(f)); 
% 
% G = GaussianFilter(f,1);
% mn = size(f,1)*size(f,2); 
% MSEf = sum(sum(minus(f,G).^2))/mn;
% MSEg = sum(sum(minus(f,g).^2))/mn;
% mseNoise = sprintf('Noise; MSE = %f',MSEg); 
% mseFilter = sprintf('GaussianFlter sgm =3; MSE = %f',MSEf); 
% 
% subplot(1,3,1);imagesc(f); colormap gray; title('Original');
% subplot(1,3,2);imagesc(g); colormap gray; title(mseNoise);
% subplot(1,3,3);imagesc(G); colormap gray; title(mseFilter);
% 
% figure(); 
% mse = [0,0,0,0,0,0];
% x = [5,10,20,40,60,100]; 
% B1 = BilateralFilter(g,3,5); 
% mse(1) = 1./mn.*sum(sum(minus(f,B1).^2));
% mseFilter1 = sprintf('sgm =5; MSE = %f',mse(1)); 
% subplot(3,2,1);imagesc(B1); colormap gray;title(mseFilter1);
% 
% B2 = BilateralFilter(g,3,10); 
% mse(2) = 1./mn.*sum(sum(minus(f,B2).^2));
% mseFilter2 = sprintf('sgm =10; MSE = %f',mse(2)); 
% subplot(3,2,2);imagesc(B2); colormap gray;title(mseFilter2);
% 
% B3 = BilateralFilter(g,3,20); 
% mse(3) = 1./mn.*sum(sum(minus(f,B3).^2));
% mseFilter3 = sprintf('sgm =20; MSE = %f',mse(3)); 
% subplot(3,2,3);imagesc(B3); colormap gray;title(mseFilter3); 
% 
% B4 = BilateralFilter(g,3,40); 
% mse(4) = 1./mn.*sum(sum(minus(f,B4).^2));
% mseFilter4 = sprintf('sgm =40; MSE = %f',mse(4)); 
% subplot(3,2,4);imagesc(B4); colormap gray;title(mseFilter4); 
% 
% B5 = BilateralFilter(g,3,60); 
% mse(5) = 1./mn.*sum(sum(minus(f,B5).^2));
% mseFilter5 = sprintf('sgm =60; MSE = %f',mse(5)); 
% subplot(3,2,5);imagesc(B5); colormap gray;title(mseFilter5); 
% 
% B6 = BilateralFilter(g,3,100); 
% mse(6) = 1./mn.*sum(sum(minus(f,B6).^2));
% mseFilter6 = sprintf('sgm =100; MSE = %f',mse(6)); 
% subplot(3,2,6);imagesc(B6); colormap gray;title(mseFilter6); 
% 
% figure();plot(x,mse);
