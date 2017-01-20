clear; clc; close all; 
%% Bilinear Interpolation I 
% I = imread('boat.png');
% I = double(I); 
% imagesc(I); colormap gray; 
% % % Down sample 1x 
% Id = I(1:2:size(I),1:2:size(I));
% % I = ones(10,10); 
% biI = BilinearInterpolation(Id);
% nnI = nearestneighbors(Id); 
% figure('Name','downsmapled_Im'); 
% imagesc(I);colormap gray;
% figure('Name','interpIm');
% imagesc(biI);colormap gray; 
% figure('Name','nearestNeighbors'); 
% imagesc(nnI),colormap gray; 
% b = biI(1:end-1,1:end-1);
% n = nnI(1:end-1,1:end-1);
% MSE_bi= mean(mean((double(b) - double(I)).^2,2),1);
% MSE_nn = mean(mean((double(n) - double(I)).^2,2),1);

%% Bilinear Interpolation II 
% X = meshgrid(1:256); 
% X = double(X); 
% Y = X; 
% for i = 1:4
%   Y = Y(1:2:end,1:2:end);
% end
% figure('Name','ds'); imagesc(Y); colormap gray; 
% upsample = Y; 
% for i = 1:4
%   upsample = BilinearInterpolation(Y);
%   Y = upsample;
% end 
% figure('Name','4xbilinear');imagesc(Y); colormap gray; 
% %% Nearest Neighbors 
% X = meshgrid(1:256); 
% X = double(X); 
% Y = X;
% for i = 1:4
%   Y = Y(1:2:end,1:2:end);
% end
% figure('Name','ds'); imagesc(Y); colormap gray; 
% upsample = Y; 
% for i = 1:4
%   upsample = nearestneighbors(Y);
%   Y = upsample;
% end 
% figure('Name','4xNearNbr');imagesc(Y); colormap gray; 

% close all; clear; clc; 
% I = imread('brain.png');
% figure('Name','brain');
% imagesc(I); colormap gray; 
% r1=50;
% r2=100;
% Io = IntensityTransform1(I,r1,10,r2,245); 
% figure('Name','seperated');
% imagesc(Io); colormap gray; 
% figure('Name','histold'); 
% hist(double(I)); 
% figure('Name','histnew'); 
% hist(double(Io)); 
%% Quantization
I = imread('brain.png');
I = double(I); 
I1 = LMquantize(I,10); 
Iu1 = 
figure('name','diff'); imagesc(Iq-Io); colormap jet; 
figure('name','orig');imagesc(Io); colormap gray; 
figure('name','iq');imagesc(Iq); colormap gray; 