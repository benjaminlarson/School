clear; clc; close all; 
%% plot 
b = 5;
st = 0.1; 
[X,Y] = meshgrid(-b:st:b, -b:st:b);
z=(1.5-X+X*Y').^2+(2.25-X+X*Y'.^2).^2+(2.625-X+X*Y'.^3).^2; 
contour(X,Y,z,50,'ShowText','off');
hold on;
% scatter(x(1,:),x(2,:)); 
% plot(x(1,:),x(2,:)); 
% title('BFGS method'); 

%% optimize
x = [-1;0;0;0]; 
eps = 1e-4; 
i = 1;
k = 0;
r = -fi_(x(:,1)); 
d = r; 
delta_new = r'*r; 
delta_0 = delta_new; 
% scatter(x(1),x(2)); 

while i < 50 && delta_new > eps^2*delta_0
    j = 1; 
    delta_d = d'*d; 
    alpha = 10; 
    while (j < 10) && (alpha^2*delta_d) > eps^2
        h = hessn(x); 
        alpha = - fi_(x)'*d/(d'*h*d); 
%         alpha = 5e-3; 
        x = x + alpha*d;
        j = j +1;
    end 
%     plot(x(1),x(2)); 
    fx(:,i) = x; 
    fx_y(:,i) = fi(x); 
%     scatter(x(1),x(2)); 
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

plot(fx(1,:),fx(2,:));  
scatter(fx(1,end), fx(2,end)); 
figure();
plot(fx_y); 