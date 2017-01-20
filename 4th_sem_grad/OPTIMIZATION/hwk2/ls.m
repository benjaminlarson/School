function [a] = ls(x,xold,ai,a_1) 
    c1 = 1e-3;
    c2 = 0.9;
    
    a = 0;

    for i = 1:10
        fai = fi(x+ai*fi_(x));
        sufdec = fi(x+0)+c1*ai*fi_(x+0)*fi_(x)';
        if fai > sufdec || (fai > fi(x+a_1*fi_(x)) && i > 1) %% sufficient decrease fails 
            a = zoom(x,a_1,ai);
            return
        end
        fi_p = fi_(x+ai*fi_(x))*fi_(x)'; 
        curv = -c2*fi_(x)*fi_(x)'; 
        if (abs(fi_p) <= curv) %% curvature fails 
            a = ai;
            return
        end
        if fi_p >= 0 %% Not a move towards minimum? 
            a = zoom(x,ai,a_1);
            return
        end
        a_1 = ai;
        ai=ai*(fi_(xold)*fi_(xold)')/(fi_(x)*fi_(x)');% this should be between (ai, amax) 
    end
end