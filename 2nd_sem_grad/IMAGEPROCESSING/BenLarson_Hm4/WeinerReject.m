function Io = WeinerReject(I, H, K)
% I is degraded image
% H is degredation in Fourier domain
% K is SNR 

I_bar = fft2(I);
for u=1:size(I_bar,1)
    for v=1:size(I_bar,2)
      G(u,v) =( I_bar(u,v)/H(u,v) * (abs(H(u,v))^2)/(abs(H(u,v))^2 + K));
    end 
end 
Io = real(ifft2(G));