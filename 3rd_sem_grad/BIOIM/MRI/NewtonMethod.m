close all;clear; 
% 
% x = 1.5; nmax = 25; eps = 1; xvals = x; n = 0;
% 
% while eps >= 1e-5 & n<=nmax
%   y = (x-sin(x)+x*cos(x))/(2*cos(x)-x*sin(x)); xvals = [xvals;y]; eps =
%   abs(y-x); x = y; n = n+1;
% end plot(xvals);hold on;
% plot(1:length(xvals),sin(xvals)+xvals.*cos(xvals),'r')

x1_ = 1.e3;
x2_ = 1/900;
nmax = 30;
eps = 1;
xvals = [0,0,0,0,0,0,0,0,0];
n = 0;

t1 = log([50,100,300,500,800,2000,4000,6000]);
x1 = x1_;
x2 = x2_;
while eps >= 1e-5 & n<=nmax
  yvals=0;
  for ti = 1:length(t1)
    t = t1(ti);
    gf = [1-exp(-x2.*t); t.*x1.*exp(-x2.*t)];
    h = [ 0 , t.*exp(-x2.*t);...
      t.*exp(-x2.*t), -t.^2*x1.*exp(-x2.*t)];
    h = inv(h);
    x = h*gf;
    x1 = x(1);
    x2 = x(2);
    y = x1*(1-exp(-x2*t)); 
    yvals = [yvals;y];
  end
  xvals = [xvals;yvals'];
  n = n+1;
end
figure();
x = repmat(t1,size(xvals,1),1); 
plot(xvals,'r')
