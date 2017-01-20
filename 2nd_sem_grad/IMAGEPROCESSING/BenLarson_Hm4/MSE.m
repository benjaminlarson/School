function m = MSE(Io, I)

m = 1./(size(Io,1)*size(Io,2)).*sum(sum(minus(Io,I).^2)); 