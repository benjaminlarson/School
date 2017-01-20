%% Total Variation
clear; close all; clc; 
% u = zeros(250,250); 
% u(50:90,:) = 10;
% u(101:150,:) = 15; 
% u(160:200,:) = 20; 
% n = rand(size(u)); 
% u = u + n*10; 
% u = double(u); 
% u0 = double(u);
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = i/10; 
    end
end 
n = rand(size(u)); 
u = u + n.*10; 
u = double(u); 
u0 = u;
figure(); imagesc(u0); 
%% Younes 
%gradient descent 

eps = 1/10; 
lambda = 1/std2(u0); 
iter = 1000; 
E = zeros(iter); 
for i =1:iter
    im = u; 
%     stencil = [-1,-1,-1;-1,8,-1;-1,-1,-1]/8;
    stencil = [0,1,0;1,-4,1;0,1,0]/4; 
%     stencil = [0,-1,0;-1,4,-1;0,-1,0]/4;
    laplacianIm = imfilter(double(im), stencil);
    E(i) = sum(sum(eps*(laplacianIm-lambda*(im-u0))));
    u = im + eps*(laplacianIm-lambda*(im-u0));    
end 
figure(); imagesc(u); figure(); 
subplot(1,3,1);
imagesc(u0,[0,30]);colormap gray;title('Initial data');
subplot(1,3,2); 
imagesc(u,[0,30]); title('GradDescent Denoised'); 
% figure(); 
% subplot(2,1,1)
% semilogy(E); 
% title('E(I,I0)'); 
% subplot(2,1,2)
% plot(E);

%% FFT 
lam = 1; 
im = u0; 
% correct size
% M = 250; N = 250; 
% for i = 1:M
%     for j = 1:N
%         im(2*M-i+1,j) = u0(i,j);
%         im(i,2*N-j+1) = u0(i,j);
%         im(2*M-i+1,2*N-j+1) = u0(i,j); 
%     end 
% end 

y = fft2(im);
K1 = 250;
K2 = 250; 
z = zeros(size(y)); 
for k1 = 1:size(y,1)
    for k2 = 1:size(y,2)
        z(k1,k2) = lam*y(k1,k2)/(lam+2*(2-cos(2*pi*(k1-1)/K1) -cos(2*pi*(k2-1)/K2) ));
    end 
end 

x = ifft2(z)/(K1*K2);
subplot(1,3,3)
imagesc(abs(x)); title('FFT Denoised')


%% Optimize, crap solution
% t = 1e-3; h = 1/250; k = 1; sigma = 1; 
% for i = 2:size(u,1)-1
%     for j = 2:size(u,2)-1
%         ux0_ = -(u(i-1,j)-u(i,j));
%         ux0   = (u(i+1,j)-u(i,j)); 
%         uy0_ = -(u(i,j-1)-u(i,j)); 
%         uy0   = (u(i,j+1)-u(i,j)); 
%     end 
% end 
% u0 = u; 
% for iter = 1:5
%     for i = 2:size(u,1)-1
%         for j = 2:size(u,2)-1
% 
%             ux_ = -(u(i-1,j)-u(i,j));
%             ux   = (u(i+1,j)-u(i,j)); 
%             uy_ = -(u(i,j-1)-u(i,j)); 
%             uy   = (u(i,j+1)-u(i,j)); 
%             gx = t/h*(ux) / (ux^2+sqrt(minmod(uy,uy_)^2)); 
%             gy =  t/h*(uy)/ (uy^2+sqrt(minmod(ux,ux_)^2));
% 
% 
%             la = sqrt(ux0^2 *ux^2);
%             lb = ux0*ux/sqrt(ux^2+uy^2); 
%             lc = uy0*uy*k/ sqrt(ux^2+uy^2); 
%             l = h/2*sigma^2*sum(la-lb-lc); 
%             lagrange = t*l*u(i,j)-u0(i,j); 
% 
%             u(i,j) = u(i,j)  +gx +gy - lagrange; 
%         end 
%     end 
%     imagesc(u); colorbar; 
%     pause(0.5); 
% end 
% imagesc(u); colorbar; 


