%sanity
%homework 5
% Ben Larson
clear; clc; close all; 

toy_im2o = importdata('myo/myocyteSep0025.jpg');
toy_im2o = rgb2gray(toy_im2o);
[x,y]=size(toy_im2o);
toy_im3o = zeros(size(toy_im2o)) ;
for i = 1:x
  for j = 1:y-1
    toy_im3o(i,j)=toy_im2o(i,j+1);   
  end
end

toy_im2 = gaussian_filter(toy_im2o,2);
toy_im3 = gaussian_filter(toy_im3o,2);

close all; 
% Image derivative [-1, 0, 1]/2
[r,c] = size(toy_im2); 
for i = 2:r-1  
  for j = 2:c-1
    toy_im2x(i,j) = (-toy_im2(i,j-1) + toy_im2(i,j+1))/2; 
    toy_im3x(i,j) = (-toy_im3(i,j-1) + toy_im3(i,j+1))/2; 
  end
end
for i = 2:r-1  
  for j = 2:c-1
    toy_im2y(i,j) = (-toy_im2(i-1,j) + toy_im2(i+1,j))/2;
    toy_im3y(i,j) = (-toy_im3(i-1,j) + toy_im3(i+1,j))/2; 
  end
end

toy_im_23_time = toy_im3 - toy_im2; 


%% OPTICAL FLOW 
% 
imagex = toy_im2x;
imagexx = toy_im3x; 
imagey = toy_im2y;
imageyy = toy_im3y; 
imaget = toy_im_23_time; 

%% ADVANCED USING NEAREST NEIGHBORS
% [x,y] = size(imagex);
% w = 3;
% s = 2;
% for c = (w+1):(x-(w+1))
%   for j = (w+1):(y-(w+1))
%     px1 = reshape(imagex ([(c-w:c+w)],[(j-w:j+w)]),[1,(2*w+1)^2]);
%     py1 = reshape(imagey ([(c-w:c+w)],[(j-w:j+w)]),[1,(2*w+1)^2]);
%     
%     Ax = [px1; py1]';
%     b = reshape(imaget([(c-w:c+w)],[(j-w:j+w)]),[1,(2*w+1)^2]);
%     b = b';
%     v = Ax\-b;
%     vx(c-w,j-w) = v(1); 
%     vy(c-w,j-w) = v(2);
%   end
% end
% figure('name','OpticalFlow');
% imshow(toy_im2o); 
% hold on;
% % pxc = (vx-min(min(vx)))/norm(vx);
% % pyc = (vy-min(min(vy)))/norm(vy);
% [x,y]= size(vx); 
% for i = 1:s:x-s
%   for j = 1:s:y-s
%     px = vx(i,j);
%     py = vy(i,j);
%     if abs(px) == px
%       line([j j+py],[i i+px],[1,1],'color','r','LineStyle','-'); 
%     else
%       line([j j+py],[i i+px],[1,1],'color','b','LineStyle','-');
%     end
%   end 
% end
% i = 1; 
% figure('name','Jacobian, Optical Flow');
% [x,y] = size(vx);
% space = 1;
% u = vx;
% v = vy; 
% for i = 1:space:x-space
%   for j = 1:space:y-space
%     jac1 = [u(i,j)-u(i+1,j), v(i,j)-v(i+1,j);
%       u(i,j)-u(i,j+1), v(i,j)-v(i,j+1)];
%     jd1(i,j) = det(jac1); 
%   end 
% end
% imshow(jd1,jet(10)); 
% hold on; 
% [x,y] = size(jd1); 
% for i = 1:x
%   for j = 1:y
%     if(jd1(i,j) < 0)
%       plot(j,i,'r.'); 
%     end
%   end 
% end
%% Horn and Schunck

lam = 5;
u = zeros(size(imagex));
v = zeros(size(imagex));
[n,m] = size(imagex); 
[r,c] = size(toy_im2); 

E1 = toy_im2;
E2 = toy_im3; 
for i = 2:r-1
  for j = 2:c-1
    Ex(i,j) = 1/4*(E1(i,j+1)-E1(i,j)+E1(i+1,j+1)-E1(i+1,j)+...
              E2(i,j+1)-E2(i,j)+E2(i+1,j+1)-E2(i+1,j));
    Ey(i,j) = 1/4*(E1(i+1,j)-E1(i,j)+E1(i+1,j+1)-E1(i,j+1)+...
              E2(i+1,j)-E2(i,j)+E2(i+1,j+1)-E2(i,j+1));
    Et(i,j) = 1/4*(E2(i,j)-E1(i,j)+E2(i+1,j)-E1(i+1,j)+...
             E2(i,j+1)-E1(i,j+1)+E2(i+1,j+1)-E1(i+1,j+1)); 
  end
end
for N =1:64
  for j = 2:m-2
    for i = 2:n-2
      ubar = 1/4*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1));
      vbar = 1/4*(v(i-1,j)+v(i+1,j)+v(i,j-1)+v(i,j+1));
      alpha = lam*(Ex(i,j)*ubar + Ey(i,j)*vbar + Et(i,j))/...
              (1+ lam*(Ex(i,j)^2 + Ey(i,j)^2));
      u(i,j) = ubar - alpha*Ex(i,j);
      v(i,j) = vbar - alpha*Ey(i,j);
    end
  end
end

figure('name','Horn and Schunk'); 
imshow(toy_im2o); 
hold on;
[x,y]= size(u); 
for i = 1:2:x
  for j = 1:2:y
    px = u(i,j);
    py = v(i,j);
    if abs(px) == px
      line([j j+py],[i i+px],[1,1],'color','r','LineStyle','-'); 
    else
      line([j j+py],[i i+px],[1,1],'color','b','LineStyle','-');
    end
  end 
end
%% Find det Jacobian Which is the diff of x(u) velocity and y(v)
% find derivative of u and v
% build the determinant in loop of finding the jacobian
i = 1; 
[x,y] = size(u);
space = 1;
for i = 1:space:x-space
  for j = 1:space:y-space
    jac = [u(i+1,j)-u(i,j), u(i+1,j)-v(i,j);
           v(i,j+1)-u(i,j), v(i,j+1)-v(i,j)];
    jd(i,j) = det(jac); 
    %negative values are impossible deformations 
    % make derivative as small as possible 
  end 
end
%% plotting 

figure();
title('Determinant of Jacobian'); 
imshow(log(jd),jet(20)); % use log to graph. 0 none, -inf super small, +inf huge
hold on; 
err = 0; 
[x,y] = size(jd); 
for i = 1:x
  for j = 1:y
    if(jd(i,j) < 0)
      plot(j,i,'r.'); 
    end
  end 
end
ljd = log(jd);