function [wspd_app, wdir_app] = ShipApparentWinds(wspd_true, wdir_true, sog, cog, hdg),
%function [wspd_app, wdir_app] = ShipApparentWinds(wspd_true, wdir_true, sog, cog, hdg),
%=======================================
% Compute apparent wind speed and direction from 
% input:
%  wspd_true = true wind speed (kts or m/s)
%  wdir_true = true wind direction, direction FROM
%  sog = speed over ground (same as wspd)
%  cog = ship course over ground (GPS)  0-360 deg  dir TO
%  hdg = ship heading, gyro,  0--360 deg
% output:
%  wspd_app (same as input units, kts or m/s) rel to bow
%  wdir_app rel to bow (deg)
%
% Speed units can vary but they must all be the same, e.g. m/s
% Apparent wind is the wind actually measured by an anemometer.
% Relative winds are the apparent winds in the true north coordinate system
%========================================
% testing
%[wsa, wda] = ShipApparentWinds(14, 270, 9.8, 249, 249) ==> 25.36 kts at 80.89 deg

%clear;
%wspd_true = 14;
%wdir_true = 270;
%sog = 9.8;
%cog = 249;
%hdg = 249;


r2d = 180/pi;
d2r = pi/180;
hdg=CompassCheck(hdg);

% ==============
% COMPUTE WINDS IN THE TRUE COORDINATE SYSTEM
% A SIMPLE ROTATION USING HEADING
%===============

% True wind components
[ut,vt] = MetP2V(wspd_true,wdir_true);
%fprintf('hdg = %.1f, true vector = (%.2f, %.2f)\n', hdg, ut, vt);

% SHIP SPEED VECTOR
[us, vs] = MetP2V(sog, cog);
us = -us; vs = -vs;    
%fprintf('sog = %.1f,  cog = %.1f, ship vector = (%.2f, %.2f)\n', sog, cog, us, vs);
ur = ut - us;
vr = vt - vs;
%fprintf('rel wind vector = (%.2f, %.2f)\n',ur, vr);

	% REL WIND VECTOR
[wspd_app,wdir_app] = MetV2P(ur,vr);
wdir_app=wdir_app-hdg;

%fprintf('apparent wind = [%.1f, %.1f]\n', wsa,wda)




return



