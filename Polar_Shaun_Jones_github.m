clear all; close all; clc

directory='C:\Users\....'; % define path to MAIN FOLDER


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%        Loading data and defining parametres        %%%%%%%%%%%%%%

load([directory '\variables\Shaun'],'T','xobj','yobj','orient','OR_VS_TAU1','OR_VS_TAU2')
% T ... complex Jones matrix
% xobj ... x-coordinates in object space
% yobj ... y-coordinates in object space
% orient ... fibre shape (FS) 
% OR_VS_TAU1 ... orientation of the first eigen-polarization ellipse (EP1) relative to FS 
% OR_VS_TAU2 ... orientation of the second eigen-polarization ellipse (EP2) relative to FS  

angle_camera=-41.3592; % compensation of the camera tilt


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%               Defining areas for evaluation                 %%%%%%%%
% The following parameters can be adjusted without affecting conclusions achieved - also limit case without amplitude restrictions (GI = BW) works well

grayImage = sqrt(abs(T(:,:,1)).^2+abs(T(:,:,3)).^2); % calculated amplitude considering e.g., H-polarized sample illumination
BW=orient>0;    % fibre binary mask with distinct regions
threshold=0.50; % set threshold for amplitude
GI = bwareaopen(BW.*grayImage>threshold, 2000); % removing low-amplitude pixels and areas smaller than 2000 pixels;
% GI = BW;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%               FIGURES             %%%%%%%%%%%%%%%%%%%%%%

figure(1); 
subplot(2,2,1); 
imagesc(xobj,yobj,squeeze(angle(T(:,:,1)))); axis image; colormap parula; clim([-pi pi])
title('phase TXX')
%
subplot(2,2,2);
imagesc(xobj,yobj,squeeze(angle(T(:,:,2)))); axis image; colormap parula; clim([-pi pi])
title('phase TXY')
%
subplot(2,2,3);
imagesc(xobj,yobj,squeeze(angle(T(:,:,3)))); axis image; colormap parula; clim([-pi pi])
title('phase TYX')
%
subplot(2,2,4); 
imagesc(xobj,yobj,squeeze(angle(T(:,:,4)))); axis image; colormap parula; clim([-pi pi])
title('phase TYY')


figure(2); 
subplot(2,2,1); 
imagesc(xobj,yobj,squeeze(abs(T(:,:,1)))); axis image; colormap gray; clim([0 1.2])
title('||TXX||')
%
subplot(2,2,2);
imagesc(xobj,yobj,squeeze(abs(T(:,:,2)))); axis image; colormap gray; clim([0 1.2])
title('||TXY||')
%
subplot(2,2,3);
imagesc(xobj,yobj,squeeze(abs(T(:,:,3)))); axis image; colormap gray; clim([0 1.2])
title('||TYX||')
%
subplot(2,2,4); 
imagesc(xobj,yobj,squeeze(abs(T(:,:,4)))); axis image; colormap gray; clim([0 1.2])
title('||TYY||')


%%%%%%%%%%%%%%%%%%%%%%             Orientation            %%%%%%%%%%%%%%%%%%%%%%
figure(3);
imagesc(orient);  axis image; colormap hot; clim([-90 90]); colorbar
title('Fibre shape')

%%%%%%%%%%%%%%%%%%%%%%             Evaluated area           %%%%%%%%%%%%%%%%%%%%%%
figure(4);
subplot(1,3,1); imagesc(grayImage);  axis image; colormap gray; colorbar; clim([0 1.0])
title('Whole amplitude')
subplot(1,3,2); imagesc(BW);  axis image; colormap gray; colorbar; clim([0 1.0])
title('Fibre binary mask')
subplot(1,3,3); imagesc(GI);  axis image; colormap gray; colorbar; clim([0 1.0])
title('Area for evaluations')

%%%%%%%%%%%%%%%%%%%%%%   EP orientations relative to FS      %%%%%%%%%%%%%%%%%%%%%%
figure(5);
subplot(1,2,1); imagesc(OR_VS_TAU1);  axis image; colormap hot; clim([-90 90]); colorbar
title('EP1 relative to FS')
subplot(1,2,2); imagesc(OR_VS_TAU2);  axis image; colormap hot; clim([-90 90]); colorbar
title('EP2 relative to FS')

figure(6);
subplot(1,2,1); imagesc(OR_VS_TAU1.*GI);  axis image; colormap hot; clim([-90 90]); colorbar
title('EP1 relative to FS for histograms')
subplot(1,2,2); imagesc(OR_VS_TAU2.*GI);  axis image; colormap hot; clim([-90 90]); colorbar
title('EP2 relative to FS for histograms')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      HISTOGRAM     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
koefic=4; % 4sigma - considered for displaying the histogram

figure(7);
vec=(OR_VS_TAU1(GI)-angle_camera); % vector for histograms 
vec2=(abs(vec(:)-mean(vec(:))))<koefic*std(vec(:)); % 4sigma interval 
i1=histfit(vec(vec2),30); set(i1(1),'facecolor','m','FaceAlpha',0.5); set(i1(2),'color','m','Visible', 'off'); 
txt_f1 = [num2str(round(mean(vec(vec2)))) '° \pm ' num2str(round(std(vec(vec2)))) '°']; 
text(round(mean(vec(vec2)))-20,15000,txt_f1,'fontsize',18)
xlim([-30 30])
title('EP1 relative to FS','fontsize',13)
set(gca,'fontsize',18)

figure(8);
vec=(OR_VS_TAU2(GI)-angle_camera); % vector for histograms
vec2=(abs(vec(:)-mean(vec(:))))<koefic*std(vec(:)); % 4sigma interval  
i2=histfit(vec(vec2),30); set(i2(1),'facecolor','c','FaceAlpha',0.5); set(i2(2),'color','c','Visible', 'off')
txt_f2 = [num2str(round(mean(vec(vec2)))) '° \pm ' num2str(round(std(vec(vec2)))) '°']; 
text(round(mean(vec(vec2)))-20,15000,txt_f2,'fontsize',18)
xlim([-30 30]+90)
title('EP2 relative to FS','fontsize',13)
set(gca,'fontsize',18)