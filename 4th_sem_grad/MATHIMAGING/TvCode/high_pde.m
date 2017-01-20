clear; clc; close all; 
% u = [1:100]; 
% su = sin(0.2.*u); 

 f=@(x) mod(x-1,16)+1;
 data=[0 1 2 3 4 3 2 1 0 -1 -2 -3 -4 -3 -2 -1];
 su=data(f(1:100));  
 

n = 3.*randn(1,length(su)); 
u = su +n; 
u0 = u; 
t = 0.01; %keep this small << 0.1
iter = 1000; 
lam = 1e-3; 
 for iteration = 1: iter
    %% E2, rename the shifted values, these are the derivatives of v. 
    ui1= circshift(u,[0 -1]); %   i+1, j 
    ui_ = circshift(u,[0 1]);%     i-1, j

    dxx = ui1+ui_-2.*u; 
     
    abs_d2= (dxx.^2+eps).^(1/2);
    
    ui1= circshift(dxx./abs_d2,[0 1]); %   i+1, j 
    ui_ = circshift(dxx./abs_d2,[0 -1]);%     i-1, j
    dxxdxx = ui1+ui_-2.*dxx./abs_d2; 
 
    e =  -dxxdxx-lam.*(u-u0); 
    u = u +t.*e; 
 end 
 subplot(2,1,1); 
 title('HighOrder')
 plot(su,'--k')
 hold on
 plot(u,'b')
 plot(u0,'--r')
legend('OrignalSignal','HigherOrder','Noise'); 
 hold off; 
 
 %% Total Variation 
u = 1: length(su); 
u = su + n; 
u0 = u; 
t = 0.01; 
 for iteration=1:iter
    ui1j= circshift(u,[0 -1]); %   i+1, j 

    dx  = ui1j - u;    
    abs_dx = sqrt(dx.^2); 
    ddx = (-circshift(dx./abs_dx,[0,1])+dx./abs_dx); %i-1, j

    s = abs_dx; 
    div =  ddx; 
    e = s.*(div -lam.*(u-u0));
    u = u + t.*e; 
 end 
subplot(2,1,2)
title('TV')
 plot(su,'--k')
 hold on
 plot(u,'b')
 plot(u0,'--r')
 legend('OriginalSignal','TV','Noise'); 