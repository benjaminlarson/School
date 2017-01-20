function m = plot_f(vol,t,y,x,z,isPsf)
fig = figure('name',t,'Position',[0,0,1000,600]);
fig.PaperPositionMode = 'auto' ; 
  if ~isPsf
    [xx,yy,zz] = meshgrid(1:1:size(vol,1),1:1:size(vol,2),1:1:size(vol,3)); 
    subplot(2,2,1);
    isosurface(xx,yy,zz,vol,1e-6); grid on; 
    xlabel('x');ylabel('y');zlabel('z'); 
    view(3); axis tight
    camlight 
    lighting gouraud
  else
   subplot(2,2,1);
   slice(vol,x,y,z); xlabel('x');ylabel('y');zlabel('z'); 
   subplot(2,2,2);
   imagesc(squeeze(vol(y,:,:)));colormap ; colorbar; 
   title('x plane');xlabel('z');ylabel('y'); 
   subplot(2,2,3);
   imagesc(squeeze(vol(:,x,:)));colormap gray; colorbar; 
   title('y plane'); xlabel('z');ylabel('x'); 
   subplot(2,2,4);
   imagesc(squeeze(vol(:,:,z)));colormap jet; colorbar; 
   title('z plane'); xlabel('x');ylabel('y'); 
   print(t,'-dpng','-r0'); 
   return; 
  end
  subplot(2,2,2);
  imagesc(squeeze(vol(y,:,:)));colormap ; colorbar; 
  title('x plane');xlabel('z');ylabel('y'); 
  text(5,10,'Cyln 1','Color','white');
  text(5,26,'Cyln 2','Color','white');
  text(5,45,'Sp1 1','Color','white');
  text(5,55,'Sp2 2','Color','white');
  subplot(2,2,3);
  imagesc(squeeze(vol(:,x,:)));colormap gray; colorbar; 
  title('y plane'); xlabel('z');ylabel('x'); 
  text(22,20,'Cyln 2','Color','white');
  text(22,35,'Sph 1','Color','white');
  text(22,50,'Cyln 4','Color','white');
  subplot(2,2,4);
  imagesc(squeeze(vol(:,:,z)));colormap jet; colorbar; 
  title('z plane'); xlabel('x');ylabel('y'); 
  text(15,25,'Cyln 1','Color','white');
  text(17,50,'Cyln 2','Color','white');
  text(30,25,'Cyln 3','Color','white');
  text(30,15,'Cyln 4','Color','white');
  text(45,25,'Sph 1','Color','white');
  text(55,25,'Sph 2','Color','white');
  fig = gcf;
  fig.PaperPositionMode = 'auto';
  print(t,'-dpng','-r0'); 
end 