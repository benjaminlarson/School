function[alpha] =  cub_int(x, al0, al1)
%al0 needs to be an initial guess of al0. 
c1 = 1e-5;
c2 = 0.9; 
al0 = (al0+al1)/2;


sufdec = fi(x+al0*fi_(x)); 
newvalue = fi(x)+c1*al0*fi_(x)*fi_(x)';

% if  sufdec <= newvalue; % 
%     alpha = al0;
%     return 
% end 

    al1 = fi_(x+0)*fi_(x)'*al0^2/(2*(fi(x+al0*fi_(x))-fi(x+0)-fi_(x+0)*-fi_(x)'*al0)); 
    if isnan(al1)
        al1 = 0;
    end 
    if fi(x+al1*fi_(x)*fi_(x)') <= (fi(x+0)+ c1*al1*fi_(x+0)*fi_(x)' )
        alpha = al1; 
        return; 
    end
    n = 0; 
%     while  norm(fi(x+al1*fi_(x))) <= norm(fi(x+0)+ c1*al1*fi_(x+0)) || n == 100
        bc1 = 0; bc2 = 0; bc3 = 0; r = 0; 
        
        bc1 =  1/(al0^2 *al1^2*(al1-al0));
        bc2 = ([al0^2, -al1^2;-al0^2, al1^3]);
        bc3 =  [fi(x+al1*fi_(x)) - fi(x+0) - fi_(x+0)];
        bc3_ =[fi(x+al0*fi_(x)) - fi(x+0) - fi_(x+0)]; 
        bc3 = [bc3;bc3_];
        r = [bc1.*dot(bc2,bc3)]; 
        n = n+1; 
        al1=( -r(2) + (r(2)^2-3*r(1)*fi_(x+0)*fi_(x)').^(1/2)) /(3*r(1)); 
        al1 =real( al1(1) ); 
%     end 
        alpha = al1; 
end 