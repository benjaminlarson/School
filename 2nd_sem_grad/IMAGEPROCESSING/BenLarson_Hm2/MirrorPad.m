function Io = MirrorIm(I,n)
% I = double(I); 
% I = randi(10,10); n = 3; 
for i=1:n
  I = [I(:,1),I];
  I = [I,I(:,end)];
  I = [I; I(end,:)];
  I = [I(1,:);I];
end
% n = 3*n; 
%  I = [I,I(:,1:n)];
%   I = [I(:,end-n:end),I];
%   I = [I; I(end-n:end,:)];
%   I = [I(1:n,:);I];
Io = I; 