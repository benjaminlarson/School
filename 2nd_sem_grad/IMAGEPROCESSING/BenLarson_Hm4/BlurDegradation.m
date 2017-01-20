function [gblur,Hblur] = BlurDegradation(f)

f = double(f);
M = size(f,1);
N = size(f,2);
sigma_n = max(f(:))*0.05; 
sigmaspatial = 4;

sigmafreq = sqrt(1/(4*pi^2*(sigmaspatial/512)^2));
for u=1:size(f,1)
    for v=1:size(f,2)
        Hblur(u,v) = exp(-((u-M/2).^2+(v-N/2).^2)/(2*sigmafreq^2));
    end;
end;
Hblur = ifftshift(Hblur);
gblur = real(ifft2(Hblur.*fft2(f)))+sigma_n*randn(M,N);