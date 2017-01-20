

x = 1.5;
nmax = 25;
eps = 1;
xvals = x;
n = 0;

while eps >= 1e-5 & n<=nmax
  y = (x-sin(x)+x*cos(x))/(2*cos(x)-x*sin(x));
  xvals = [xvals;y];
  eps = abs(y-x);
  x = y;
  n = n+1; 
end
plot(xvals);hold on;
plot(1:length(xvals),sin(x)+x*cos(x),'r')