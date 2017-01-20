clear; clc; 
xy = [1 10; 4 4; 8 7; 5 6; 3 16; 7 7; 10 14; 4 2; 4 10; 8 8]
xy = [-1,1; -1,-1; 1,-1; -1,-1; -1,1;1,-1;1,1;-1,-1;-1,1;1,-1 ]
% xy = [6, 7] 
l = [-1, -1, 1, -1, -1, 1, 1, -1, 1, -1]'
w = [0,0] 
r = 1
b = 3 

c = 0;
for i = 1 : 10 % all rows i = each row 
%     if (sign(w' * input(i,:)+b) ~= tvalue(i)) % predict and check 
  if (l(i)*(dot(w ,xy(i,:)))- b <= 0)  
    c = c+1;
    w = w + r * xy(i,:) * l(i); % update
    b = b + r*l(i); 
  end
end