%homework 4
clc; clear; 
data = load('astro.data');
data = [data(:,1),log(data(:,2:5))]; 

d1  = data(1:   2000,2:5);
d1t = data(1:   2000,1);

d2  = data(2001:4000,2:5);
d2t = data(2001:4000,1);

d3  = data(4001:6000,2:5);
d3t = data(4001:6000,1);

d4  = data(6001:8000,2:5);
d4t = data(6001:8000,1);

d5  = data(8001:10000,2:5); 
d5t = data(8001:10000,1); 

C = [10e6, 10e5, 10e4, 10e3, 10e2, 10e1, 1]; 
ro = [1, 0.5, 0.1, 0.01];

T = 5; 
w = [0,0,0,0]'; 
d = []; td = []; cRows_rCol = zeros(7,4); 
%% k-1 parts 

for c = 1:7 %for each hyperparamter
  for r = 1:4 %for each learning rate
    test = zeros(1,5); % zero out the crossC results
    for k = 1:5
      if k == 1
        d = [d1; d2; d3; d4    ];     td = d5t;
        dy= [d1t; d2t; d3t; d4t    ]; dd = d5; 
      end
      if k == 2
        d = [    d2; d3; d4; d5];     td = d1t;
        dy =[    d2t; d3t; d4t; d5t]; dd = d1;
      end
      if k == 3
        d = [d1;     d3; d4; d5];      td = d2t;
        dy = [d1t;     d3t; d4t; d5t]; dd = d2; 
      end
      if k == 4
        d = [d1; d2;     d4; d5];      td = d3t;
        dy = [d1t; d2t;     d4t; d5t]; dd = d3; 
      end
      if k == 5
        d = [d1; d2; d3;     d5];      td = d4t;
        dy = [d1t; d2t; d3t;     d5t]; dd = d4; 
      end
      w = [0,0,0,0]; 
      for e = 1:T %epochs
        %SHUFFLE at the start of each epoch!!!
        d = d(randperm(size(d,1)),:);
        cc = C(c);
        rr = ro(r)/(1+ro(r)*e/cc); 
        for i = 1:length(d)
          x = d(i,:);
          y = dy(i); 
          if (y*dot(w,x)) <= 1
%             w = (1-rr) * w + rr * cc * y * x;
              w = w - rr * w - rr* cc * y * x;
          else
%             w = (1-rr)*w;
              w = w-rr*w; 
          end
        end
      end
      count = 0;
      for i = 1:length(td)
        
        y = td(i);
        x = dd(i,:);
        if (y*dot(w,x)) <= 0
          count = count + 1; %mistakes
        end
      end
       test(k) = count;
    end
    cRows_rCol(c,r) = mean(test);%accuracy for each r,C
  end
end