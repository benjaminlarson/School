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
    f = polyfit(t1,log(xn),1);
    t1map(i,j) = f(2); 
  end
end
figure(); 
t1map = abs(t1map);
imagesc(t1map);colormap gray; 
