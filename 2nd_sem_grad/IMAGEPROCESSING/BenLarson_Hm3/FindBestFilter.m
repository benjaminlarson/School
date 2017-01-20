clear; clc; close all; 

house = double(imread('house.pgm'));
houseNsy = double(imread('houseNoisy1.pgm'));
I = ffzeropad(houseNsy);
N = size(houseNsy,1); M = size(houseNsy,2);

fhouseNsy1 = fft2(I);
fhouseNsy = fftshift(fhouseNsy1);
best = 10000; 

mn = size(I,1)*size(I,2); 


for i = 50: 100
  for j = 1: 50 
    rmfhouseNsy = ButterworthBandReject(fhouseNsy,i,j,2);
    fi = fftshift(rmfhouseNsy);
    inim1 = ifft2(fi);
    in = inim1(1:N,1:M);
    mse = 1./mn.*sum(sum(minus(house,real(in)).^2));
    if mse < best
      best = mse
      i
      j
    end
  end
end
best
