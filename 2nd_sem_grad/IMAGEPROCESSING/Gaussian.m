% function m = Gaussian(n)
clear; clc; close all; 
n = 10; 
m = zeros(ceil(6*n),ceil(6*n));
sigma = 3*n; 
% for i = 1:n 
%   for j = 1:n
%     top = -(i^2+j^2)/(2*sigma^2)
%     m(i,j) = 1/(2*pi*sigma^2) * exp(top); 
%   end
% end
io = floor(size(m,1)/2);
jo = floor(size(m,2)/2); 
for i = 1:size(m,1)
  for j = 1:size(m,2)
    top = -((i-io)^2/(2*sigma^2)+(j-jo)^2/(2*sigma^2)); 
    m(i,j) = 1/(2*pi*sigma^2) * exp(top);
  end
end
surf(m); 