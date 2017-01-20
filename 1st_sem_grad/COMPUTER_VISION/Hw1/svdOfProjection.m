% Camera Calibration

load('pointsANDimage.mat'); 
%image space in 3 dimensions 
u1 = xinput(1,1); v1 = xinput(1,2);
u2 = xinput(2,1); v2 = xinput(2,2); 
u3 = xinput(3,1); v3 = xinput(3,2); 

u4 = xinput(4,1); v4 = xinput(4,2);
u5 = xinput(5,1); v5 = xinput(5,2);
u6 = xinput(6,1); v6 = xinput(6,2);

%world space [mm] 
px1 = 2.8;  py1 = 19.7;  pz1 = 0;
px2 = 16.8; py2 = 14.2;  pz2 = 0;
px3 = 11.3; py3 = 8.3;   pz3 = 0; 
px4 = 0;   py4 = 14.0;  pz4 = 22.5;
px5 = 0;   py5 = 11.2;  pz5 = 2.8;
px6 = 0;   py6 = 5.6 ;  pz6 = 11.2; 

P = [px1, py1, pz1, 1,   0,   0,   0, 0, -u1*px1, -u1*py1, -u1*pz1, -u1;
    0   ,   0,   0, 0, px1, py1, pz1, 1, -v1*px1, -v1*py1, -v1*pz1, -v1;
    
    px2 , py2, pz2, 1,   0,   0,   0, 0, -u2*px2, -u2*py2, -u2*pz2, -u2;
    0   ,    0,  0, 0, px2, py2, pz2, 1, -v2*px2, -v2*py2, -v2*pz2, -v2;
    
    px3, py3, pz3,  1,   0,   0,   0, 0, -u3*px3, -u3*py3, -u3*pz3, -u3;
    0  ,   0,   0,  0, px3, py3, pz3, 1, -v3*px3, -v3*py3, -v3*pz3, -v3;
    
    px4, py4, pz4,1,   0,   0,   0, 0, -u4*px4, -u4*py4, -u4*pz4, -u4;
      0,   0,   0,0, px4, py4, pz4, 1, -v4*px4, -v4*py4, -v4*pz4, -v4;
      
    px5, py5, pz5,1,   0,   0,   0, 0, -u5*px5, -u5*py5, -u5*pz5, -u5;
      0,   0,   0,0, px5, py5, pz5, 1, -v5*px5, -v5*py5, -v5*pz5, -v5;
      
    px6, py6, pz6, 1,   0,   0,   0, 0, -u6*px6, -u6*py6, -u6*pz6, -u6;
      0,   0,   0, 0, px6, py6, pz6, 1, -v6*px6, -v6*py6, -v6*pz6, -v6;];

% Perform SVD of P
[U,S,V] = svd(P); 
[min_val, min_index] = min(diag(S(1:12,1:12)));
%m is given by right singular vector of min singular values
m = V(:,12); 

M=zeros(3,4);
M(1,:)=m(1:4);
M(2,:)=m(5:8);
M(3,:)=m(9:12);

A=M(:,1:3);
B=M(:,4);

% Intrinsic & Extrinsic parameters
a1 = A(1,:); 
a2 = A(2,:); 
a3 = A(3,:);


% a1 = m(1:3); a2 = m(4:6); a3 = m(7:9); 
row = 1/norm(a3); 
%not sure about
theta = acos(dot(cross(a1,a3),cross(a2,a3))/(norm(cross(a1,a3))*norm(cross(a2,a3)))); %this should be the cos(X) = ....
% ca12 = cross(a1,a2); 
alpha = (row*row)*norm(cross(a1,a2))*sin(theta);
beta  = row^2*norm(cross(a2,a3))*sin(theta);

r3    = row*a3;
r1    = 1/norm(cross(a2,a3))*(cross(a1,a3));
r2    = cross(r3,r1);
 
tx    = m(10);
ty    = m(11);
tz    = m(12); 
u0    = row^2*(dot(a1,a3));
v0    = row^2*(dot(a2,a3)); 
% 
% calibM = [
%   alpha.*r1' - alpha.*cot(theta).*r2' + u0.*r3', alpha.*tx-alpha*cot(theta)*ty + u0*tz;
%   beta/sin(theta).*r2' + v0.*r3'               , beta/sin(theta)*ty+v0*tz;
%   r3'                                          , tz
%   ];
perProjM2 = [
  alpha.*r1' - alpha.*cot(theta).*r2'+u0.*r3';
  beta/sin(theta).*r2' + v0.*r3';
  r3']; 

