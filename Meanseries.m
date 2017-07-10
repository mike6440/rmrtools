function [x,ix,s,nbad,mn,mx] = Meanseries(y,xlimin),
% function [x,ix,s,nbad,mn,mx] = Meanseries(y,ylim),
% Scrubs bad and NaN data then takes an average.
%
%input
%  y = scalar vector
%  ylim (optional) [min,max], accept if min >= y <= max
%output
% x = scrubbed series mean
% ix = index in y of all good values.
% s = stdev of scrubbed series
% nbad = number of bad points.
% mn = minimum of all good points.
% mx = maximum of all good points.
%
%
if nargin == 1,
    xlim = [-inf,inf];
else
    xlim = xlimin;
end

[x1,ix] = ScrubSeries(y,xlim);
x = mean(x1);
s = std(x1);
nbad=length(y)-length(x1);
mn=min(x1);
mx=max(x1);
return

