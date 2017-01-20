clear; clc; close all; 
x = [10e-6;10e-6];
x = [1.7;1.7]; 
track = x; 

k = 1;
alpha = [0; 1];
Bi = eye(2); 
k = 1; 
while norm(fi_(x(:,k)) ) > 10e-9 && k ~=5
    
    alpha(k+2) = ls(x(:,k),track,alpha(k+1), alpha(k),Bi);
%     alpha(k+2) = 1.0;
    track = x(:,k);
    B = hessian(x(:,k)); 
    Bi = inv(B); 
    p = -Bi*fi_(x(:,k)); 
    x(:,k+1) = x(:,k)+alpha(k+2)*p; 
    
    k = k+1; 
    grad = fi_(x(:,k))
%     nrm = norm(fi_(x(:,k)))
    minat = x(:,k)
end 
norm(fi_(x(:,k))) > 10e-9

b = 5;
st = 0.1; 
[X,Y] = meshgrid(-b/2:st:b/2, -b:st:b);

z=100*(Y-X.^2).^2+(1-X).^2; 

contour(X,Y,z,50,'ShowText','off');
hold on;
scatter(x(1,:),x(2,:)); 
plot(x(1,:),x(2,:)); 
title('Conjugate Gradient Method');
hold off; 