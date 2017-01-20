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
newfit = zeros(size(x1)); t1map = zeros(size(x1)); 
t1 = [50,100,300,500,800,2000,4000,6000]; 

for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    xn = [-x1(i,j),-x2(i,j),-x3(i,j),-x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];

    n = length(xn); 
    b = (n*sum(xn.*log(t1))-sum(xn)*sum(log(t1)))./(n*sum(log(t1).^2)-(sum(log(t1)).^2));
    a = (sum(xn)-b.*sum(log(t1)))./n;
%     subplot(3,1,1);
%     plot(t1,(a+b.*log(t1)),'k-'); 
%     subplot(3,1,2); 
%     plot(t1,xn,'b-'); 
%     subplot(3,1,3)
%     plot(t1,xn,'b-',t1,(a+b.*log(t1)),'k-'); 
%     test = log(1-max(a+b.*log(t1)))./t1;
    t1map(i,j) = b;
  end
end
figure(); 
t1map = abs(t1map);
imagesc(t1map);colormap gray; 

% i = 100;
% j = 80; 
