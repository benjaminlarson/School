%% total variation, primal 
function [denoisedIm, energy] = youne(u, iter, lam, sp) 
% u is the image, lam = lambda penalty 
u0 = u; 
for i = 1:iter
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
     u = u+sp.*e; 
     energy(i) = sum(sum( s+lam.*(u-u0).^2 )); 
%             s = (ix.^2+iy.^2+1e-4).^(1/2);
%             dix = -circshift(ix,[0,1])+ix; 
%             diy = -circshift(ix,[1,0])+iy; 
%             div = dix./s +diy./s; 
%             e = s.*(div-2*lam*(u-u0)); 
%             u = real(u +sp.*e);   
%             imagesc(real(u)); 
end 
denoisedIm = u; 
