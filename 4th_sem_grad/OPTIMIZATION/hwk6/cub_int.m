function[alpha] =  cub_int(x, a0, a1,p)
%al0 needs to be an initial guess of al0. 
c1 = 1e-5;
c2 = 0.9; 

sufdec = fi(x+a0*fi_(x)); 
newvalue = fi(x)+c1*a0*fi_(x)'*p;

% if  sufdec <= newvalue; % 
%     alpha = al0;
%     return 
% end 
    a1 = (fi_(x+0*p)'*p*a0^2)/(2*(fi(x+a0*p)-fi(x)-fi_(x+0*p)'*p*a0)  ); 

    if fi(x+a1*fi_(x)'*p) <= (fi(x+0)+ c1*a1*fi_(x+0)'*p )
        alpha = a1; 
        return; 
    end
    n = 0; 
%     while  norm(fi(x+al1*fi_(x))) <= norm(fi(x+0)+ c1*al1*fi_(x+0)) || n == 100
        bc1 = 0; bc2 = 0; bc3 = 0; r = 0; 
        
        bc1 =  1/(a0^2 *a1^2*(a1-a0));
        bc2 = ([a0^2, -a1^2;-a0^3, a1^3]);
        bc3 =  [fi(x+a1*p) - fi(x+0) - fi_(x+0)'*p*a1];
        bc3_ =[fi(x+a0*p) - fi(x+0) - fi_(x+0)'*p*a0]; 
        bc3 = [bc3;bc3_];
        r = [bc1.*bc2*bc3]; 
        n = n+1; 
        al1=( -r(2) + (r(2)^2-3*r(1)*fi_(x+0)'*p).^(1/2)) /(3*r(1)); 
        al1 =real( al1(1) ); 
%     end 
        alpha = al1; 
end 