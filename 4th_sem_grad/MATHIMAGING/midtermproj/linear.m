%% Affine Transformation 

clear; close all; clc; 
ct = load('coordinates/centroids_CT.mat'); 
ct = ct.centroids_CT;
mri = load('coordinates/centroids_MRI.mat'); 
mri = mri.centroids3;

%Train 
ctx = ct(1:2:end,1);
cty = ct(1:2:end,2);
ctz = ct(1:2:end,3);
ctt = [ctx,cty,ctz]; 
mrix = mri(1:2:end,1);
mriy = mri(1:2:end,2);
mriz = mri(1:2:end,3);
mrit = [mrix,mriy,mriz]; 
%test 
xt = ct(2:2:end,1);
yt = ct(2:2:end,2);
zt = ct(2:2:end,3);

xmt = mri(2:2:end,1);
ymt = mri(2:2:end,2);
zmt = mri(2:2:end,3);

% a1 = [ctx, cty, ctz, ones(size(ctx))];
a1 = [mrix,mriy,mriz,ones(size(mrix))]; 
z = zeros(size(a1)); 
A = [a1,z,z; z,a1,z; z,z,a1];

% b = [mrix; mriy; mriz];
b = [ctx;cty;ctz];
x = A\b; 
test = [xmt,ymt,zmt]; 
for i = 1:length(ctx)
    r = [test(i,:),1]';
    nx(i) = x(1:4)'*r;
    ny(i) = x(5:8)'*r; 
    nz(i) = x(9:12)'*r;
end 
scatter3(nx,ny,nz,'o');
hold on;
scatter3(xt,yt,zt,'x'); 

error = norm(nx'-xt)+ norm(ny'-yt)+ norm(nz'-zt)