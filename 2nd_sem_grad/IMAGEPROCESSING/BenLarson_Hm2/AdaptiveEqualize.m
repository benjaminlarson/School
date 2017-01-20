function Io = AdaptiveEqualize(I)
% clear; close all; clc; 
% I = imread('fingerprint.png');
I = double(I); 
x = size(I,1);
y = size(I,2); 
out_x = 32*floor(x/32)-32;
out_y = 32*floor(y/32)-32; 
Io = zeros(size(I)); 
for k = 1: 32: size(I,1)
  for t = 1: 32: size(I,2)
    n = I(k:k+31,t:t+31);
    m = mean(mean(n));
    
%     sI = var(var(n)); 
    sn = 50;
    mn = 128;
%     sig = sI/sn^2;
%      %this gives the correct m,sig but scales wrong
%     Io(k:k+31,t:t+31) = I(k:k+31,t:t+31) - sig*(I(k:k+31,t:t+31)-m);
    % gives 128, 50
    sI = std(std(n));
    sig = sn/sI;
    Io(k:k+31,t:t+31) = mn + sig*(I(k:k+31,t:t+31)-m);

        % f(x,y) = g(x,y) - sig^2/sig^2(g(x,y) - localMean);
%         Io((i+k),(j+t)) = mn - sig*(I((i+k),(j+t))-m);
%         Io(i+k,j+t) = I(i+k,j+t) - sig*(I(i+k,j+t)-m);
    mean(mean(Io(k:k+31,t:t+31)))
    std(std(Io(k:k+31,t:t+31)))
  end
end