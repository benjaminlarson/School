function [result] = quad_m(x,p)
%rosenbrock function, remember 10 = 100 in the actual problem 
X = x(1); Y=x(2); 

fx = 10*(Y-X.^2).^2 + (1-X).^2;

g = [(40*X.^3-40*X.*Y+2*X-2);(20*Y-20*X.^2)];

B = [120*X.^2-40*Y+2, -40*X*ones(size(X));...
    -40*X*ones(size(X)), 20*ones(size(X))]; 

m = fx+dot(p,g)+1/2*p'*B*p; % this is wierd 

result = m; 
end 