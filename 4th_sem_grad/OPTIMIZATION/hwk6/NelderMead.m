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
x4 = [0,0,0,10]; 
S(1,:) = [10, 10, 10,10,   function1(x0)];
S(2,:) = [0, 0, 10,0,    function1(x1)];
S(3,:) = [10, 0, 0,0,    function1(x2)]; 
S(4,:) = [0, 10, 0,0,    function1(x3)]; 
S(5,:) = [0,0,0,10,   function1(x4)]; 
track= S; 
%transform the simplex 
%% 1 - Ordering
n = 0; 
while (sum(S(:,fx_col)) > 10e-5) && n ~= 50
    track = [track;S];
%     track = unique(track,'rows'); 
    n = n+1; 
    [i,h]= max(S(:,fx_col));%worst 
    [ii,ii] = sort(S(:,fx_col));%second worst 
    %     s = S(ii(2),fx_col); %use this to get the second largest value
    s = ii(3); %3, because 2nd largest
    [i,l] = min(S(:,fx_col)); %best
    
    if (l == h || s == h || s == l)
%         fprintf('fix the ordering \n'); 
    end 
    
    %2 - Centroid
    c = 1/fx_col.*(sum(S(:,1:d))-S(h,1:d)); 
    
    %% 3 - Transformation 
    % 3 - Reflect
    xh = S(h,1:d);
    xl = S(l,1:d); 
    xs = S(s,1:d); 
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
    xs = S(s,1:d); 
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
plot(track(1:fx_col:end,1));title('values x1'); 
subplot(2,2,2)
plot(track(2:fx_col:end,2));title('values x2');
subplot(2,2,3);
plot(track(3:fx_col:end,3));title('values x3');
subplot(2,2,4);
semilogy(track(:,fx_col));title('values f(x)'); 
