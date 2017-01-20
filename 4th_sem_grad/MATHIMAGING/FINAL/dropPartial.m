%% Higher Order PDEs denoising 
function [dim1,dim2, energy1,energy2] = dropPartial(u, E1iter, E2iter, lam1,lam2,stepU,stepV)
% u image
% stepU for the tv term;
% stepV for the higher order term; 
eps = 1e-9; 
v = u;
u0 = u; 
for i = 1:E1iter
    %% E1 Higher order without partials Dxy,Dyx 
    ui1j= circshift(u,[0 -1]); %   i+1, j 
    uij1= circshift(u,[-1 0]); %       i, j+1 
    ui1j1=circshift(u,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(u,[1 1]);% i-1, j-1
    ui_j = circshift(u,[0 1]);%     i-1, j
    uij_ = circshift(u,[1 0]); %    i    , j-1

    dxx = ui1j+ui_j-2.*u; 
    dyy = uij1+uij_-2.*u; 
    
    abs_d2= (dxx.^2+dyy.^2+eps).^(1/2);
    
    ui1j= circshift(dxx./abs_d2,[0 1]); %   i+1, j 
    ui_j = circshift(dxx./abs_d2,[0 -1]);%     i-1, j
    dxxdxx = ui1j+ui_j-2.*dxx./abs_d2; 
%     dxxdxx = ui1j-dxx./abs_d2; 
    uij1= circshift(dyy./abs_d2,[1 0]); %       i, j+1 
    uij_ = circshift(dyy./abs_d2,[-1 0]); %    i    , j-1
    dyydyy = uij1+uij_-2.*dyy./abs_d2; 
%     dyydyy = uij1-dyy./abs_d2; 
    e =  (-dxxdxx-dyydyy)-lam2.*(u-u0); 
    unew = u +stepU.*e; 
    u = unew;
    energy1(i) = sum(sum(sqrt(dxx.^2+dyy.^2) +0.5*lam1.*(u-u0).^2 )); 
end
dim1 = u; 
    %% E2  Higher order with partials. 
for i =1:E2iter 
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
    
    abs_d2= (dxx.^2+dyy.^2+eps).^(1/2);
    dxy = 1/4.*(ui1j1 +ui_j_ -ui_j1-ui1j_);
    dyx = dxy; 

    % Shifts for second order derivatives 
    ui1j= circshift(dxx./abs_d2,[0 1]); %   i+1, j 
    ui_j = circshift(dxx./abs_d2,[0 -1]);%     i-1, j
    dxxdxx = ui1j+ui_j-2.*dxx./abs_d2; 
%     dxxdxx = ui1j-dxx./abs_d2; 
    uij1= circshift(dyy./abs_d2,[1 0]); %       i, j+1 
    uij_ = circshift(dyy./abs_d2,[-1 0]); %    i    , j-1
    dyydyy = uij1+uij_-2.*dyy./abs_d2; 
%     dyydyy = uij1-dyy./abs_d2; 
    ui_j_ = circshift(dxy./abs_d2,[-1 -1]);% i-1, j-1
    ui1j1 = circshift(dxy./abs_d2,[1,1]); 
    ui_j1 = circshift(dxy./abs_d2,[1,-1]); 
    ui1j_ = circshift(dxy./abs_d2,[-1,1]); 
    dyx2= 1/4.*(ui_j_+ui1j1-ui1j_-ui_j1); 
    dxy2 = dyx2; 
    e =  (-dxxdxx-dyx2-dxy2-dyydyy)-lam2.*(v-u0); 
    vnew = v +stepV.*e; 
    v = vnew;
    energy2(i) = sum(sum(sqrt(dxx.^2+dyy.^2+dxy.^2+dyx.^2) +0.5*lam1.*(v-u0).^2 )); 
end 
dim2 = v; 
end 
