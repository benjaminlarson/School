function [fx] = function1(in) 
% original function 
%     fx = in(1)^2+in(2)^2+in(1)*in(2)+in(1)*in(3)+in(3)^2; 

% Beale's function:
y = in(2);
x = in(1);
fx = (1.5-x+x*y)^2+(2.25-x+x*y^2)^2+(2.625-x+x*y^3)^2; 

%Rosenbrock
% fx = 0;
% for i = 1:3 
%     fx = fx + 100*(in(i+1)-in(i)^2)^2 + (in(i)-1)^2; 
% end

end