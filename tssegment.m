function [good] = tssegment(tx,maxjumpdays),
%=========================================
%
% function [good] = tssegment(tx,maxjumpdays)
%
% First positive jumps greater than maxjumpdays (days) are 
% located.  Segment the time into groups with diff(dt)<maxjumpdays.
%
% Next, the program checks through the time base and finds any points that
% should be removed because time is non-monotonic.
% Points are marked for removal if diff(dt) <= 0.  Also,
% if diff(tx) < 0, all times are tagged until the time exceeds
% the first point where it was negative.
%
% Points are NOT removed. 
% The time base does not have to be equally spaced.
%
% The first time point must be good.
%
%input
%  tx = datenum time series, nx1, n time points
%  maxjumpdays == limit on positive jumps.
%
%output
% Structure good
%  length(good) = n, where n = number of segments, >=1
%  good(i).iends = [startindex endindex]  is the segment end points
%  good(i).dt = datenum time for each segment
%
% example
	% TEST
%clear
%maxjumpdays=2;
%load /Users/rmr/data/20180124_rosr1_kaimei/timeseries2a/gps_avg_flat.mat
%tx=gpsavg.dt; lat=gpsavg.lat;
%xx=tssegment(tx,maxjumpdays);
	% END TEST
	%% REMOVE POINTS WHERE THERE IS A TOO-BIG POSITIVE TIME JUMP
ix = find ( diff(tx) > maxjumpdays );
fprintf('Found %d gaps\n',length(ix));
	% 
if length(ix)==0, ix=[0 ; length(tx)];
else ix = [0 ; ix ; length(tx)];
end
	% FIND SEGMENTS
for ig=1:length(ix)-1;
	cmd=sprintf('i1=ix(%d)+1; i2=ix(%d); c=%d; good(c).iends=[i1 i2]; good(c).dt=tx(i1:i2);',ig,ig+1,ig);
	eval(cmd);
end
fprintf('%d CRUISES WITH GAPS > %d DAYS\n',length(good), maxjumpdays);
	% MAKE EACH SEGMENT MONOTONIC
for i = 1:length(good),
	cmd=sprintf('ibad=TimeBaseJump(good(%d).dt);',i);
	eval(cmd);
	cmd=sprintf('good(%d).ibad=ibad;',i);
	eval(cmd);
	%fprintf('Segment %d, #bad points=%d\n',i,length(ibad));
end
return
