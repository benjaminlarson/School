%% Program for computing the primal dual as developed in: 
% "A fourth order dual method for staircase-reduction in texture
% extraction and image restoration problems" Chan, Esedoglu, Park 

clear; close all; clc; 
u = zeros(250,250);
u(:,100:150) = 15; 
u(50:90,:) = 10;
u(101:150,:) = 15; 
u(160:200,:) = 20; 

for i = 1:250
    for j = 1:100
        u(i,j) = i./10; 
         if i < j
           u(i,j) = 30; 
         end 
    end
end 
Lu = u; 
n = randn(size(u)); 
u = u + n; 
u = double(u); 
f = u;
u1 = zeros(size(u)); 
u2 = zeros(size(u)); 
v =zeros(size(u)); 

alpha = 1e0; 
lambda = 1e0; 
mu = 1e0; 
iter = 500; 

p = zeros(size(u)); 
tau = 1/64; 
for i = 1:iter 
    A = del2(del2(p))-del2((f-u1-v)./(alpha*lambda));
    p = (p-tau.*A)./(1+tau.*abs(A)); 
    u2 = f - u1-v-alpha*lambda.*del2(p); 
end

tau = 1/8;
p= zeros(size(u));
for i = 1:iter
    A=del2(p)-(f-u1-u2)./mu;
    p = (p+tau.*A)./(1+tau.*abs(A)); 
    v = mu.*del2(p);
end

p = zeros(size(u));
for i = 1:iter
    A = gradient(imdiv(p)-(f-u2-v)./lambda); 
    p = (p+tau.*A)./(1+tau.*abs(A)); 
    u1 = f-u2-v-lambda.*imdiv(p);  
end 

subplot(2,3,1);imagesc(f);
subplot(2,3,2); imagesc(u1+u2,[0,35]);
subplot(2,3,3);imagesc(f-v,[0,35]); 
subplot(2,3,4);imagesc(u2);
subplot(2,3,5);imagesc(u1);
subplot(2,3,6);imagesc(v); 