function Io = ffzeropad(I)
%doubles the image size, with the original in topleft corner. 
M = size(I,1); N = size(I,2); 
I = double(I);
I = [I,zeros(M,N)];
I = [I;zeros(size(I,1),size(I,2))];
Io = I; 