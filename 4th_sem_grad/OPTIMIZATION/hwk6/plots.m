
b = 5;
st = 0.05; 
[X,Y] = meshgrid(-b/5:st:b/5, -b:st:b);

z=100*(Y-X.^2).^2+(1-X).^2; 
subplot(2,1,1);
mesh(X,Y,z); 
subplot(2,1,2);
contour(X,Y,z,10,'ShowText','on');
figure();  

contour(X,Y,z,100,'ShowText','off');
% hold on;
% scatter(x(:,1),x(:,2)); 
% plot(x(:,1),x(:,2)); 
