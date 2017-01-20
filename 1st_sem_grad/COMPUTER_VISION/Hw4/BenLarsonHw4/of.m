%homework 5
% Ben Larson
clear; clc; close all; 

toy_im2o = importdata('toy-car-images-bw/toy_formatted4.png');
toy_im3o = importdata('toy-car-images-bw/toy_formatted5.png');
% % % 
% toy_im2o = importdata('Untitled0.tif');
% toy_im3o = importdata('Untitled9.tif');

toy_im2 = gaussian_filter(toy_im2o,2);
toy_im3 = gaussian_filter(toy_im3o,2);

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

%time gradient:
% for i = 1:r  
%   for j = 1:c
%     toy_im_23_time(i,j) = (toy_im2(i,j) - toy_im3(i,j));
%   end
% end
toy_im_23_time = toy_im3 - toy_im2; 
close all; 
subplot(3,2,1);
imshow(toy_im2o); 
title('original image2'); 

subplot(3,2,2); 
toy_im_23_time = scale(toy_im_23_time); 
imshow(toy_im_23_time);
title('time derivative = im3 - im2');

subplot(3,2,3); 
toy_im2x = scale(toy_im2x); 
imshow(toy_im2x);
title('x gradient, im2');

subplot(3,2,4);
toy_im3x = scale(toy_im3x); 
imshow(toy_im3x);
title('x gradient, im3'); 

subplot(3,2,5); 
toy_im2y = scale(toy_im2y); 
imshow(toy_im2y);
title('y gradient, im2');

subplot(3,2,6); 
toy_im3y = scale(toy_im3y); 
imshow(toy_im3y); 
title('y gradient, im3'); 


%% OPTICAL FLOW 
% 
imagex = toy_im2x;
imagexx = toy_im3x; 
imagey = toy_im2y;
imageyy = toy_im3y; 
imaget = toy_im_23_time; 
% %create patch
% i = 1; 
% figure('name','OpticalFlow');
% imshow(toy_im2o);
% hold all; 
% [x,y] = size(imagex);
% space = 2;
% for i = 1:space:x-space
%   for j = 1:space:y-space
%     if imaget(i,j) == 0
%       imaget(i,j) = 1 
%     end 
%     px = 1*(imagex(i,j)-imagexx(i,j))/imaget(i,j);
%     py = 1*(imagey(i,j)-imageyy(i,j))/imaget(i,j);
%     if abs(px) == px
%       line([j j+py],[i i+px],[1,1],'Color', 'r','LineStyle','-'); 
%     else%'color', 'r/b'
%       line([j j+py],[i i+px],[1,1],'Color', 'b','LineStyle','-');
%     end
%   end 
% end
% 
% %% ADVANCED USING NEAREST NEIGHBORS
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
% figure('name','Nearest Neighbors');
% imshow(toy_im2o); 
% hold on;
% pxc = (vx-min(min(vx)))/norm(vx);
% pyc = (vy-min(min(vy)))/norm(vy);
% [x,y]= size(vx); 
% for i = 1:s:x-s
%   for j = 1:s:y-s
%     px = vx(i,j);
%     py = vy(i,j);
%     if abs(px) == px
%       line([j j+py],[i i+px],[1,1],'color',[pxc(i,j),pyc(i,j),1],'LineStyle','-'); 
%     else
%       line([j j+py],[i i+px],[1,1],'color',[1,pxc(i,j),pyc(i,j)],'LineStyle','-');
%     end
%   end 
% end

%% Horn and Schunck
Et = imaget;
lam = 10; 
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
for N =1:32
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