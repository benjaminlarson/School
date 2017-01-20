clear;
close all;
I=imread('boat.png');
figure(1);image(I);colormap gray;
figure(2);imagesc(I);colormap gray;
min(I(:))
max(I(:))
%% 
I=double(I);
I=I/255;
min(I(:))
max(I(:)) 
Inoisy = I + 0.05*randn(size(I));
minI = min(Inoisy(:))
maxI = max(Inoisy(:))
figure(1);imagesc(I)
figure(2);imagesc(Inoisy)
%% 
close all;
subplot(2,2,1);
imagesc(I);colormap gray;

Idownsampled2 = I(1:2:end,1:2:end);
subplot(2,2,2);
imagesc(Idownsampled2)

Idownsampled4 = Idownsampled2(1:2:end,1:2:end);
subplot(2,2,3);
imagesc(Idownsampled4)

Idownsampled8 = Idownsampled4(1:2:end,1:2:end);
subplot(2,2,4);
imagesc(Idownsampled8)
whos
%% 
figure(2);
subplot(2,2,1);
imagesc(I);colormap gray;

Idecimated2 = 0.25*(I(1:2:end,1:2:end)+I(2:2:end,1:2:end)+I(1:2:end,2:2:end)+I(2:2:end,2:2:end));
subplot(2,2,2);
imagesc(Idecimated2)

Idecimated4 = 0.25*(Idecimated2(1:2:end,1:2:end)+Idecimated2(2:2:end,1:2:end)+Idecimated2(1:2:end,2:2:end)+Idecimated2(2:2:end,2:2:end));
subplot(2,2,3);
imagesc(Idecimated4)

Idecimated8 = 0.25*(Idecimated4(1:2:end,1:2:end)+Idecimated4(2:2:end,1:2:end)+Idecimated4(1:2:end,2:2:end)+Idecimated4(2:2:end,2:2:end));
subplot(2,2,4);
imagesc(Idecimated8)