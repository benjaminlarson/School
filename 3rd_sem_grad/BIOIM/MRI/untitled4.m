yfirst=[.8967e07 1.6294e07 2.6587e07 3.2537e07 3.6136e07 3.8419e07 3.9706e07]'; 
xfirst=[1,2,4,6,8,10,15]';

expfun = @(b,xdata) b(1) -b(2) .* exp(b(3) .* xdata);             % Objective Funciton

SSECF = @(b) sum((yfirst - expfun(b,xfirst)).^2);           % Sum-Squared-Error Cost Function
start_point =[4E+7; 2.23e7; -.005];
[B, SSE] = fminsearch(SSECF, start_point);

figure(1)
plot(xfirst, yfirst, 'bp')
hold on
plot(xfirst, expfun(B,xfirst), '-r')
hold off
grid
text(5.2, 1.75E+7, sprintf('f(x) = %9.2E - %9.2E\\cdote^{%9.2E\\cdotx}', B))

