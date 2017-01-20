%this function starts at the first row (1st example) and 
%predicts the value. If wrong it updates w, and b. 
function [w,c] = perceptronMargin(input, tvalue, w_i, r, b, u, e)
%make sure that input and w_i are the same size 
w = w_i; %initialize weight
c = 0;
for k = 1 : e 
  for i = 1 : size (input,1) % all rows i = each row 
%     if (sign(dot(w, input(i,:))*tvalue(i)+b) <= u) % predict and check 
    if ((dot(w , input(i,:))+b)*tvalue(i) <= u) 
      c = c+1; 
      w = w + r * input(i,:) * tvalue(i); % update
      b = b + r*tvalue(i); 
    end
  end
end
end