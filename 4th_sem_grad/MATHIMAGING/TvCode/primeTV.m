%% total variation, primal 
clear; close all; clc; 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = 2*i/50; 
    end
end 
n = rand(size(u)); 
u = u + n.*2; 
u = double(u); 
u0 = u;
plotEnergy = zeros(1,10); 
im = u; 
im0  =u0; 
sp = 1e-1;
lam = 1e-1; 
for iter = 1:10
    
    for i = 2:size(im,1)-1
        for j = 2:size(im,2)-1       
            ix = (im(i+1,j)-im(i-1,j))/2; 
            iy = (im(i,j+1)-im(i,j-1))/2;
            ixx = (im(i+1,j)-2*im(i,j)+im(i-1,j));
            iyy = (im(i,j+1)-2*im(i,j)+im(i,j-1)); 
            ixy = (im(i+1,j+1)-im(i-1,j+1)-im(i+1,j-1)+im(i-1,j-1))/4; 
            div = (ixx*iy^2-2*ix*iy*ixy+iyy*ix^2)/((ix^2+iy^2)^(3/2)); 

            s = sp*sqrt(ix^2+iy^2); 
            e = s*(div-2*lam*(im(i,j)-im0(i,j))); 
            imVal = im(i,j) + e; 
            imn(i,j) = imVal; 
            energy(i,j) = e; 
        end 
    end
    plotEnergy(iter) = plotEnergy(iter) + sum(energy(:)); 
%     imagesc(im); colorbar(); 
    im = imn; 
end 
% figure()
% plot(plotEnergy); 
figure(); 
subplot(1,2,1)
imagesc(im0./max(im0(:)));title('original'); colorbar(); 
subplot(1,2,2)
imagesc(im/max(im(:))); title('tv denoised'); colorbar(); 

