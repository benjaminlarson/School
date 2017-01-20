function [result] = bleal(x) 
x = x(1), y = x(2); 
    result = (1.5-x+x*y)^2 + (2.25-x+x*y^2)^2+(2.265-x+x*y^3)^2; 
end 