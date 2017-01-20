function [p,K] = devkernelR(data, constraint) 

for i = 1:length(data) 
    for j = 1:length(data) 
%         r = sqrt( (data(j,1)-data(i,1) ).^2 + ( data(j,2)-data(i,2) ).^2+( data(j,3)-data(i,3) ).^2 );
        r = sqrt( (data(j,1)-data(i,1) ).^2 + ( data(j,2)-data(i,2) ).^2+( data(j,3)-data(i,3) ).^2 );
       
        s = 10; 
        b2(i,j) = exp(-r^2/(2*s^2));
        if isnan(b2(i,j))
            b2(i,j) = 0;
        end 
    end 
end 
% b1 = [ones(size(data(:,1)))';data(:,1)';data(:,2)';data(:,3)']; 
% b1 = [data(:,1)';data(:,2)';data(:,3)';ones(size(data(:,1)))';]; 
% b3 = [zeros(4,4)]; 
B = b2;
z = zeros(size(B)); 
A = [B,z,z;z,B,z;z,z,B]; 
b = [constraint(:,1);constraint(:,2);constraint(:,3);]; 
p = A\b; 
K = b2; 
end

