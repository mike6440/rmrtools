function [xmin,xmax,imin,imax] = Minmaxseries(y,xlimin),
% function [x,ix] = MeanTS(y,ylim),
% Scrubs bad and NaN data then takes an average.
%
%input
%  y = scalar vector
%  ylim (optional) [min,max], accept if min >= y <= max
%output
% x = scrubbed series.
% ix = index in y of all good values.
%
%
if nargin == 1,
    xlim = [-inf,inf];
else
    xlim = xlimin;
end

ig=[1:length(y)]';
[x1,ix] = ScrubSeries(y,xlim);
if length(ix)>1 | ~isnan(ix),
	ig(ix)=[];
end
[xmin,i] = min(x1);
imin=ig(i);

[xmax,i] = max(x1);
imax=ig(i);


return

