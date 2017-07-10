%function [B,B0] = PlanckLaw(T,lambda),
%=============================
% Compute Planck Radiation
% wallace & hobbs p287
%     B = c1 lambda^{-5} exp(-c2/(lambda T))
%where
% c1=3.74186e-16;
% c2=.01439;
%Input
%  lambda = wavelength in m or microns
%  T = absolute temp (C+273.15) or degC
%Output
% B in W sr^-1 m^-3  Relative to 25C, 10 micron value
% B0 = 10 micron, 25C value
%=============================
function [B,B0] = PlanckLaw(T,lambda),

ix=find(T<200);
if length(ix)>0, T(ix)=273.15+T(ix); end
ix=find(lambda>1e-4);
if length(ix)>0, lambda(ix)=lambda(ix)/1e6; end
c1=3.74186e-16;
c2=0.01439;
B=exp(-c2 ./ lambda ./ T) .* c1 .* lambda .^ -5;
l0=10e-6; t0=273.15+25;
B0 = exp(-c2 ./ l0 ./ t0 ) .* c1 .* l0 .^ -5;
B=B/B0;

return

