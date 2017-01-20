function Io = Zeropad(I,n)
I = double(I); 
I = [I, zeros(size(I,1),n)];
I = [zeros(size(I,1),n),I];
I = [I; zeros(n,size(I,2))];
I = [zeros(n,size(I,2));I];
Io = I; 