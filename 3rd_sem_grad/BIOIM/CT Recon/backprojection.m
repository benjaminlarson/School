function m = backprojection(theta, rho)

  % start clean 
  m = zeros(length(rho),length(rho));
  % setup x,y coordinates. Make sure to center. 
  x = repmat(-(length(rho)-1)/2:length(rho)/2,length(rho),1);
  y= x';
  % find rotation based on x,y, theta
  test = x.*cosd(theta)+y.*sind(theta);
  % interpolate beteen rho values based on test coordinates 
  v = interp1(-(length(rho)-1)/2:length(rho)/2,rho,test(:),'linear');
  v(isnan(NaN)) = 0;
  v = reshape(v,length(rho),length(rho));
  % add together projections 
  m = m + v;
end