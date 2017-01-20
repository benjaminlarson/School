function [h] = hessn(in)
% x = in(1);
% y = in(2); 
% pxx = 1200*x^2-400*y+2;
% pyy = 200;
% pyx = -400*x;
% pxy = -400*x; 
% h = ([pxx, pxy; pyx, pyy]); 
syms x1 x2 x3 x4
f = 100*(x2-x1^2)^2+(x1-1)^2+...
    100*(x3-x2^2)^2+(x2-1)^2+ ...
    100*(x4-x3^2)^2+(x3-1)^2; 
h = hessn(f, in); 
end 
