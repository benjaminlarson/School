close all; 
clear; 
input = zeros(100); 
m = zeros(size(input));
rho = zeros(1,100); 
theta = linspace(-90,90,100);
rho(45:50) = 10;
rho(50:60) = 2; 
e = 0.5;

% for x = 1:size(input,1)
%   for y = 1:size(input,2)
%     for th = 1:size(theta,2)
%       test_r = x*cos(theta(th))+y*sin(theta(th));
%       for r = 1:length(rho)-1
%         if ((abs(test_r) < (r+e)) && (abs(test_r) > (r-e)))
%           %Interpolate between possible rho values r+1 and r 
%           project = rho(r)+(rho(r+1)-rho(r))/((r+1)-r) *(test_r-r);
%           m(x,y) = m(x,y) + project;
%         end
%       end
%     end
%   end
% end
% r = repmat(rho,100,1);
y = repmat(-49:50,100,1);
x= y';
% rho = rho - 50; %just shifts the range

for theta=0:pi/180:2*pi
%     test = x.*cos(theta)+y.*sin(theta);
%     A = (test <= (r+e) & test >= (r-e));
%     v = interp1(-49:50,rho,test(:),'pchip');
%     v(isnan(NaN)) = 0;
%     B = logical(ind2sub(size(r),A));
%     v = reshape(v,100,100);
%     m = m + v;
    m = m+backprojection(theta,rho); 
    imagesc(m); colormap jet;
    pause(0.01);
end
figure(); 
imagesc(m);
% [X,Y] = meshgrid(rho);
% rho_m = repmat(rho,100,1);
% x = repmat(-50:49,100,1);
% y = x';
% for theta=0:1:90
%     found_rho = x*cosd(theta)+y*sind(theta);
%     rho_v = find(found_rho == rho_m);
%     m = m + rho_m(rho_v);
%     imagesc(m); colormap jet; colorbar;
%     pause(0.1);
% end
