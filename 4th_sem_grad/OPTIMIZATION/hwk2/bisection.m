function [root] = bisection(inta,intb)
% this function iterates between a and b to find an approximation to the
% root of a function. 
    n = 1;
    while n <= 100
        c = (inta+intb)/2;
        if (fi(c) == 0 ||(intb-inta)/2 < 10^-4)
            root = c; 
            return 
        end 
        n = n+1; 
        if sign(fi(c)) == sign(fi(inta)) 
            inta = c; 
        else 
            intb = c; 
        end 
    end 
end 