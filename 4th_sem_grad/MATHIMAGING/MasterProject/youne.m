%% total variation, primal 
function u = youne() 
clear;clc; close all; 
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
u = u + n.*2; 
u = double(u); 
u0 = u;

sp = 1e-1;
lam = 1e-1; 
eps = 1e-6;

for i = 1:100
    ui1j= circshift(u,[0 -1]); %   i+1, j 
    uij1= circshift(u,[-1 0]); %       i, j+1 
    ui1j1=circshift(u,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(u,[1 1]);% i-1, j-1
    ui_j = circshift(u,[0 1]);%     i-1, j
    uij_ = circshift(u,[1 0]); %    i    , j-1     

    ui_j1 = circshift(u,[-1,1]);
    ui1j_ = circshift(u,[1,-1]); 

    ix = ui1j-u; 
    ix_ = u-ui_j; 
    iy = uij1-u; 
    iy_ = u-uij_; 
    ixx = ui1j-2*u+ui_j; 
    iyy = uij1-2*u+uij_; 
    ixy = (ui1j1-ui_j1-ui1j_+ui_j_)/4;
    div = (ixx.*iy.^2-2.*ix.*iy.*ixy+iyy.*ix.^2)./((ix.^2+iy.^2+eps).^(3/2)); 

    m_dx = (sign(iy)+sign(iy_))./2.*min((iy.^2).^(1/2),(iy_.^2).^(1/2)); 
    abs_dx = (ix.^2+m_dx.^2+eps).^(1/2); 
    m_dy = (sign(ix)+sign(ix_))./2.*min((ix.^2).^(1/2),(ix_.^2).^(1/2));
    abs_dy =  (iy.^2+m_dy.^2+eps).^(1/2);
            
%      dix = -circshift(ix./abs_dx,[0,1])+ix./abs_dx; 
%      diy = -circshift(iy./abs_dy,[1,0])+iy./abs_dy; 
%      div = dix+diy;
     s = (ix.^2+iy.^2+eps).^(1/2); 
%             s = (abs_dx.*abs_dy).^(1/2); 
%             s = 1; 
     e = s.*(div-2*lam.*(u-u0)); 
     u = real(u+sp.*e); 
            
%             s = (ix.^2+iy.^2+1e-4).^(1/2);
%             dix = -circshift(ix,[0,1])+ix; 
%             diy = -circshift(ix,[1,0])+iy; 
%             div = dix./s +diy./s; 
%             e = s.*(div-2*lam*(u-u0)); 
%             u = real(u +sp.*e);   
%             imagesc(real(u)); 
end 
figure('name','youne'); imagesc(u);  
% u = zeros(250,250);
% u(:,100:150) = 15; 
% u(50:90,:) = 10;
% u(101:150,:) = 15; 
% u(160:200,:) = 20; 
% n = rand(size(u)); 
% u = u + n*2; 
% u = double(u); 
% u0 = double(u);
%% Compare Youne div with Norway guy
% for i = 1:10
%     ui1j= circshift(u,[0 1]); %   i+1, j 
%     uij1= circshift(u,[1 0]); %       i, j+1 
%     ui1j1=circshift(u,[1 1]); %  i+1, j+1
% 
%     ui_j_ = circshift(u,[-1 -1]);% i-1, j-1
%     ui_j = circshift(u,[0 -1]);%     i-1, j
%     uij_ = circshift(u,[-1 0]); %    i    , j-1
% 
%     dx  = (ui1j - ui_j)./2;
% %     dx_= 1*(-ui_j + u);
% % 
%     dy  = (uij1-uij_)./2; 
% %     dy_ =1*(-uij_+u);
% % 
% %  % abs value terms
% %     m_dx = (sign(dy)+sign(dy_))./2.*min(abs(dy),abs(dy_)); 
%     abs_dx = (dx.^2+dy.^2+eps).^(1/2); 
% %     m_dy = (sign(dx)+sign(dx_))./2.*min(abs(dx),abs(dx_));
%     abs_dy =  (dx.^2+dy.^2+eps).^(1/2);
% %     
%     ddx_ = circshift(dx./abs_dx,[0,-1]); %i-1, j
%     ddx = circshift(dx./abs_dx,[0,1]); %i+1, j 
%      ddx_ = (ddx-ddx_)./2;
% % %     ddx_ = -1*(-ddx_+ dx./abs_dx); % increases noise
% % %     ddx_=-ddx_+dx; %causes blurring, without abs_dx
%     ddy_ = circshift(dy./abs_dy,[-1,0]); %i, j-1 
%     ddy  = circshift(dy./abs_dy,[1,0]); 
%     ddy_ = (ddy+ddy_)./2; 
% %     ddy_=  -ddy_+dy; %causes blurring  
% %     dy = (2*u-uij_-uij1); 
% %     dx = (2*u -ui_j-ui1j); 
% %     abs_dx = (dx.^2+dy.^2+eps).^(1/2);         
% %     ddx_ = dx./abs_dx;
% %     ddy_ = dy./abs_dx;
% %      s = 1; 
%     s = (abs_dx.*abs_dy).^(1/2); 
%     div = ddx_+ddy_; 
%     e = s.*(div-2*lam.*(u-u0));
%     unew = u + sp.*e; %lambda should be updated
%     unew = real(unew); 
% end 
% figure('name','horder'); 
% imagesc(unew); 




% for i = 1:10
% ui1j= circshift(u,[0 -1]); %   i+1, j 
% uij1= circshift(u,[-1 0]); %       i, j+1 
% ui1j1=circshift(u,[-1 -1]); %  i+1, j+1
% 
% ui_j_ = circshift(u,[1 1]);% i-1, j-1
% ui_j = circshift(u,[0 1]);%     i-1, j
% uij_ = circshift(u,[1 0]); %    i    , j-1     
% 
% ui_j1 = circshift(u,[-1,1]);
% ui1j_ = circshift(u,[1,-1]); 
% 
%             ix = (ui1j-ui_j)/2; 
%             iy = (uij1-uij_)/2; 
%             ixx = ui1j-2*u+ui_j; 
%             iyy = uij1-2*u+uij_; 
%             ixy = (ui1j1-ui_j1-ui1j_+ui_j_)/4;
%             
%             div = (ixx.*iy.^2-2.*ix.*iy.*ixy+iyy.*ix.^2)./((ix.^2+iy.^2).^(3/2)); 
% 
%             s = (ix^2+iy^2).^(1/2); 
%             imagesc(real(s)); 
%             e = s.*(-div+2*lam*(u-u0)); 
%             u = real(u +sp.*e);   
%             imagesc(real(u)); 
% end 