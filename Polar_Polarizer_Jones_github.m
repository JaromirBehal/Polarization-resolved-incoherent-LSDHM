clear all; close all; clc

directory='C:\Users\....'; % define path to MAIN FOLDER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%         OPTICAL PARAMETERS        %%%%%%%%%%%%%%%%%%%%%%

    %columns                % rows
    M=3096;                 N=2080;         % camera pixels
    m=-M/2:(M/2-1);         n=-N/2:(N/2-1);
    dx=2.4*10^(-6);         dy=dx;          % camera pixel size
    x=m.*dx;                y=n.*dy;        

    magMO=10;               % nominal magnification of the MO
    fTL_ideal=0.180;        % nominal focal length of ideal Tube lens (for which the MO is designed)
    fTL=0.300;              % focal length of used Tube lens
    beta=magMO*fTL/fTL_ideal*(150/200);     % overall lateral magnification of the sample-imaging optical path   

    xobj=x/beta*1000000; % x dimensions in object space in micrometers
    yobj=y/beta*1000000; % y dimensions in object space in micrometers

%% Example image of the evaluated LP

I=imread([directory '\data\LP example.png']);
figure(1); imagesc(xobj,yobj,I); axis image; colormap gray; colorbar; clim([0 170]) 

%% Loading values

load([directory '\variables\Polarizer'],'LP_exp_abs','LP_exp_abs_std','orient_angle_relative')
% Parameters of reconstructed Jones matrix
% LP_exp_abs ... mean value 
% LP_exp_abs_std ... standard deviation
% orient_angle_relative ... orientation angle of the polarizer relative to the camera frame


%% Simultaneous fitting multiple graphs with shared parameters

    % X vectors for all datasets
		x1 = orient_angle_relative;
		x2 = orient_angle_relative;
		x3 = orient_angle_relative;
		x4 = orient_angle_relative;

    % Y data - experimental
		y1 = LP_exp_abs(:,1);
		y2 = LP_exp_abs(:,2);
        y3 = LP_exp_abs(:,3);
        y4 = LP_exp_abs(:,4);

    % Define fitting functions and parameters
		mdl1 = @(beta,x) cosd(x-beta(1)).^2.*beta(2);
		mdl2 = @(beta,x) abs(cosd(x-beta(1)).*sind(x-beta(1))).*beta(2); 
		mdl3 = @(beta,x) abs(cosd(x-beta(1)).*sind(x-beta(1))).*beta(2); 
		mdl4 = @(beta,x) sind(x-beta(1)).^2.*beta(2);

    % Prepare input for NLINMULTIFIT and perform fitting
		x_cell = {x1, x2, x3, x4};
		y_cell = {y1, y2, y3, y4};
		mdl_cell = {mdl1, mdl2, mdl3, mdl4};
		beta0 = [0.9, -20];                     % initial guess
		[beta,r,J,Sigma,mse,errorparam,robustw] = ...
					nlinmultifit(x_cell, y_cell, mdl_cell, beta0);

    % Calculate model predictions and confidence intervals
		[ypred1,delta1] = nlpredci(mdl1,x1,beta,r,'covar',Sigma);
		[ypred2,delta2] = nlpredci(mdl2,x2,beta,r,'covar',Sigma);
		[ypred3,delta3] = nlpredci(mdl3,x3,beta,r,'covar',Sigma);
		[ypred4,delta4] = nlpredci(mdl4,x4,beta,r,'covar',Sigma);

    % Calculate parameter confidence intervals
		ci = nlparci(beta,r,'Jacobian',J);

    % angle of the LP relative to H direction estimated by the fit
    orient_real=orient_angle_relative-beta(1);
    
    % the same angle with finer step for plotting the theoretical curves
    alp=min(orient_real):max(orient_real);

figure(2)
plot(alp,cosd(alp).^2.*beta(2),'r','LineWidth',2); hold on; 
errorbar(orient_real,LP_exp_abs(:,1),LP_exp_abs_std(:,1),"o","MarkerSize",8, 'Linewidth',2, 'CapSize', 15,'Color','r' , 'MarkerFaceColor','r')
%
plot(alp,abs(sind(alp).*cosd(alp).*beta(2)),'g','LineWidth',2); hold on; 
errorbar(orient_real,LP_exp_abs(:,2),LP_exp_abs_std(:,2),"o","MarkerSize",8, 'Linewidth',2, 'CapSize', 15, 'Color','g', 'MarkerFaceColor','g')
%
plot(alp,abs(sind(alp).*cosd(alp).*beta(2)),'b--','LineWidth',2); hold on; 
errorbar(orient_real,LP_exp_abs(:,3),LP_exp_abs_std(:,3),"o","MarkerSize",8, 'Linewidth',2, 'CapSize', 15, 'Color','b', 'MarkerFaceColor','b')
%
plot(alp,sind(alp).^2.*beta(2),'k','LineWidth',2); hold on; 
errorbar(orient_real,LP_exp_abs(:,4),LP_exp_abs_std(:,4),"o","MarkerSize",8, 'Linewidth',2, 'CapSize', 15, 'Color','k', 'MarkerFaceColor','k')
%
axis tight; ylim([0 1])
title('Calibration measurements with linear polarizer')
legend('|Txx| fit','experiment','|Txy| fit','experiment','|Tyx| fit','experiment','|Tyy| fit','experiment')
xlabel('orientation angle [degrees]')
ylabel('amplitude [a.u.]')
set(gca,'fontsize', 15)


%% Evaluating goodness of the fit
    
    % zz is the dependent variable, and ZZ is the fitted value of the dependent variable from the regression.  
    zz=transp(LP_exp_abs(:));
    ZZ=[cosd(orient_real).^2, abs(sind(orient_real).*cosd(orient_real)), abs(sind(orient_real).*cosd(orient_real)), sind(orient_real).^2].*beta(2);
    
    SStot = sum((zz(:)-mean(zz(:))).^2);                  % Total Sum-Of-Squares
    SSres = sum((zz(:)-ZZ(:)).^2);                        % Residual Sum-Of-Squares
    Rsq = 1-SSres/SStot;                                  % R^2 parameter
    
    
    disp(Rsq)
