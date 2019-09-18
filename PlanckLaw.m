function [B,B0] = PlanckLaw(T,lambda),
% 190124
%function [B,B0] = PlanckLaw(T,lambda),
%Input
%  lambda = wavelength in m or microns
%  T = absolute temp (C+273.15) or degC
%Output
% B = normalized to 25C at lambda.
% B0 = in W sr^-1 m^-3, at lambda and 25C.
% Compute Planck Radiation
% wallace & hobbs p287
%     B = c1 lambda^{-5} exp(-c2/(lambda T))
%where
% c1=3.74186e-16;
% c2=.01439;
%=============================
% convert T to degK
ix=find(T<200);
if length(ix)>0, T(ix)=273.15+T(ix); end
% convert lambda to meters, m
ix=find(lambda>1e-4);
if length(ix)>0, lambda(ix)=lambda(ix)/1e6; end
% Compute radiance by Planck's Law
c1=3.74186e-16;
c2=0.01439;
B=exp(-c2 ./ lambda ./ T) .* c1 .* lambda .^ -5;
% Radiance at 25C
t0=273.15+25;
B0 = exp(-c2 ./ lambda ./ t0 ) .* c1 .* lambda .^ -5;
% Normalized radiance
B=B/B0;

return

