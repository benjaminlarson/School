function [p,b2,R]= devKernel (data, constraint, dim) 

% for i = 1:length(data) 
%     for j = 1:length(data) 
% 
% %            r = sqrt( (data(j,1)-data(i,1)).^2 + (data(j,2)-data(i,2)).^2 + (data(j,3)-data(i,3)).^2 ); 
%         r = sqrt( (data(i,1)-data(j,1)).^2 + (data(i,2)-data(j,2)).^2 + (data(i,3)-data(j,3)).^2 ); 
%         
%         b3(i,j) = r^2*log( r );
%         R(i,j) = r; 
%         
%         if isnan(b3(i,j))
%             b3(i,j) = 0;
%         end 
%     end 
% end 
% b1 = [data(:,1)';data(:,2)';data(:,3)'; ones(size(data(:,1)))']; 
% b2 = [zeros(4,4)]; 
% b4 = [data(:,1),data(:,2),data(:,3), ones(size(data(:,1)))]; 
% B = [b1, b2; b3, b4]; 
% b = [0,0,0,0,constraint(:,dim)']; 
% p = B/b; 

for i = 1:length(data) 
    for j = 1:length(data) 
%         c = 1e-4; 
        r = sqrt( (data(j,1)-data(i,1) ).^2 + ( data(j,2)-data(i,2) ).^2+( data(j,3)-data(i,3) ).^2 );  
%         b2(i,j) =c* r^2*log( r ); 
        b2(i,j) = r; 
        R(i,j) = r; 
        
        if isnan(b2(i,j))
            b2(i,j) = 0;
        end 
    end 
end 
b4 = [ones(size(data(:,1)))';data(:,1)';data(:,2)';data(:,3)']; 
b3 = [zeros(4,4)]; 
% b1 = [ones(size(data(:,1))),data(:,1),data(:,2),data(:,3)]; 
% B = [b2, b1; b1', b3];
B = [b4',b2;b3,b4]; 
b = [constraint(:,dim);0;0;0;0]; 
p = B\b; 
end
