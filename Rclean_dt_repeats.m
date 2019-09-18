% Rclean_dt_repeats.m
%Script that operates on an R array. 
%It locates all cases where dt repeats and removes all but the first occurance.
% input
% arrayname
% output
%  outf is the modified array

cmd=sprintf('outf=%s; ',arrayname);
disp(cmd); eval(cmd);

ix=find(diff(outf.dt)<=0);
length(ix)

for i=1:length(ix),
	% Which of these is a repeat time
	ij=find(diff()>0);
	ii=ix(i);
	ij=find(outf.dt==outf.dt(ii));
	fprintf('%d
	TruncateRTimeSeries(outf,ij(2:end));
end
return
