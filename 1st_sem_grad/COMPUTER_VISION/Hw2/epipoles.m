
%% Load image, get the points using ginput 
%image left
% LeftImageMatrix = imread('maxresdefault.jpg'); 
% figure(1);
% imagesc(LeftImageMatrix); 
% 
% % need 8 points 
% LIP=ginput(8);
% 
% %image right
% RightImageMatrix = imread('maxresdefault copy.jpg'); 
% figure(1);
% imagesc(RightImageMatrix); 
% 
% % need 8 points 
% RIP=ginput(8);

clc; close all; 
%precomputed the 8 points for speed. 
load('leftImage.mat');
% load('part1.mat'); 
RIP = xinput; 
LIP = x1input; 
close all; 
%% Calculate F matrix, find SVD of F 
%left image features
u1 = LIP(1,1); v1 = LIP(1,2);
u2 = LIP(2,1); v2 = LIP(2,2); 
u3 = LIP(3,1); v3 = LIP(3,2); 
u4 = LIP(4,1); v4 = LIP(4,2); 
u5 = LIP(5,1); v5 = LIP(5,2);
u6 = LIP(6,1); v6 = LIP(6,2);
u7 = LIP(7,1); v7 = LIP(7,2);
u8 = LIP(8,1); v8 = LIP(8,2); 
u9 = 1; v9 = 1; 

%right image features
u11 = RIP(1,1); v11 = RIP(1,2);
u22 = RIP(2,1); v22 = RIP(2,2);
u33 = RIP(3,1); v33 = RIP(3,2);
u44 = RIP(4,1); v44 = RIP(4,2);
u55 = RIP(5,1); v55 = RIP(5,2);
u66 = RIP(6,1); v66 = RIP(6,2); 
u77 = RIP(7,1); v77 = RIP(7,2);
u88 = RIP(8,1); v88 = RIP(8,2); 
u99 = 1; v99 = 1; 

P = [u1*u11 u1*v11 u1 v1*u11 v1*v11 v1 u11 v11 1;
     u2*u22 u2*v22 u2 v2*u22 v2*v22 v2 u22 v22 1;
     u3*u33 u3*v33 u3 v3*u33 v3*v33 v3 u33 v33 1;
     u4*u44 u4*v44 u4 v4*u44 v4*v44 v4 u44 v44 1;
     u5*u55 u5*v55 u5 v5*u55 v5*v55 v5 u55 v55 1;
     u6*u66 u6*v66 u6 v6*u66 v6*v66 v6 u66 v66 1;
     u7*u77 u7*v77 u7 v7*u77 v7*v77 v7 u77 v77 1;
     u8*u88 u8*v88 u8 v8*u88 v8*v88 v8 u88 v88 1;
     u9*u99 u9*v99 u9 v9*u99 v9*v99 v9 u99 v99 1;
    ];

% Perform SVD of P
[U,S,V] = svd(P); 
[min_val, min_index] = min(diag(S(1:9,1:9)));
%m is given by right singular vector of min singular values
F = V(1:9, min_index); 
F = [F(1,1),F(2,1),F(3,1);
    F(4,1), F(5,1), F(6,1);
    F(7,1), F(8,1), F(9,1);]; 
  
RightImageMatrix = imread('dm1.jpg'); 
LeftImageMatrix = imread('dm2.jpg'); 
% RightImageMatrix = imread('hw22.jpg');
% LeftImageMatrix = imread('hm2.jpg');
figure();
imagesc(LeftImageMatrix); 
leftPoint = ginput(1); 
leftPoint = [leftPoint, 1]; 
rightLine = F * leftPoint';

figure();
imagesc(RightImageMatrix); 
rightPoint = ginput(1);
rightPoint = [rightPoint, 1];
leftLine = rightPoint * F;

figure(); 
imagesc(RightImageMatrix); 
s = size(RightImageMatrix); 
x = 0:1:s(2);
y = (-rightLine(1)*x - rightLine(3))/rightLine(2); 
hold on; 
plot(x,y,'Color','r','Linewidth',2);
plot(rightPoint(1),rightPoint(2),'*'); 

figure();
imagesc(LeftImageMatrix);
sL = size(LeftImageMatrix); 
x = 0:1:sL(2);
y = (-leftLine(1)*x - leftLine(3))/leftLine(2); 
hold on; 
plot(x,y,'Color','r','Linewidth',2);
plot(leftPoint(1),leftPoint(2),'*'); 

%% Eigens to get the epipoles
[u,d] = eigs(F'*F); 
uu = u(:,3); 
EpipoleLeftCam = uu/uu(3);

%%  Dense distance map from dense disparity

RightImageMatrixGray = rgb2gray(RightImageMatrix); 
LeftImageMatrixGray = rgb2gray(LeftImageMatrix); 

rim = im2double(RightImageMatrixGray); 
lim = im2double(LeftImageMatrixGray);

%% first rectify images?
% T = [10,0,0]; %in mm, the translation of the camera 
% 
% e1 = T/norm(T);
% 
% e2 = 1/sqrt(T(1)^2+ T(2)^2)* [T(2), T(1), 0]'; 
% 
% e3 = cross(e1,e2); 
% 
% Rect = [e1',e1',e3']; 
% 
% R = [0.0196189414843500,-0.0112740035504965,0.0106508314582486;
%      0.00208768316947736,0.0115243847944799,0.0151747002824412;
%      7.10563857619488e-07,-4.14444674386939e-05,3.87448034593068e-05];
% 
% Rl = Rect;
% Rr = R*Rect; 
% RectifiedRight = zeros(1000,1000); 
% % Left 
% sr = size(rim);
% s1 = sr(1);
% s2 = sr(2); 
% % for i = 1 : s1
% %   for j = 1 : s2
% %     p = [i, j, 1]';
% %     pl = Rl*p; 
% %     x= pl(1);y=pl(2); 
% %     RectifiedRight(x,y) = lim(i,j); 
% %   end 
% % end 
% % Right 
% figure(); 
% imagesc(RectifiedRight); 

%% Can for correspondence 
% Scan two images 
% Windows:

m  = rim;
sm = size(rim); 
mp = lim; 
smp = size(lim); 
bound = 5; 
% highC = zeros(sm(1), sm(2));
highC = 0; 
C = zeros(sm(1), sm(2)); 
DistanceMatrix = zeros(sm(1), sm(2));%initialize matrix for speed?

for i = bound : sm(1) - bound % Image 1
  for j = bound : sm(2) - bound % Image 2 Scan from left to right
    for si = bound : (smp(1) - bound)
%       for sj = bound+5 : smp(2) - (bound+5)
        % Using first image (row, column) j moves first (horizontally)then i 
%         w = [m(i-1, j+1),  m(i,j+1), m(i+1,j+1), ...
%              m(i-1, j  ),  m(i,j  ), m(i+1,j  ), ...
%              m(i-1, j-1),  m(i,j-1), m(i+1,j-1)];
%         w = reshape(m([(i-3:i+3),(j-3:j+3)]),[1,36]); 
        w = reshape(m([(i-3:i+3),(j-3:j+3)]),[1,14]); 
        wp= reshape(mp([(si-3:si+3),(j-3:j+3)]),[1,14]); 
        zero_w = mean(w); 
        % Scan through second image 
        sj = j; % Keep the lines horizontally similar 
%        wp= [mp(si-1, sj+1),  mp(si,sj+1), mp(si+1,sj+1), ...
%             mp(si-1, sj  ),  mp(si,sj  ), mp(si+1,sj  ), ...
%             mp(si-1, sj-1),  mp(si,sj-1), mp(si+1,sj-1)];
        zero_wp = mean(wp); 
        
        C = 1/(norm(w-zero_w))*1/(norm(wp-zero_wp))*dot((w-zero_w),(wp-zero_wp));
        if (C > highC)
          highC = C; 
%           x = m(i)-mp(si);
          x = i - si; 
          y = 0; % because on the horizontal scanline 
          DistanceMatrix(i,j) = 3.2*10/sqrt(x^2+y^2);
        end 
    end 
    highC =0;
    %found the highest correlation in this row? 
  end
end 