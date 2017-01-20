[X,Y] = meshgrid(-3:.1:3,-3:.1:3);
z = (X.^4 + X.^2 + Y.^2 + 1.2 * X .* (Y+1).^(1.4) + 1).^(0.7);

surf(X,Y,real(z)) 
figure()
imagesc(real(z)) 