% function Io = findVentricle(I, seed)

clear; clc; close all; 
I = imread('brain.png');
sz = size(I); 
I(I >= 60) = 0;
I(I ~= 0) = 1; 
figure();imagesc(I); 
Imseg = zeros(size(I));
Imseg(76,130) = 1; 
% Seed is array of already chosen points
% I is the image to segment.
seed = sub2ind(sz,76,130);
counter = 0; 
while(true)
  counter = size(seed,1)
  for s = 1:size(seed)% look at each seed 
    [sx,sy] = ind2sub(sz,seed(s)); %find 8 nay 
    ate = I(sx-1:sx+1,sy-1:sy+1);% sum the values 
    if sum(sum(ate)) > 3 % if no longer in vent
      Imseg(sx,sy) = 1; 
      seed = [seed; sub2ind(sz,sx,sy-1)];
      seed = [seed; sub2ind(sz,sx,sy+1)];
      seed = [seed; sub2ind(sz,sx-1,sy)];
      seed = [seed; sub2ind(sz,sx-1,sy-1)];
      seed = [seed; sub2ind(sz,sx-1,sy+1)];
      seed = [seed; sub2ind(sz,sx+1,sy)];
      seed = [seed; sub2ind(sz,sx+1,sy-1)];
      seed = [seed; sub2ind(sz,sx+1,sy+1)];
      seed = unique(seed); % remove duplicate seeds
    end
  end
  if counter == size(seed,1)
        break 
    end
end
figure();imagesc(Imseg); 
