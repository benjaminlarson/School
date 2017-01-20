clear; clc; close all; 
% A1 = [4,1;1,3]; b = [1,2]'; 
% x = [2,1]'; 
% wiki = conjGrad(A1,b,x); 

n = 5;
for i =1: n
    for j = 1:n
        A(i,j) = 1/(i+j-1); 
    end 
end 

b = ones(n,1);
x = zeros(n,1); 
[newx, res, count] = conjGrad(A,b,x);
subplot(4,2,1); semilogy(res); title('Log y axis');
subplot(4,2,2); plot(res); 
title(sprintf('ConjGrad with Hilbert matrix dim = %d and iter = %d', n, count)); 

n = 8;
for i =1: n
    for j = 1:n
        A(i,j) = 1/(i+j-1); 
    end 
end 

b = ones(n,1);
x = zeros(n,1); 
[newx, res, count] = conjGrad(A,b,x);
subplot(4,2,3); semilogy(res); title('Log y axis');
subplot(4,2,4); plot(res); 
title(sprintf('ConjGrad with Hilbert matrix dim = %d and iter = %d', n, count)); 

n = 12;
for i =1: n
    for j = 1:n
        A(i,j) = 1/(i+j-1); 
    end 
end 

b = ones(n,1);
x = zeros(n,1); 
[newx, res, count] = conjGrad(A,b,x);
subplot(4,2,5); semilogy(res); title('Log y axis');
subplot(4,2,6); plot(res); 
title(sprintf('ConjGrad with Hilbert matrix dim = %d and iter = %d', n, count)); 

n = 20;
for i =1: n
    for j = 1:n
        A(i,j) = 1/(i+j-1); 
    end 
end 

b = ones(n,1);
x = zeros(n,1); 
[newx, res, count] = conjGrad(A,b,x);
subplot(4,2,7); semilogy(res); title('Log y axis');
subplot(4,2,8); plot(res); 
title(sprintf('ConjGrad with Hilbert matrix dim = %d and iter = %d', n, count)); 
