close all; 
good = load('lab_bioimaging/imT2.mat'); 
seg = load('t2.mat'); 
seg = double(seg.scirunnrrd.data(:,:,1)); 
x1 = good.imT2(:,:,1).*seg;
x2 = good.imT2(:,:,2).*seg;
x3 = good.imT2(:,:,3).*seg;
x4 = good.imT2(:,:,4).*seg;
x5 = good.imT2(:,:,5).*seg;
x6 = good.imT2(:,:,6).*seg;
x7 = good.imT2(:,:,7).*seg;
x8 = good.imT2(:,:,8).*seg;
newfit = zeros(size(x1)); t2map = zeros(size(x1)); 
t2 = [11.21,22.42,33.63,44.85,56.06,67.27,78.48,89.69];
for i = 1:size(x1,1)
  for j = 1:size(x1,2)
    y = [x1(i,j),x2(i,j),x3(i,j),x4(i,j),x5(i,j),x6(i,j),x7(i,j),x8(i,j)];
    f = polyfit(t2,log(y),1);
    t2map(i,j) = 1/f(1);
  end
end
t2map(isnan(t2map))=0;
imagesc(abs(t2map),[10,50]); colormap gray;