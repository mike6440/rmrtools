%function [csp,cdir] = ShipTrackStats(dt,lat,lon),
% This is a script
% Work in progress

global SERIES DTRANGE LATRANGE LONRANGE INTERPSECS

D2R = pi / 180;

% DISTANCE BETWEEN POINTS
lt=[];
for i=2:length(lat),
	lt = [lt; (lat(i-1)+lat(i))/2];
end
dx = cos(D2R*lt) .* diff(lon) .* 60;  %minutes
dy = diff(lat)*60;  %minutes
% distance between points
r = sqrt(dx.*dx + dy .* dy);
% overall mean speed
s = r ./ diff(dt) ./ 24;



return
