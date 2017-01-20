%% Higher Order PDEs denoising 
clear; close all; clc; 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
%         u(i,j) = mod(i,40); 
            u(i,j) = i/10.; 
         if i < j
           u(i,j) = 30; 
         end 
    end
end 
Lu= u; 
n = randn(size(u)); 
u = u + n; 
u = double(u); 
u0 = u;
v = u;

%parameters
lam1 = 1e-3; 
lam2 = 1e-1;
eps = 1e-9; 
%step size for gradient descent 
t_tv =1e-1; 
t_htv = 1e-2; %MAKE THIS LESS THAN .01!!!
E1iter = 100;
E2iter = 1000; 

figure('units','normalized','outerposition',[0 0 1 0.5]); 
for i = 1:E1iter
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

     s = (dx.^2+dy.^2).^(1/2); 
%      s = (abs_dx+abs_dy).^(1/2); 
%     s = (abs_dx.*abs_dy).^(1/2); 
%     s = 1; 
    div =  ddx_+ddy_; 
    e = s.*(div -2*lam1.*(u-u0));
    unew = u + t_tv.*e; %lambda should be updated
    unew = real(unew);
    u = unew; 
end
    %% E2, rename the shifted values, these are the derivatives of v. 
for i =1:E2iter 
    ui1j= circshift(v,[0 -1]); %   i+1, j 
    uij1= circshift(v,[-1 0]); %       i, j+1 
    ui1j1=circshift(v,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(v,[1 1]);% i-1, j-1
    ui_j = circshift(v,[0 1]);%     i-1, j
    uij_ = circshift(v,[1 0]); %    i    , j-1

    dxx = ui1j+ui_j-2.*v; 
    dyy = uij1+uij_-2.*v; 

%     dxx = ui1j-v;
%     dyy = uij1-v; 
    
    abs_d2= (dxx.^2+dyy.^2+eps).^(1/2);
    
    ui1j= circshift(dxx./abs_d2,[0 1]); %   i+1, j 
    ui_j = circshift(dxx./abs_d2,[0 -1]);%     i-1, j
    dxxdxx = ui1j+ui_j-2.*dxx./abs_d2; 
%     dxxdxx = ui1j-dxx./abs_d2; 
    uij1= circshift(dyy./abs_d2,[1 0]); %       i, j+1 
    uij_ = circshift(dyy./abs_d2,[-1 0]); %    i    , j-1
    dyydyy = uij1+uij_-2.*dyy./abs_d2; 
%     dyydyy = uij1-dyy./abs_d2; 
    e =  (dxxdxx+dyydyy)-lam2.*(v-u0); 
    vnew = v -t_htv.*e; 
    vnew = real(vnew); 
    v = vnew;
end 
% figure(); 
subplot(1,3,1);
imagesc(Lu);colormap jet; 
subplot(1,3,2);
imagesc(u);colormap jet; 
subplot(1,3,3);
imagesc(v); colormap jet; 
figure();
subplot(1,2,1); 
plot(Lu(:,25),'b'); hold on; 
plot(vnew(:,25),'--r'); 
plot(unew(:,25),'--k'); hold off;
legend('NoiseIm','HighOrder','TV'); 
subplot(1,2,2); 
plot(Lu(:,200),'b'); hold on; 
plot(vnew(:,200),'--r'); 
plot(unew(:,200),'--k'); hold off; 
legend('NoiseIm','HighOrder','TV'); 
