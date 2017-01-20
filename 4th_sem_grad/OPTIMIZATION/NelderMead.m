%% Nelder Mead Simplex optimization 
clear; clc; 
%Constants for contraction, expansion, shrinkage
a = 1/2; b = 1/2; g = 2; d = 1/2; 

%construct initial working simplex S, n+1 (4 for 3d) 
d = 4; 
fx_col = 5;  
x0 = [10, 10, 10,10]; 
x1 = [10, 0, 10,0];
x2 = [10, 0, 0,0];
x3 = [10, 10, 0,0];
S(1,:) = [10, 10, 10,10,   function1(x0)];
S(2,:) = [0, 0, 10,    function1(x1)];
S(3,:) = [10, 0, 0,    function1(x2)]; 
S(4,:) = [0, 10, 0,    function1(x3)]; 
track= S; 
%transform the simplex 
%% 1 - Ordering
n = 0; 
while (sum(S(:,4)) > 10e-5) && n ~= 30
    track = [track;S];
%     track = unique(track,'rows'); 
    n = n+1; 
    [i,h]= max(S(:,4));%worst 
    [ii,ii] = sort(S(:,4));%second worst 
    %     s = S(ii(2),4); %use this to get the second largest value
    s = ii(3); %3, because 2nd largest
    [i,l] = min(S(:,4)); %best
    
    if (l == h || s == h || s == l)
%         fprintf('fix the ordering \n'); 
    end 
    
    %2 - Centroid
    c = 1/4.*(sum(S(:,1:d))-S(h,1:3)); 
    
    %% 3 - Transformation 
    % 3 - Reflect
    xh = S(h,1:3);
    xl = S(l,1:3); 
    xs = S(s,1:3); 
    xr = c+a*(c-xh); %reflection point 
%     S(h,:) = [xr, function1(xr)]; 
    if function1(xl) <= function1(xr) ||  function1(xr) < function1(xs)
        S(h,:)=[xr, function1(xr)];  
        continue; 
    end 
    
    % 3 - Expand
    if function1(xr) < function1(xl)
        xe = c+g*(xr-c); %expansion point 
        if function1(xe) < function1(xr)
            S(h,:) = [xe, function1(xe)]; 
            continue; 
        elseif function1(xe) >= function1(xr)
            S(h,:)=[xr, function1(xr)]; 
            continue; 
        end 
    end 

    % 3 - Contract
    xs = S(s,1:3); 
    if function1(xr) >= function1(xs)
        %outside
        if function1(xs)<=function1(xr) || function1(xr) < function1(xh)
            xc = c+b*(xr-c); %contraction point
            if function1(xc) <= function1(xr)
                S(h,:) = [xc, function1(xc)]; 
                continue;  
            end
        else 
%             xj = xl+d*(xj-xl) 
            fprintf('implement shrink'); 
        end 
        %inside 
        if function1(xr) > function1(xh)
            xc = c+b*(xh-c); 
            if function1(xc) < function1(xh)
                S(h,:) = [xc, function1(xc)]; 
            end 
        end 
    end 

    %3 - Shrink 
    % return best vertex of current simple 
end 

subplot(2,2,1)
plot(track(1:4:end,1));title('values x1'); 
subplot(2,2,2)
plot(track(2:4:end,2));title('values x2');
subplot(2,2,3);
plot(track(3:4:end,3));title('values x3');
subplot(2,2,4);
semilogy(track(:,4));title('values f(x)'); 
