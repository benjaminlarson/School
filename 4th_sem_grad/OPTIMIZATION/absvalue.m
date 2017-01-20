
x = -1:0.1:1;

plot(sqrt(x.^2),'--r'); 
hold on;
plot(sqrt(x.^2+1e-2)); 
legend('abs(x)','abs(x+e)'); 