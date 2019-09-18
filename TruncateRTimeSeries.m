function rx=TruncateRTimeSeries(r1,ix),
% function rx=TruncateRTimeSeries(r1,ix),
%
%input
%  r1 = name of the primary time series
%  ix = indexes to remove
%output
% rx structure all imbedded time series are truncated

rx=r1;
iv=length(rx.vars);
for i=1:iv,
	v=deblank(rx.vars(i,:));
	%disp(v);
	eval(['rx.',v,'(ix)=[];']);
end
rx.dt=datenum(rx.yyyy,rx.MM,rx.dd,rx.hh,rx.mm,rx.ss);
return
