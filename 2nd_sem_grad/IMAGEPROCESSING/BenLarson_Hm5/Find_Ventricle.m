function Io = findVentricle(I, seed)

Imseg = zeros(size(I));
sz = size(I);
counter = 0;
seed = sub2ind(sz,seed(1),seed(2));

while counter ~= size(seed,1)
  counter = size(seed,1) % setup to fail
  for s = 1:size(seed)% look at each seed
    [sx,sy] = ind2sub(sz,seed(s)); %find 8 nay
    if I(sx,sy) == 0 %only consider part of segment
      continue
    end
    ate = I(sx-1:sx+1,sy-1:sy+1);% sum the values
    if sum(sum(ate)) >= 3 % if no longer in vent
      Imseg(sx,sy) = 1;
      % Add nay to seeds
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
end
Io = Imseg;