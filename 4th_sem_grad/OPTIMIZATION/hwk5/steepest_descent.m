clear; close all; clc; 
x = [1,0]; track = x; minimum = 10e5; 
% Steepest descent
 a_1 = 0;
 alpha = 100; 
for i = 1:4
%     alpha = 0.1; 
    a_1 = alpha; 
    alpha = ls(x,track, alpha,a_1); %x, x-1, alpha guess 
    grad = [fi_(x)]; 
    track = x;
    x =x+alpha*fi_(x);
    minimum = fi(x);
end 
minimum
x = [1,0]; track = x; minimum = 10e5; a_1 = 0; alpha = 1; 
% newton method
for i = 1:4
    
    a_1 = alpha;
    alpha = ls(x,track,alpha,a_1);
    hes = hessian(x); 
    grad = hes*fi_(x)'; 
    track = x; 
    x = x+(alpha*hes*fi_(x)')'; 
    minimum = fi(x) ;
end 
% modified newton
x
minimum
x = [1,0]; track = x; minimum = 10e5; a_1 = 0; alpha =1; 

for i = 1:4
    hes = hessian(x); 
    e = eig(hes); 
    e 
    if any(e <= 0 )
        hes = hes+10e-6*eye(size(hes));%or just update the smallest egien values? by the eigenvalues? 
    end
    
    a_1 = alpha;
    alpha = ls(x,track,alpha,a_1); 
    grad = hes*fi_(x)'; 
    track = x; 
    x = x+(alpha*hes*fi_(x)')'; 
    minimum = fi(x) ;
end 
x
minimum


% [X,Y] = meshgrid(-3:.1:3,-3:.1:3);
% z =real((X.^4 + X.^2 + Y.^2 + 1.2 * X .* (Y+1).^(1.4) + 1).^(0.7));

% [X,Y] = meshgrid(-4:.1:4,-4:.1:4); 
% z = X.^2+9*Y.^2+6.*X.*Y+0.3*X.^4; 
% surf(X,Y,z);


%Test Function
% surf(X,Y,X.^2+Y.^2) 
% xlabel('x'); 
% figure()
% imagesc(real(z)) 
% imagesc(real(z)); 

