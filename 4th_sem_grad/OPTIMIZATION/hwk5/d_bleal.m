function result = d_bleal(x)
    x = x(1); y = x(2); 
    dx = x*(2*y^6-4*y^3+4*y^2-8*y+6)+5.25*y^3+7.5*y-12.75; 
    dy = x*(x*(6*y^5-6*y^2+4*y-4)+15.75*y^2+7.5);
    result = [dx; dy]; 
end 