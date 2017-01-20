clear; clc; close all; 
%% Bilinear Interpolation I 
I = imread('boat.png');
I = double(I); 
imagesc(I); colormap gray; 
% % Down sample 1x 
Id = I(1:2:size(I),1:2:size(I));
biI = BilinearInterpolation(Id);
nnI = nearestneighbors(Id); 
figure('Name','downsmapled_Im'); 
imagesc(Id);colormap gray;
figure('Name','interpIm');
imagesc(biI);colormap gray; figure(); 
figure('Name','nearestNeighbors'); 
imagesc(nnI),colormap gray; 
b = biI(1:end,1:end);
n = nnI(1:end-1,1:end-1);
MSE_bi= mean(mean((double(b) - double(I)).^2,2),1);
MSE_nn = mean(mean((double(n) - double(I)).^2,2),1);

%% Bilinear Interpolation II 
X = meshgrid(1:256); 
X = double(X); 
Y = X; 
imagesc(Y);colormap gray; 
for i = 1:4
  Y = Y(1:2:end,1:2:end);
end
figure('Name','ds'); imagesc(Y); colormap gray; 
% upsample = Y; 
for i = 1:4
  upsample = BilinearInterpolation(Y);
  Y = upsample;
end 
figure('Name','4xbilinear');imagesc(Y); colormap gray; 
%% Nearest Neighbors 
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
% r2=150;
% Io = IntensityTransform1(I,r1,r2,10,245); 
% figure('Name','seperated');
% imagesc(Io); colormap gray; 
% figure('Name','histold'); 
% hist(double(I)); 
% figure('Name','histnew'); 
% hist(double(Io)); 
%% Quantization
% I = imread('flinstones.png');
% I = double(I); 
% % I1 = LMquantize(I,2); 
% Iu1 = UniformQuantization(I,2); 
% MSE_mine1 =  mean(mean((double(I1) - double(I)).^2,2),1);
% MSE_class1 = mean(mean((double(Iu1) - double(I)).^2,2),1);
% figure('name','mine');imagesc(I1); colormap gray; 
% figure('name','class');imagesc(Iu1); colormap gray; 
% 
% I1 = LMquantize(I,10); 
% Iu1 = UniformQuantization(I,10); 
% MSE_mine1 =  mean(mean((double(I1) - double(I)).^2,2),1);
% MSE_class1 = mean(mean((double(Iu1) - double(I)).^2,2),1);
% figure('name','mine');imagesc(I1); colormap gray; 
% figure('name','class');imagesc(Iu1); colormap gray; 
% % 
% I1 = LMquantize(I,30); 
% Iu1 = UniformQuantization(I,30); 
% MSE_mine1 =  mean(mean((double(I1) - double(I)).^2,2),1);
% MSE_class1 = mean(mean((double(Iu1) - double(I)).^2,2),1);
% figure('name','mine');imagesc(I1); colormap gray; 
% figure('name','class');imagesc(Iu1); colormap gray; 