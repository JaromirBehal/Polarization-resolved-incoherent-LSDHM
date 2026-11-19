clear all; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%         OPTICAL PARAMETERS        %%%%%%%%%%%%%%%%%%%%%%

directory='C:\Users\....'; % define path to MAIN FOLDER

addpath([directory '\functions']); % FOLDER WITH USED FUNCTIONS

    %columns                % rows
    M=3096;                 N=2080;         % camera pixels
    m=-M/2:(M/2-1);         n=-N/2:(N/2-1);
    dx=2.4*10^(-6);         dy=dx;          % camera pixel size
    x=m.*dx;                y=n.*dy;        
    [X,Y]=meshgrid(x,y);
    lambda=532*10^(-9);     % central wavelength

    fx=m/(M*dx);            fy=n/(N*dy);    % spatial frequencies (in image space)
    [FX,FY]=meshgrid(fx,fy);
    NA=0.25;                % numerical aperture of microscope objective (MO) 
    magMO=10;               % nominal magnification of the MO
    fTL_ideal=0.180;        % nominal focal length of ideal Tube lens (for which the MO is designed)
    fTL=0.300;              % focal length of used Tube lens
    beta=magMO*fTL/fTL_ideal*(150/200);     % overall lateral magnification of the sample-imaging optical path   

    xobj=x/beta*1000000;    % x dimensions in object space in micrometers
    yobj=y/beta*1000000;    % y dimensions in object space in micrometers


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%       INTERFERENCE PATTERNS       %%%%%%%%%%%%%%%%%%%%%%

    % interference pattern with diatoms
    I=apodization_for_propag(fitsread([directory '\data\diatoms.FIT']));

    % interference pattern without sample
    Iref=apodization_for_propag(fitsread([directory '\data\diatoms_ref.FIT']));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%      CPLX amplitude reconstruction      %%%%%%%%%%%%%%%%%%%    
    coef = 0.6;
    
    row_R1=1590;   col_R1=2440;     % coordinates of diffraction order in spectrum
    U1=off_axis_reconstruction_general(I.*exp(-1i*2*pi*(fx(col_R1).*X+fy(row_R1).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    U1ref=off_axis_reconstruction_general(Iref.*exp(-1i*2*pi*(fx(col_R1).*X+fy(row_R1).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    U1cor=U1./U1ref; % background phase correction by reference interference image
    U1cor=U1cor.*exp(-1i*mean2(angle(U1cor(810:870,1080:1180)))); % residual background phase correction

    row_R2=670;   col_R2=958;       % coordinates of diffraction order in spectrum
    U2=off_axis_reconstruction_general(I.*exp(-1i*2*pi*(fx(col_R2).*X+fy(row_R2).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    U2ref=off_axis_reconstruction_general(Iref.*exp(-1i*2*pi*(fx(col_R2).*X+fy(row_R2).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    U2cor=U2./U2ref; % background phase correction by reference interference image
    U2cor=U2cor.*exp(-1i*mean2(angle(U2cor(810:870,1080:1180)))); % residual background phase correction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%              FIGURES              %%%%%%%%%%%%%%%%%%%%%%

figure(1); imagesc(xobj,yobj,I); axis image; colormap gray; colorbar; clim([3000 65000])

figure(2); imagesc(I(400:451,1700:1751)); axis image; colormap gray; colorbar; clim([30000 60000])

figure(3); imagesc(fx*beta/1000,fy*beta/1000,log1p(abs(fftshift(fft2(I))))); axis image; colormap gray; clim([9 22]); colorbar

figure(4);  imagesc(angle(U1cor)); axis image; colormap parula; colorbar; clim([-pi pi])

figure(5);  imagesc(xobj,yobj,angle(U2cor)); axis image; colormap parula; colorbar; clim([-pi pi])

figure(6); imagesc(xobj,yobj,angle(U1cor./U2cor)); axis image; colormap parula; colorbar; clim([-pi pi])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%           DIRECT IMAGES           %%%%%%%%%%%%%%%%%%%%%%

    % direct image of diatoms (polarizer without analyzer); 12 ms camera exposure
    Idia=imread([directory '\data\diatoms_no_analyz.png']);

    % direct image of diatoms (crossed polarizer and analyzer); 1000 ms (!!!) camera exposure 
    Idia_cros=imread([directory '\data\diatoms_with_analyz.png']);

figure(11); imagesc(xobj,yobj,Idia); axis image; colormap gray; colorbar; clim([0 200])
figure(12); imagesc(xobj,yobj,Idia_cros); axis image; colormap gray; colorbar; clim([0 200])