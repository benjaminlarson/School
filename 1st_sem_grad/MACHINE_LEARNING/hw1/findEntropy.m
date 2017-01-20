%% find information gain
% att is the attributes to find gain
% pass in the data(att) example S(color:blue) 
function [Entropy] = findEntropy(att1, att2)

total = att1+att2; 
%find ratio of t/f for entropy calculation
% for i = 0 : size(att(:,1))
%   if (att(i) == 1)
%     attTrue = attTrue +1; 
%   else
%     attFalse = attFalse +1; 
%   end
% end

Entropy = -att1 /total*log2(att1 /total) ...
         - att2/total*log2(att2/total); 