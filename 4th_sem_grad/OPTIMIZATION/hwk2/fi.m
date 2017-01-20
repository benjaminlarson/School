function [a_result] = fi(a)
x = a(1); y = a(2) ; 

%function 1 
a_result = (x^4+ x^2+ y^2+ 1.2*x*(y+1)^(1.4)+ 1)^0.7;  

%function 2 
% a_result = x^2+9*y^2+6*x*y+0.3*x^4; 

%Test Function 
% a_result = x^2+y^2; 

%Function 3
% x = a(1); y =a(2); z = a(3); 
% a_result = x^2+100*y^2+10*z^2-15*x*y+2*y*z; 

end 