function p=part2plot(m)
  
  figure();
  subplot(2,4,1);
  imagesc(m); axis square; 
  subplot(2,4,2);
  theta = 0; 
  [R,xp] = radon(m,theta);% xp radial coordinates to each row in R 
%   imshow(R,[],'Xdata',[-90,90],'Ydata',xp);axis square; 
  plot(xp,R);axis square; xlim([-50,50]); 
  ylabel('p')
  title('\theta (degrees)= 0');


  subplot(2,4,3);
  theta = 45; 
  [R,xp] = radon(m,theta);% xp radial coordinates to each row in R 
%   imagesc(xp,theta,R);colormap gray; colorbar;  axis square; 
  plot(xp,R);axis square; xlim([-50,50]); 
  ylabel('p')
  title('\theta (degrees)= 45');
 
  
  subplot(2,4,4);
    theta = 90; 
  [R,xp] = radon(m,theta);% xp radial coordinates to each row in R 
%   imagesc(xp,theta,R);colormap gray; colorbar;  axis square;
  plot(xp,R);axis square; xlim([-50,50]); 
  ylabel('p')
  title('\theta (degrees)= 90');

  
  subplot(2,4,6);
    theta = 360-45; 
  [R,xp] = radon(m,theta);% xp radial coordinates to each row in R 
%   imagesc(xp,theta,R);colormap gray; colorbar;  axis square; 
  plot(xp,R);axis square; xlim([-50,50]); 
  ylabel('p')
  title('\theta (degrees) = -45');

  
  subplot(2,4,7);
    theta = 360-90; 
  [R,xp] = radon(m,theta);% xp radial coordinates to each row in R 
%   imagesc(xp,theta,R);colormap gray; colorbar;  axis square; 
  plot(xp,R);axis square; xlim([-50,50]); 
  ylabel('p')
  title('\theta (degrees)= -90');

  
  subplot(2,4,5);
    theta = -90:90; 
  [R,xp] = radon(m,theta);% xp radial coordinates to each row in R 
  imagesc(xp,theta,R);colormap gray; axis square; 
  xlabel('\theta (degrees)')
  ylabel('p')
  title('Sinogram from Radon T');

end