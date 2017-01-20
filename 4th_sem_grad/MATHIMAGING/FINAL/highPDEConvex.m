%% Higher Order PDEs denoising 
function [u,e1,e2] = highPDEConvex(u,lam1,lam2,stepU,stepV,iter,theta,c)
u0 = u; 
v = u; 
eps = 1e-6; 
for i = 1:iter
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
    e = s.*div ;
    unew = u + stepU.*e-2*lam1.*(u-u0); %lambda should be updated
    u = unew; 
    e1(i) = sum(sum( sqrt(dx.^2+dy.^2) +0.5*lam1.*(u-u0).^2 )); 
    
    %% E2, rename the shifted values, these are the derivatives of v. 
    ui1j= circshift(v,[0 -1]); %   i+1, j 
    uij1= circshift(v,[-1 0]); %       i, j+1 
    ui1j1=circshift(v,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(v,[1 1]);% i-1, j-1
    ui_j = circshift(v,[0 1]);%     i-1, j
    uij_ = circshift(v,[1 0]); %    i    , j-1

     ui_j1 = circshift(v,[1,-1]);%  i-1,j+1 
     ui1j_ = circshift(v,[-1,1]); %  i+1,j-1 
     
    dxx = ui1j+ui_j-2.*v; 
    dyy = uij1+uij_-2.*v; 
    
    dxy = 1/4.*(ui1j1 +ui_j_ -ui_j1-ui1j_);
    dyx = dxy; 
    
    abs_d2= (dxx.^2+dxy.^2+dyx.^2+dyy.^2+eps).^(1/2);
    
    ui1j= circshift(dxx./abs_d2,[0 1]); %   i+1, j 
    ui_j = circshift(dxx./abs_d2,[0 -1]);%     i-1, j
    dxxdxx = ui1j+ui_j-2.*dxx./abs_d2; 
    
    uij1= circshift(dyy./abs_d2,[1 0]); %       i, j+1 
    uij_ = circshift(dyy./abs_d2,[-1 0]); %    i    , j-1
    dyydyy = uij1+uij_-2.*dyy./abs_d2; 
    
    ui_j_ = circshift(dxy./abs_d2,[-1 -1]);% i-1, j-1
    ui1j1 = circshift(dxy./abs_d2,[1,1]); 
    ui_j1 = circshift(dxy./abs_d2,[1,-1]); 
    ui1j_ = circshift(dxy./abs_d2,[-1,1]); 
    dyx_2= 1/4.*(ui_j_+ui1j1-ui1j_-ui_j1); 
    dxy2 = dyx_2; 

    e =  dxxdxx+dxy2+dyx_2+dyydyy; 
    vnew = v -stepV.*e-lam2.*(v-u0); 
    
    %Convex Combination 
    w1 = theta.*unew;
    w2 = (1-theta).*vnew; 
    w = w1+w2;
    w = w./max(max(w)); 
    [gwx,gwy] = gradient(w);
    absw = (gwx.^2+gwy.^2).^(1/2);  
    theta = 1/2.*cos((2*pi.*absw)./c)+1/2; 

    theta(abs(gradient(w)) >=c) =1; 
%     theta = zeros(size(u)); 
    u = theta.*unew+(1-theta).*vnew;
    v = u; 
    e2(i) = sum(sum( sqrt(dxx.^2+dxy.^2+dyx.^2+dyy.^2)+0.5*lam2.*(u-u0).^2 ));
%     e2(i) = sum(sum( sqrt(dxxdxx.^2+dxy2.^2+dyx_2.^2+dyydyy.^2) )); 
end 
