function rx=TruncateRTimeSeries(r1,ix),
% function rx=TruncateRTimeSeries(r1,ix),
%
%input
%  r1 = name of the primary time series
%  ix = indexes to remove
%output
% rx structure all imbedded time series are truncated

iv=length(r1.vars(:,1));
% for each variable
for i=1:iv,
	v = deblank(r1.vars(i,:));	
	eval(['r1.',v,'(ix) = [];']);
end
r1.dt=datenum(r1.yyyy,r1.MM,r1.dd,r1.hh,r1.mm,r1.ss);
rx=r1;
return
