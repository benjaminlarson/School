%% Gaussian 
%% MRI CT distortions
clear; close all; clc; 
ct = load('coordinates/centroids_CT.mat'); 
ct = ct.centroids_CT;
% ct = ct./max(ct(:)); 
mri = load('coordinates/centroids_MRI.mat'); 
mri = mri.centroids3;
% mri = mri./max(mri(:)); 

ctx = ct(:,1);
cty = ct(:,2);
ctz = ct(:,3);

mrix = mri(:,1);
mriy = mri(:,2);
mriz = mri(:,3);

ctx = ct(1:2:end,1);
cty = ct(1:2:end,2);
ctz = ct(1:2:end,3);
ctt = [ctx,cty,ctz]; 
mrix = mri(1:2:end,1);
mriy = mri(1:2:end,2);
mriz = mri(1:2:end,3);
mrit = [mrix,mriy,mriz]; 
[px,Kx] = devkernelR(mrit,ctt);

x = mrix; y = mriy; z = mriz;
% x = ctx; y = cty; z = ctz; 

third = length(px)/3; 
cx = px(1:third); 
cy = px(third+1:2*third);
cz = px(2*third+1:end); 

for i = 1:length(Kx)
%     r = [Kx(:,i); mrix(i); mriy(i); mriz(i); 1];
    r = Kx(:,i); 
    nx(i) = cx'*r;
    ny(i) = cy'*r; 
    nz(i) = cz'*r; 
end 
figure(); 
scatter3(ctx,cty,ctz,'r');
% hold on; 
% scatter3(mrix,mriy,mriz,'k'); 
hold on; 
% figure(); 
scatter3(nx,ny,nz,'x');  


error = norm(nx'-x)+norm(ny'-y)+norm(nz'-z)
dis = norm(ct-mri) 
