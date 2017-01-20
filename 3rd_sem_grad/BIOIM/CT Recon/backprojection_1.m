%% part 1
rho = zeros(100,1); 
rho(40:60) = 1;

zero = backprojection(0,rho);figure('name','backprojection 0'); 
imagesc(zero);colormap gray;
thirt = backprojection(30,rho); figure('name','backprojection 30'); 
imagesc(thirt); colormap gray; 
fourf = backprojection(45,rho); figure('name','backprojection 45'); 
imagesc(fourf); colormap gray; 

%% part 2 
clear;
data = load('prob2.mat');
sinogram = data.sinogram; thetas = data.thetas; 
figure('name','sinogram');
imagesc(sinogram');colormap gray; ylim([-1,403]); 
hold on; 
% theta = 0 @ 0
line([0,size(sinogram,2)],[1,1],'Color','r');
% theta = 90 @  68
line([0,size(sinogram,2)],[202,202],'Color','r');
% theta = 180 @ 102
line([0,size(sinogram,2)],[402,402],'Color','r');
ylabel('\theta degrees');
xlabel('\rho'); 
%% part 3
im = zeros(size(sinogram,1));
for i = 1:length(thetas)
    im = im+ backprojection(thetas(i),sinogram(:,i));
end 
figure('name','Unfiltered Backprojection'); 
imagesc(im);colormap gray;

close all; 
%% part 4

im = zeros(size(sinogram,1));
for i = 1:length(thetas)
    newI = fbackprojection(thetas(i),sinogram(:,i));
    im = im + newI;
end 
figure('name','Filtered Backprojection');
imagesc(flipud(im)); colormap gray;
% subplot(4,1,1);
% imagesc(real(im));colormap gray; colorbar;
% subplot(4,1,2);
% imagesc(iradon(sinogram,thetas)); colormap gray; colorbar;
% subplot(4,1,3);
% imagesc(flipud(im),[0,1]);
% subplot(4,1,4);
% imagesc(sinogram);
