%% Assignment 3 main 
% Ben Larson 
clear all; close all; clc; 

I = double(imread('fingerprint.png'));
[g, H] = BlurDegradation(I);  

K = 0.004;
wr_im = WeinerReject(g,H,K);
figure(2); 
subplot(1,3,1); imagesc(I); colormap gray; 
subplot(1,3,2); imagesc(g); colormap gray; 
subplot(1,3,3); imagesc(wr_im); colormap gray; 
MSE(I, wr_im)

% mse_temp = 1e9;  
% s = 1e3; 
% K = linspace(1e-4, 1e-1, s); 
% m = zeros(size(K)); 
% for i = 1:s 
%   wr_im = WeinerReject(g,H,K(i));
%   mse = MSE(I,wr_im); 
%   m(i) = mse(1); 
%   if mse_temp > mse(1)
%     mse_temp = mse(1);
%     K(i)
%     mse_temp 
%   end 
% end 
% figure();loglog(K,m);