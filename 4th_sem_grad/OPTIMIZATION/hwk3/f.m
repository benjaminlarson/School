function result = f(x)
X = x(1); Y=x(2); 
 result = 10*(Y-X.^2).^2 + (1-X).^2;
end 