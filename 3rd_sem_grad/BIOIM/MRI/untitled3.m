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
t1map_ = zeros(size(x1)); 
t1 = [50,100,300,500,800,2000,4000,6000]; 
start_point = [2e8,1/900];
for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    x = [x1(i,j),x2(i,j),x3(i,j),x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
    xn= [-x1(i,j),-x2(i,j),-x3(i,j),-x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
%     xn = xn+abs(min(xn)); 
%     n = length(xn); 
%     b = (n*sum(xn.*log(t1))-sum(xn)*sum(log(t1)))./(n*sum(log(t1).^2)-(sum(log(t1)).^2));
%     a = (sum(xn)-b.*sum(log(t1)))./n;
%     y = real(a+b.*log(t1)); 
    [e,m] = fitLog(t1,y,start_point);
%     [e1,m1]=fitLog(t1,xn,start_point);
    [sse, fc]= m(e);
    [sse1,fc1]=m1(e1);
    plot(t1,xn,'*k');hold on; 
    plot(t1,fc,'r');
    plot(t1,start_point(1)*(1-exp(-(start_point(2)*t1))),'--b'); 
    sse
    sse1
    t1map_(i,j)= 1/e(2);close all; 
  end
end
figure(); 
t1map = abs(t1map_);
imagesc(t1map_);colormap gray; 


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
t1map_ = zeros(size(x1)); 
t1 = [50,100,300,500,800,2000,4000,6000]; 
 
for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    xn = [-x1(i,j),-x2(i,j),-x3(i,j),-x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
    n = length(xn); 
    b = (n*sum(xn.*log(t1))-sum(xn)*sum(log(t1)))./(n*sum(log(t1).^2)-(sum(log(t1)).^2));
    a = (sum(xn)-b.*sum(log(t1)))./n;
    y = a+b*log(t1); 
    [e,m] = fitLog(t1,y);
    [sse, fc]= m(e);
    t1map_(i,j)= e(2); 
  end
end
figure(); 
t1map = abs(t1map_);
imagesc(t1map_);colormap gray; 