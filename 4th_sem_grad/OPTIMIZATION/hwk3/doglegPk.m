function [result] = doglegPk(delta, x)
X = x(1); Y = x(2); 

g = [(40*X.^3-40*X.*Y+2*X-2);(20*Y-20*X.^2)];

B = [120*X.^2-40*Y+2, -40*X*ones(size(X));...
    -40*X*ones(size(X)), 20*ones(size(X))]; 

pu = (-g'*g/(g'*B*g))*g;  
pb = -inv(B)*g;  %=inv(H) *g 

gBg = g'*B*g; 
%
    if gBg <= 0
        tau = 1;
    else 
       tau = min([norm(g)^3/(delta*gBg),1]);
    end 


    if (0< tau) && (tau< 1)
        pt = tau*pu; 
    elseif (1<= tau) && (tau <=2)  
        pt = pu+(tau-1)*(pb-pu); 
    else
        fprinf('problem with tau');
        pt = 0; 
    end 
tau
result = pt;
end 