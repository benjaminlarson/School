function Io = nearestneighbors(I)
% clear; clc; close all; 
% X = meshgrid(1:256); 
% X = double(X); 
% I = X; 
for x = 1:2*size(I,1)
  for y = 1:2*size(I,2)
    Io(x,y) = 0; 
  end
end
for i =3:1:(size(Io,1)-2)
  for j = 3:1:(size(Io,2)-2)
    x = i*(size(I,1)-1)/(size(Io,1)-1);
    y = j*(size(I,2)-1)/(size(Io,2)-1); 
    Io(i,j)  = I(round(x),round(y));
  end
end
figure('Name','original'); 
imagesc(I); colormap gray;
figure('Name','new'); 
imagesc(Io); colormap gray; 