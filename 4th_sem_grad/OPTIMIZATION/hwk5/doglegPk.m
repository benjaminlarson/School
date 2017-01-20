function [result] = doglegPk(delta, x, B)
X = x(1); Y = x(2); 

g = fi_(x); 
pu = (-g'*g/(g'*B*g))*g;  
pb = -B*g; 
gBg = g'*B*g; 
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
        fprintf('problem with tau');
        pt = 0; 
    end 
result = pt;
end 