function [estimates, model] = fitLog(xdata, ydata,start_point)
% Call fminsearch with a random starting point.

model = @expfun;
% options = optimset('MaxFunEvals',1000000);
estimates = fminsearch(model, start_point);%,options);
% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A*exp(-lambda*xdata)-ydata,
% and the FittedCurve. FMINSEARCH only needs sse, but we want
% to plot the FittedCurve at the end.
    function [sse, FittedCurve] = expfun(params)

        A = params(1);
        lambda = params(2);
        
        FittedCurve = A.*(1 -2*exp(-lambda .* xdata));
        ErrorVector = FittedCurve - ydata;
        sse = sum(ErrorVector .^ 2);
    end
end