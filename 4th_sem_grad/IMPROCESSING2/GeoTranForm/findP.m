function [P] = findP(source_xy, target_xy)

A = zeros(size(source_xy,1), 8); 
b = zeros(size(source_xy,1),1); 

source = source_xy;  
moving = target_xy; 

for i = 1: size(source,1)
        x = source(i,1); 
        y = source(i,2);
        xp= moving(i,1);
        yp = moving(i,2); 
        r = [-x -y -1 0 0 0 x*xp y*xp];
        A(i,:) = r; 
        b(i,:) = -xp; 
end

for i = 1: size(source,1)
        x = source(i,1); 
        y = source(i,2);
        xp= moving(i,1);
        yp = moving(i,2); 
        r = [0 0 0 -x -y -1 x*yp y*yp];
        A = [A; r] ;
        b = [b;-yp]; 
end

P = A\b; 

end 