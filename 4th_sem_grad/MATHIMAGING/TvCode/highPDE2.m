%% Higher Order PDEs denoising 
clear; close all; clc; 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = i/10; 
         if i < j
           u(i,j) = 30; 
         end 
    end
end 
n = randn(size(u)); 
u = u + n; 
u = double(u); 
u0 = u;
v = u;

%parameters
lam1 = 1e-2; 
lam2 = 1e-4;
eps = 1e-5; 
%step size for gradient descent 
t_tv =1e-2; 
t_htv = 1e-3; %MAKE THIS LESS THAN .01!!!
theta = 1/2.*ones(size(u)); 
c = 1/25; 

% imagesc(u);figure(); 

figure('units','normalized','outerposition',[0 0 1 0.5]); 
for i = 1:200
    %% E1 
    ui1j= circshift(u,[0 -1]); %   i+1, j 
    uij1= circshift(u,[-1 0]); %       i, j+1 
    ui1j1=circshift(u,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(u,[1 1]);% i-1, j-1
    ui_j = circshift(u,[0 1]);%     i-1, j
    uij_ = circshift(u,[1 0]); %    i    , j-1

    dx  = ui1j - u;
    dx_= -ui_j + u;

    dy  = uij1-u; 
    dy_ =-uij_+u;

 % abs value terms
    m_dx = (sign(dy)+sign(dy_))./2.*min((dy.^2).^(1/2),(dy_.^2).^(1/2)); 
    abs_dx = (dx.^2+m_dx.^2+eps).^(1/2); 
    m_dy = (sign(dx)+sign(dx_))./2.*min((dx.^2).^(1/2),(dx_.^2).^(1/2));
    abs_dy =  (dy.^2+m_dy.^2+eps).^(1/2);
    
    ddx_ = (-circshift(dx./abs_dx,[0,1])+dx./abs_dx); %i-1, j
    ddy_ = (-circshift(dy./abs_dy,[1,0])+dy./abs_dy); %i, j-1 

%     l1 = findL1(u, u0,eps);
%     h = 1/250; 
%     lam1 = -h/(sigma^2).*l1; 
%     lam1 = 1e-1; 
%     s = (abs_dx.*abs_dy).^(1/2); 
    s = 1; 
    div =  ddx_+ddy_; 
    e = s.*(div -2*lam1.*(u-u0));
    unew = u + t_tv.*e; %lambda should be updated
    unew = real(unew); 
    
    
    %% E2, rename the shifted values, these are the derivatives of v. 
    ui1j= circshift(v,[0 -1]); %   i+1, j 
    uij1= circshift(v,[-1 0]); %       i, j+1 
    ui1j1=circshift(v,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(v,[1 1]);% i-1, j-1
    ui_j = circshift(v,[0 1]);%     i-1, j
    uij_ = circshift(v,[1 0]); %    i    , j-1

    dxx = ui1j+ui_j-2.*v; 
    dyy = uij1+uij_-2.*v; 
    
    dxy = uij1 -ui1j+2.*v;
    dxy_ = -uij_-ui_j+2.*v; 

    dyx = -ui1j-uij1+2.*v;
    dyx_=-ui_j-uij_+2.*v; 
    
    abs_d2= (dxx.^2+dxy.^2+dyx.^2+dyy.^2+eps).^(1/2);
    
    ui1j= circshift(dxx./abs_d2,[0 1]); %   i+1, j 
    ui_j = circshift(dxx./abs_d2,[0 -1]);%     i-1, j
    dxxdxx = ui1j+ui_j-2.*dxx./abs_d2; 
    
    uij1= circshift(dyy./abs_d2,[1 0]); %       i, j+1 
    uij_ = circshift(dyy./abs_d2,[-1 0]); %    i    , j-1
    dyydyy = uij1+uij_-2.*dyy./abs_d2; 
    
    ui_j_ = circshift(dxy./abs_d2,[-1 -1]);% i-1, j-1
    ui_j = circshift(dxy./abs_d2,[0 -1]);%     i-1, j
    uij_ = circshift(dxy./abs_d2,[-1 0]); %    i    , j-1
    dyx_2=-uij_-ui_j+2.*dxy./abs_d2;
    
    ui1j1=circshift(dyx_./abs_d2,[1 1]); %  i+1, j+1
    uij1= circshift(dyx_./abs_d2,[1 0]); %     i, j+1 
    ui1j= circshift(dyx_./abs_d2,[0 1]); %   i+1, j 
    dxy2 = - uij1 -ui1j+2.*dyx_./abs_d2;

%     s = (dxxdxx.^2+dyydyy.^2+dyx_2.^2+dxy2.^2+eps).^(1/2); 
    s = 1; 
    e =  s.*((dxxdxx+dxy2+dyx_2+dyydyy)-lam2.*(v-u0)); 
    vnew = v -t_htv.*e; 
    vnew = real(vnew); 
    
    w1 = theta.*unew;
    w2 = (1-theta).*vnew; 
    w = w1+w2;
    w = w./max(max(w)); 
    [gwx,gwy] = gradient(w);
    absw = (gwx.^2+gwy.^2).^(1/2);  
    theta = 1/2.*cos((2*pi.*absw)./c)+1/2; 

    theta(abs(gradient(w)) >=c) =1; 
    theta = zeros(size(u)); 
    uopt = theta.*unew+(1-theta).*vnew;
    v = u; 
    u = unew; 
    v = vnew;
% subplot(1,5,1);
% imagesc(u0);
% subplot(1,5,2);
% imagesc(unew);
% subplot(1,5,3);
% imagesc(vnew); 
% subplot(1,5,4)
% % imagesc(uopt); 
% subplot(1,5,5); 
% imagesc(theta); 
% pause(0.1); 
end 
% figure(); 
subplot(1,3,1);
imagesc(u0);
subplot(1,3,2);
imagesc(u);
subplot(1,3,3);
imagesc(v); 
% subplot(1,4,4)
% imagesc(u,[0,25]); 
% figure();imagesc(theta); 
figure();
subplot(2,1,1); 
plot(u0(:,25),'b'); hold on; 
plot(vnew(:,25),'--r'); 
plot(unew(:,25),'--k'); hold off;
legend('NoiseIm','HighOrder','TV'); 
subplot(2,1,2); 
plot(u0(:,200),'b'); hold on; 
plot(vnew(:,200),'--r'); 
plot(unew(:,200),'--k'); hold off; 
legend('NoiseIm','HighOrder','TV'); 
% figure();
% subplot(2,1,1); 
% plot(u0(:,25),'b'); hold on; plot(unew(:,25),'--r'); 
% subplot(2,1,2);
% plot(u0(:,200),'b'); hold on; plot(unew(:,200),'--r'); 