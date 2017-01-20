clear; clc; close all; 

bound = 3; d = 0.1; 
[X Y] = meshgrid(-1*bound:d:bound, -1*bound:d:bound); 

fx = 10*(Y-X.^2).^2 + (1-X).^2;
contour(X,Y,fx,50) ; 


g = [(40*X.^3-40*X.*Y+2*X-2);(20*Y-20*X.^2)];

B = [120*X.^2-40*Y+2, -40*X*ones(size(X));...
    -40*X*ones(size(X)), 20*ones(size(X))]; 
% B = [120*X.^2-40*Y+2, -40*X;...
%     -40*X, 20]; 
m = fx+norm(g)+1/2*norm(B);
% figure; 
% mesh(X,Y,m) 
figure() 
contour(X,Y,m,100) 
hold on; 

theta = linspace(0,2*pi,50).';
a = 0, b = -1 
for i =1 :10
    i = i/5; 
    plot(a+cos(theta)*i, b+sin(theta)*i,'b'); 
%     contour(X,Y, sqrt( (X-0).^2+(Y--1).^2)==i,1); 
end 
Z =10*(Y-X.^2).^2 + (1-X).^2;
[DX,DY] =gradient(Z,10,10);

hold on
% contour(X,Y,Z,100,'LineWidth',0.01); 
% quiver(X,Y,DX*-1,DY*-1)
% scatter(x(:,1),x(:,2)); 
% plot(x(:,1),x(:,2)); 
hold off

figure() 
contour(X,Y,m,100) 
hold on; 

theta = linspace(0,2*pi,50).';
a = 0, b = -1 
for i =1 :10
    i = i/5; 
    plot(0+cos(theta)*i, 0.5+sin(theta)*i,'k'); 
%     contour(X,Y, sqrt( (X-0).^2+(Y--1).^2)==i,1); 
end 
Z =10*(Y-X.^2).^2 + (1-X).^2;
[DX,DY] =gradient(Z,10,10);

hold on
% contour(X,Y,Z,100,'LineWidth',0.01); 
% quiver(X,Y,DX*-1,DY*-1)
% scatter(x(:,1),x(:,2)); 
% plot(x(:,1),x(:,2)); 
hold off