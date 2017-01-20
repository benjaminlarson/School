clear; clc; close all; 
w0 = double(rgb2gray(imread('w0.png')));
w1 = double(rgb2gray(imread('w1.png')));
w2c = double(rgb2gray(imread('w2c.png'))); 
w3c = double(rgb2gray(imread('w3c.png'))); 

im3_im0=[
264 105  
369  84 
257 252  
367 239  
152 141
146 242];

im0_im3 = [
134  10
231   8  
132 128 
231 127
12  20
11 110];

im0_im1 = [
434   6
451 136
540 125
550  21
542 222
563 270
454 216
355 244
402 295
535 216
563 267
565 282
566 306];

im1_im0 = [
81  72 
106 227
210 203
218  69
212 328
243 383
110 325
9 360
63 418
203 322
243 383
246 399
248 429];

im0_im2 = [
256 164
313 165
256 196
313 192
145 246
218 246
145 342
218 342
30 221
16 362
3 249
2 340]; 

im2_im0 = [
428 107
489 109
425 142
488 141
302 195
382 197
296 299
376 300
174 163
155 317
140 192
139 293]; 

source_im = double(w0); 
target_im = double(w1);
p = findP(im0_im1,  im1_im0);  
P = [p(1),p(2),p(3); p(4),p(5),p(6); p(7),p(8),1;];
im = projectIm(P, source_im, target_im); 
imagesc(im); colorbar(); 

source_im = double(w0); 
target_im = double(w2c);
p = findP(im0_im2,  im2_im0);  
P = [p(1),p(2),p(3); p(4),p(5),p(6); p(7),p(8),1;];
im = projectIm(P, source_im, target_im); 
figure(); 
imagesc(im); colorbar(); 

source_im = double(w0); 
target_im = double(w3c);
p = findP(im0_im3,  im3_im0);  
P = [p(1),p(2),p(3); p(4),p(5),p(6); p(7),p(8),1;];
im = projectIm(P, source_im, target_im); 
figure(); 
imagesc(im); colorbar(); 


%         x0 = floor(new_xy(1)); x1 = ceil(new_xy(1));
%         y0 = floor(new_xy(2)); y1 = ceil(new_xy(2));
%         im(x+500,y+500) = [1-i, j]*[source_im(i,i), source_im(i,j+1); source_im(i+1,i), source_im(i+1,j+1)]*[1-j; j]; 
%         im(i+500,j+500) = [1-x0, y0]*[source_im(x0,y0), source_im(x0,y1); source_im(x1,y0), source_im(x1,y1)]*[1-y0; y0]; 
