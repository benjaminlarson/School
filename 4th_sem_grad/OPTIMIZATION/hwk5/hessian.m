function [h] = hessian(in)
x = in(1);
y = in(2); 
pxx = 1200*x^2-400*y+2;
pyy = 200;
pyx = -400*x;
pxy = -400*x; 
h = ([pxx, pxy; pyx, pyy]); 
end 
