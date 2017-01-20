function Io = Dilation(I)
Inew = zeros(size(I)); 
% for i = 2:size(I,1)-1
%  for j = 2:size(I,2)-1
%     if I(i,j) == 1
%       Inew(i-1:i+1,j-1:j+1) = 1; 
%     end 
%   end 
% end
for i = 2:size(I,1)-1
 for j = 2:size(I,2)-1
    if I(i,j) == 1
      Inew(i,j) = 1; 
      Inew(i-1,j) = 1;
      Inew(i+1,j) = 1;
      Inew(i,j-1) = 1;
      Inew(i,j+1) = 1;
    end 
  end 
end

Io = Inew; 