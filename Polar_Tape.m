clear all; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%         OPTICAL PARAMETERS        %%%%%%%%%%%%%%%%%%%%%%
%addpath('C:\Users\...\functions'); % FOLDER WITH USED FUNCTIONS

    %columns                % rows
    M=3096;                 N=2080;         % camera pixels
    m=-M/2:(M/2-1);         n=-N/2:(N/2-1);
    dx=2.4*10^(-6);         dy=dx;          % camera pixel size
    x=m.*dx;                y=n.*dy;        
    [X,Y]=meshgrid(x,y);
    lambda=532*10^(-9);     k=2*pi/lambda;  % central wavelength

    fx=m/(M*dx);            fy=n/(N*dy);    % spatial frequencies (in image space)
    [FX,FY]=meshgrid(fx,fy);
    NA=0.25;                % numerical aperture of microscope objective (MO) 
    magMO=10;               % nominal magnification of the MO
    fTL_ideal=0.180;        % nominal focal length of ideal Tube lens (for which the MO is designed)
    fTL=0.300;              % focal length of used Tube lens
    beta=magMO*fTL/fTL_ideal*(150/200);     % overall lateral magnification of the sample-imaging optical path   

    xobj=x/beta*1000000; % x dimensions in object space in micrometers
    yobj=y/beta*1000000; % y dimensions in object space in micrometers


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%       INTERFERENCE PATTERNS       %%%%%%%%%%%%%%%%%%%%%%

directory_images='C:\Users\jaray\Desktop\incoh_lat_shear_DH\POLARIZATION\mfiles_polar\final_2026_07_16\data'; % folder with camera records

    % interference pattern with tape
    I=apodization_for_propag((fitsread([directory_images '\2025-08-18-1027_2-CapObj_0000.FIT'])));

    % interference pattern without sample
    Iref=apodization_for_propag((fitsread([directory_images '\2025-08-18-1027_6-CapObj_0000.FIT'])));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%      CPLX amplitude reconstruction      %%%%%%%%%%%%%%%%%%%    
    coef = 0.6;
    
    row_R1=1590;          col_R1=2438+2;
    U1=off_axis_reconstruction_general(I.*exp(-1i*2*pi*(fx(col_R1).*X+fy(row_R1).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    U1ref=off_axis_reconstruction_general(Iref.*exp(-1i*2*pi*(fx(col_R1).*X+fy(row_R1).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    
    row_R2=670;           col_R2=958;
    U2=off_axis_reconstruction_general(I.*exp(-1i*2*pi*(fx(col_R2).*X+fy(row_R2).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);
    U2ref=off_axis_reconstruction_general(Iref.*exp(-1i*2*pi*(fx(col_R2).*X+fy(row_R2).*Y)),fx,fy,coef*(NA/lambda)/beta,0.5,24);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%              FIGURES              %%%%%%%%%%%%%%%%%%%%%%

figure(1); 
imagesc(xobj,yobj,angle(U1./U1ref)); axis image; colormap parula; colorbar; clim([-pi pi])

figure(2); 
imagesc(xobj,yobj,angle(U2./U2ref)); axis image; colormap parula; colorbar; clim([-pi pi])

figure(3); 
imagesc(xobj,yobj,angle((U1./U1ref)./(U2./U2ref))); axis image; colormap parula; colorbar; clim([-pi pi])

