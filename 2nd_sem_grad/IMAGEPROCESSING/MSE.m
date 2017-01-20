function m = MSE(Io, I)

m = 1./size(Io).*sum(sum(minus(Io,I).^2)); 