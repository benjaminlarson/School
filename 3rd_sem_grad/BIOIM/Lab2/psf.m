function m = psf(onesn,dgaus1,sig_z)
% create the x, y gaussian 
m1 = zeros(size(onesn,1),size(onesn,2)); 
  for x = 1:size(onesn,1) 
    mx = onesn(x,:,:);
    mx = reshape(mx,size(onesn,1),size(onesn,2)); 
    mx = mx.*dgaus1; 
    m1 = cat(3,m1,mx);
  end
  m1 = m1(:,:,2:end); %trim off empty zero slice
  
  sigma = sig_z;
  howbig = 3*sig_z+1;
  x = linspace(-howbig/2, howbig/2, howbig);
  gaussz = exp(-x .^ 2 / (2 * sigma ^ 2));
  gaussz = gaussz / sum (gaussz); % normalize
  
  for z =1:size(gaussz,2)
    %each slice times the tube at that slice
    m(:,:,z) = m1(:,:,z).*gaussz(z);
  end 
  
%   
%   for y = 1:size(onesn,2)
%     my = onesn(:,y,:);
%     my = reshape(my,size(onesn,1),size(onesn,2)); 
%     my = my.*dgausy; 
%     m2 = cat(3,m2,my);
%   end
%   m2 = m2(:,:,2:end); 
%   for z = 1:size(onesm,3)
%     mz = onesm(:,:,z);
%     mz = reshape(mz,size(onesm,1),size(onesm,2)); 
%     mz = mz.*dgausz; 
%     m3 = cat(3,m3,mz);
%   end
%   m3 = m3(:,:,2:end);
%   
%   m2 = permute(m2,[2,1,3]);
%   m3 = permute(m3,[3,2,1]); 
%   %create a matrix with zeros past the size m3 
%   m = m1.*m2.*m3%(size(onesn,1)*size(onesn,2)*size(onesn,3));
%   m = convn(m1,m2);
%   m = convn(m2,m3); 
end