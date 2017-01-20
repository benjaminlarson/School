function [a_result] = fi(a)
x = a(1); y = a(2); 
a_result = 100*(y-x^2)^2+(1-x)^2;  
end 