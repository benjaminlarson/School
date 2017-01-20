function mse_return = mse_3d(orig, im)
  x = size(orig,1);
  y = size(orig,2);
  z = size(orig,3);  
  orig_ = reshape(orig,[1,x*y*z]);
  
  x = size(orig,1);
  y = size(orig,2);
  z = size(orig,3); 
  im_ = reshape(im,[1,x*y*z]);
  
  mse_return = mean(minus(orig_,im_).^2); 
end