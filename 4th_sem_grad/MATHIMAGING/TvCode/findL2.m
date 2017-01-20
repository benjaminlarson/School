function l2 = findL2(u, u0,eps)
    
    ui1j= circshift(u,[0 1]); %   i+1, j 
    uij1= circshift(u,[1 0]); %       i, j+1 
    ui1j1=circshift(u,[1 1]); %  i+1, j+1

    ui_j_ = circshift(u,[-1 -1]);% i-1, j-1
    ui_j = circshift(u,[0 -1]);%     i-1, j
    uij_ = circshift(u,[-1 0]); %    i    , j-1

    dxx = ui1j+ui_j; 
    dyy = uij1+uij_; 

    dxy = ui1j1 - uij1 -ui1j+u;
    dxy_ = ui_j_-uij_-ui_j+u; 

    dyx = ui1j1-ui1j-uij1+u;
    dyx_=ui_j_-ui_j-uij_+u;
    abs_d2= (dxx.^2+dxy.^2+dyx.^2+dyy.^2+eps)^(1/2);
    
    datamatch = u-u0;
    ui1j= circshift(datamatch./abs_d2,[0 1]); %   i+1, j 
    ui_j = circshift(datamatch./abs_d2,[0 -1]);%     i-1, j
    dmxx = ui1j+ui_j; 
    
    uij1= circshift(datamatch./abs_d2,[1 0]); %       i, j+1 
    uij_ = circshift(datamatch./abs_d2,[-1 0]); %    i    , j-1
    dmyy = uij1+ui_j; 
    
    ui_j_ = circshift(datamatch,[-1 -1]);% i-1, j-1
    ui_j = circshift(datamatch,[0 -1]);%     i-1, j
    uij_ = circshift(datamatch,[-1 0]); %    i    , j-1
    dmyx=ui_j_-ui_j-ui_j+datamatch/abs_d2;
    
    ui1j1=circshift(datamatch,[1 1]); %  i+1, j+1
    uij1= circshift(datamatch,[1 0]); %     i, j+1 
    ui1j= circshift(datamatch,[0 1]); %   i+1, j 
    dmxy = ui1j1 - uij1 -ui1j+datamatch/abs_d2;
    
    l2 = sum(sum(dxx./abs_d2.*dmxx ...
        +dxy./abs_d2.*dmyx + dyx./abs_d2.*dmxy...
        +dyy./abs_d2.*dmyy)); 
end 