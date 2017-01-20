% %% LlodyMax
% clc; clear; close all;
function Iq = LMquantize(I,n) 
% I = imread('brain.png');
% n = 10;
% Initialize, randomly select a(i) from image 
mx = max(I(:)); 
mn = min(I(:));
if mn == 0
  mn =1;
end 
a = randi([mn,mx],1,n-1);
a = sort(a); 
b = zeros(1,n);
Io = I; 
%% Recursive part 
% Create the boundaries, b(i) 
diff = 10000; 
while diff > 0 
  diff = diff -1; 
  %Redistribute the boundaries between the rep points 
  bold = b; 
  b(1) = mn; 
  for i = 2:n-1
    b(i) = 1/2*(a(i-1)+a(i)); 
  end
  b(end) = mx; 
  % Find image values, quantize them to new a(i) 
  % k = k(k>=min(r) & k<=max(r));
  for k = 1:n-1
    tempI = I(I(:)>=b(k) & I(:)<=b(k+1));
    m = mean(tempI); 
    a(k) = m; 
    I(I(:)>=b(k) & I(:)<=b(k+1)) = m;
  end 
  %find the difference between old boundary and new... quit when small
  d = (bold-b).^2;
  d = mean(d);
  if d <= 0.01 
    break; 
  end 
end
Iq = I; 
