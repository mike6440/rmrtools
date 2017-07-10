function e = VapPressAtmos(tc, rh, p)%VAPPRESSATMOS -- compute actual vapor pressure from T,RH,P%============================================================%	e = VapPressAtmos(tc, rh, p)%%input:% tc = temperature (degC)% rh = relative humidity (%)% p = barometric pressure (hPa)%%output% e = vapor pressure (hPa)%%reynolds 981117%============================================================%=================% saturated water vapor%=================esat = esatwat(tc);%================% sat mix ratio%================wsat = mixratio( esat,p);%==================% actual mix ratio%==================w = wsat .* rh ./ 100;%=================% actual vap pressure%==================e = w .* p ./ (0.622 + w);return;