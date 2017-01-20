
ms_info = dicominfo('MRIdata/3D/MRIm120');
ms = dicomread(ms_info);
imagesc(ms); %imcontrast;

