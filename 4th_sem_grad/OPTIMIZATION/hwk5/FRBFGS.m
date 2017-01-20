clear; clc; 
%% plot 
b = 10;
st = 0.1; 
[X,Y] = meshgrid(-b/2:st:b/2, -b:st:b);
z=100*(Y-X.^2).^2+(1-X).^2; 
contour(X,Y,z,50,'ShowText','off');
hold on;
% scatter(x(1,:),x(2,:)); 
% plot(x(1,:),x(2,:)); 
% title('BFGS method'); 

%% optimize
x = [-3;3]; 
eps = 1e-6; 
i = 1;
k = 0;
r = -fi_(x(:,1)); 
d = r; 
delta_new = r'*r; 
delta_0 = delta_new; 
scatter(x(1),x(2)); 
while i < 50 && delta_new > eps^2*delta_0
    j = 1; 
    delta_d = d'*d; 
    alpha = 1; 
    while (j < 10) && (alpha^2*delta_d) > eps^2
        alpha = - fi_(x)'*d/(d'*hessian(x)*d); 
%         alpha = 5e-3; 
        x = x + alpha*d;
        j = j +1 ; 
    end 
    scatter(x(1),x(2)); 
    r = -fi_(x);
    delta_old = delta_new; 
    delta_new = r'*r; 
    B = delta_new/delta_old; 
    d = r+B*d; 
    k = k+1; 
    if k == 10 || r'*d <=0
        d = r;
        k = 0;
    end 
    i = i+1; 
end 

