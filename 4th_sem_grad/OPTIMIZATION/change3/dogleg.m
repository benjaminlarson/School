clear; clc; close all; 
%% try dh = 0.1, n= 1e-3
dh =1e1; % > 0 
% d0 = dh/2; %in[0,dh]
d = dh/2; 
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
%  xx = x(k,1); yy = x(k,2); 
% g = [(40*xx.^3-40*xx.*yy+2*xx-2);(20*yy-20*xx.^2)];
% gr(k+1,:) = x(k,:)+g'; 
end

dh =1e1; % > 0 
% d0 = dh/2; %in[0,dh]
d = dh/2; 

for k = 1:iter
    cp = cauchy(d(k),puregrad(k,:)); 
    pk_eval = (f(puregrad(k,:))-f(puregrad(k,:)+cp'))/(quad_m(puregrad,[0,0]')-quad_m(puregrad,cp)); %the sign on this is wierd +-
    if pk_eval <1/4
        d(k+1) = 1/4*d(k); 
    else
        if (pk_eval > 3/4) && (norm(cp) == d(k))
            d(k+1) = min(2*d(k), dh); 
        else
            d(k+1) = d(k); 
        end 
    end
    
    if pk_eval > n
        puregrad(k+1,:) = puregrad(k,:) + cp';
    else
        puregrad(k+1,:) = puregrad(k,:); 
    end 
end


d = d'; 
[X,Y] = meshgrid(-10:1:10);
Z =10*(Y-X.^2).^2 + (1-X).^2;
[DX,DY] =gradient(Z,0.1,0.1);

figure
contour(X,Y,Z,100)
hold on
% quiver(X,Y,DX*-1,DY*-1)
scatter(x(:,1),x(:,2),'filled'); 
plot(x(:,1),x(:,2)); 

% plot(gr(:,1),gr(:,2),'k');
% scatter(gr(:,1),gr(:,2),'k'); 
% figure() 
contour(X,Y,Z,100); hold on; 
plot(puregrad(:,1),puregrad(:,2),'r'); 
scatter(puregrad(:,1),puregrad(:,2),'r'); 
% hold off

% figure(); 
% theta = linspace(0,2*pi,50).'; 
% for i =1 :iter
%     r=d(i);  a = x(i,1); b=x(i,2); 
%     plot(a+cos(theta)*r, b+sin(theta)*r,'k'); hold on; 
% end 