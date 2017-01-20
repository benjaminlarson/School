close all; 
%dicominfo 
good = load('matlab.mat');
x1 = good.image(:,:,1);
x2 = good.image(:,:,2);
x3 = good.image(:,:,3);
x4 = good.image(:,:,4);
x5 = good.image(:,:,5);
x6 = good.image(:,:,6);
x7 = good.image(:,:,7);
x8 = good.image(:,:,8);

newfit = zeros(size(x1)); t1map = zeros(size(x1)); 
t1 = [50,100,300,500,800,2000,4000,6000]; 
checkT1=0; 
for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    x1 = [x1(i,j),x2(i,j),x3(i,j),x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
    %linear regression in log space
    x = -log(x1); 
    xf = x; 
%     for t=1:length(x)-1
%       if x(t)-x(t+1) > 0
%         xf(t) = -x(t);
%       else
%         xf(t) = x(t); 
%       end
%     end 
    f = polyfit(t1,xf,1);

    plot(t1,log(x1),'g-',t1,xf,'k-',t1,(f(2)+f(1)*t1),'b-');
    t1map(i,j) = 1/f(1);
  end
end
plot(checkT1); 
figure(); 
t1map = abs(t1map);
imagesc(t1map,[100,4000]);colormap gray; 
