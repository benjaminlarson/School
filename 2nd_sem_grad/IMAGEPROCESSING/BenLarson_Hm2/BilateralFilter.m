function Io = BilateralFilter(I,sigmad,sigmar)
x = size(I,1);
y = size(I,2); 
%How do we decide the neighborhood?
start = 3*sigmad; 
Io = zeros(size(I));
I = MirrorPad(I,start);  
% compute closeness/distance once 
for i = 1:2*start+1
  for j = 1:2*start+1
%     kt = sqrt((i-start)^2+(j-start)^2);
    kt1 = (i-start)^2+(j-start)^2;
    c(i,j) = exp(-kt1/(2*sigmad^2)); 
  end
end
% I = MirrorPad(I,start); 
% for i = 1+start:x+start
%   for j = 1+start:y+start
%     if i < start
%       n = I(i-start:i+start,j-start:j+start);
%     if j < start 
%     intensity = I(i,j);
%     ds = (n - intensity).^2;
%     s = exp(-ds./(2*sigmar^2));
%     
%     pixel = sum(sum(n.*s.*c));
%     normal =  sum(sum(s.*c)); 
%     pixel/normal;
%     Io(i-start,j-start) = pixel/normal;
% %     normal = conv2(s,c); 
% %     Io(i-start,j-start) = conv2(n,conv2(s,c))/normal;
%   end 
%     end 
for i = 1+start:x+start
  for j = 1+start:y+start
    if i < start && j < start
      n = I(i:i+2*start,j:j+2*start);
    elseif i < start
      n = I(i:i+2*start,j-start:j+start);
    elseif j < start
      n = I(i-start:i+start,j:j+2*start);
    else
      n = I(i-start:i+start,j-start:j+start);
    end
    intensity = I(i,j);
    ds = (n - intensity).^2;
    s = exp(-ds./(2*sigmar^2));
    
    pixel = sum(sum(n.*s.*c));
    normal =  sum(sum(s.*c)); 
    pixel/normal;
    Io(i-start,j-start) = pixel/normal; 
  end 
end 
% Io(1:start,:)=[];
% Io(:,1:start)=[];
% Io(end-start: end,:)=[];
% Io( :, end-start:end)=[];
