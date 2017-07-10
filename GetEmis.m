function [emis] = GetEmis(zenithangle),
%# COMPUTE EMISSIVITY OF THE SEA SURFACE FROM A GIVEN 
%# VIEWING ANGLE.  See email from Donlon 040313
%# Call: emis = GetEmis($viewangle)
%# 
%# INPUT
%# $viewangle = the isar drum angle toward the sea. From 90-180 deg.
%# OUTPUT
%# emissivity: viewangle from 90-120 emis=$missing, from 120-140 deg, emai is calculated, from 140-180 deg, emis = 0.99
%# 
%# v2 110328 rmr -- include angles < 40 deg
%# v3 110506 rmr -- moved to perl module Isar.pm
%# v4 140329 rmr -- added safeguards to ComputeSSST
%# v5 170710 rmr -- cleaned up and verified.
%# =================================================================#
	emis=0.98 * ones(size(zenithangle));
	% SEA EMISSIVITY BASED ON VIEW ANGLE
	% donlon email 040317
	a = [40,  0.9893371
		41,  0.9889863
		42,  0.9885924
		43,  0.9881502
		44,  0.9876541
		45,  0.9870975
		46,  0.9864734
		47,  0.9857735
		48,  0.9849886
		49,  0.9841085
		50,  0.9831214
		51,  0.9820145
		52,  0.9807728
		53,  0.9793796
		54,  0.9778162
		55,  0.9760611
		56,  0.9740904
		57,  0.9718768
		58,  0.9693894
		59,  0.9665933
		60,  0.9634488];
	
	% NEAR VERTICAL POINTING
	ix=find(zenithangle > 140);
	if length(ix)>0, emis(ix)=0.99; end
	% NEAR HORIZONTAL, EMIS IS NOT DEFINED
	ix=find(zenithangle <= 120);
	if length(ix)>0, emis(ix)=NaN; end
	% IN THE RANGE 40-60 DEG FROM NADIR
	ix=find(zenithangle > 120 & zenithangle <= 140);
	if length(ix)>0, 
		nadirangle=180-zenithangle;
		% --- INTERPOLATE TO SEA ANGLE ---
		emis(ix) = interp1(a(:,1),a(:,2),nadirangle(ix));
	end
return
