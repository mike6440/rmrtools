function [T_skin,T_uncorr] = ComputeSSST(TB,K,Pointangle,tilt,ebb,A),
%function [ssst,ssst_uncorr] = ComputeSSST(TB,K,Pointangle,tilt,ebb,A),
%INPUT
% BB temps, n x 2. e.g. TB=[15.208 29.904];
% K n x 4 ( bb1 bb2 sea sky )
%  e.g. K = [149307431 185374448 147557855 128480388];
% Pointangle =  135;
% tilt n x 2 [pitch roll] e.g. tilt=[-1.8 0.7];
% bb emissivity, normally 1. e.g. ebb = 1.0;
% calibration coefs 1 x 2. e.g. A=[1 0];
% --- test ---------------
% [ssst, ssst_uncorr]=ComputeSSST([21.572 41.228],[317.3 413.5 301.7 290.6],135,[3.8 -2.7],1,[1 0])
% [ssst, ssst_uncorr]=ComputeSSST([15.208 29.904],[149307431 185374448 147557855 128480388],135,[-1.8 0.7],1,[1 0])
%TB=[15.208 29.904];K = [149307431 185374448 147557855 128480388];Pointangle =  135;
%tilt=[-1.8 0.7]; ebb = 1.0;A=[1 0];
%[ssst, ssst_uncorr]=ComputeSSST(TB,K,Pointangle,tilt,ebb,A),
% --- test ---------------
% ssst = 14.55,  ssst_uncorr = 15.24
%Note: PlanckFiltered must have the correct KT15 response table.
%=======================
% RAD TABLE
%=======================
T=[-10:60]';
R=PlanckFiltered(T);
%=======================
% VIEWING ANGLE AND EMISSIVITY
%======================
% SEA EMISSIVITY BASED ON VIEW ANGLE
% v4.0 check if we have pitch and roll data.  For this first effort we will use
% only roll.  A positive roll decreases the isar view angle.  i.e. if the view angle is 
% 125 deg and the roll is +2 deg then the corrected view angle is 123 deg.  And the nadir
% angle is 57 deg.
actualviewangle = Pointangle - tilt(2);
e_sea = GetEmis(actualviewangle);
%===================
% BB RADIANCES
%===================
S1 = interp1(T,R,TB(:,1));
S2 = interp1(T,R,TB(:,2));
% VIEW IRRADIANCES DEPEND ON THE EMISSIVITIES OF THE BB'S AND SOURCE
S1v = ebb .* S1 - (1 - ebb ) *S1;
S2v = ebb .* S2 - (1 - ebb)*S1;

%===================
% DOWN VIEW RADIANCE---
%===================
% Ad = (kd-k1) ./ (k2-k1);
Ad = ( K(:,3) - K(:,1) ) ./ ( K(:,2) - K(:,1) );
% Calibration slope
Ad = A(1) * Ad;
% DOWN VIEW INCOMING IRRADIANCE BY INTERPOLATION
Sdv = S1v + (S2v - S1v) .* Ad;
%===================
% --- UP VIEW RADIANCE ---
%===================
% Au = (ku-k1) ./ (k2-k1);
Au = ( K(:,4) - K(:,1) ) ./ ( K(:,2) - K(:,1) );
% Calibration slope
Au = A(1) * Au;
% UP VIEW INCOMING IRRADIANCE BY INTERPOLATION
Suv = S1v + (S2v - S1v) .* Au;
%======================
% REFLECTED SKY IRRADIANCE
%=======================
Srefl = Suv .* ( 1 - e_sea );
%======================
% SEA SURFACE RADIANCE
% view radiance minus the upwelling
%=====================
S_skin = (Sdv - Srefl) ./ e_sea;
% ===================
% COMPUTE SSST FROM THE TABLE
%====================
T_uncorr = interp1(R, T, Sdv./e_sea);  % without sky correction
T_skin = interp1(R,T,S_skin);
%====================
% CAL OFFSET
%====================
T_skin = T_skin + A(2);
T_corr = T_uncorr - T_skin;   % the correction for sky reflection
return

%test ComputeSSST: 15.208 29.904 149307431.0 185374448.3 147557855.7 128480388.9 135 -1.6 0.7 0.9870975 1.0 1.0106 -0.0426 0 -999 ARRAY(0x7fe289893bb8) ARRAY(0x7fe289893b58)
%pitch = -1.6,  roll = 0.7, ActualViewAngle = 134.300
%e_sea = 0.98666063, e_sea_0 = 0.9870975,   viewangle = 135
%bb1t = 15.208,  S_1 = 1.3032e+00
%bb2t = 29.904,  S_2 = 1.6423e+00
%S_1 = 1.303,  S_2 = 1.642
%kt1= 149307431.0000, kt2=185374448.3000, ktsea=147557855.7000, ktsky=128480388.9000
%Ad = -0.0485
%Ad = -0.0490
%S_dv = 1.2865
%slope Au = -0.5775,   corrected Au = -0.5836
%sky view radiance S_uv = 1.1053
%S_upwelling = 0.0147
%S_skin = 1.2890
%Rad2Temp: S_dv=1.287, e_sea=0.98666
%T_uncorr = 15.201, T_skin = 14.505  T_corrdiff = 0.696
%test sst0 = 14.505, sst1 = 14.505
%*************************************************************/
