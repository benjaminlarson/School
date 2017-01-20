%% Gaussian 
%% MRI CT distortions
clear; close all; clc; 
ct = load('coordinates/centroids_CT.mat'); 
ct = ct.centroids_CT;
% ct = ct./max(ct(:)); 
mri = load('coordinates/centroids_MRI.mat'); 
mri = mri.centroids3;
% mri = mri./max(mri(:)); 

%train 
ctx = ct(1:2:end,1);
cty = ct(1:2:end,2);
ctz = ct(1:2:end,3);
ctt = [ctx,cty,ctz]; 
mrix = mri(1:2:end,1);
mriy = mri(1:2:end,2);
mriz = mri(1:2:end,3);
mrit = [mrix,mriy,mriz]; 
%test 
x = ct(2:2:end,1);
y = ct(2:2:end,2);
z = ct(2:2:end,3);
xmt = mri(2:2:end,1);
ymt = mri(2:2:end,2);
zmt = mri(2:2:end,3);

ctx = ct(:,1);
cty = ct(:,2);
ctz = ct(:,3);

mrix = mri(:,1);
mriy = mri(:,2);
mriz = mri(:,3);

[px,Kx] = devkernelR(mrit,ctt);

x = mrix; y = mriy; z = mriz;
% x = ctx; y = cty; z = ctz; 

third = length(px)/3; 
cx = px(1:third); 
cy = px(third+1:2*third);
cz = px(2*third+1:end); 
s = 1; 
for i = 1:length(Kx)
%     r = [Kx(:,i); mrix(i); mriy(i); mriz(i); 1];
        u = [x-xmt(i), y-ymt(i),z-zmt(i) ];
        u = sqrt(sum(u.^2,2));
%      r = u.^2.*log(u+1e-6);  
        r = exp(-u.^2./(2*s^2));
        rx = [ r; xmt(i); ymt(i); zmt(i); 1];
%      warpx(i,j) = cx'*rx;
%      warpy(i,j) = cy'*rx;
%      r = Kx(:,i); 
        nx(i) = cx'*rx;
        ny(i) = cy'*rx; 
        nz(i) = cz'*rx; 
end 
figure(); 
scatter3(ctx,cty,ctz,'r');
% hold on; 
% scatter3(mrix,mriy,mriz,'k'); 
hold on; 
% figure(); 
scatter3(nx,ny,nz,'b');  
error = norm(nx'-x)+norm(ny'-y)+norm(nz'-z)
dis = norm(ct-mri) 
