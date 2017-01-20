function [a] = ls(x,xold,ai,a_1,B) 
    c1 = 1e-3;
    c2 = 0.9;
    
    a = 0;
    for i = 1:10
        g = fi_(x); %gradient for this x 
        p = -1*B*g; %B should be inverse, pass it in, inverted. Because quasi newton... 
        fai = fi(x+ai*p);
        sufdec = fi(x+0)+c1*ai*fi_(x)'*p;
        if fai > sufdec || (fai > fi(x+a_1*p) && i > 1) %% sufficient decrease fails 
            a = zoom(x,a_1,ai,p);
            return
        end
        fi_p = fi_(x+ai*p)'*p; 
        curv = -c2*fi_(x+0)'*p; 
        if (abs(fi_p) <= curv) %% curvature fails 
            a = ai;
            return
        end
        if fi_p >= 0 %% Not a move towards minimum? 
            a = zoom(x,ai,a_1,p);
            return
        end
        a_1 = ai*abs(log(ai));
%         a_1=ai*(fi_(xold)'*fi_(xold))/(fi_(x)'*fi_(x));% this should be between (ai, amax) 
    end
end