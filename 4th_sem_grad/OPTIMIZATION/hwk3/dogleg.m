clear; clc; close all; 
dh =1; % > 0 
d0 = 0; %in[0,dh]
d(1:2) = d0; 
n = 1e-6;  % in [0,1/4) 
iter = 10; 
x = zeros(1,2); 
x(1,:) = [-8,-8];
puregrad = zeros(1,2); 
puregrad(1,:)= [-8,-8]; 


for k = 1:iter
    pk = doglegPk(d(k),x(k,:)); 
    pk_eval = (f(x(k,:))-f(x(k,:)+pk'))/(quad_m(x,[0,0]')-quad_m(x,pk)); %the sign on this is wierd +-
    
    if pk_eval <1/4
        d(k+1) = 1/4*d(k); 
    else
        
        if (pk_eval > 3/4) && (norm(pk) == d(k))
            d(k+1) = min(2*d(k), dh); 
        else
            d(k+1) = d(k); 
        end 
        
    end
    
    if pk_eval > n
        x(k+1,:) = x(k,:) + pk';
    else
        x(k+1,:) = x(k,:); 
    end 
%     figure(); 
%     theta = linspace(0,2*pi,50).'; 
%     r=d(k);  a = x(k,1); b=x(k,2); 
%     plot(x(k,:),x(k,:)+pk'); hold on; 
%     plot(a+cos(theta)*r, b+sin(theta)*r,'k'); 
xx = x(k,1); yy = x(k,2); 
g = [(40*xx.^3-40*xx.*yy+2*xx-2);(20*yy-20*xx.^2)];
puregrad(k,:) = x(k,:)+g'; 
end

[X,Y] = meshgrid(-10:1:10);
Z =10*(Y-X.^2).^2 + (1-X).^2;
[DX,DY] =gradient(Z,0.1,0.1);

figure
contour(X,Y,Z,100)
hold on
% quiver(X,Y,DX*-1,DY*-1)
% scatter(x(:,1),x(:,2)); 
plot(x(:,1),x(:,2)); 
% plot(puregrad(:,1),puregrad(:,2),'r'); 
% hold off

% figure(); 
theta = linspace(0,2*pi,50).'; 
for i =1 :iter
    r=d(i);  a = x(i,1); b=x(i,2); 
    plot(a+cos(theta)*r, b+sin(theta)*r,'k'); hold on; 
end 