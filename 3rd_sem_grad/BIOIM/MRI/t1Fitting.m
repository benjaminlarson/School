good = load('lab_bioimaging/imT1.mat');
seg = load('t1.mat'); 
seg = double(seg.scirunnrrd.data(:,:,1)); 
x1 = good.imT1(:,:,1).*seg;
x2 = good.imT1(:,:,2).*seg;
x3 = good.imT1(:,:,3).*seg;
x4 = good.imT1(:,:,4).*seg;
x5 = good.imT1(:,:,5).*seg;
x6 = good.imT1(:,:,6).*seg;
x7 = good.imT1(:,:,7).*seg;
x8 = good.imT1(:,:,8).*seg;
newfit = zeros(size(x1)); 
t1map_ = zeros(size(x1)); 
t1 = [50,100,300,500,800,2000,4000,6000]; 
start_point = [2e8,1/900];
for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    xn= [-x1(i,j),-x2(i,j),-x3(i,j),-x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
    [e,m] = fitLog(t1,xn,start_point);
    [sse, fc]= m(e);
%     plot(t1,xn,'*k');hold on; 
%     plot(t1,fc,'r');
%     plot(t1,start_point(1)*(1-exp(-(start_point(2)*t1))),'--b'); 
%     sse
%     sse1
    t1map_(i,j)= 1/e(2);close all; 
  end
end
figure(); 
t1map = t1map_;
imagesc(t1map_,[500,1500]);colormap gray; 