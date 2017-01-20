% function Io = AverageFilter(I,w)
clear;clc;close all;
I = meshgrid(1:110,1:110);

I(1:110,1:110) = 0;
I(1:110,1:55) = 1; 

Ic = meshgrid(1:110,1:110);
Ic(1:110,1:110) = 0;

count = 1; 
for i = 1:10:size(I,1)
  for j = 1:10:size(I,2)
    if mod(count,2) ==0
      Ic(i:i+9,j:j+9) = 1;
      count = count + 1; 
    else
      Ic(i:i+9,j:j+9)=0; 
      count = count + 1; 
    end
  end
end

%% averaging 
Ic = double(Ic);
s = 9;
w = 1;
Ioc = Ic;
for k = 1:1
  for i = w+1:size(I,1)-w-1
    for j = w+1:size(I,2)-w-1
      n = Ioc(i-w:i+w,j-w:j+w);
      Ioc(i,j) = sum(sum(n))/s;
    end
  end
end

I = double(I);
s = 9;
w = 1;
Io = I;
for k = 1:1
  for i = w+1:size(I,1)-w-1
    for j = w+1:size(I,2)-w-1
      n = Io(i-w:i+w,j-w:j+w);
      Io(i,j) = sum(sum(n))/s;
    end
  end
end

imagesc(Io);colormap gray; 
figure(); 
%% plotting 
subplot(2,4,1);imagesc(I); colormap gray; 
subplot(2,4,2);imhist(I);colormap gray;xlim([-0.1,1.1]);
subplot(2,4,3);imagesc(Ic); colormap gray;
subplot(2,4,4);imhist(Ic);colormap gray;xlim([-0.1,1.1]);
subplot(2,4,5);imagesc(Io); colormap gray;
subplot(2,4,6);imhist(Io);colormap gray;xlim([-0.1,1.1]);
subplot(2,4,7);imagesc(Ioc); colormap gray;
subplot(2,4,8);imhist(Ioc);colormap gray;xlim([-0.1,1.1]);