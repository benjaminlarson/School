
y = [1,1000,3000,5000,7000,8500,8700,9000]; 
x = [50,100,300,500,800,2000,4000,6000]; 

f = polyfit(x,y,1);
f
ny = f(1)*exp(-x*f(2));
subplot(3,1,1);
plot(x,y,'-k');
subplot(3,1,2);
plot(x,log(y),'-b');
subplot(3,1,3); 
plot(x,f(1) + f(2)*log(x),'-r'); 