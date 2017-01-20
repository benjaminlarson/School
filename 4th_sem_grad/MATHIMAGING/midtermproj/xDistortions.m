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

[px,Kx,r] = devKernel(ct,mri, 1); 

[py,Ky,r] = devKernel(ct,mri, 2);
[pz,Kz,r] = devKernel(ct,mri, 3); 

x = ctx; y = cty; z = ctz; 
% for i = 1:length(Kx)
%     nx(i) = sum(px(i)'*Kx(:,i))+px(end-3)*z(i)+px(end-2)*y(i)+px(end-1)*x(i)+px(end);
%     ny(i) = sum(py(i)'*Ky(:,i))+py(end-3)*z(i) +py(end-2)*y(i)+py(end-1)*x(i)+py(end);
%     nz(i) = sum(pz(i)'*Kz(:,i))+pz(end-3)*z(i) +pz(end-2)*y(i)+pz(end-1)*x(i)+pz(end);
% end 
for i = 1:length(Kx)
    nx(i) = px(end-3)*z(i)+px(end-2)*y(i)+px(end-1)*x(i)+px(end);
    ny(i) = py(end-3)*z(i) +py(end-2)*y(i)+py(end-1)*x(i)+py(end);
    nz(i) = pz(end-3)*z(i) +pz(end-2)*y(i)+pz(end-1)*x(i)+pz(end);
end 
%  nx = sum(px(1:end-4).*Kx(:))+px(4)*z+px(3)*y+px(2)*x+px(1);
%  ny = sum(py(1:end-4).*Ky(:))+py(4)*z+py(3)*y+py(2)*x+py(1);
%  nz = sum(pz(1:end-4).*Kz(:))+pz(4)*z +pz(3)*y+pz(2)*x+pz(1);
figure(); 
scatter3(ctx,cty,ctz,'k');
hold on; 
scatter3(mrix,mriy,mriz,'r'); 
scatter3(nx,ny,nz,'b');  
