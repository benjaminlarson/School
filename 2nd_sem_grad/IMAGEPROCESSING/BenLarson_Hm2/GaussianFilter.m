function Io = GaussianFilter(I, sigma)
x = size(I,1);
y = size(I,2);
Io = zeros(x,y); 
I = MirrorPad(I,3*sigma); 
gaushood = Gaussian(3*sigma);
start = 3*sigma; 
% for i = 3*sigma+1 : x+3*sigma
%   for j = 3*sigma+1 : y+3*sigma
%     imhood = I((i-3*sigma):(i+3*sigma),(j-3*sigma):(j+3*sigma));
%     %convolution
%     c = sum(sum(gaushood*imhood)); 
%     Io(i-3*sigma,j-3*sigma) = c;
%     Io(i-3*sigma,j-3*sigma) = c/sqrt(2*pi*3*sigma^2);
%   end
% end
for i = start+1 : x+start
  for j = start+1 : y+start
%     imhood = I((i-3*sigma):(i+3*sigma),(j-3*sigma):(j+3*sigma));
    if i < start && j < start
      imhood = I(i:i+2*start,j:j+2*start);
    elseif i < start
      imhood = I(i:i+2*start,j-start:j+start);
    elseif j < start
      imhood = I(i-start:i+start,j:j+2*start);
    else
      imhood = I(i-start:i+start,j-start:j+start);
    end
    
    %convolution
    c = sum(sum(gaushood*imhood)); 
    Io(i-start,j-start) = c;
    Io(i-start,j-start) = c/sqrt(2*pi*3*sigma^2);
  end
end
% Io(1:3*sigma,:)=[];
% Io(:,1:3*sigma)=[];
% Io(end-3*sigma: end,:)=[];
% Io( :, end-3*sigma:end)=[];