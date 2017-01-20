function l1 = findL1(u,u0,eps)

    ui1j= circshift(u,[0 -1]); %   i+1, j 
    uij1= circshift(u,[-1 0]); %       i, j+1 
    ui1j1=circshift(u,[-1 -1]); %  i+1, j+1

    ui_j_ = circshift(u,[1 1]);% i-1, j-1
    ui_j = circshift(u,[0 1]);%     i-1, j
    uij_ = circshift(u,[1 0]); %    i    , j-1

    dx  = ui1j - u;
    dx_= -ui_j + u;
    dx = dx+dx_; 
    
    dy  = uij1-u; 
    dy_ =-uij_+u;
    dy = dy+dy_; 

 % abs value terms
    m_dx = (sign(dy)+sign(dy_))./2.*min((dy.^2).^(1/2),(dy_.^2).^(1/2)); 
    abs_dx = (dx.^2+m_dx.^2+eps).^(1/2); 
    m_dy = (sign(dx)+sign(dx_))./2.*min((dx.^2).^(1/2),(dx_.^2).^(1/2));
    abs_dy =  (dy.^2+m_dy.^2+eps).^(1/2);
    
    dm = u0; 
    ui1j= circshift(dm,[0 1]); %   i+1, j 
    uij1= circshift(dm,[1 0]); %       i, j+1 

    ux  = ui1j - dm;  
    uy  = uij1-dm; 
%     datamatch = ux+uy;
    
%     s = (abs_dx+abs_dy).^(1/2); 
    
%     l1 = 1*sum(sum(dx./s.*datamatch))
    l1a = dx.*ux./(dx.^2+dy.^2).^(1/2); 
    l1b = dy.*uy./(dx.^2+dy.^2).^(1/2);
    lam = (dx.^2+dy.^2).^(1/2)-l1a-l1b; 
    l1 = sum(sum(lam)); 
end 