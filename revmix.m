function [Pvap, MixR] = RevMix(MixRsat, RH, Pbaro),% RevMix				actual mixing ratio from RH and sat mix ratio.%			[Pvap, MixR] = RevMix(MixRsat, RH, Pbaro)% INPUT:  MixRsat -- sat mixing ratio%         RH -- relative humidity in %%         Pbaro -- baro pressure (Pa)%% OUTPUT:  MixR -- actual mixing ratio %          Pvap -- actual vapor pressure (Pa)%	Reynolds, 970204if RH >= 100;  RH = 100;end;if RH < 0;  RH = 0;end;MixR = RH / 100 * MixRsat;a = MixR / 0.622;b = a ./ (1 + a);Pvap = Pbaro * b;  % output in Pa. return;