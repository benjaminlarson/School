% function Io = BicubicInterp(I) 
X = meshgrid(1:256); 
X = double(X); 
I = X; 
for x = 1:2*size(I,1)+1
  for y = 1:2*size(I,2)+1
    if mod(x,2)==0 && mod(y,2)==0
      Io(x,y) = I(x/2,y/2); 
    else
      Io(x,y) = 0;
    end
  end
end
Io(:,1) = Io(:,2);Io(:,end) = Io(:,end-1);
Io(1,:) = Io(2,:);Io(end,:) = Io(end-1,:); 

for i = 4:(size(I,1)-4) %columns
  for j = 4:(size(I,2)-4) %rows 
    
    n01= I(i-1,j+2); n02 = I(i,j+2); n03= I(i+1,j+2); 
    n1 = I(i-1,j+1); n2 = I(i,j+1); n3 = I(i+1,j+1);
    n4 = I(i-1,j  ); n5 = I(i,j)  ; n6 = I(i+1, j); 
    n7 = I(i-1,j-1); n8 = I(i,j-1); n9 = I(i+1,j-1); 
    n07= I(i-1,j-2); n08= I(i,j-2); n09= I(i+1,j-2); 
    
    m0 = I(i-2,(j+2):(j-2)); 
    m1 = I(i-1,(j+2):(j-2)); 
    m2 = I(i,  j+2:j-2);
    m3 = I(i+1,j+2:j-2);
    m4 = I(i+2,j+2:j-2);
    
    A = [1, i, j, i*i, j*j, (i)*(j)];
       
    b = [n5, n6, n8, n9];
    x = b/A;
    Io(2*i-1,2*j-1)  = x(1) + x(2) + x(3) + x(4);
    Io(2*i-1,2*j-2)  = x(1) + x(2) + x(3) + x(4);
    Io(2*i-2,  2*j-1)  = x(1) + x(2) + x(3) + x(4);
  end
end
Io(:,1) = Io(:,2);Io(:,end) = Io(:,end-1);
Io(1,:) = Io(2,:);Io(end,:) = Io(end-1,:); 
