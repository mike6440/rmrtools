function [aout]=ScrubRTimeSeries(arrayname, ix),%function [aout]=ScrubRTimeSeries(arrayname,ix),%==============================================================%%input: %  arrayname is the input arrayname in R format% ix is the indexes of points to be removed%output:% aout is the output array%Reynolds, 121119%==============================================================	% NON-DESTRUCTIVEdt=arrayname.dt;	% truncate remove indexes to this seriesix=ScrubSeries(ix,[1,length(dt)]);	% SCRUB FOR EACH VARIABLEfor i = 1:length(aout.vars(:,1)),	v=deblank(aout.vars(i,:));	%disp(v);	cmd=sprintf('aout.%s(ix)=[];',v);	%disp(cmd);	eval(cmd);end	% DT IS NOT INCLUDED IN VARSaout.dt(ix)=[];return;