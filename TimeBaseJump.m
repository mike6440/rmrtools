function [ibad] = TimeBaseJump(tx),
%=========================================
%
% function [ibad] = TimeBaseJump(tx),
%
% The program checks through the time base and finds any points that
% should be removed because time is non-monotonic.
% Points are marked for removal if diff(dt) <= 0.  Also,
% if diff(tx) < 0, all times are tagged until the time exceeds
% the first point where it was negative.
%
% Points are removed. 
% The time base does not have to be equally spaced.
%
% The first time point must be good.
%
%input
%  tx = datenum time series, nx1, n time points
%
%output
% ibad = indexes of points that need removal.
%      returns [empty] if all is okay.
%===========================================
% v01 20061112 rmr -- create
ix = find(diff(tx) <= 0);
ibad = [];
	% SCAN EACH NON MONOTONIC POINT
j=1;
%fprintf('Begin at index %d\n',ix(j));
while j <= length(ix),
	ibad = [ibad; ix(j)+1];	
	if ix(j)+1 >= length(tx), break; end
	k=2;
	while tx(ix(j)+k) <= tx(ix(j)),
		%fprintf('time index=%d, time=%d mins\n',ix(j)+k, fix((tx(ix(j)+k) - tx(ix(j)+1))*1440) );
		ibad=[ibad; ix(j)+k];
		k = k + 1;
		if ix(j)+k >= length(tx); ibad=[ibad;length(tx)]; break; end
	end
	j=j+1;
end
fprintf('TimeBaseJump: TS size = %d, ibad length = %d\n',length(tx), length(ibad));
return
