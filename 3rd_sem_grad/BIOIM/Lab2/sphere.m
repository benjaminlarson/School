function m = sphere(mat,center,r,value)

m = zeros(size(mat));
for x = 1:size(mat,1)
  for y = 1:size(mat,2)
    for z = 1:size(mat,3)
      d = distance([x,y,z],center);
      if d <= r
        m(y,x,z) = value;
      end 
    end
  end
end 
end 