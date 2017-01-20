close all; 
clear; 
input = zeros(100); 
m = zeros(size(input));
rho = zeros(1,100); 
theta = linspace(-90,90,100);
rho(45:50) = 10;
rho(50:60) = 2; 

y = repmat(-49:50,100,1);
x= y';

for theta=0:pi/180:pi
    test = x.*cos(theta)+y.*sin(theta);
    v = interp1(-49:50,rho,test(:),'pchip');
    v(isnan(NaN)) = 0;
    v = reshape(v,100,100);
    m = m + v;
end
figure(); 
imagesc(m);