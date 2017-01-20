function m = cylinder(mat,start,r,length,axis,value)
  
m = zeros(size(mat));
if axis == 'x'
  for x = start(1):start(1)+length  
    for y = 1:size(mat,2)
      for z = 1:size(mat,3)
        d = distance([x,y,z],[x,start(2),start(3)]);
        if d <= r
          m(y,x,z) = value;
        end 
      end
    end
  end 
elseif axis == 'y'
   for y =start(2):start(2)+length 
    for x = 1:size(mat,1)
      for z = 1:size(mat,3)
        d = distance([x,y,z],[start(1),y,start(3)]);
        if d <= r
          m(y,x,z) = value;
        end 
      end
    end
  end 
else
  for z = start(3):start(3)+length
   for y = 1:size(mat,2)
      for x = 1:size(mat,1)

        d = distance([x,y,z],[start(1),start(2),z]);
        if d <= r
          m(y,x,z) = value;
        end 
      end
    end
  end 
end 