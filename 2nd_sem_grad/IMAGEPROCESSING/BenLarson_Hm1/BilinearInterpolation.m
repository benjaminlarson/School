function Io = BilinearInterp(I) 

for x = 1:2*size(I,1)
  for y = 1:2*size(I,2)
    Io(x,y) = 0;
  end
end

for i = 3:1:(size(Io,1)-2) %columns
  for j = 3:1:(size(Io,2)-2) %rows 
    % this is the weights
    x = i*(size(I,1)-1)/(size(Io,1)-1);
    y = j*(size(I,2)-1)/(size(Io,2)-1); 
    
    cx=ceil(x); cy=ceil(y);
    fx=floor(x);fy=floor(y);
    if fx == 0 || fy == 0
      fx=0.5;
      fy=0.5;
    end
    A = [fx fy fy*fx 1;
         cx fy fy*cx 1;
         fx cy cy*fx 1;
         cx cy cy*cx 1]; 
    n5 = I(fx,fy); 
    n6 = I(cx,fy);  
    n8 = I(fx,cy); 
    n9 = I(cx,cy); 
    b = [n5; n6; n8; n9];
    xs = A\b;
    Io(i,j)  = xs(1)*x + xs(2)*y + xs(3)*x*y + xs(4);
  end
end
