function Io = IntensityTransform1(I,r1,r2,s1,s2)
figure('Name','1');
% one = (floor(I(:))>=0 & floor(I(:))<r1);
% hist(double(I(one)));colormap gray; figure('Name','2'); 
% two = (floor(I(:))>=r1 & floor(I(:))<r2);
% hist(double(I(two)));colormap gray; figure('Name','3');
% three = (floor(I(:))>=r2);
% hist(double(I(three)));colormap gray; figure();
one = find(I(:)<=r1);
two = find(I(:)>r1 & I(:)<=r2);
three = find(I(:)>r2);

% % I(one) = I(one).*r1/s1;
% % I(two) = I(two).*(r2-r1)/(s2-s1);
% I(three) = I(three).*(255-r2)/(255-s2); 
I(one) = I(one).*(s1/r1);
I(two) = I(two).*((s2-s1)/(r2-r1));
I(three) = I(three).*((255-s2)/(255-r2)); 
Io = I; 
% if floor(I(i,j)) == r
%   if r < r1
%     Io(i,j) = r*r1/s1;
%   elseif r < r2
%     Io(i,j) = r*(r2-r1)/(s2-s1);
%   else
%     Io(i,j) = r*(255-r2)/(255-s2); 
%   end
% end
