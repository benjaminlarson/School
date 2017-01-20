%% L2 Primal Dual for Higher Order Denosing 

%% Program for computing the primal dual as developed in: 
% "A fourth order dual method for staircase-reduction in texture
% extraction and image restoration problems" Chan, Esedoglu, Park 

function L2PrimalDual
clear; clc; close all; 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = i./10; 
         if i < j
           u(i,j) = 30; 
         end 
    end
end 
Lu = u; 
n = randn(size(u)); 
u = u + n; 
u = double(u); 
f = u;
u1 = zeros(size(u)); 
u2 = zeros(size(u)); 

alpha = 1; 
lambda = 0.1; 
iter = 200; 

p = zeros(size(u)); 
tau = 1/64; 
for i = 1:iter 
    A = 4.*del2(4.*del2(p))-4.*del2((f-u1)./(alpha*lambda));
    p = (p-tau.*A)./(1+tau.*abs(A)); 
    u2 = f-u1-alpha*lambda.*4.*del2(p); 
    
    Eu2(i) = alpha.*sum(sum(  abs(4.*del2(u2))  ))+1/(2*lambda).*sum(sum(  (f-u2).^2  )); 
    Eu2d(i) = sum(sum(  alpha*lambda/2.*(4.*del2(p).^2)-(f-u1).*4.*del2(p)  )); 
    Eu2d2(i) = sum(sum( (4.*del2(p)-(f-u1)./(alpha.*lambda)).^2 )); 
end

tau = 1/8; % <1/8 will converge
px = zeros(size(u)); py = zeros(size(u)); 
p = zeros(size(u)); 
u2_Rof = u2; 
% u2 = zeros(size(u)); %ROF Model 
for i = 1:iter
%     A = gradient(imdiv(p)-(f-u2)./lambda); 
%     p = (p+tau.*A)./(1+tau.*abs(A)); 
%     u1 = f-u2-lambda.*(imdiv(p)); 
    [Ax,Ay] = gradient(imdiv(p)-(f-u2)./lambda); 
    px = (px+tau.*Ax)./(eye(size(p))+tau.*abs(Ax)); 
    py = (py+tau.*Ay)./(eye(size(p))+tau.*abs(Ay)); 
    u1 = f-u2-lambda.*(px+py);  

    Eu1(i) = sum(sum(  abs(gradient(u1))  ))+0.5*lambda.*sum(sum(  (f-u1).^2  ));
    Eu1d(i) = sum(sum((  lambda.*imdiv(p)-(f-u2)).^2  ));  
end 
% semilogy(Eu2,'k');hold on; semilogy(abs(Eu2d),'b');  semilogy(Eu2d2,'r'); 
semilogy(Eu1,'m'); semilogy(abs(Eu1d),'g');  
hold off; 
% legend('Eu2','Eu2dual','Eu2dual2','Eu1','Eu1d'); 
figure();
semilogy(Eu2+Eu1,'k');hold on; semilogy(abs(Eu2d+Eu1d),'b');  semilogy(Eu2d2+Eu1d,'r');  hold off; 
legend('Eu2+Eu1','Eu2d+Eu1d','Eu2d2+Eu1d'); 
figure(); 
subplot(2,2,1);imagesc(f);
subplot(2,2,2); imagesc(u1+u2,[0,35]);
subplot(2,2,3);imagesc(u1);
subplot(2,2,4);imagesc(u2_Rof);

end 
function divf = div(ux,uy)
    divf = (ux - circshift(ux,[0,1])) + (uy - circshift(uy,[1,0]));
end

function [ux,uy] = grad(f)
    ux = circshift(f,[0,-1]) - f;
    uy = circshift(f,[-1,0]) - f;
end
function laplacian = lap(f)
    Lx = circshift(f,[0,-1])-2.*f+circshift(f,[0,1]);
    Ly = circshift(f,[-1,0])-2.*f+circshift(f,[1,0]);
    laplacian = Lx+Ly; 
end 
function biharmonic = biharmonic(f)
    Lx = circshift(f,[0,2])-4.*circshift(f,[0,1])+6.*f-4.*circshift(f,[0,-1])+circshift(f,[0,-2]); 
    Ly = circshift(f,[2,0])-4.*circshift(f,[1,0])+6.*f-4.*circshift(f,[-1,0])+circshift(f,[-2,0]); 
    Lxy= circshift(f,[2,2])+circshift(f,[-2,-2])-4.*f+circshift(f,[-2,2])+circshift(f,[2,-2])...
        -( circshift(f,[0,2])+circshift(f,[2,0])+circshift(f,[-2,0])+circshift(f,[0,-2]) ); 
    biharmonic = Lx+Ly+Lxy; 
end 