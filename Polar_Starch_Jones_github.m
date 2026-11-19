close all; clear all; clc

% path to the folder with mfiles
directory='C:\Users\....'; % define path to MAIN FOLDER

% loading variables for the first Starch granule
load([directory '\variables\Starch_1'],'TT','xx','yy')
% TT ... complex Jones matrix
% xx ... x-coordinates in object space
% yy ... y-coordinates in object space

figure(1); 
subplot(2,2,1); 
imagesc(xx,yy,squeeze(angle(TT(:,:,1)))); axis image; colormap parula; clim([-pi pi])
title('phase TXX')
%
subplot(2,2,2);
imagesc(xx,yy,squeeze(angle(TT(:,:,2)))); axis image; colormap parula; clim([-pi pi])
title('phase TXY')
%
subplot(2,2,3);
imagesc(xx,yy,squeeze(angle(TT(:,:,3)))); axis image; colormap parula; clim([-pi pi])
title('phase TYX')
%
subplot(2,2,4); 
imagesc(xx,yy,squeeze(angle(TT(:,:,4)))); axis image; colormap parula; clim([-pi pi])
title('phase TYY')



figure(2); 
subplot(2,2,1); 
imagesc(xx,yy,squeeze(abs(TT(:,:,1)))); axis image; colormap gray; clim([0 1.2])
title('||TXX||')
%
subplot(2,2,2);
imagesc(xx,yy,squeeze(abs(TT(:,:,2)))); axis image; colormap gray; clim([0 1.2])
title('||TXY||')
%
subplot(2,2,3);
imagesc(xx,yy,squeeze(abs(TT(:,:,3)))); axis image; colormap gray; clim([0 1.2])
title('||TYX||')
%
subplot(2,2,4); 
imagesc(xx,yy,squeeze(abs(TT(:,:,4)))); axis image; colormap gray; clim([0 1.2])
title('||TYY||')

%%
% loading variables for the second Starch granule
load([directory '\variables\Starch_2'],'TT','xx','yy')
% TT ... complex Jones matrix
% xx ... x-coordinates in object space
% yy ... y-coordinates in object space

figure(3); 
subplot(2,2,1); 
imagesc(xx,yy,squeeze(angle(TT(:,:,1)))); axis image; colormap parula; clim([-pi pi])
title('phase TXX')
%
subplot(2,2,2);
imagesc(xx,yy,squeeze(angle(TT(:,:,2)))); axis image; colormap parula; clim([-pi pi])
title('phase TXY')
%
subplot(2,2,3);
imagesc(xx,yy,squeeze(angle(TT(:,:,3)))); axis image; colormap parula; clim([-pi pi])
title('phase TYX')
%
subplot(2,2,4); 
imagesc(xx,yy,squeeze(angle(TT(:,:,4)))); axis image; colormap parula; clim([-pi pi])
title('phase TYY')

figure(4); 
subplot(2,2,1); 
imagesc(xx,yy,squeeze(abs(TT(:,:,1)))); axis image; colormap gray; clim([0 1.2])
title('||TXX||')
%
subplot(2,2,2);
imagesc(xx,yy,squeeze(abs(TT(:,:,2)))); axis image; colormap gray; clim([0 1.2])
title('||TXY||')
%
subplot(2,2,3);
imagesc(xx,yy,squeeze(abs(TT(:,:,3)))); axis image; colormap gray; clim([0 1.2])
title('||TYX||')
%
subplot(2,2,4); 
imagesc(xx,yy,squeeze(abs(TT(:,:,4)))); axis image; colormap gray; clim([0 1.2])
title('||TYY||')