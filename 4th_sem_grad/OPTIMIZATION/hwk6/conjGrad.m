
function [x, solution, count] = conjGrad(A,b,x)
    count = 0;
    r=A*x-b;
    p=-r;
    rsold=r'*r;
    solution = zeros(1,1); 
    for i=1:1000
        alpha=r'*r/(p'*A*p);
        x=x+alpha*p;
        rold = r; 
        r=r+alpha*A*p;
        B = r'*r/(rold'*rold); 
        if r <10e-6
              break;
        end
        count = count+1; 
        p=-r+B*p;
        solution(i) = r'*r; 
    end
end