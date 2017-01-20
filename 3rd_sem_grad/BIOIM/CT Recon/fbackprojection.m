function m = fbackprojection(theta, rho)

%% filter 
  x = length(rho)/2;
  frho_ = fft(rho);
  frho = fftshift(frho_);
  absr = abs(-x:(x-1))/length(-x:x-1);
%   absr =2* abs(-x:(x-1))/(sum(abs(-x:x-1)/length(-x:x-1)));
  if (0) %use gaussian filter
    s = std(-x:x-1);
    gaussian = 1/(sqrt(2*pi)*s).*exp(-(-x:x-1).^2/(2*s^2));
%     subplot(5,1,1);
%     plot(-x:x-1,frho);
%     subplot(5,1,2);
%     plot(-x:x-1,absr);
%     subplot(5,1,3);
%     plot(-x:x-1,gaussian);
%     subplot(5,1,4);
%     plot(-x:x-1,absr'.*gaussian'); 
    filter = absr' .*  gaussian' .* frho;
%     subplot(5,1,5); 
%     plot(-x:x-1,filter); 
    filter = ifftshift(filter,1); 
    rho = real(ifft(filter));
  end 
  if(1) % just use abs ramp filter 
%     subplot(3,1,1);
%     plot(-x:x-1,frho);
%     subplot(3,1,2);
%     plot(-x:x-1,absr);
    filter = absr'.* frho;
%     subplot(3,1,3); 
%     plot(-x:x-1,filter);
    filter = ifftshift(filter,1); 
    rho = real(ifft(filter));
  end 
%% project 
  % start clean 
  m = zeros(length(rho),length(rho));
  % setup x,y coordinates. Make sure to center. 
  x = repmat(-(length(rho)-1)/2:length(rho)/2,length(rho),1);
  y= x';
  % find rotation based on x,y, theta
  test = x.*cosd(theta)+y.*sind(theta);
  % interpolate beteen rho values based on test coordinates 
%   v = interp1(-(length(rho)-1)/2:length(rho)/2,rho,test(:),'pchip');
  v = interp1(-(length(rho)-1)/2:length(rho)/2,rho,test(:),'linear',0); 
  v(isnan(v)) = 0;
  v = reshape(v,length(rho),length(rho));
  % add together projections 
  m = m + v;
end