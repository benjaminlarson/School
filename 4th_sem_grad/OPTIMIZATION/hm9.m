%optimization homwork 9
clear; close all; clc; 
%% Problem 1 
% [x,y] = meshgrid(-10:1:10);
% 
% for i  = 1: 12; 
% % mesh(x,y,-5.*x+y+(x-1).^2)
% % figure();
% subplot(1,2,1); 
% mesh(x,y,-5.*x+y-i.*(x-1).^2)
% % contour(x,y,-5.*x+y+(x-1).^2); hold on; scatter(1,0); 
% % figure()
% subplot(1,2,2) 
% contour(x,y,-5.*x+y+i.*(x-1).^2);hold on; scatter(1,0); 
% pause(2); 
% end 

%% Problem 3 
% u = 1; 
% t = 1/u; 
% options =  optimoptions(@fminunc, 'TolFun',t);
% fun = @(x) x(1)+x(2) +u/2.*(x(1)^2+x(2)^2-2).^2;
% x0 = [0,1];
% [x,fval] = fminunc(fun,x0)
% res(1,:) = x; 
% u = 10; 
% t = 1/u; 
% options =  optimoptions(@fminunc, 'TolFun',t);
% fun = @(x) x(1)+x(2) +u/2.*(x(1)^2+x(2)^2-2).^2;
% [x,fval] = fminunc(fun,x)
% res(2,:) = x;
% u = 100; 
% t = 1/u; 
% options =  optimoptions(@fminunc, 'TolFun',t);
% fun = @(x) x(1)+x(2) +u/2.*(x(1)^2+x(2)^2-2).^2;
% [x,fval] = fminunc(fun,x)
% res(3,:) = x; 
% u = 1000; 
% t = 1/u; 
% options =  optimoptions(@fminunc, 'TolFun',t);
% fun = @(x) x(1)+x(2) +u/2.*(x(1)^2+x(2)^2-2).^2;
% [x,fval] = fminunc(fun,x)
% res(4,:) = x; 
% [x,y] = meshgrid(-10:1:10);
% 
% subplot(1,2,1); 
% mesh(x,y, x+y +u/2.*(x^2+y^2-2).^2)
% subplot(1,2,2) 
% contour(x,y, x+y +u/2.*(x^2+y^2-2).^2);
% figure(); scatter(res(1,:),res(2,:));

%% Problem 4 
u = 1e-10; 
t = 1/u+1e-6; 
x = [10,11,10];
s = x; 
lam = 1.0; 
for i = 1:10
    options =  optimoptions(@fminunc, 'TolFun',t);
    fun = @(x) norm(x,2).^2 -lam.*(x(1)+x(2)-3*x(3)-2)+u/2.*(x(1)^2+x(2)^2-3*x(3)-2).^2;
    [x,fval] = fminunc(fun,x);
    u = 10*u; 
    lam = lam - u*(x(1)+x(2)-3*x(3)-2); 
end 
res = x
fval 

[x,y] = meshgrid(-15:1:15);

subplot(1,2,1); 
mesh(x,y,(x+y).^2 -lam.*(x+y-2)+u/2.*(x^2+y^2-2).^2)
subplot(1,2,2) 
contour(x,y,(x+y).^2);hold on; plot([10,res(1)],[10,res(2)]); 
figure()
contour(x,y,(x+y).^2 -lam.*(x+y-2)+u/2.*(x^2+y^2-2).^2,20); hold on; plot([s(1),res(1)],[s(2),res(2)]); 

