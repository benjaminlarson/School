%% MRI CT distortions
clear; close all; clc; 
ct = load('coordinates/centroids_CT.mat'); 
ct = ct.centroids_CT; 
mri = load('coordinates/centroids_MRI.mat'); 
mri = mri.centroids3; 

ctx = ct(:,1);
cty = ct(:,2);
ctz = ct(:,3);

mrix = mri(:,1);
mriy = mri(:,2);
mriz = mri(:,3); 

 
% scatter3(ctx, cty, ctz);
% hold on; 
% scatter3(mrix,mriy,mriz); 

x = ct(:,1)/max(ct(:,1)); 
y = ct(:,2)/max(ct(:,2)); 
xx = mri(:,1)/max(mri(:,1)); 
yy = mri(:,2)/max(mri(:,2)); 

% im = imread('cb.png');
% imagesc(im); 
% [x,y] = ginput(5); 
% [xx,yy]=ginput(5); 

for i = 1:length(x)
    for j = 1:length(y) 
         b3x(i,j) = norm([x(i),y(i)]-[x(j),y(j)])^2*log(norm([x(i),y(i)]-[x(j),y(j)])); 
         if isnan(b3x(i,j))
             b3x(i,j) = 0; 
         end 
    end 
end 
for i = 1:length(x)
    for j = 1:length(y)
         b3y(i,j) = norm([x(i),y(i)]-[x(j),y(j)])^2*log(norm([x(i),y(i)]-[x(j),y(j)])); 
         if isnan(b3y(i,j))
             b3y(i,j) = 0; 
         end 
    end 
end 
b1 = [x' ;y'; ones(size(x))']; 
b2 = [zeros(3,3)]; 
b4 = [y ,x, ones(size(x))]; 
B1 = [b1, b2; b3x, b4]; 
B2 = [b1,b2; b3y, b4]; 
A = [B1, zeros(size(B1)); zeros(size(B2)), B2]; 
b = [0,0,0, xx', 0,0,0,yy']; 

p = A/b; 

figure(); 
scatter(x,y,'k'); 
hold on 
scatter(xx,yy,'g'); 

for i = 1:length(x)
    h = length(p)/2; 
    kx = sum(b3x(i,:)*p(1:h-3)); 
    Tx(i) = kx +p(h-2)*yy(i)+p(h-1)*xx(i)+p(h);
    ky = sum(b3y(i,:)*p(h+1:end-3));
    Ty(i) = ky +p(end-2)*yy(i)+p(end-1)*xx(i)+p(end); 
end 
scatter(Tx, Ty);
% scatter(Tx*2e-6,Ty*2e-6, 'r'); 
