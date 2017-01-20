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

x = ct(:,1);
y = ct(:,2);
xx = mrix;
yy = mriy;

b1 = [x' ; ones(size(x))'];
b2 = [zeros(3,3)];
for i = 1:length(x)
    for j = 1:length(y)
        b3(i,j) = (x(i)-x(i))^2*log(x(i)-x(i)); 
        if isnan(b3(i,j))
            b3(i,j) = 0;
        end 
    end
end
b4 = [x, ones(size(x))]; 
A = [b1, b2; b3, b4]; 
b = [xx',0,0,0]; 

p = A/b; 

figure(); 
scatter(xx,yy,'k'); 
hold on;
for i = 1:length(p)
    f(i) = sum(b3(i,:)*p(1:end-2))+p(end-1)*xx(i)+p(end); 
end 
scatter(f,'b');
