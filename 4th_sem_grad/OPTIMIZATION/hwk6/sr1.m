clear; clc; close all; 
% x = [10e-6,10e-6]; 
x = [1,2]; 
B = eye(2)*1; 
del = 1e-1;
eps = 10e-3; %eps > 0 
namb = 10e-4;%(0,10e-3)
r  = 0.9; %(0,1)
s = [1,1]; 
k = 1; 

while norm(fi_(x)) > eps && k ~= 10
%     s(k,:) = 1; %find the directional derivative 
s(k,:) = doglegPk(del(k), x,B);
    s = s(k,:)
    s = [0.5,0.5]; 
    y = fi_( x(k,:)+s )-fi_( x(k,:) ); 
    ared = fi( x(k,:) )-fi( x(k,:) +s )
    pred = -1*(fi_( x(k,:) )'*s' + 1/2*s*B*s')
    ap_ratio = ared/pred
    
    if ared/pred > namb
        x(k+1,:) = x(k,:) +s; 
    else
        x(k+1,:) = x(k,:); 
    end 
    
    if ared/pred > 0.75
        if norm(s) <= 0.8*del(k); 
            del(k+1) = del(k); 
        else
            del(k+1) = 2*del(k);
        end 
    elseif 0.1 <= ared/pred <=0.75
        del(k+1) = del(k);
    else 
        del(k+1) = 0.5*del(k); 
    end 
    yBs = (y-B*s'); 
    a = abs(s*yBs); % This ended up being the dot product. If the book transposes s, we don't need to. 
    b =  r*norm(s)*norm(yBs);
    if a >= b
        B = B + (yBs*yBs')./(yBs*s)
        if any(B(:)) == 0 || isinf(any(B(:)))
            fprintf('Zero in denominator'); 
        end 
    else 
        B = B; 
    end 
    k = k+1; 
end 
x
B

b = 10;
st = 0.1; 
[X,Y] = meshgrid(-b/2:st:b/2, -b:st:b);

z=100*(Y-X.^2).^2+(1-X).^2; 
% subplot(2,1,1);
% mesh(X,Y,z); 
% subplot(2,1,2);
% contour(X,Y,z,b,'ShowText','on');
% figure();  

contour(X,Y,z,50,'ShowText','off');
hold on;
scatter(x(:,1),x(:,2)); 
plot(x(:,1),x(:,2)); 
title('SR1 method')
hold off; 
