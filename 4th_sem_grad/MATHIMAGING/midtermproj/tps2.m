%% MRI CT distortions
clear; close all; 
ct = load('coordinates/centroids_CT.mat'); 
ct = ct.centroids_CT;
mri = load('coordinates/centroids_MRI.mat'); 
mri = mri.centroids3;

%train 
ctx = ct(:,1);
cty = ct(:,2);
ctz = ct(:,3);
ctt = [ctx,cty,ctz]; 
mrix = mri(:,1);
mriy = mri(:,2);
mriz = mri(:,3);
mrit = [mrix,mriy,mriz]; 
%test 
x = ct(:,1);
y = ct(:,2);
z = ct(:,3);

xmt = mri(:,1);
ymt = mri(:,2);
zmt = mri(:,3);

[px,Kx,r] = devkernel3d(mrit,ctt); %train mri to match ct 

third = length(px)/3; 
cx = px(1:third); 
cy = px(third+1:2*third);
cz = px(2*third+1:end); 

for i = 1:length(Kx)
    r = [Kx(:,i);xmt(i);ymt(i);zmt(i);1];
    nx(i) = cx'*r;
    ny(i) = cy'*r; 
    nz(i) = cz'*r; 
end 
figure(); 
scatter3(x,y,z,'o');
hold on; 
% scatter3(mrit,mrit,mrit,'k'); 
scatter3(nx,ny,nz,'x');  

error = norm(nx'-x)+norm(ny'-y)+norm(nz'-z)
dis = norm(ct-mri) 
