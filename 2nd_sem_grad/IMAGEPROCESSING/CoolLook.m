% function Io = WeinerReject(I, H, K)
% I is degraded image
% H is degredation in Fourier domain
% K is SNR 
clear all; close all; clc; 
I = double(imread('fingerprint.png'));
degradeIm = BlurDegradation(I); 
imagesc(degradeIm); colormap gray;  
K = 0.0001; 

f = double(I);
M = size(I,1);
N = size(I,2);
sigmaspatial = 4;
sigmafreq = sqrt(1/(4*pi^2*(sigmaspatial/512)^2));
for u=1:size(f,1)
    for v=1:size(f,2)
        Hblur(u,v) = exp(-((u-M/2).^2+(v-N/2).^2)/(2*sigmafreq^2));
    end;
end;
 
Io = ffzeropad(I); 
fIo = fft2(I); 
I_bar = fftshift(I); 
H_Io = Hblur; 

Io = ffzeropad(I); 
fIo = fft2(I); 
I_bar = fftshift(I); 

W =(1./H_Io .* abs(H_Io).^2./(abs(H_Io).^2 - K)).*I_bar; 

IoW = fftshift(W); 
Io = ifft2(IoW);
Io = Io(1:size(I,1),1:size(I,2)); 
Io = real(Io); 
figure(); 
imagesc(abs(Io)); colormap jet; colorbar; 

