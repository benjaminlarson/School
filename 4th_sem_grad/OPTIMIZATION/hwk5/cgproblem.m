clear; clc; close all; 
x = [10e-6;10e-6];
x = [2;2]; 
track = [10e-6,10e-6]; 

f = fi(x);
f_ = fi_(x); 
p = -f_; 
k = 1;
alpha = [1; 10];
H = eye(2)+10e-3; 

%% Fletcher Reeves method 
while norm(fi_(x(:,k))) > 10-9 && k ~=12
    
%     alpha(k+2) = ls(x(:,k),track,alpha(k+1), alpha(k),H);
    alpha(k+2) = 1e-3; 
%     track = x(:,k); 
    
    x(:,k+1) = x(:,k)+alpha(k+2)*p;
    
    f_(:,k+1) = -fi_(x(:,k+1)); 
    B = (f_(:,k+1)'*f_(:,k+1))/(f_(:,k)'*f_(:,k)); 
    
    p = f_(:,k+1) + B*p;
    k = k+1 ; 
end 

b = 10;
st = 0.1; 
[X,Y] = meshgrid(-b/2:st:b/2, -b:st:b);

z=100*(Y-X.^2).^2+(1-X).^2; 

contour(X,Y,z,50,'ShowText','off');
hold on;
scatter(x(1,:),x(2,:)); 
plot(x(1,:),x(2,:)); 
title('Conjugate Gradient Method');
hold off; 