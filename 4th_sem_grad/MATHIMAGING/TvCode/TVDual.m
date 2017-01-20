function [Itv,Pe,De] = TVDual(I0, sigma, Niter, eps)

wx = zeros(size(I0));
wy = zeros(size(I0));

%Calculate the gradient of I0
[Ix,Iy] = grad(I0);
 divw = div(wx,wy);
 De = zeros(1,Niter);
 Pe = zeros(1,Niter);
    for k=1:Niter
    %Calculate the gradient with respect to w

    [gdwx,gdwy] = grad(divw);
    
    wx = wx + eps.*(Ix + (sigma)*gdwx);
    wy = wy + eps.*(Iy + (sigma)*gdwy);
    
    %Now project the gradient
    
    nW = sqrt(wx.*wx+wy.*wy);
    nW(nW<1) = 1.0;
    wx = wx./nW;
    wy = wy./nW;
    
    divw = div(wx,wy);
    %Calculate the dual energy
    De(k) = sum(sum((-I0.*divw - 0.5*(divw.*divw)*sigma)));
    % Calculate the primal energy
    Itv = I0 + divw*sigma;
    [Itx,Ity] = grad(Itv);
    
    Pe(k) = sum(sum( (I0-Itv).^2/(2*sigma) + sqrt(Itx.*Itx+Ity.*Ity)));
    
    end

    function divf = div(ux,uy)
    divf = (ux - circshift(ux,[1,0])) + (uy - circshift(uy,[0,1]));

    end

    function [ux,uy] = grad(f)
        ux = circshift(f,[-1,0]) - f;
        uy = circshift(f,[0,-1]) - f;
    end
        
    
end

