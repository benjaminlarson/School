clear;
close all; 
clc; 
m = zeros(100);

a = 10;
b = 20;
for y = 1:size(m,1)
  for x = 1:size(m,2)
    dist = (x-50)^2/a^2 + (y-50)^2/b^2; 
    if dist <= 1
      m(x,y) = 1;
    end
  end 
end
part2plot(m); 

m = zeros(100); 
m(45:55,45:55) = 1; 
part2plot(m'); 

m = zeros(100); 
for x = 1:size(m,1)
  for y = 1:size(m,2)
    dist = sqrt((x-50)^2 + (y-65)^2); 
    if dist <= 5
      m(x,y) = 1;
    end
  end 
end
for x = 1:size(m,1)
  for y = 1:size(m,2)
    dist = sqrt((x-50)^2 + (y-35)^2); 
    if dist <= 5
      m(x,y) = 1;
    end
  end 
end
part2plot(m'); 