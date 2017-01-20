close all; 
clear; 
%dicominfo 
good = load('lab_bioimaging/imT1.mat');
x1 = good.imT1(:,:,1);
x2 = good.imT1(:,:,2);
x3 = good.imT1(:,:,3);
x4 = good.imT1(:,:,4);
x5 = good.imT1(:,:,5);
x6 = good.imT1(:,:,6);
x7 = good.imT1(:,:,7);
x8 = good.imT1(:,:,8);
newfit = zeros(size(x1)); 
t1map = zeros(size(x1)); 
t1 = [50,100,300,500,800,2000,4000,6000]; 
 
for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    y = [x1(i,j),x2(i,j),x3(i,j),x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
    [e,m] = fitcurvedemo(t1,y);
    [sse, fc]= m(e);
%     plot(t1,fc,'r-');
%     fc 
%     e
%     hold on; 
%     plot(t1,y,'b-');
    t1map(i,j) = 1/e(2); 
    close all; 
  end
end
figure(); 
t1map = abs(t1map);
imagesc(t1map);colormap gray; 


%% Demo
% xdata = (0:.1:10)'; 
% ydata = 1- 40 * exp(-.5 * xdata) + randn(size(xdata));
% 
% [estimates, model] = fitcurvedemo(xdata,ydata);
% 
% plot(xdata, ydata, '*')
% hold on
% [sse, FittedCurve] = model(estimates);
% plot(xdata, FittedCurve, 'r')
%  
% xlabel('xdata')
% ylabel('f(estimates,xdata)')
% title(['Fitting to function ', func2str(model)]);
% legend('data', ['fit using ', func2str(model)])
% hold off