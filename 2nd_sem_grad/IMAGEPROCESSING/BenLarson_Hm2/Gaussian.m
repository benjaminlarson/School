function m = Gaussian(n)
% n should be 3*sigma 
m = zeros(ceil(2*n+1),ceil(2*n+1));
sigma = n; 

io = floor(size(m,1)/2)+1;
jo = floor(size(m,2)/2)+1; 
for i = 1:size(m,1)
  for j = 1:size(m,2)
    top = -((i-io)^2/(2*sigma^2)+(j-jo)^2/(2*sigma^2)); 
    m(i,j) = 1/(2*pi*sigma^2) * exp(top);
  end
end