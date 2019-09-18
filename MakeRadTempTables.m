% Make the T,B series
% This is a script
% 190124
% Make a table of T v. R for a particular radiometer.
% T = temperature, deC, from 10 to 40 C.
% B is the corresponding Radiance as a ratio to 25 C.
% Make cubic fit: p3 and b3
T=[10:40]'+273.15;
[B,kt15sn] = PlanckFiltered(T);

t=T-273.15;
p3=polyfit(t,B,3);
b3=polyval(p3,t);
% interpolation error
er=(b3-B)*100./B;
ermean=mean(er);
erstd=std(er);

q3=polyfit(B,t,3);
t3=polyval(q3,B);
ert=(t3-t)*100./t;
ertmean=mean(ert);
ertstd=std(ert);

figure('position',[50,50,1200,1000]);
set(gcf,'papersize',[9.5 7], 'paperposition',[.25 .25 9 6.5])

% Plot Base data
plot(t,B,'b.','markersize',8);grid; hold on
plot(t,b3,'r');
plot(t3,B,'g');
set(gca,'fontname','arial','fontweight','bold','fontsize',14)
xlabel('BB TEMPERATURE -- C')
ylabel('FILTERED IRRADIANCE -- W/m\^2')
str=sprintf('Filtered Black Body response, %s',kt15sn);
tx=title(str);

tx=text(0,0,'CONVERT BB TEMP TO PLANCK IRRAD');
set(tx,'units','normalized','position',[.05,.9]);
set(tx,'fontname','arial','fontweight','bold','fontsize',10)

str=sprintf('p3=[%.5e  %.5e  %.5e  %.5e]',p3(1),p3(2),p3(3),p3(4));
fprintf('%s\n',str)
tx=text(0,0,str);
%tx=text(0,0,'p3=[-1.12e-08   6.588682e-05    0.011716899863   0.642656210819]');
set(tx,'units','normalized','position',[.05,.85]);
set(tx,'fontname','arial','fontweight','bold','fontsize',10)

str=sprintf('std(err) = %.2e percent',erstd);
tx=text(0,0,str);
set(tx,'units','normalized','position',[.05,.80]);
set(tx,'fontname','arial','fontweight','bold','fontsize',10)

tx=text(0,0,'CONVERT PLANCK IRRAD TO RADIATIVE TEMP');
set(tx,'units','normalized','position',[.3,.15]);
set(tx,'fontname','arial','fontweight','bold','fontsize',10)

str=sprintf('q = [%.5e  %.5e  %.5e  %.5e]',q3(1),q3(2),q3(3),q3(4));
fprintf('%s\n',str)
tx=text(0,0,str);
set(tx,'units','normalized','position',[.3,.10]);
set(tx,'fontname','arial','fontweight','bold','fontsize',10)

str=sprintf('std(err) = %.2e percent',ertstd);
tx=text(0,0,str);
set(tx,'units','normalized','position',[.3,.05]);
set(tx,'fontname','arial','fontweight','bold','fontsize',10)

fn=sprintf('/Users/rmr/aa/filtered_bb_response_ktsn%s.pdf',kt15sn);
saveas(gcf,fn,'pdf')
return

