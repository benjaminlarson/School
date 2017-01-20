%% butterworth band reject 
% I = input image
% Do = distance of middle of the band to be rejected
% W = width of the rejection band 
% n = order of butterworth filter 

function Io = ButterworthBandReject(I,Do,W,n) 
I = double(I); N = size(I,1); M = size(I,2);
mask = zeros(size(I));
Q = N;
P = M; 
for i = 1:size(I,1)
  for j = 1:size(I,2)
    mask(i,j) = sqrt((i-P/2)^2+(j-Q/2)^2);
  end
end
bottom = (mask*W)./(mask.^2-Do^2);
butter = 1./(1 + bottom.^(2*n));
Io = butter.*I;
