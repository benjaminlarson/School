%% Higher Order PDEs denoising 
clear; close all; clc; 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = 2*i/50; 
    end
end 
n = rand(size(u)); 
u = u + n.*2; 
u = double(u); 
u0 = u;
v = u;
%parameters
lam1 = 10e-1; 
lam2 = 1e-1; 
eps = 1e-4; 
t =1e-1; 
sigma = std(std(u0)); 
theta = 1/2.*ones(size(u)); 
c = 1/25; 

% imagesc(u);figure(); 
for i = 1:100
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
%     lam1 = -1/(sigma^2)*l1
%     lam1 = 1e-1; 
    s = (abs_dx.*abs_dy).^(1/2); 
%     s = 1; 
    div =  ddx_+ddy_; 
    e = s.*(div -2*lam1.*(u-u0));
    unew =u + t.*e; %lambda should be updated
    unew = real(unew); 
    
    
    %% E2, rename the shifted values, these are the derivatives of v. 
    ui1j= circshift(v,[0 -1]); %   i+1, j 
    uij1= circshift(v,[-1 0]); %       i, j+1 
    ui1j1=circshift(v,[-1 -1]); %  i+1, j+1
    ui_j_ = circshift(v,[1 1]);% i-1, j-1
    ui_j = circshift(v,[0 1]);%     i-1, j
    uij_ = circshift(v,[1 0]); %    i    , j-1
    ui2j = circshift(v,[0 -2]); % i+2,  j
    ui2_j = circshift(v,[0 2]); % i-2, j 
    uij2 = circshift(v,[-2 0]); % i,  j+2
    uij2_ = circshift(v,[2,0]); % i, j-2 
    ui1j_ = circshift(v,[1,-1]); % i+1,j-1
    ui_j1 = circshift(v,[-1 1]); %i-1, j+1

    dxx = ui_j -2.*v+ui1j; 
    dxy = v+ui1j1-uij1-ui1j; 
    dyx = v+ui_j_-ui_j-uij_; 
    dyy = -2.*v+uij_+uij1; 
    abs_d2= (dxx.^2+dxy.^2+dyx.^2+dyy.^2+eps).^(1/2);
   
    dxxdxx = 6.*v-4.*ui1j-4.*ui_j+ui2_j+ui2j; 
    dyydyy =  6.*v-4.*uij1-4.*uij_+uij2+uij2_; 
    dxy_dyx = -ui_j+2.*uij1-ui1j_ ...
                    +2.*ui_j-4.*v+2.*ui1j ...
                    -ui_j +2.*uij_ -ui1j1; 
    dyx_dxy = dxy_dyx; 
    e =  (dxxdxx./abs_d2+dyx_dxy./abs_d2+dxy_dyx./abs_d2+dyydyy./abs_d2)-lam2.*(v-u0); 
    vnew = v -t.*e;  
    vnew = real(vnew); 
    
    w1 = theta.*unew;
    w2 = (1-theta).*vnew; 
    w = w1+w2;
    [gwx,gwy] = gradient(w);
    absw = (gwx.^2+gwy.^2).^(1/2);  
    theta = 1/2.*cos((2.*pi.*absw)./c)+1/2; 
    theta(gradient(w) >=c) =1;
    
%     u = theta.*unew+(1-theta).*vnew;
%     v = u; 
    u = unew; 
    v = v;
subplot(1,4,1);
imagesc(u0);
subplot(1,4,2);
imagesc(unew);
subplot(1,4,3);
imagesc(vnew); 
subplot(1,4,4)
imagesc(u); 
end 
figure(); 
subplot(1,4,1);
imagesc(u0);
subplot(1,4,2);
imagesc(unew);
subplot(1,4,3);
imagesc(vnew); 
subplot(1,4,4)
imagesc(u);

%% Youne's method
figure('name','Youne'); 
imagesc(youne()); 

%% TVDual code 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = 2*i/50; 
    end
end 
n = rand(size(u)); 
u = u + n.*2; 
u = double(u); 
u0 = u;
v = u;
[tvim,p,d] = TVDual(u, sigma, 1000,1e-3); 
figure('name','TVDual'); 
subplot(1,2,1);
imagesc(u); 
subplot(1,2,2);
imagesc(tvim); 