function [a] = zoom(x, a, b, p)
c1 = 1e-5;
c2 = 0.9; 
 
for j = 1:2000
    aj = cub_int(x,a,b, p); 
    aj = (a+b)/2; 
    
    fi_a = fi(x+aj*fi_(x)'*p);
    sufdec = fi(x+0)+c1*aj*fi_(x)'*p; 
    
    curvaj = fi(x+aj*p);
    curva =  fi(x+a*p) ; 
    
    % using this step aj, do we have large steps? set the end point to the
    % new step size and make aj smaller 
    if (fi_a > sufdec || curvaj >= curva)
        b = aj;
    else
        fi_p = fi_(x+aj*p)'*p;
        if abs(fi_p) <= -c2*fi_(x+0)'*p
            a = aj;
            return
        end
        if (fi_(x+aj*p)'*p )*(b-a) >= 0
            b = a;
        end
        a = aj; 
    end
end
if j == 2000
    a = aj; 
end 
end 