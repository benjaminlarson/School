function Io = Erosion(I)

Inew = I; 
% for i = 2:size(I,1)-1
%  for j = 2:size(I,2)-1
%     n = sum(sum(I(i-1:i+1,j-1:j+1)))
%     if  n <= 9 & n > 4
%       Inew(i-1:i+1,j-1:j+1) = 1; 
%       
%     end 
%   end 
% end

for i = 2:size(I,1)-1
 for j = 2:size(I,2)-1
    n = sum([
      I(i,j),
      I(i-1,j),
      I(i+1,j),
      I(i,j-1),
      I(i,j+1)]); 
    if  n <= 3
      Inew(i,j) = 0; 
      Inew(i-1,j) = 0;
      Inew(i+1,j) = 0;
      Inew(i,j-1) = 0;
      Inew(i,j+1) = 0;
    end
 end
end

Io = Inew; 