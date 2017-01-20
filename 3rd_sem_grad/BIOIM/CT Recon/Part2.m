
clear;
close all; 
load('Prob2.mat'); 

m = zeros(size(sinogram,1));
theta = thetas;  
for x = 1:size(m,1)
  for y = 1:size(m,2)
    for t_i = 1:length(theta)
      rho = sinogram(:,t_i);
      th = theta(t_i); 
      for r = 1:length(rho)-1
        test_r = x*cos(th)+y*sin(th);
        %%Interpolate between possible rho values r+1 and r 
        project = rho(r)+(rho(r+1)-rho(r))/((r+1)-r) *(test_r-r);
        m(x,y) = m(x,y) + project;
%         if ((test < r+e) && (test > r-e))
%           %%%linear interpolate for in between rho
%           m(x,y) = m(x,y) + (rho(r+1)-rho(r))/(r-r+1)*(r-r+1);
%         end
      end
    end
  end
end

imagesc(m); 