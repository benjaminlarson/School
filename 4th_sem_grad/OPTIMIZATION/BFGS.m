%% BFGS, quasi newton method 
% The ls parameter for the last resort may need to be 
% changed to 5. Converges well in this case. 

% function [result] = BFGS (x,y)
clear; clc; close all; 
eps = 1e-1;
H = eye(2)+1e-2; 

% x = [0,0]+eps; % keep division from zero early on
x = [-1;0]; 
% ls parameters: 
ai = 0.01; a_1 = 1e-6; alpha = 1; track = x; 
%H1 is H(k+1). Not sure how to concatenate hessians in a matrix. 

p = zeros(2,1); 
g = zeros(2,1);
s = zeros(2,1);
y = zeros(2,1);
r = zeros(2,1); 
k= 1;

b = 4;
st = 0.1; 
[X,Y] = meshgrid(-b/2:st:b/2, -b:st:b);
z=(1.5-X+X*Y)^2+(2.25-X+X*Y^2)^2+(2.625-X+X*Y^3)^2; 
contour(X,Y,z,50,'ShowText','off');
hold on;
scatter(x(1,:),x(2,:)); 
plot(x(1,:),x(2,:)); 
scatter(1,1,'xk'); 
title('BFGS method'); 
% hold off; 

while norm( fi_(x(:,k)) ) > eps && k~=50
    
%     H = inv(H); 
    p(:,k) = -H*fi_(x(:,k));  %search direction p 
    
    alpha = ls(x(:,k),track,alpha,a_1,H)
%     alpha = power(1/k,1e-4);
%     if k <= 2   
%         alpha = 1e-2;
%     else 
%         alpha = 1e-3; 
%     end 
    a_1 = alpha; 
    track = x(:,k); 
    
    x(:,k+1) = x(:,k)+alpha*p(:,k);
%     s(:,k) = x(:,k+1)-x(:,k);
    s(:,k) = alpha*p(:,k);%same result as above line. 
    
    g(:,k) = fi_(x(:,k));
    g(:,k+1) = fi_(x(:,k+1)); 
    
    y(:,k) = g(:,k+1)-g(:,k);
    r = 1/(y(:,k)'*s(:,k)); 
    
    %BFGS part 
    psy = r*s(:,k)*y(:,k)'; 
    pys = r*y(:,k)*s(:,k)'; 
    H = (eye(size(H))-psy)*H*(eye(size(H))-pys)+r*s(:,k)*s(:,k)'; 
    k = k+1; 
    
    scatter(x(1,:),x(2,:)); 
    plot(x(1,:),x(2,:)); 
    
%     scatter(x(:,1),x(:,2)); 
%     plot(x(:,1),x(:,2)); 
    pause(0.1); 
end 

% b = 10;
% st = 0.1; 
% [X,Y] = meshgrid(-b/2:st:b/2, -b:st:b);
% 
% z=100*(Y-X.^2).^2+(1-X).^2; 
% 
% contour(X,Y,z,50,'ShowText','off');
% hold on;
% scatter(x(1,:),x(2,:)); 
% plot(x(1,:),x(2,:)); 
% title('BFGS method'); 
% hold off; 