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
lambda = 1; 
iter = 100; 

p = zeros(size(u)); 
tau = 1/64; 
for i = 1:iter 
    nP = sqrt(p.*p); 
    nP(nP<1) = 1.0; 
    p = p./nP; 
    A =biharmonic(p)-laplacian((f-u1)./(alpha*lambda));
    p = (p-tau.*A)./(1+tau.*sqrt(A.^2)); 
    lp = laplacian(p); 
    u2 = f-u1-alpha*lambda.*lp; 
    
    Eu2(i) = alpha.*sum(sum(  sqrt(laplacian(u2).^2)  ))+0.5*lambda.*sum(sum(  (f-u1-u2).^2  )); 
    
%     c(i) = sum(sum( (alpha*lambda/2).*lp.^2));
%     cc(i) = sum(sum( (f-u1).*lp )); 
    Eu2d(i) = sum(sum(  -(alpha*lambda/2).*(lp.^2)+(f-u1).*lp  )); 
%     Eu2d2(i) = sum(sum( (lp-(f-u1)./(alpha.*lambda))^2 )); 
end
% plot(c); hold on; plot(cc,'r'); 
tau = 1/8; % <1/8 will converge
u2_Rof = u2; 
u2 = zeros(size(u)); %ROF Model
px = zeros(size(u)); 
py = zeros(size(u));
lambda = 1e0; 

for i = 1:iter

    divp = div(px,py); 
    [Ax,Ay] = grad( divp - (f-u2)./lambda );

    px = (px+tau.*Ax)./(1+tau.*sqrt(Ax.^2));
    py = (py+tau.*Ay)./(1+tau.*sqrt(Ay.^2));
    
    nP = sqrt(px.*px+py.*py);
    nP(nP<1) = 1.0;
    px = px./nP;
    py = py./nP;
    divp = div(px,py); 
    u1 = f-u2-(lambda.*divp); 
    
%     sum(sum(-lambda.*divp))
    [u1x,u1y]=grad(u1); 
    Eu1(i) = sum(sum(  sqrt(u1x.*u1x+u1y.*u1y)  ))+1/(2*lambda).*sum(sum(  (f-u1-u2).^2  ));
%     Eu1d(i) = sum(sum(  (lambda.*divp-(f-u2)).^2  ));
    Eu1d(i) = sum(sum( u1.*divp)) + 1/(2*lambda).*sum(sum( (f-u1-u2).^2)); 
end 
% figure(); plot(c);
figure(); colormap(jet(256)); 
subplot(2,3,1);semilogy(Eu1,'m');legend('E1');
subplot(2,3,2);semilogy(Eu2,'k'); legend('E2'); 
subplot(2,3,3); semilogy(Eu2+Eu1,'k'); legend('E1+E2'); 
subplot(2,3,4);semilogy(Eu1d,'g');  legend('E1d'); 
subplot(2,3,5);semilogy(Eu2d,'b');  %hold on; semilogy(Eu2d2,'r'); hold off; legend('E2d','E2d2');
subplot(2,3,6); semilogy(Eu2d+Eu1d,'b'); % hold on; semilogy(Eu2d2+Eu1d,'r');  hold off; legend('E2d+E1d','E2d2+E1d'); 

figure(); 
semilogy(Eu1,'--b');hold on; semilogy(Eu1d,'--b');
semilogy(Eu2,'r');semilogy(Eu2d,'r'); 

figure(); colormap jet; 
subplot(2,2,1);imagesc(f);
subplot(2,2,2); imagesc(u1+u2_Rof,[0,35]);
subplot(2,2,3);imagesc(u1);
subplot(2,2,4);imagesc(u2_Rof);

figure(); 
subplot(2,1,1);
plot(f(:,25),'k'); hold on; plot(u1(:,25),'r'); plot(u2_Rof(:,25),'b'); hold off; 
subplot(2,1,2); 
plot(f(:,200),'k');hold on; plot(u1(:,200),'r'); plot(u2_Rof(:,200),'b'); hold off; 
end 
function divf = div(ux,uy)
    divf = (ux - circshift(ux,[0,1])) + (uy - circshift(uy,[1,0]));
%     divf = (circshift(ux,[0,-1]) - circshift(ux,[0,1])) + (circshift(ux,[-1,0]) - circshift(uy,[1,0])); 
end

function [ux,uy] = grad(f)
    ux = circshift(f,[0,-1]) - f;
    uy = circshift(f,[-1,0]) - f;
%     ux = (circshift(f,[0,1])-circshift(f,[0,-1]))./2; 
%     uy = (circshift(f,[1,0])-circshift(f,[-1,0]))./2; 
%     [ux,uy] = gradient(f); 
end
function laplacian = laplacian(f)
    Lx = circshift(f,[0,-1])- 2.*f+ circshift(f,[0,1]);
    Ly = circshift(f,[-1,0])- 2.*f+ circshift(f,[1,0]);
    laplacian = Lx+Ly; 
end 
function biharmonic = biharmonic(f)
%     Lx = circshift(f,[0,2])-4.*circshift(f,[0,1])+6.*f-4.*circshift(f,[0,-1])+circshift(f,[0,-2]); 
%     Ly = circshift(f,[2,0])-4.*circshift(f,[1,0])+6.*f-4.*circshift(f,[-1,0])+circshift(f,[-2,0]); 
%     Lxy= circshift(f,[2,2])+circshift(f,[-2,-2])-4.*f+circshift(f,[-2,2])+circshift(f,[2,-2])...
%         -( circshift(f,[0,2])+circshift(f,[2,0])+circshift(f,[-2,0])+circshift(f,[0,-2]) ); 
%     biharmonic = Lx+Ly+Lxy; 
%     biharmonic = 4.*del2(4.*del2(f)); 
    biharmonic=laplacian(laplacian(f)); 
end 